Comandos para executar:

Iniciar a aplicação:

bash
docker-compose up -d --build
Instalar dependências e configurar:

bash
# Instalar dependências do Composer (se necessário)
docker-compose exec app composer install

# Instalar dependências do Node (se necessário)
docker-compose exec app npm install

# Gerar chave da aplicação
docker-compose exec app php artisan key:generate

# Executar migrações
docker-compose exec app php artisan migrate

# Compilar assets (para produção)
# docker-compose exec app npm run build
Comandos úteis:

bash
# Ver logs
docker-compose logs -f

# Executar comandos Artisan
docker-compose exec app php artisan make:model Product

# Instalar pacotes Composer
docker-compose exec app composer require package-name

# Instalar pacotes npm
docker-compose exec app npm install package-name

# Acessar PostgreSQL
docker-compose exec postgresql psql -U laravel -d laravel
Acessos:

Aplicação: http://localhost:8000

Vite Dev Server: http://localhost:5173

PostgreSQL: localhost:5432

Características desta configuração:

✅ PHP 8.4 com todas as extensões necessárias

✅ Node.js 22 para o Vite/Inertia

✅ PostgreSQL 16

✅ Hot-reload do Vite funcionando

✅ Health checks para monitoramento

✅ Volumes nomeados para persistência

✅ Configuração otimizada para desenvolvimento

✅ Permissões corretas para Laravel