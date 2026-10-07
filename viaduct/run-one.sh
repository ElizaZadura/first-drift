#!/usr/bin/env bash
set -euo pipefail
model="${1:?model}"
probe="${2:?probe file}"

[ -f "$probe" ] || { echo "ERR missing probe: $probe (pwd=$(pwd))" >&2; exit 1; }

case "$model" in
  phi4:mini-instruct|phi4-mini|phi4-mini:*) model="phi4-mini:latest" ;;
esac

ts_iso=$(date -Iseconds)        # e.g., 2025-09-16T16:00:06+02:00
ts_file=${ts_iso//:/-}          # safe for filenames: 2025-09-16T16-00-06+02-00
name=$(basename "${probe%.*}")

case "$model" in
  llama3.1:8b-instruct-q4_K_M) args='temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###"' ;;
  qwen2.5-coder:7b-instruct)   args='temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###"' ;;
  phi4-mini:latest)            args='temperature=0.7 top_p=0.95 repeat_penalty=1.25 repeat_last_n=64 num_predict=280 stop="###"' ;;
  *)                           args='temperature=0.6 top_p=0.9 num_predict=280 stop="###"' ;;
esac

mkdir -p sessions

log="sessions/${ts_file}-${model//:/_}-${name}.md"
cat scaffold.txt "$probe" | ollama run "$model" $args | tee "$log"

probe_base=$(basename "$probe")
echo "$ts_iso — $model — $probe_base — $log" >> Sluglasses_session_log.md

# --- Dual-layer log: append a human-friendly mirror right after the raw line ---
probe_name="${probe_base%.md}"
# Keep model string as-is for readability (avoids brittle parsing).
ts_human="${ts_iso/T/ }"   # e.g., 2025-09-16 20:30:52+02:00
{
  echo "→ Date/Time: ${ts_human} | Model: ${model} | Probe: ${probe_name} | Fossil: ${log}"
} >> Sluglasses_session_log.md


