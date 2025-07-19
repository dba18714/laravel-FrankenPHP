FROM dunglas/frankenphp:latest AS base

# 设置服务器名称为HTTP，因为Zeabur会处理HTTPS
ENV SERVER_NAME=":8080"
ENV OCTANE_SERVER=frankenphp

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libpq-dev \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装PHP扩展
RUN install-php-extensions \
    pdo_mysql \
    pdo_pgsql \
    gd \
    zip \
    opcache \
    redis \
    pcntl \
    sockets

# 复制Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 设置工作目录
WORKDIR /app

# 开发阶段
FROM base AS development

# 复制PHP开发配置
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# 复制应用代码
COPY . /app

# 安装依赖
RUN composer install --optimize-autoloader

# 设置权限
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# 生产阶段
FROM base AS production

# 复制生产PHP配置
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 复制composer文件并安装依赖
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-cache --no-scripts --no-autoloader --optimize-autoloader

# 复制应用代码
COPY . /app

# 完成composer自动加载
RUN composer dump-autoload --optimize --no-dev

# Laravel优化命令
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# 设置权限
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# 暴露端口
EXPOSE 8080

# 启动命令
CMD ["php", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0", "--port=8080"] 