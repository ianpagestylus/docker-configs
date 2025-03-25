function Monitor-Services {
    param(
        [int]$duration = 60,
        [int]$interval = 5
    )

    Write-Host "🔍 Monitoreando servicios por $duration segundos" -ForegroundColor Cyan
    
    $iterations = [math]::Ceiling($duration / $interval)
    $stats = @()

    for ($i = 1; $i -le $iterations; $i++) {
        Write-Host "`n📊 Muestra $i de $iterations" -ForegroundColor Yellow

        # Monitorear Ollama
        $ollamaStats = docker stats ollama --no-stream --format "{{.CPUPerc}};{{.MemUsage}};{{.MemPerc}}"
        $ollamaValues = $ollamaStats.Split(';')
        
        Write-Host "`n🤖 Ollama:" -ForegroundColor Cyan
        Write-Host "CPU: $($ollamaValues[0])" -ForegroundColor Green
        Write-Host "Memoria: $($ollamaValues[1])" -ForegroundColor Green
        Write-Host "Porcentaje Memoria: $($ollamaValues[2])" -ForegroundColor Green

        # Monitorear n8n
        $n8nStats = docker stats n8n --no-stream --format "{{.CPUPerc}};{{.MemUsage}};{{.MemPerc}}"
        $n8nValues = $n8nStats.Split(';')
        
        Write-Host "`n🔄 n8n:" -ForegroundColor Magenta
        Write-Host "CPU: $($n8nValues[0])" -ForegroundColor Green
        Write-Host "Memoria: $($n8nValues[1])" -ForegroundColor Green
        Write-Host "Porcentaje Memoria: $($n8nValues[2])" -ForegroundColor Green

        # Verificar estado de PostgreSQL
        $pgStatus = docker compose ps postgres --format json | ConvertFrom-Json
        Write-Host "`n📀 PostgreSQL:" -ForegroundColor Blue
        Write-Host "Estado: $($pgStatus.Status)" -ForegroundColor Green

        $stats += [PSCustomObject]@{
            Timestamp = Get-Date
            Ollama = @{
                CPU = $ollamaValues[0]
                Memory = $ollamaValues[1]
                MemPercent = $ollamaValues[2]
            }
            N8N = @{
                CPU = $n8nValues[0]
                Memory = $n8nValues[1]
                MemPercent = $n8nValues[2]
            }
            PostgreSQL = $pgStatus.Status
        }

        Start-Sleep -Seconds $interval
    }

    return $stats
}

# Ejecutar monitoreo
$results = Monitor-Services -duration 120 -interval 10