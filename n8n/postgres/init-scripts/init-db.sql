-- Script de inicialización para la base de datos n8n

-- Asignar privilegios al usuario existente
REASSIGN OWNED BY CURRENT_USER TO "n8n";
GRANT ALL PRIVILEGES ON DATABASE n8n TO n8n;

-- Asegurarnos que el usuario tenga los permisos necesarios
GRANT ALL PRIVILEGES ON SCHEMA public TO n8n;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO n8n;
ALTER DEFAULT PRIVILEGES FOR ROLE n8n IN SCHEMA public GRANT ALL ON SEQUENCES TO n8n;