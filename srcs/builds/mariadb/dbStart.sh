#!/bin/sh
set -eu

DB="${MYSQL_DATABASE:-wordpress_db}"
USR="${MYSQL_USER:-wordpress_user}"
ROOT="$(cat /run/secrets/db_root_password)"
PASS="$(cat /run/secrets/db_password)"

/usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid --socket=/run/mysqld/mysqld.sock &
PID=$!

# attendre que mysqld réponde
for i in $(seq 1 60); do
  mysqladmin ping -h 127.0.0.1 -p"$ROOT" --silent && break
  sleep 1
done

mysql -uroot -p"$ROOT" <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$USR'@'%' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON \`$DB\`.* TO '$USR'@'%';
FLUSH PRIVILEGES;
SQL

wait "$PID"
