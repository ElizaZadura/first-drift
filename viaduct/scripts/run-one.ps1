param(
  [string]$Model = "llama3.1:8b-instruct",
  [string]$ProbePath = "..\probes\probe_trace.txt"
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $root "..")

$scaffold = Get-Content ".\scaffold.txt" -Raw
$probe    = Get-Content $ProbePath -Raw

$stamp = (Get-Date -Format "yyyyMMdd_HHmmss")
$probeName = Split-Path $ProbePath -LeafBase
$outDir = ".\sessions"
$outFile = Join-Path $outDir "$stamp__$($Model.Replace(':','_'))__$probeName.md"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

# Write a header immediately so the file is never empty
"### Model: $Model`n### Probe: $probeName`n### Time: $stamp`n---`n" | Out-File $outFile -Encoding UTF8

# Combine scaffold + probe and run
$input = "$scaffold`n`n$probe"
$input | ollama run $Model `
  temperature=0.6 `
  top_p=0.9 `
  repeat_penalty=1.15 `
  num_predict=200 |
  Tee-Object -FilePath $outFile -Append

Write-Host "Saved -> $outFile"
