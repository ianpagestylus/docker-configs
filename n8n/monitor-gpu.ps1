function Monitor-GPU {
    param(
        [int]$duration = 60,
        [int]$interval = 5
    )

    Write-Host "🔍 Monitoreando GPU para Ollama..." -ForegroundColor Cyan
    
    $iterations = [math]::Ceiling($duration / $interval)

    for ($i = 1; $i -le $iterations; $i++) {
        Write-Host "`n📊 Muestra $i de $iterations" -ForegroundColor Yellow
        
        # Verificar GPU dentro del contenedor
        $gpuStats = docker exec ollama nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits
        $gpuValues = $gpuStats.Split(',').Trim()
        
        Write-Host "Utilización GPU: $($gpuValues[0])%" -ForegroundColor Green
        Write-Host "Memoria GPU Usada: $($gpuValues[1]) MB" -ForegroundColor Green
        Write-Host "Memoria GPU Total: $($gpuValues[2]) MB" -ForegroundColor Green
        
        Start-Sleep -Seconds $interval
    }
}

# Ejecutar monitoreo durante una prueba
Write-Host "🚀 Iniciando monitoreo de GPU..." -ForegroundColor Cyan
Monitor-GPU -duration 120 -interval 5