# Usa la misma versión de n8n que estás ejecutando
FROM n8nio/n8n:1.32.2

# Cambia a usuario root para poder instalar el nodo
USER root

# Limpiamos la caché de npm y reinstalamos el nodo
RUN npm cache clean --force && \
    npm install -g @n8n/n8n-nodes-langchain@0.1.0

# Cambia nuevamente al usuario node por seguridad
USER node
