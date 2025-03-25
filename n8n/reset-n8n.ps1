Write-Host "🔄 Reiniciando n8n..." -ForegroundColor Cyan

# Detener contenedores y limpiar
docker compose down -v
docker system prune -f

# Iniciar PostgreSQL primero
Write-Host "`n🚀 Iniciando PostgreSQL..." -ForegroundColor Yellow
docker compose up -d postgres

# Esperar a que PostgreSQL esté listo
Write-Host "`n⏳ Esperando a que PostgreSQL esté listo..." -ForegroundColor Yellow
$attempts = 0
do {
    $attempts++
    Start-Sleep -Seconds 5
    $status = docker compose ps postgres --format json | ConvertFrom-Json
    Write-Host "Intento $attempts - Estado PostgreSQL: $($status.Status)" -ForegroundColor Cyan
} while ($status.Status -notlike "*healthy*" -and $attempts -lt 6)

if ($attempts -ge 6) {
    Write-Host "Error: PostgreSQL no inició correctamente" -ForegroundColor Red
    exit 1
}

# Iniciar los demás servicios
Write-Host "`n🚀 Iniciando servicios restantes..." -ForegroundColor Yellow
docker compose up -d

# Esperar y verificar
Write-Host "`n⏳ Esperando a que los servicios inicien..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

# Verificar acceso web
Write-Host "`n🌐 Verificando acceso web..." -ForegroundColor Yellow
$attempts = 0
do {
    $attempts++
    Start-Sleep -Seconds 5
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5678" -Method HEAD -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ n8n accesible en http://localhost:5678" -ForegroundColor Green
            break
        }
    } catch {
        Write-Host "Intento $attempts - Esperando respuesta HTTP..." -ForegroundColor Cyan
    }
} while ($attempts -lt 6)

# Mostrar estado final
Write-Host "`n📊 Estado final de los servicios:" -ForegroundColor Green
docker compose ps

# Verificar logs de n8n
Write-Host "`n📝 Últimas líneas del log de n8n:" -ForegroundColor Yellow
docker compose logs n8n --tail 10