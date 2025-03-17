README.md - n8n Docker Setup
md
Copiar
Editar
# 🚀 Configuración de n8n con Docker Compose

Este directorio contiene los archivos necesarios para desplegar **n8n**, una base de datos **PostgreSQL** y el servicio **Ollama** (para modelos de IA), utilizando **Docker Compose**.

## 📂 Estructura de Carpetas y Archivos

tree /F n8n

csharp
Copiar
Editar
n8n/
│── docker-compose.yml         # Configuración principal de Docker Compose
│── .env                       # Variables de entorno (credenciales, puertos)
│── postgres/
│   ├── data/                  # Datos persistentes de PostgreSQL
│   ├── init-scripts/
│   │   ├── init-db.sql        # Script SQL para inicialización de la DB
│── n8n/
│   ├── data/                  # Flujos y configuraciones persistentes de n8n
│   ├── logs/                  # Logs de ejecución de n8n
│── ollama/
│   ├── models/                # Modelos de IA descargados por Ollama
│   ├── data/                  # Configuración y almacenamiento de Ollama
│── README.md                  # Documentación del proyecto
md
Copiar
Editar
## 🛠 Requisitos previos
Antes de ejecutar los contenedores, asegúrate de tener instalado:
- **Docker** → [Descargar Docker](https://www.docker.com/get-started)
- **Docker Compose** → (Incluido en Docker Desktop)
- **Opcional:** `docker-compose.override.yml` para configuraciones personalizadas.

## 🚀 Cómo ejecutar los servicios
Ejecuta los siguientes comandos dentro del directorio `n8n/`:

### 1️⃣ **Iniciar los contenedores**
```sh
docker-compose up -d
2️⃣ Verificar que los contenedores están corriendo
sh
Copiar
Editar
docker ps
3️⃣ Acceder a la interfaz de n8n
Abre un navegador y ve a:
🔗 http://localhost:5678

4️⃣ Conectar a la base de datos PostgreSQL
Si necesitas conectarte a PostgreSQL, usa los siguientes datos:

Host: postgres
Usuario: n8n_user
Contraseña: n8n_pass
Base de datos: n8n_db
Puerto: 5432
sh
Copiar
Editar
docker exec -it postgres psql -U n8n_user -d n8n_db
📌 Configuración de .env
Puedes definir variables de entorno en un archivo .env para ocultar credenciales:

ini
Copiar
Editar
POSTGRES_USER=n8n_user
POSTGRES_PASSWORD=n8n_pass
POSTGRES_DB=n8n_db
N8N_DIAGNOSTICS_ENABLED=false
OLLAMA_HOST=ollama:11434
📜 Personalización y Configuración Adicional
🔹 Agregar Scripts de Inicialización a PostgreSQL
Si necesitas ejecutar SQL al iniciar PostgreSQL, colócalo en:

sh
Copiar
Editar
postgres/init-scripts/init-db.sql
Ejemplo:

sql
Copiar
Editar
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);
🔹 Ver logs de n8n
Si necesitas revisar los registros de ejecución de n8n:

sh
Copiar
Editar
docker logs -f n8n
🔹 Detener y eliminar los contenedores
Para apagar los contenedores y limpiar volúmenes:

sh
Copiar
Editar
docker-compose down -v
🛠 Solución de Problemas
❌ Error: "Database is not ready"
Si PostgreSQL tarda en iniciarse, prueba:

sh
Copiar
Editar
docker-compose restart n8n
❌ Error: Puerto en uso
Si el puerto 5678 está en uso, puedes cambiarlo en docker-compose.yml:

yaml
Copiar
Editar
    ports:
      - "8080:5678"
Luego, accede a http://localhost:8080.

📌 Recursos Adicionales
Documentación Oficial de n8n: https://docs.n8n.io/
Repositorio GitHub de n8n: https://github.com/n8n-io/n8n
✍ Autor: [Tu Nombre]
📅 Última actualización: $(date +'%Y-%m-%d')

yaml
Copiar
Editar

---

### **✅ Beneficios de este README.md**
✔ **Explica claramente la estructura del proyecto**  
✔ **Instrucciones paso a paso para levantar los contenedores**  
✔ **Configuración de `.env` y PostgreSQL**  
✔ **Solución de problemas comunes**  
✔ **Documentación y enlaces útiles**  

🔹 **¿Quieres agregar algo más, como un script para automatizar el proceso?** 🚀

# Configuración de N8N con Ollama y PostgreSQL

## Preparación
Antes de iniciar, crear los siguientes directorios:
```bash
mkdir -p postgres/data postgres/init-scripts n8n/data n8n/logs n8n/config ollama/data ollama/models
```

## Comandos básicos

Iniciar los servicios:
```bash
docker-compose up -d
```

Verificar el estado:
```bash
docker-compose ps
```

Ver logs:
```bash
docker-compose logs
```

Detener servicios:
```bash
docker-compose down
```

La configuración debería funcionar correctamente ya que:
- Las redes están bien configuradas (network: internal)
- Los puertos están correctamente mapeados
- Las dependencias están bien establecidas
- Los volúmenes están correctamente definidos
- Las variables de entorno están bien configuradas

Para asegurarte de que todo funcione, puedes validar:
- n8n estará disponible en: `http://localhost:5678`
- Ollama estará disponible en: `http://localhost:11434`
- PostgreSQL estará accesible internamente para n8n

No es necesario hacer cambios en los archivos actuales, pero te sugiero crear un nuevo archivo para documentar los comandos básicos:

### [README.md](file:///d%3A/cursos/docker-configs/n8n/README.md)


docker exec -it ollama ollama list


$body = @{
    model = "llama3:8b"
    prompt = "Resume en 5 líneas la historia de la computación."
    stream = $false
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json" | ConvertTo-Json -Depth 10


docker exec -it ollama ollama pull llama3:8b

Para descargar el modelo Llama 3.3 en el contenedor de Ollama dentro de Docker, ejecuta el siguiente comando en PowerShell o CMD:

sh
Copiar
Editar
docker exec -it ollama ollama pull llama3:8b
📌 Opciones de modelos disponibles
Si necesitas un modelo más grande o diferente, puedes usar:

Llama 3.3 (8B) → Requiere ~4.7GB de RAM

sh
Copiar
Editar
docker exec -it ollama ollama pull llama3:8b
Llama 3.3 (13B) → Requiere ~10GB de RAM

sh
Copiar
Editar
docker exec -it ollama ollama pull llama3:13b
Llama 3.3 (33B) → Requiere ~32GB de RAM (⚠️ Puede ser demasiado pesado para tu máquina)

sh
Copiar
Editar
docker exec -it ollama ollama pull llama3:33b
📌 Verificar que el modelo se haya descargado correctamente
Una vez completada la descarga, verifica la lista de modelos disponibles con:

sh
Copiar
Editar
docker exec -it ollama ollama list
Si todo está bien, deberías ver algo como:

makefile
Copiar
Editar
NAME        ID            SIZE     MODIFIED
llama3:8b   abc123xyz     4.7GB    Just now
📌 Probar el modelo descargado
Para asegurarte de que funciona correctamente, prueba generando un texto con:

sh
Copiar
Editar
docker exec -it ollama ollama run llama3:8b
📌 Esto abrirá una consola interactiva donde puedes escribir preguntas y recibir respuestas del modelo.

🚀 ¡Listo! Ahora tienes el modelo Llama 3.3 funcionando en Docker con Ollama. 🔥
Si necesitas otro modelo o tienes algún problema, dime y lo solucionamos. 💪








