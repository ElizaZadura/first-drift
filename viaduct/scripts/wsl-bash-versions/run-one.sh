#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

MODEL="${1:-llama3.1:8b-instruct}"
PROBE="${2:-./probes/probe_trace.txt}"

STAMP="$(date +%Y%m%d_%H%M%S)"
PROBE_BASENAME="$(basename "$PROBE" .txt)"
OUTDIR="./sessions"
mkdir -p "$OUTDIR"
OUTFILE="$OUTDIR/${STAMP}__${MODEL//:/_}__${PROBE_BASENAME}.md"

# Header first so file is never empty
{
  echo "### Model: $MODEL"
  echo "### Probe: $PROBE_BASENAME"
  echo "### Time: $STAMP"
  echo "---"
} > "$OUTFILE"

# Pipe scaffold + probe into ollama
{
  cat scaffold.txt
  echo
  cat "$PROBE"
} | ollama run "$MODEL" \
     temperature=0.6 \
     top_p=0.9 \
     repeat_penalty=1.15 \
     num_predict=200 \
  | tee -a "$OUTFILE"

echo "Saved -> $OUTFILE"
