FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools /var/www/

#RUN service mysql start && mysql < /var/www/initial_db.sql && rm -f /var/www/initial_db.sql;

# Run the MariaDB server, initialize the database, and clean up the initial SQL file
RUN mysqld_safe --skip-networking & sleep 5 && mysql -uroot < /var/www/initial_db.sql && rm -f /var/www/initial_db.sql

CMD ["mysqld"]
