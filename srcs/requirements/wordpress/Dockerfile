FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Add the Sury repository for PHP 7.3
RUN apt-get update && \
    apt-get -y install apt-transport-https lsb-release ca-certificates wget && \
    wget -O /etc/apt/trusted.gpg.d/sury.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury.list

# Update package list and install PHP 7.3 and necessary packages
RUN apt-get update && \
    apt-get -y install php7.3 php7.3-mysqli php7.3-fpm wget sendmail && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Copy the custom PHP-FPM configuration and the startup script
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/
COPY ./tools /var/www/

# Make the startup script executable
RUN chmod +x /var/www/wordpress_start.sh

# Set the entrypoint to the startup script
ENTRYPOINT [ "/var/www/wordpress_start.sh" ]

# Command to run PHP-FPM
CMD ["/usr/sbin/php-fpm7.3", "--nodaemonize"]
