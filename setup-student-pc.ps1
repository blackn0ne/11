# Run on each classroom PC. No admin rights needed.
$server = "http://192.168.110.100:20128/v1"
$key    = "sk-5c59bf4db5544923-fe1060-36a5a7d1"

Write-Host "Checking server $server ..."
try {
  Invoke-RestMethod -Uri "$server/models" -Headers @{Authorization="Bearer $key"} -TimeoutSec 10 | Out-Null
  Write-Host "OK: server is reachable" -ForegroundColor Green
} catch {
  Write-Host "ERROR: cannot reach server: $($_.Exception.Message)" -ForegroundColor Red
  Write-Host "Check: server IP, firewall on the server (port 20128), same network."
  Read-Host "Press Enter to close"
  exit 1
}

$dir = Join-Path $env:USERPROFILE ".continue"
New-Item -ItemType Directory -Force $dir | Out-Null
$cfg = @"
name: Classroom
version: 1.0.0
schema: v1
models:
  - name: Free Coding AI
    provider: openai
    model: free-coding
    apiBase: $server
    apiKey: $key
    roles: [chat, edit, apply]
"@
Set-Content -Path (Join-Path $dir "config.yaml") -Value $cfg -Encoding utf8
Write-Host "DONE: config written to $dir\config.yaml" -ForegroundColor Green
Write-Host "Restart VS Code. Model name: Free Coding AI"
Read-Host "Press Enter to close"
