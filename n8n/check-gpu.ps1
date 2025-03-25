Write-Host "🎮 Verificando recursos GPU disponibles..." -ForegroundColor Cyan

# Verificar GPU con nvidia-smi
try {
    $gpuInfo = nvidia-smi --query-gpu=name,memory.total,memory.free,memory.used,temperature.gpu,utilization.gpu --format=csv,noheader,nounits
    $gpuData = $gpuInfo.Split(',').Trim()

    Write-Host "`n📊 Información GPU:" -ForegroundColor Yellow
    Write-Host "Modelo: $($gpuData[0])" -ForegroundColor Green
    Write-Host "Memoria Total: $($gpuData[1]) MB" -ForegroundColor Green
    Write-Host "Memoria Libre: $($gpuData[2]) MB" -ForegroundColor Green
    Write-Host "Memoria Usada: $($gpuData[3]) MB" -ForegroundColor Green
    Write-Host "Temperatura: $($gpuData[4])°C" -ForegroundColor Green
    Write-Host "Utilización: $($gpuData[5])%" -ForegroundColor Green

    # Calcular memoria disponible para Ollama
    $recommendedMemory = [math]::Floor([int]$gpuData[1] * 0.85)
    Write-Host "`n💡 Configuración recomendada para Ollama:" -ForegroundColor Magenta
    Write-Host "OLLAMA_GPU_MEMORY=$recommendedMemory" -ForegroundColor Cyan

} catch {
    Write-Host "❌ Error al obtener información de la GPU: $_" -ForegroundColor Red
}