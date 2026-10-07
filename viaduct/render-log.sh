#!/usr/bin/env bash
set -euo pipefail
# Usage: ./render-log.sh [RAW_LOG_MD] [READABLE_MD]
# Defaults match your current naming.
RAW="${1:-Sluglasses_session_log.md}"
OUT="${2:-Sluglasses_session_log_readable.md}"
# TSV="Sluglasses_session_log.tsv"

emdash='—'

# Temp store for normalized entries: ts \t model \t probeBase \t fossil
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

# 1) Pull entries from RAW em-dash log (with or without trailing em-dash)
if [[ -f "$RAW" ]]; then
  # shellcheck disable=SC2002
  cat "$RAW" | awk -v mdash="$emdash" '
    BEGIN{ FS=" — " }
    # Expect 4 or 5 fields depending on trailing dash
    NF==4 || NF==5 {
      # $1 ts, $2 model, $3 probeBase, $4 fossil
      ts=$1; model=$2; probe=$3; fossil=$4;
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", ts);
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", model);
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", probe);
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", fossil);
      if (ts!="" && model!="" && probe!="" && fossil!="") {
        printf "%s\t%s\t%s\t%s\n", ts, model, probe, fossil;
      }
    }
  ' >> "$tmp"
fi

# 2) If an old TSV exists, merge it too
#if [[ -f "$TSV" ]]; then
#  awk -F'\t' 'NF==4 {print $1 "\t" $2 "\t" $3 "\t" $4}' "$TSV" >> "$tmp"
#fi

# 3) De-duplicate + sort by timestamp, then model/probe/fossil
# Also normalize TZ like +0200 -> +02:00 for consistent sort
norm() {
  awk -F'\t' '
    function normtz(s,   n) {
      # add colon in timezone if missing (…+HHMM -> …+HH:MM)
      if (match(s, /[+-][0-9]{4}$/)) {
        return substr(s,1,length(s)-2) ":" substr(s,length(s)-1,2)
      }
      return s
    }
    { ts=$1; model=$2; probe=$3; fossil=$4;
      tsn=normtz(ts);
      print ts "\t" model "\t" probe "\t" fossil "\t" tsn;
    }
  '
}

# unique+sort
sort -u "$tmp" | norm | sort -t$'\t' -k5,5 -k2,2 -k3,3 -k4,4 > "${tmp}.sorted"

# 4) Rewrite RAW (single source of truth: em-dash format with trailing dash)
> "$RAW"
awk -F'\t' '{ printf "%s — %s — %s — %s —\n", $1, $2, $3, $4 }' "${tmp}.sorted" >> "$RAW"

# 5) Write READABLE, with whitespace padding around the fossil path
> "$OUT"
awk -F'\t' '
  function rmmd(s){ sub(/\.md$/,"",s); return s }
  {
    ts=$1; model=$2; probe=$3; fossil=$4;
    gsub("T"," ",ts);
    printf "→ Date/Time: %s | Model: %s | Probe: %s | Fossil:  %s  \n",
           ts, model, rmmd(probe), fossil
  }
' "${tmp}.sorted" >> "$OUT"

echo "Rendered:"
echo "  RAW: $RAW"
echo "  READABLE: $OUT"
