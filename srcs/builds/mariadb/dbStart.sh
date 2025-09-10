#!/bin/bash
# echo "Starting MariaDB..."

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

Start MariaDB
service mariadb start


sleep 5

mariadb -e "CREATE DATABASE IF NOT EXISTS \'${DB_NAME}\';"
mariadb -e "CREATE USER IF NOT EXISTS \'${DB_USER}\'@\'%\' IDENTIFIED BY \'${DB_PASSWORD}\';"
mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO \'${DB_USER}\'@\'%\';"

service mariadb stop

exec mysqld --bind-address=0.0.0.0
Keep the container running
tail -f /dev/null