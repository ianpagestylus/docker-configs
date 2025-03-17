Write-Host "🔍 Verificando recursos GPU..." -ForegroundColor Cyan

# Verificar GPU del sistema
Write-Host "`n📊 GPU del Sistema:" -ForegroundColor Yellow
nvidia-smi --query-gpu=gpu_name,memory.total,memory.used,memory.free,utilization.gpu --format=csv,noheader

# Verificar GPU en Ollama
Write-Host "`n🚀 GPU en Ollama:" -ForegroundColor Yellow
docker exec ollama nvidia-smi --query-gpu=gpu_name,memory.total,memory.used,memory.free,utilization.gpu --format=csv,noheader

# Verificar límites configurados
Write-Host "`n⚙️ Límites configurados:" -ForegroundColor Yellow
docker exec ollama env | Select-String "NVIDIA|CUDA|OLLAMA"