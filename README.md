## Useful — Guia de Configuração (Dev e Produção)

### Pré-requisitos
- Docker e Docker Compose
- Git
- (Opcional para dev fora do container) Node.js 22 e npm

### 1) Clonar e preparar variáveis de ambiente
```bash
cp .env.example .env
# Ajuste as variáveis DB_* se desejar (compose já fornece Postgres local)
```

Valores padrão usados pelo Docker (se não setados):
- DB_DATABASE=useful
- DB_USERNAME=user
- DB_PASSWORD=secret

### 2) Ambiente de Desenvolvimento (Docker)
1. Subir os serviços:
```bash
docker compose up -d
docker compose exec app composer install
docker compose exec vite npm ci
```
Serviços: `app` (PHP-FPM), `nginx`, `postgresql`, `vite`, `queue`, `scheduler`.

2. Gerar chave, linkar storage e migrar:
```bash
docker compose exec app php artisan key:generate
docker compose exec app php artisan storage:link
docker compose exec app php artisan migrate
```

3. Acessar a aplicação:
- http://localhost (Nginx)

4. Logs úteis (opcional):
```bash
docker compose logs -f nginx
docker compose logs -f app
docker compose logs -f vite
```

Notas dev:
- Hot reload de frontend via serviço `vite` (porta 5173, já proxied pelo Nginx).
- Filas e agendador já executam via serviços `queue` e `scheduler`.

### 3) Ambiente de Produção (Docker)
1. Crie um arquivo `.env.prod` com variáveis seguras (APP_KEY, DB_*, etc.).

2. Build e subida:
```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d --build
```

3. Rodar migrações:
```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod exec app php artisan migrate --force
```

Arquitetura prod:
- `app` usa imagem multi-stage com assets do Vite já compilados.
- `nginx` serve `public/` e faz proxy para PHP-FPM.
- `postgresql` com volume persistente e healthcheck.

### 4) Scripts npm principais
```bash
npm run dev        # Vite dev (se quiser rodar fora do container)
npm run build      # Build de assets
npm run lint       # ESLint
npm run format     # Prettier write
```

### 5) CI (GitHub Actions)
- Pipeline `CI` executa: Composer, migrações (Postgres 16), lint, typecheck e build, testes PHP.

### 6) Comandos úteis do Artisan (dentro do container)
```bash
docker compose exec app php artisan tinker
docker compose exec app php artisan queue:retry all
docker compose exec app php artisan schedule:list
```

### 7) Troubleshooting
- Porta 80 ocupada: altere o mapeamento em `docker-compose.yml` (serviço `nginx`).
- Porta 5432 ocupada: pare Postgres local ou troque a porta do serviço `postgresql`.
- Vite não atualiza: garanta `CHOKIDAR_USEPOLLING=true` (já configurado) e verifique permissões de arquivos.
- Erro `pg_isready`: confira `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` no `.env` e serviços estão saudáveis (`docker compose ps` e `logs`).

### 8) Limpeza
```bash
docker compose down -v    # remove containers e volumes (dev)
docker compose -f docker-compose.prod.yml down -v
```