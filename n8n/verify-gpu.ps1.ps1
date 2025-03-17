# Verificar configuración de NVIDIA
Write-Host "🔍 Verificando runtime de Docker..." -ForegroundColor Cyan
docker info | Select-String "nvidia"

Write-Host "`n📊 Verificando GPU del sistema..." -ForegroundColor Cyan
nvidia-smi

Write-Host "`n🚀 Reiniciando Ollama con GPU..." -ForegroundColor Cyan
docker compose down
docker compose up -d ollama

Start-Sleep -Seconds 10

Write-Host "`n📝 Verificando GPU en Ollama..." -ForegroundColor Cyan
docker compose exec ollama nvidia-smi

Write-Host "`n🔍 Logs de Ollama..." -ForegroundColor Cyan
docker compose logs ollama | Select-String "gpu|cuda|nvidia"