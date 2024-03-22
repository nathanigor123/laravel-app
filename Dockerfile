FROM php:8.3-fpm

# Copy composer.lock and composer.json into the working directory
COPY  composer.json /var/www/laravel-app/

# Set working directory
WORKDIR /var/www/laravel-app/

# Install dependencies for the operating system software
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    libzip-dev \
    unzip \
    git \
    libonig-dev \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions for php
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
# RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Install composer (php package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents to the working directory
COPY . /var/www/laravel-app

# Assign permissions of the working directory to the www-data user
RUN chown -R www-data:www-data \
        /var/www/laravel-app/storage \
        /var/www/laravel-app/bootstrap/cache

# Expose port 8000 and start php-fpm server (for FastCGI Process Manager)
EXPOSE 8000
EXPOSE 9000
CMD ["php-fpm"]
