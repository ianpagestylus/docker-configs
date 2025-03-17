Write-Host "🔍 Verificando conexión con Ollama..." -ForegroundColor Cyan

try {
    # Verificar si el contenedor está activo
    $containerStatus = docker compose ps ollama --format json
    Write-Host "`n� Estado del contenedor:" -ForegroundColor Yellow
    Write-Host $containerStatus

    # Probar generación simple con medición de tiempo
    Write-Host "`n🚀 Probando generación..." -ForegroundColor Yellow
    $startTime = Get-Date
    
    $response = curl -s -X POST http://localhost:11434/api/generate -d '{
        "model": "llama3:8b",
        "prompt": "di hola",
        "stream": false,
        "options": {
            "num_gpu": 1,
            "num_thread": 8,
            "batch_size": 2048
        }
    }'
    
    $endTime = Get-Date
    $duration = ($endTime - $startTime).TotalSeconds
    
    Write-Host "`n⏱️ Tiempo de respuesta: $($duration.ToString('F2')) segundos" -ForegroundColor Cyan
    Write-Host "`n✉️ Respuesta:" -ForegroundColor Green
    $responseObj = $response | ConvertFrom-Json
    Write-Host $responseObj.response

    # Mostrar métricas
    Write-Host "`n📊 Métricas:" -ForegroundColor Yellow
    Write-Host "Total Duration: $([math]::Round($responseObj.total_duration/1e9, 2)) segundos"
    Write-Host "Eval Count: $($responseObj.eval_count)"
    Write-Host "Tokens/segundo: $([math]::Round($responseObj.eval_count/($responseObj.total_duration/1e9), 2))"

} catch {
    Write-Host "`n❌ Error: $_" -ForegroundColor Red
    Write-Host "Verifica el estado de Ollama con: docker compose ps" -ForegroundColor Yellow
}