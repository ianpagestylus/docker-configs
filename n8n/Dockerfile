FROM n8nio/n8n:latest

USER root

# Instalar herramientas necesarias usando apk (Alpine package manager)
RUN apk add --no-cache \
    postgresql-client \
    wget \
    curl \
    iputils \
    bind-tools \
    && rm -rf /var/cache/apk/*

# Instalar el nodo de LangChain
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install @n8n/n8n-nodes-langchain

USER node
