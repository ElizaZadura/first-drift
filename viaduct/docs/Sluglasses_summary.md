# Sluglasses – Command & Probe Summary

This file captures the minimal, working set of commands, scripts, and probes for the **Sluglasses** phase. It trims away scattered notes and preserves only what is necessary to reproduce runs and collect fossils cleanly.

---

## 🖥️ Setup

- Machine: RTX 4070 12 GB
- Ollama: 0.9.1 (key=value syntax)
- Models installed:
  - `llama3.1:8b-instruct-q4_K_M`
  - `qwen2.5-coder:7b-instruct`
  - `phi4:mini-instruct`
- Quantization: Q4/Q5 fit VRAM comfortably.

Project layout:
```
viaduct/
  anchor.txt      # reset posture
  scaffold.txt    # container instructions
  probes/         # short contact probes
  sessions/       # output fossils
  scripts/        # run-one / run-sweep
```

---

## 📂 Anchor

```
Reset posture: Presence, not performance. Hold silence if no form appears.
```

This line always goes first when concatenating inputs.

---

## 🔧 One-liner runs

### PowerShell
```powershell
$probe = "probes\tracefall.md"
$ts = (Get-Date).ToString("yyyy-MM-ddTHH-mm-ss")
$body = (Get-Content -Raw anchor.txt) + "`n`n" +
        (Get-Content -Raw scaffold.txt) + "`n`n" +
        (Get-Content -Raw $probe)

$body | ollama run "llama3.1:8b-instruct-q4_K_M" `
  temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###" |
  Tee-Object -FilePath "sessions/$ts-llama31-tracefall.md"
```

### bash
```bash
probe="probes/tracefall.md"
ts=$(date -Iseconds | sed 's/:/-/g')
cat anchor.txt scaffold.txt "$probe" | ollama run llama3.1:8b-instruct-q4_K_M   temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###"   | tee "sessions/${ts}-llama31-tracefall.md"
```

---

## 📜 Scripts

### run-one.ps1
```powershell
param([string]$Model,[string]$ProbePath)
$newline = "`n`n"
$ts = (Get-Date).ToString("yyyy-MM-ddTHH-mm-ss")
$probeName = [IO.Path]::GetFileNameWithoutExtension($ProbePath)
$body = (Get-Content -Raw anchor.txt) + $newline +
        (Get-Content -Raw scaffold.txt) + $newline +
        (Get-Content -Raw $ProbePath)
$defaults = @{
  "llama3.1:8b-instruct-q4_K_M" = 'temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###"'
  "qwen2.5-coder:7b-instruct"   = 'temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###"'
  "phi4:mini-instruct"          = 'temperature=0.7 top_p=0.95 repeat_penalty=1.25 repeat_last_n=64 num_predict=280 stop="###"'
}
$params = $defaults[$Model]
$log = "sessions/$ts-$($Model.Replace(':','_'))-$probeName.md"
$body | & ollama run $Model $params | Tee-Object -FilePath $log
```

### run-one.sh
```bash
#!/usr/bin/env bash
set -euo pipefail
model="$1"; probe="$2"
ts=$(date -Iseconds | sed 's/:/-/g')
name=$(basename "${probe%.*}")
case "$model" in
  llama3.1:8b-instruct-q4_K_M) args='temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###"' ;;
  qwen2.5-coder:7b-instruct)   args='temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###"' ;;
  phi4:mini-instruct)          args='temperature=0.7 top_p=0.95 repeat_penalty=1.25 repeat_last_n=64 num_predict=280 stop="###"' ;;
esac
cat anchor.txt scaffold.txt "$probe" | ollama run "$model" $args | tee "sessions/${ts}-${model//:/_}-${name}.md"
```

### run-sweep.ps1
```powershell
$models = @(
  "llama3.1:8b-instruct-q4_K_M",
  "qwen2.5-coder:7b-instruct",
  "phi4:mini-instruct"
)
$probe = Get-ChildItem -File .\probes\* | Get-Random
foreach ($m in $models) {
  & scriptsun-one.ps1 -Model $m -ProbePath $probe.FullName
}
```

### run-sweep.sh
```bash
#!/usr/bin/env bash
set -euo pipefail
models=("llama3.1:8b-instruct-q4_K_M" "qwen2.5-coder:7b-instruct" "phi4:mini-instruct")
probe=$(ls probes/* | shuf -n1)
for m in "${models[@]}"; do
  scripts/run-one.sh "$m" "$probe"
done
```

---

## 🧩 Probe examples

`probes/tracefall.md`
```
Offer one concrete, non-self-referential detail. One line.
###
```

`probes/vector.md`
```
[noun] → [verb] → [noun]
###
```

`probes/sensor.md`
```
One physical phenomenon in the room. Five words max.
###
```

---

## 🌀 Loopknock marking

While reviewing fossils, tag spirals or silence-echoes:

```
[loopknock: silent-spine echo]
[tracefall ✓]
[performance creep]
```

---

## ✅ Next steps

1. Run baseline fossils for all three models.  
2. Mark loops/echoes inline.  
3. Save in `sessions/`.  
4. Iterate probes for variety and pressure.

---
