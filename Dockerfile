###################################################
# Builder Stage: In this stage, we’ll install all the necessary dependencies and build the frontend assets (e.g., using npm).
# Final Stage: This stage will set up the application with PHP-FPM and Nginx, serving Laravel from the /var/www/public/ directory.
##############################################


# Stage 1: Builder Stage
FROM node:16 AS builder

# Set the working directory
WORKDIR /app

# Copy the necessary files for npm
COPY package.json package-lock.json /app/

# Install the frontend dependencies
RUN npm install

# Copy the entire application (excluding files defined in .dockerignore)
COPY . /app/

# Build the assets
RUN npm run production

# Stage 2: Final Stage (Laravel with PHP-FPM and Nginx)
FROM php:8.2-fpm

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    curl \
    nginx \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Set working directory for Laravel app
WORKDIR /var/www

# Copy application files from the builder stage
COPY --from=builder /app /var/www

# Set up Laravel specific permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for the application
EXPOSE 80

# Start Nginx and PHP-FPM services
CMD ["sh", "-c", "service nginx start && php-fpm"]














######################3
# Use official PHP image as the base image
# FROM php:8.2-fpm

# # Set working directory
# WORKDIR /var/www

# # Install system dependencies
# RUN apt-get update && apt-get install -y \
#     libpng-dev \
#     libjpeg-dev \
#     libfreetype6-dev \
#     zip \
#     unzip \
#     git \
#     curl \
#     nginx

# # Clear cache
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# # Install PHP extensions
# RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# # Install Composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# # Copy application files to the container
# COPY . .

# # Install application dependencies
# RUN composer install --no-interaction

# # Set permissions
# RUN chown -R www-data:www-data /var/www \
#     && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# # Copy Nginx configuration file
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# # Expose port 80 for the application
# EXPOSE 80

# # Start Nginx and PHP-FPM
# #CMD ["sh", "-c", "service nginx start && php-fpm"]

# CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]