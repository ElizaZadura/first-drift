
param(
  [Parameter(Mandatory=$true)][string]$Model,
  [Parameter(Mandatory=$true)][string]$ProbePath
)

$newline = "`n`n"
$ts = (Get-Date).ToString("yyyy-MM-ddTHH-mm-ss")
$probeName = [IO.Path]::GetFileNameWithoutExtension($ProbePath)

$body = (Get-Content -Raw anchor.txt) + $newline +
        (Get-Content -Raw scaffold.txt) + $newline +
        (Get-Content -Raw $ProbePath)

switch -regex ($Model) {
  '^phi4[-:]?mini' { $Model = 'phi4-mini:latest' }
}

$defaults = @{
  "llama3.1:8b-instruct-q4_K_M" = 'temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###"'
  "qwen2.5-coder:7b-instruct"   = 'temperature=0.6 top_p=0.9 repeat_penalty=1.2 repeat_last_n=64 num_predict=280 stop="###"'
  "phi4-mini:latest"            = 'temperature=0.7 top_p=0.95 repeat_penalty=1.25 repeat_last_n=64 num_predict=280 stop="###"'
}
$params = $defaults[$Model]; if (-not $params) { $params = 'temperature=0.6 top_p=0.9 num_predict=280 stop="###"' }

if (-not (Test-Path -Path "sessions")) { New-Item -ItemType Directory -Path "sessions" | Out-Null }

$logPath = "sessions/$ts-$($Model.Replace(':','_'))-$probeName.md"
$body | & ollama run $Model $params | Tee-Object -FilePath $logPath

$iso = (Get-Date).ToString("s")
$probeBase = [IO.Path]::GetFileName($ProbePath)
$line = "$iso — $Model — $probeBase — $logPath —"
Add-Content -Path "Sluglasses_session_log.md" -Value $line
