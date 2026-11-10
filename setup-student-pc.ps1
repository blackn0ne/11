# Запускать на каждом компьютере класса (обычный PowerShell, права админа не нужны).
# Предварительно в VS Code должно быть установлено расширение Continue (Continue.continue).
$server = "http://192.168.110.100:20128/v1"
$key    = "sk-5c59bf4db5544923-fe1060-36a5a7d1"

# 1. Проверка доступа к серверу
try {
  Invoke-RestMethod -Uri "$server/models" -Headers @{Authorization="Bearer $key"} -TimeoutSec 10 | Out-Null
  Write-Host "Сервер доступен" -ForegroundColor Green
} catch {
  Write-Host "Нет доступа к $server : $($_.Exception.Message)" -ForegroundColor Red
  exit 1
}

# 2. Конфиг Continue
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
Write-Host "Готово: перезапустите VS Code. Модель: Free Coding AI" -ForegroundColor Green
