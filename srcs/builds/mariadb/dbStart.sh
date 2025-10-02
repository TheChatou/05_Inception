#!/bin/sh
set -eu           # -e : exit on error ; -u : exit on undefined var

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# On associe les variables d'environnement aux variables utilisées dans le script
ROOT="$(cat /run/secrets/db_root_password)"
PASS="$(cat /run/secrets/db_password)"
NAME="${MYSQL_DATABASE}"
USER="${MYSQL_USER}"

# BUT : Lancement de MariaDB en fond #
# Initialisation puis lancement si la base est vide, sinon juste lancement
if [ ! -d /var/lib/mysql/mysql ] || [ "$(ls -A /var/lib/mysql/mysql 2>/dev/null | wc -l)" -eq 0 ]; then
  if command -v mariadb-install-db >/dev/null 2>&1; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
  else
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
  fi

  # Lancement temporaire de MariaDB
  mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
  TMP_PID="$!"              # Sauvegarde du PID pour kill si besoin ('$!' : PID du dernier job en arrière-plan)

  for i in $(seq 1 60); do
    mariadb -uroot --protocol=socket -h localhost -e "SELECT 1" >/dev/null 2>&1 && break
    sleep 1
  done

  # Création DB/utilisateur WordPress (idempotent)
  mariadb --protocol=socket -uroot -h localhost <<SQL
CREATE DATABASE IF NOT EXISTS \`${NAME}\`;
CREATE USER IF NOT EXISTS '${USER}'@'%' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON \`${NAME}\`.* TO '${USER}'@'%';
FLUSH PRIVILEGES;
SQL

  # Arrêt temporaire de MariaDB
  mysqladmin --protocol=socket -uroot -p"${ROOT}" shutdown || kill "$TMP_PID"
  wait "$TMP_PID"
fi

# bind sur 0.0.0.0 pour que WordPress (autre conteneur) puisse se connecter
mysqld --user=mysql --bind-address=0.0.0.0 &
MARIADB_PID=$!

# Attendre que MariaDB soit prêt
for i in $(seq 1 60); do
  mariadb -uroot --protocol=socket -h localhost -e "SELECT 1" >/dev/null 2>&1 && break
  sleep 1
done

# Création DB/utilisateur WordPress à chaque démarrage (idempotent)
mariadb --protocol=socket -uroot -h localhost <<SQL
CREATE DATABASE IF NOT EXISTS \`${NAME}\`;
CREATE USER IF NOT EXISTS '${USER}'@'%' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON \`${NAME}\`.* TO '${USER}'@'%';
FLUSH PRIVILEGES;
SQL

# Attendre la fin du serveur MariaDB (process principal)
wait $MARIADB_PID
