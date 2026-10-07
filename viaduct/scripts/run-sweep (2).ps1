
$models = @(
  "llama3.1:8b-instruct-q4_K_M",
  "qwen2.5-coder:7b-instruct",
  "phi4-mini:latest"
)
$probe = Get-ChildItem -File .\probes\* | Get-Random
foreach ($m in $models) {
  Write-Output "===== $m ====="
  & .\run-one.ps1 -Model $m -ProbePath $probe.FullName
}
