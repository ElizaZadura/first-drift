$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $root "..")

# Models to sweep
$models = @(
  "llama3.1:8b-instruct",
  "qwen2.5-coder:7b-instruct",
  "phi4:mini-instruct"
)

# Pick a random probe
$probeFiles = Get-ChildItem .\probes -Filter *.txt
if ($probeFiles.Count -eq 0) { throw "No probes found in .\probes" }
$probe = (Get-Random $probeFiles).FullName

foreach ($m in $models) {
  pwsh .\scripts\run-one.ps1 -Model $m -ProbePath $probe
}
