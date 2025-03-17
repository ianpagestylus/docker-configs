function Monitor-Ollama {
    param(
        [int]$duration = 60,
        [int]$interval = 5
    )

    Write-Host "🔍 Monitoreando Ollama por $duration segundos" -ForegroundColor Cyan
    
    $iterations = [math]::Ceiling($duration / $interval)
    $stats = @()

    for ($i = 1; $i -le $iterations; $i++) {
        $stat = docker stats ollama --no-stream --format "{{.CPUPerc}};{{.MemUsage}};{{.MemPerc}}"
        $values = $stat.Split(';')
        
        $stats += [PSCustomObject]@{
            CPU = $values[0]
            Memory = $values[1]
            MemPercent = $values[2]
            Timestamp = Get-Date
        }

        Write-Host "📊 Muestra $i de $iterations" -ForegroundColor Yellow
        Write-Host "CPU: $($values[0])" -ForegroundColor Green
        Write-Host "Memoria: $($values[1])" -ForegroundColor Green
        Write-Host "Porcentaje Memoria: $($values[2])`n" -ForegroundColor Green

        Start-Sleep -Seconds $interval
    }

    return $stats
}

# Ejecutar monitoreo
$results = Monitor-Ollama -duration 60 -interval 5