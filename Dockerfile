# Usar imagem base do PHP 8.4 FPM
FROM php:8.4-fpm AS base

ARG user=useful
ARG uid=1000

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libpq-dev \
    libzip-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install \
    pdo_pgsql \
    pgsql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user && \
    mkdir -p /home/$user/.composer && chown -R $user:$user /home/$user

WORKDIR /var/www

# ---------- Dependências PHP ----------
FROM base AS php-deps
COPY composer.* ./
RUN composer install --no-scripts --no-autoloader --prefer-dist --no-dev

# ---------- Build Frontend ----------
FROM node:22-alpine AS frontend
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY resources ./resources
COPY vite.config.ts ./vite.config.ts
COPY tsconfig.json ./tsconfig.json
RUN npm run build

# ---------- Produção ----------
FROM base AS production
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV LOG_CHANNEL=stderr

COPY --chown=$user:$user . .
COPY --from=php-deps /var/www/vendor /var/www/vendor
COPY --from=frontend /app/dist /var/www/public/build

RUN composer dump-autoload --optimize && \
    php artisan vendor:publish --provider="Laravel\Fortify\FortifyServiceProvider" --force || true && \
    chown -R $user:$user /var/www && \
    chmod -R 775 storage bootstrap/cache

USER $user
EXPOSE 9000
CMD ["php-fpm"]

# ---------- Desenvolvimento (opcional) ----------
FROM base AS development
# Inclui Node em ambiente dev para Vite hot reload dentro do container, se desejado
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs
CMD ["php-fpm"]