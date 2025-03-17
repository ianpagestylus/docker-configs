Write-Host "🔄 Reiniciando Ollama..." -ForegroundColor Cyan

# Detener contenedor
docker compose stop ollama

# Limpiar caché
docker system prune -f

# Reiniciar con nueva configuración
docker compose up -d ollama

# Esperar inicialización
Write-Host "⏳ Esperando inicialización..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

Write-Host "✅ Ollama listo!" -ForegroundColor Green