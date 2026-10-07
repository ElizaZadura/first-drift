#!/usr/bin/env bash
set -euo pipefail

# run-one-seq.sh (enhanced)
# Runs scaffold → anchor → probe as *separate* prompts (each saved as its own fossil & log entry).
# Enhancements:
#   - If -p/--probe is a directory, pick a random file inside it as the probe.
#   - Adds the chosen probe filename into the fossil filename.
#   - Optional -v/--verbose flag to echo progress.

usage() {
  echo "Usage: $0 -m MODEL -s SCAFFOLD -a ANCHOR -p PROBE|DIR [--rules RULES_SH] [-v] [--print-input]" >&2
  exit 1
}

MODEL=""
SCAFFOLD=""
ANCHOR=""
PROBE=""
RULES=""
VERBOSE=0
PRINT_INPUT=0

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--model) MODEL="$2"; shift 2;;
    -s|--scaffold) SCAFFOLD="$2"; shift 2;;
    -a|--anchor) ANCHOR="$2"; shift 2;;
    -p|--probe) PROBE="$2"; shift 2;;
    --rules) RULES="$2"; shift 2;;
    -v|--verbose) VERBOSE=1; shift;;
    --print-input) PRINT_INPUT=1; shift;;
    -h|--help) usage;;
    *) echo "Unknown arg: $1" >&2; usage;;
  esac
done

[[ -z "${MODEL}" || -z "${SCAFFOLD}" || -z "${PROBE}" ]] && usage

# If anchor is missing, mark it so we can skip later
ANCHOR="${ANCHOR:-}"

# If PROBE is a directory, pick a random file from it
if [[ -d "${PROBE}" ]]; then
  files=("${PROBE}"/*)
  if [[ ${#files[@]} -eq 0 ]]; then
    echo "Probe directory is empty: ${PROBE}" >&2
    exit 2
  fi
  PROBE="${files[RANDOM % ${#files[@]}]}"
  [[ $VERBOSE -eq 1 ]] && echo "Picked random probe: ${PROBE}"
fi

# Load rules file if provided (must define decide_next)
if [[ -n "${RULES}" ]]; then
  if [[ ! -f "${RULES}" ]]; then
    echo "Rules file not found: ${RULES}" >&2
    exit 2
  fi
  # shellcheck disable=SC1090
  source "${RULES}"
  if ! type decide_next >/dev/null 2>&1; then
    echo "Rules file does not define decide_next()" >&2
    exit 2
  fi
fi

mkdir -p sessions

# Get timestamp with timezone offset in ISO 8601 (portable approach)
ts_iso="$(date +%Y-%m-%dT%H:%M:%S%z)"
# Insert colon in timezone for ISO compatibility: +0200 -> +02:00
tz="${ts_iso:19:3}:${ts_iso:22:2}"
ts_iso="${ts_iso:0:19}${tz}"

run_step() {
  local step="$1"
  local file="$2"
  local model="$3"

  if [[ ! -f "$file" ]]; then
    echo "Missing file for step '$step': $file" >&2
    exit 3
  fi

  local basefile
  basefile="$(basename "$file")"
  local stem="${basefile%.*}"

  # Fossil filename (include step name and probe stem if probe)
  local safe_model="${model//:/_}"
  local ts_safe="${ts_iso//:/-}"
  local fossil="sessions/${ts_safe}-${safe_model}-${step}-${basefile}"


[[ $VERBOSE -eq 1 ]] && {
  printf -- '\n==== STEP: %s ====\nINPUT: %s\nFOSSIL: %s\nMODEL: %s\n\n' \
    "$step" "$file" "$fossil" "$model"
}

# Optionally show the exact input that will be sent
if [[ $PRINT_INPUT -eq 1 ]]; then
  printf -- '--- BEGIN %s ---\n' "$file"
  cat "$file"
  printf -- '\n--- END %s ---\n\n' "$file"
fi

# Write header to fossil, then append model output
TS_COMPACT="$(date +%Y%m%d_%H%M%S)"
printf "### Model: %s\n### Probe: %s\n### Time: %s\n---\n\n" \
       "$model" "$basefile" "$TS_COMPACT" > "$fossil"
ollama run "$model" < "$file" | tee -a "$fossil"

# Log to TSV (true columns)
# printf "%s\t%s\t%s\t%s\n" "$ts_iso" "$model" "$basefile" "$fossil" \
#  >> "Sluglasses_session_log.tsv"

# (Legacy) also keep the old em-dash line for compatibility
echo "${ts_iso} — ${model} — ${basefile} — ${fossil} —" \
  >> "Sluglasses_session_log.md"

  echo "$fossil"
}

# Default stepping order if no rules are present
 default_next() {
   local current="$1"
   case "$current" in
    scaffold)
      if [[ -n "$ANCHOR" ]]; then
        echo "anchor"
      else
        echo "probe"
      fi
      ;;
    anchor) echo "probe";;
    probe) echo "stop";;
    *) echo "stop";;
  esac
}

current="scaffold"
while : ; do
  case "$current" in
    scaffold) fossil_path="$(run_step "scaffold" "${SCAFFOLD}" "${MODEL}")";;
    anchor)
      if [[ -n "$ANCHOR" ]]; then
        fossil_path="$(run_step "anchor" "${ANCHOR}" "${MODEL}")"
      fi
      ;;
    probe) fossil_path="$(run_step "probe" "${PROBE}" "${MODEL}")";;
    stop)     break;;
    *) echo "Unknown step: ${current}" >&2; exit 4;;
  esac

  if [[ -n "${RULES}" ]]; then
    # Let user rules decide; must echo one of: anchor | probe | stop
    next="$({ decide_next "${fossil_path}" "${current}" || true; } | tr -d '\r\n')"
    if [[ -z "$next" ]]; then
      # Fallback to default if rules returned nothing
      next="$(default_next "${current}")"
    fi
  else
    next="$(default_next "${current}")"
  fi

  current="$next"
done

[[ $VERBOSE -eq 1 ]] && echo "Sequence complete."
