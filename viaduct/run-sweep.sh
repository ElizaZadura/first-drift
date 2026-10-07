#!/usr/bin/env bash
set -euo pipefail
models=("llama3.1:8b-instruct-q4_K_M" "qwen2.5-coder:7b-instruct" "phi4-mini:latest" "mistral:instruct")
probe="$(ls probes/*.md | shuf -n1)"
for m in "${models[@]}"; do
  echo "===== $m ====="
  echo "PROBE: $probe"
  ./run-one.sh "$m" "$probe"
done
