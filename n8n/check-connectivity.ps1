Write-Host "🔍 Verificando conectividad entre servicios..." -ForegroundColor Cyan

function Test-PostgreSQL {
    Write-Host "`n📊 Verificando conexión a PostgreSQL..." -ForegroundColor Yellow
    
    # Verificar estado del contenedor
    $pgStatus = docker compose ps postgres --format json | ConvertFrom-Json
    Write-Host "Estado PostgreSQL: $($pgStatus.State)" -ForegroundColor $(if ($pgStatus.State -like "*healthy*") { "Green" } else { "Red" })
    
    # Probar conexión desde n8n
    Write-Host "`nProbando conexión desde n8n a PostgreSQL..." -ForegroundColor Yellow
    $result = docker compose exec -T n8n pg_isready -h postgres
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Conexión exitosa a PostgreSQL" -ForegroundColor Green
    } else {
        Write-Host "❌ Error conectando a PostgreSQL" -ForegroundColor Red
    }
}

function Test-Ollama {
    Write-Host "`n🤖 Verificando conexión a Ollama..." -ForegroundColor Yellow
    
    # Verificar API
    Write-Host "`nProbando API de Ollama..." -ForegroundColor Yellow
    try {
        $response = docker compose exec -T n8n curl -s http://ollama:11434/api/version
        $version = ($response | ConvertFrom-Json).version
        if ($version) {
            Write-Host "✅ API de Ollama accesible (Versión: $version)" -ForegroundColor Green
        } else {
            Write-Host "❌ API de Ollama no responde o la respuesta no es válida" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ API de Ollama no responde: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Verificar ping
    Write-Host "`nHaciendo ping a Ollama..." -ForegroundColor Yellow
    docker compose exec n8n ping -c 2 ollama
}

function Test-Network {
    Write-Host "`n🌐 Verificando red 'internal'..." -ForegroundColor Yellow
    
    $network = docker network inspect n8n_internal | ConvertFrom-Json
    
    Write-Host "`nContenedores conectados:" -ForegroundColor Yellow
    $network.Containers.PSObject.Properties | ForEach-Object {
        $container = $_.Value
        Write-Host "- $($container.Name): $($container.IPv4Address)" -ForegroundColor Green
    }
}

function Test-Variables {
    Write-Host "`n🔧 Verificando variables de entorno..." -ForegroundColor Yellow
    
    Write-Host "`nVariables en n8n:" -ForegroundColor Yellow
    $vars = @(
        "POSTGRES_DB",
        "POSTGRES_USER",
        "POSTGRES_PASSWORD",
        "DB_POSTGRESDB_DATABASE",
        "OLLAMA_HOST"
    )
    
    foreach ($var in $vars) {
        $value = docker compose exec -T n8n env | findstr $var
        if ($value) {
            Write-Host "✅ $var configurada" -ForegroundColor Green
        } else {
            Write-Host "❌ $var no encontrada" -ForegroundColor Red
        }
    }
}

function Test-Tools {
    Write-Host "`n🔧 Verificando herramientas instaladas..." -ForegroundColor Cyan

    $tests = @(
        @{
            name = "PostgreSQL"
            command = "psql --version"
            icon = "📀"
        },
        @{
            name = "Wget"
            command = "wget --version | head -n 1"
            icon = "🌐"
        },
        @{
            name = "Curl"
            command = "curl --version | head -n 1"
            icon = "📡"
        },
        @{
            name = "Ping"
            command = "ping -c 1 ollama"
            icon = "🔌"
        }
    )

    foreach ($test in $tests) {
        Write-Host "`n$($test.icon) Probando $($test.name)..." -ForegroundColor Yellow
        $result = docker compose exec -T n8n sh -c $test.command
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ $($test.name) instalado y funcionando" -ForegroundColor Green
            Write-Host $result -ForegroundColor Gray
        } else {
            Write-Host "❌ Error con $($test.name)" -ForegroundColor Red
        }
    }
}

# Ejecutar todas las pruebas
Write-Host "🔍 Iniciando verificación completa del sistema..." -ForegroundColor Cyan
Test-Tools
Test-Network
Test-PostgreSQL
Test-Ollama
Test-Variables

Write-Host "`n📝 Verificando logs de servicios..." -ForegroundColor Yellow
Write-Host "`nLogs de n8n:" -ForegroundColor Cyan
docker compose logs --tail 10 n8n

Write-Host "`nLogs de PostgreSQL:" -ForegroundColor Cyan
docker compose logs --tail 10 postgres

Write-Host "`nLogs de Ollama:" -ForegroundColor Cyan
docker compose logs --tail 10 ollama