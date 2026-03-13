# Use the official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies and PHP extensions required by Laravel
# Install system dependencies and robust PHP extensions required by Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip xml

# Enable Apache mod_rewrite for Laravel routing
RUN a2enmod rewrite

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy composer files FIRST to cache dependencies and prevent timeout errors
COPY composer.json composer.lock ./

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Run Composer install (ignore dev packages, optimize for production)
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Copy the rest of the application files
COPY . .

# Set necessary permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Update Apache configuration to point to Laravel's "public" directory
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
# Update this line in your Dockerfile
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev
