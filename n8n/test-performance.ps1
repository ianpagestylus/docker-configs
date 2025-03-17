function Test-OllamaPerformance {
    param(
        [int]$iterations = 3,
        [string]$model = "llama3:8b",
        [string]$prompt = "¿Qué es Docker?"
    )
    
    $times = @()
    $gpuStats = @()
    
    Write-Host "🚀 Iniciando pruebas con GPU" -ForegroundColor Cyan
    
    for ($i = 1; $i -le $iterations; $i++) {
        Write-Host "`n📊 Prueba $i de $iterations" -ForegroundColor Yellow
        
        # Capturar métricas GPU
        $gpuBefore = docker exec ollama nvidia-smi --query-gpu=utilization.gpu,memory.used --format=csv,noheader,nounits
        
        $start = Get-Date
        curl -s -X POST http://localhost:11434/api/generate -d "{
            `"model`": `"$model`",
            `"prompt`": `"$prompt`",
            `"stream`": false,
            `"options`": {
                `"gpu_layers`": 35,
                `"num_gpu`": 1,
                `"num_thread`": 6,
                `"batch_size`": 1024,
                `"flash_attention`": true,
                `"mmap`": true,
                `"f16`": true
            }
        }" | Out-Null
        $end = Get-Date
        
        $duration = ($end - $start).TotalSeconds
        $gpuAfter = docker exec ollama nvidia-smi --query-gpu=utilization.gpu,memory.used --format=csv,noheader,nounits
        
        $times += $duration
        $gpuStats += [PSCustomObject]@{
            Before = $gpuBefore
            After = $gpuAfter
            Duration = $duration
        }
        
        Write-Host "⏱️ Tiempo: $($duration.ToString('F2')) segundos" -ForegroundColor Yellow
        Write-Host "🔄 GPU Antes: $gpuBefore" -ForegroundColor Cyan
        Write-Host "🔄 GPU Después: $gpuAfter" -ForegroundColor Cyan
    }
    
    # Análisis final
    $avgTime = ($times | Measure-Object -Average).Average
    Write-Host "`n📈 Resultados:" -ForegroundColor Green
    Write-Host "Tiempo promedio: $($avgTime.ToString('F2')) segundos" -ForegroundColor Green
    Write-Host "Uso máximo GPU: $(($gpuStats.After | ForEach-Object { $_.Split(',')[0] } | Measure-Object -Maximum).Maximum)%" -ForegroundColor Green
    
    return $gpuStats
}

# Ejecutar pruebas
$results = Test-OllamaPerformance -iterations 3
Write-Host "`n📊 Detalles de resultados:" -ForegroundColor Cyan
$results | ForEach-Object { Write-Host $_ }