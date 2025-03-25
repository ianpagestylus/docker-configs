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

# Lista de modelos a verificar/descargar
$models = @(
    @{
        name = "llama3:8b"
        description = "Modelo base Llama 3 8B"
    },
    @{
        name = "mistral"
        description = "Modelo Mistral base"
    },
    @{
        name = "llama2"
        description = "Modelo Llama 2 base"
    },
    @{
        name = "neural-chat"
        description = "Modelo optimizado para chat"
    }
)

# Verificar y descargar modelos
Write-Host "`n📥 Verificando modelos..." -ForegroundColor Yellow
foreach ($model in $models) {
    Write-Host "`nVerificando $($model.name)..." -ForegroundColor Cyan
    $modelExists = docker compose exec -T ollama ollama list | Select-String $model.name

    if (-not $modelExists) {
        Write-Host "🔄 Descargando $($model.name)..." -ForegroundColor Yellow
        docker compose exec -T ollama ollama pull $model.name
    } else {
        Write-Host "✅ Modelo $($model.name) ya instalado" -ForegroundColor Green
    }
}

# Probar el servicio
Write-Host "`n🧪 Probando Ollama..." -ForegroundColor Yellow
$response = curl -s -X POST http://localhost:11434/api/generate -d '{
    "model": "llama3:8b",
    "prompt": "di hola",
    "stream": false
}'

if ($response) {
    Write-Host "`n✅ Ollama respondió correctamente:" -ForegroundColor Green
    Write-Host $response
} else {
    Write-Host "`n❌ Error: Ollama no respondió" -ForegroundColor Red
}

# Verificar GPU y mostrar advertencias si necesario
Write-Host "`n🎮 Verificando GPU..." -ForegroundColor Magenta
$gpuStats = docker exec ollama nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits
if ($gpuStats) {
    $gpuValues = $gpuStats.Split(',').Trim()
    $usedMemory = [int]$gpuValues[1]
    $totalMemory = [int]$gpuValues[2]
    $memoryUsagePercent = [math]::Round(($usedMemory / $totalMemory) * 100, 2)

    Write-Host "GPU Utilización: $($gpuValues[0])%" -ForegroundColor $(if ([int]$gpuValues[0] -gt 80) { "Red" } else { "Green" })
    Write-Host "GPU Memoria: $usedMemory MB / $totalMemory MB ($memoryUsagePercent%)" -ForegroundColor $(if ($memoryUsagePercent -gt 90) { "Red" } else { "Green" })

    # Advertencias
    if ($memoryUsagePercent -gt 90) {
        Write-Host "`n⚠️  Advertencia: Uso de memoria GPU alto" -ForegroundColor Yellow
    }
}

# Verificar respuesta del modelo
$responseObj = $response | ConvertFrom-Json
Write-Host "`n📊 Estadísticas de respuesta:" -ForegroundColor Cyan
Write-Host "Tiempo total: $([math]::Round($responseObj.total_duration/1e9, 2)) segundos" -ForegroundColor Green
Write-Host "Tokens generados: $($responseObj.eval_count)" -ForegroundColor Green
Write-Host "Tokens/segundo: $([math]::Round($responseObj.eval_count/($responseObj.total_duration/1e9), 2))" -ForegroundColor Green

# Función mejorada para probar modelos
function Test-OllamaModel {
    param (
        [string]$modelName
    )

    $prompts = @(
        "Realiza la suma de 2+2",
        "¿Qué es Docker en una frase?",
        "Escribe un haiku sobre programación"
    )

    Write-Host "`n🧪 Probando modelo $modelName..." -ForegroundColor Yellow
    
    foreach ($prompt in $prompts) {
        Write-Host "`n📝 Prompt: $prompt" -ForegroundColor Cyan
        
        $startTime = Get-Date
        $response = docker compose exec -T n8n curl -s -X POST http://ollama:11434/api/generate -d "{
            `"model`": `"$modelName`",
            `"prompt`": `"$prompt`",
            `"stream`": false
        }"
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds

        if ($response) {
            $responseObj = $response | ConvertFrom-Json
            Write-Host "✅ Respuesta:" -ForegroundColor Green
            Write-Host $responseObj.response
            Write-Host "⏱️ Tiempo: $([math]::Round($duration, 2)) segundos" -ForegroundColor Gray
            
            # Verificar GPU
            $gpuStats = docker exec ollama nvidia-smi --query-gpu=utilization.gpu,memory.used --format=csv,noheader,nounits
            if ($gpuStats) {
                $gpuValues = $gpuStats.Split(',').Trim()
                Write-Host "🎮 GPU: $($gpuValues[0])% | Memoria: $($gpuValues[1])MB" -ForegroundColor Magenta
            }
        }
        
        Start-Sleep -Seconds 2
    }
}

# Probar cada modelo
foreach ($model in $models) {
    Test-OllamaModel -modelName $model.name
}

# Mostrar resumen final
Write-Host "`n📊 Resumen de modelos instalados:" -ForegroundColor Cyan
docker compose exec -T ollama ollama list

Write-Host "`n✨ Inicialización completa!" -ForegroundColor Cyan