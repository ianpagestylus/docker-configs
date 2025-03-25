function Watch-Ollama {
    param(
        [int]$duration = 60,
        [int]$interval = 5,
        [switch]$IncludeGPU
    )

    Write-Host "🔍 Monitoreando Ollama por $duration segundos" -ForegroundColor Cyan
    
    $iterations = [math]::Ceiling($duration / $interval)
    $stats = @()

    for ($i = 1; $i -le $iterations; $i++) {
        $stat = docker stats ollama --no-stream --format "{{.CPUPerc}};{{.MemUsage}};{{.MemPerc}}"
        $values = $stat.Split(';')
        
        # Obtener estadísticas GPU si está habilitado
        $gpuStats = if ($IncludeGPU) {
            docker exec ollama nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits
        } else { $null }

        $stats += [PSCustomObject]@{
            Timestamp = Get-Date
            CPU = $values[0]
            Memory = $values[1]
            MemPercent = $values[2]
            GPU = if ($gpuStats) {
                $gpuValues = $gpuStats.Split(',').Trim()
                @{
                    Utilization = $gpuValues[0]
                    MemoryUsed = $gpuValues[1]
                    MemoryTotal = $gpuValues[2]
                }
            } else { $null }
        }

        # Mostrar estadísticas actuales
        Write-Host "`n📊 Muestra $i de $iterations" -ForegroundColor Yellow
        Write-Host "CPU: $($values[0])" -ForegroundColor Green
        Write-Host "Memoria: $($values[1])" -ForegroundColor Green
        Write-Host "Porcentaje Memoria: $($values[2])" -ForegroundColor Green
        
        if ($gpuStats) {
            Write-Host "`n🎮 GPU:" -ForegroundColor Magenta
            Write-Host "Utilización: $($stats[-1].GPU.Utilization)%" -ForegroundColor Green
            Write-Host "Memoria Usada: $($stats[-1].GPU.MemoryUsed)MB" -ForegroundColor Green
            Write-Host "Memoria Total: $($stats[-1].GPU.MemoryTotal)MB" -ForegroundColor Green
        }

        Start-Sleep -Seconds $interval
    }

    # Generar resumen
    $summary = @{
        CPUAvg = ($stats.CPU | ForEach-Object { [double]$_.TrimEnd('%') } | Measure-Object -Average).Average
        MemAvg = ($stats.MemPercent | ForEach-Object { [double]$_.TrimEnd('%') } | Measure-Object -Average).Average
        GPUAvg = if ($IncludeGPU) { ($stats.GPU.Utilization | Measure-Object -Average).Average } else { $null }
    }

    Write-Host "`n📈 Resumen:" -ForegroundColor Cyan
    Write-Host "CPU Promedio: $([math]::Round($summary.CPUAvg, 2))%" -ForegroundColor Yellow
    Write-Host "Memoria Promedio: $([math]::Round($summary.MemAvg, 2))%" -ForegroundColor Yellow
    if ($summary.GPUAvg) {
        Write-Host "GPU Promedio: $([math]::Round($summary.GPUAvg, 2))%" -ForegroundColor Yellow
    }

    return $stats
}

# Ejecutar monitoreo con GPU
$results = Watch-Ollama -duration 60 -interval 5 -IncludeGPU

# Display the collected statistics
Write-Host "📈 Resultados del monitoreo:" -ForegroundColor Cyan
$results | ForEach-Object {
    Write-Host "Timestamp: $($_.Timestamp)" -ForegroundColor Yellow
    Write-Host "CPU: $($_.CPU)" -ForegroundColor Green
    Write-Host "Memoria: $($_.Memory)" -ForegroundColor Green
    Write-Host "Porcentaje Memoria: $($_.MemPercent)`n" -ForegroundColor Green
}