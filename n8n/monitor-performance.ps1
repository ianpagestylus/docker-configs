Write-Host "🔍 Monitoreando rendimiento..." -ForegroundColor Cyan

while ($true) {
    Clear-Host
    
    # GPU Stats
    $gpuStats = nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader
    $gpuValues = $gpuStats.Split(',').Trim()
    
    Write-Host "📊 Estadísticas GPU:" -ForegroundColor Yellow
    Write-Host "Utilización: $($gpuValues[0])" -ForegroundColor Green
    Write-Host "Memoria Usada: $($gpuValues[1])" -ForegroundColor Green
    Write-Host "Memoria Total: $($gpuValues[2])" -ForegroundColor Green
    Write-Host "Temperatura: $($gpuValues[3])°C" -ForegroundColor Green
    
    # Ollama Stats
    $ollamaStats = docker stats ollama --no-stream --format "{{.CPUPerc}}\t{{.MemUsage}}"
    Write-Host "`n🚀 Estadísticas Ollama:" -ForegroundColor Yellow
    Write-Host "CPU: $($ollamaStats.Split()[0])" -ForegroundColor Green
    Write-Host "Memoria: $($ollamaStats.Split()[1])" -ForegroundColor Green
    
    Start-Sleep -Seconds 2
}