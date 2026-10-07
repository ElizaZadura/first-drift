#!/usr/bin/env bash
set -euo pipefail
LOGFILE="${1:-}"
OUTFILE="Sluglasses_session_log_readable.md"
: "${MARKERS_FILE:=}"
pick_logfile() {
  if [[ -n "$LOGFILE" && -f "$LOGFILE" ]]; then echo "$LOGFILE"; return; fi
  [[ -f Sluglasses_session_log.tsv ]] && { echo Sluglasses_session_log.tsv; return; }
  [[ -f Sluglasses_session_log.md  ]] && { echo Sluglasses_session_log.md;  return; }
  echo "No log file found." >&2; exit 1
}
SRC="$(pick_logfile)"
touch "$OUTFILE"
awk -v mf="$MARKERS_FILE" -v src="$SRC" -v out="$OUTFILE" '
BEGIN{
  OFS="";
  while ( (getline l < out) > 0 ) {
    if (l ~ /^\*\*Fossil:\*\* `[^`]+`[[:space:]]*$/) {
      fossil = substr(l, index(l, "`")+1); sub(/`[[:space:]]*$/, "", fossil);
      Seen[fossil] = 1;
    }
  }
  close(out);
}
function print_block(ts, model, basefile, fossil, mark,   ts_h, probe) {
  ts_h = ts; gsub("T"," · ",ts_h);
  probe = basefile; sub(/\.[^.]*$/,"",probe);
  print "### " ts_h "\n" >> out;
  print "**Model:** " model "  \n" >> out;
  print "**Probe:** " probe "  \n" >> out;
  print "**Fossil:** `" fossil "`  \n" >> out;
  print "**Markers:** \n" >> out;
  print "\n---\n\n" >> out;
}
{
  line = $0;
  if (src ~ /\.tsv$/) {
    n = split(line, f, /\t/);
    if (n >= 4) {
      ts=f[1]; model=f[2]; basefile=f[3]; fossil=f[4]; sub(/[[:space:]]*—[[:space:]]*$/, "", fossil);
      if (!(fossil in Seen)) print_block(ts, model, basefile, fossil, "");
    }
    next;
  }
  n = split(line, f, / — /);
  if (n >= 4) {
    ts=f[1]; model=f[2]; basefile=f[3]; fossil=f[4]; sub(/[[:space:]]*—[[:space:]]*$/, "", fossil);
    if (!(fossil in Seen)) print_block(ts, model, basefile, fossil, "");
  }
}
' "$SRC"
echo "Appended new entries from $SRC to $OUTFILE" >&2
