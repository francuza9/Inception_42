#!/bin/bash

# Modify PHP-FPM configuration to listen on port 9000
sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/" "/etc/php/7.3/fpm/pool.d/www.conf"

# Set proper permissions for WordPress files
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

# Create necessary directories and files for PHP-FPM
mkdir -p /run/php/
touch /run/php/php7.3-fpm.pid

# Setup WordPress if wp-config.php does not exist
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress: setting up..."
    mkdir -p /var/www/html
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    cd /var/www/html
    wp core download --allow-root
    mv /var/www/wp-config.php /var/www/html/
    echo "WordPress: creating users..."
    wp core install --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_LOGIN} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
    wp user create --allow-root ${WP_USER_LOGIN} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD}
    echo "WordPress: set up!"
fi

# Execute the CMD passed as arguments
exec "$@"

