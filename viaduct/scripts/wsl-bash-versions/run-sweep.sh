#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

MODELS=("llama3.1:8b-instruct" "qwen2.5-coder:7b-instruct" "phi4:mini-instruct")
mapfile -t PROBES < <(find ./probes -type f -name "*.txt")
[[ ${#PROBES[@]} -gt 0 ]] || { echo "No probes found in ./probes"; exit 1; }

PROBE="${PROBES[RANDOM % ${#PROBES[@]}]}"

for M in "${MODELS[@]}"; do
  ./scripts/run-one.sh "$M" "$PROBE"
done
