# 🚀 N8N + Ollama + PostgreSQL: Stack de Automatización con IA Local

## 📑 Índice
- [🎯 Descripción](#-descripción)
- [⚡ Características](#-características)
- [📋 Requisitos](#-requisitos)
- [🛠️ Instalación](#️-instalación)
- [🤖 Modelos de IA](#-modelos-de-ia)
- [📊 Monitoreo](#-monitoreo)
- [🔌 Endpoints](#-endpoints)
- [📝 Ejemplos](#-ejemplos)
- [🛟 Solución de Problemas](#-solución-de-problemas)

## 🎯 Descripción
Sistema integrado de automatización con IA local que combina:
- 🔄 **n8n**: Plataforma de automatización
- 🧠 **Ollama**: Servidor de IA local
- 💾 **PostgreSQL**: Base de datos persistente

## ⚡ Características
- 🏃‍♂️ **IA Local**: 100% en tu máquina
- 🔒 **Privacidad**: Sin dependencias cloud
- 🎮 **GPU Optimizada**: Soporte NVIDIA
- 💾 **Persistencia**: PostgreSQL
- 🤖 **Automatización**: n8n + IA

## 📋 Requisitos
- 🐳 Docker y Docker Compose
- 🎮 NVIDIA GPU (CUDA)
- 💻 8GB+ RAM
- 💽 20GB+ espacio

## 🛠️ Instalación

### 📂 Estructura de Directorios
```bash
mkdir -p postgres/{data,init-scripts} n8n/{data,logs,config} ollama/{data,models}
```

### 🔧 Configuración
```bash
cp .env.example .env
# Editar .env según necesidades
```

### 🚀 Iniciar Servicios
```bash
docker compose up -d
```

### ✅ Verificación
```bash
./check-connectivity.ps1
```

## 🤖 Modelos de IA

### 📦 Modelos Disponibles
| Modelo | VRAM | Uso |
|--------|------|-----|
| 🦙 llama3:8b | 4.7GB | General |
| 🌪️ mistral | 4GB | Cálculos |
| 🦙 llama2 | 4GB | General |
| 🗣️ neural-chat | 4GB | Chat |

### 📥 Instalación de Modelos
```bash
docker compose exec ollama ollama pull llama3:8b
```

## 📊 Monitoreo

### 🔍 Scripts Disponibles
- 🎮 `check-gpu.ps1`: Estado GPU
- 📈 `monitor-gpu.ps1`: Uso GPU
- 🤖 `monitor-ollama.ps1`: Rendimiento Ollama
- 🔄 `monitor-services.ps1`: Estado servicios

## 🔌 Endpoints

### 🌐 Servicios Web
- 🔄 **n8n**: `http://localhost:5678`
  - 👤 Usuario: `admin`
  - 🔑 Password: `admin123`
- 🤖 **Ollama**: `http://localhost:11434`
- 💾 **PostgreSQL**: `localhost:5432`

## 📝 Ejemplos

### 🤖 Chatbot Básico
```powershell
$body = @{
    model = "llama3:8b"
    prompt = "¡Hola! ¿Cómo estás?"
    stream = $false
} | ConvertTo-Json

Invoke-RestMethod "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json"
```

## 🛟 Solución de Problemas

### 🔄 Reinicio de Servicios
```bash
./reset-ollama.ps1  # Problemas con Ollama
./reset-n8n.ps1     # Problemas con n8n
```

### 🔍 Diagnóstico
```bash
./check-connectivity.ps1  # Verificar conexiones
./check-gpu.ps1          # Verificar GPU
```

## 📚 Referencias
- 📖 [Docs n8n](https://docs.n8n.io/)
- 🤖 [Docs Ollama](https://ollama.ai/docs)
- 💾 [Docs PostgreSQL](https://www.postgresql.org/docs/)

## 📄 Licencia
📝 MIT License