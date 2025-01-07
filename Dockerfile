# Use the official Ubuntu base image
FROM ubuntu:20.04
 
# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
 
# Update package list and install required dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    nginx \
    curl \
    git \
    unzip \
    zip \
&& apt-get clean
 
# Add the PHP 8.3 repository and install PHP 8.3 and necessary extensions
RUN add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y \
    php8.3-fpm \
    php8.3-mbstring \
    php8.3-xml \
    php8.3-curl \
    php8.3-mysql \
    php8.3-bcmath \
    php8.3-zip \
    php8.3-gd \
&& apt-get clean
 
# Install Composer (for managing PHP dependencies)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
 
# Set working directory
WORKDIR /var/www/mnk-laravel
 
# Copy your Laravel project to the container
COPY . /var/www/mnk-laravel
 
# Set permissions for Laravel directories
RUN chown -R www-data:www-data /var/www/mnk-laravel \
&& chmod -R 775 /var/www/mnk-laravel/storage /var/www/mnk-laravel/bootstrap/cache
 
# Install Laravel dependencies using Composer
RUN composer install --no-dev --optimize-autoloader
 
# Copy the Nginx config file
COPY ./nginx.conf /etc/nginx/sites-available/default
 
# Expose port 80 for HTTP
EXPOSE 80
 
# Start both PHP-FPM and Nginx
CMD service php8.3-fpm start && service nginx start && tail -f /dev/null
