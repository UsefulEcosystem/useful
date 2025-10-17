# Usar imagem base do PHP 8.4 FPM
FROM php:8.4-fpm

# Argumentos
ARG user=useful
ARG uid=1000

# Instalar dependências do sistema
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

# Instalar Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

# Instalar extensões do PHP
RUN docker-php-ext-install \
    pdo_pgsql \
    pgsql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Criar usuário para a aplicação
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Definir diretório de trabalho
WORKDIR /var/www

# Copiar arquivos de dependências primeiro (para cache do Docker)
COPY package*.json ./
COPY composer.* ./

# Instalar dependências do PHP (sem scripts para evitar problemas)
RUN composer install --no-scripts --no-autoloader

# Instalar dependências do Node
RUN npm install

# Copiar o restante da aplicação
COPY . .

# Executar otimizações do Composer
RUN composer dump-autoload --optimize

# Ajustar permissões (Executar uma vez no primeiro build)
RUN chown -R $user:$user /var/www
RUN chmod -R 775 storage bootstrap/cache

# Usuário
USER $user

# Expor porta 9000 para PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]