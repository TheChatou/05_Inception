#!/bin/sh
set -eu           # -e : exit on error ; -u : exit on undefined var

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# On associe les variables d'environnement aux variables utilisées dans le script
ROOT="$(cat /run/secrets/db_root_pswd)"
PASS="$(cat /run/secrets/db_pswd)"

# BUT : Lancement de MariaDB en fond #
# Initialisation puis lancement si la base est vide, sinon juste lancement
if [ ! -d /var/lib/mysql/mysql ]; then
  if command -v mariadb-install-db >/dev/null 2>&1; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
  else
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
  fi

# On lance un mysqld temporaire en local pour faire les confs de base
#     --skip-networking : uniquement en local
#     --socket : on précise le socket pour éviter les erreurs
  mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
  TMP_PID="$!"

# Etape 2 : On attend que le serveur soit prêt (Plus secu qu'un simple sleep)
  for i in $(seq 1 60); do
    mariadb -uroot --protocol=socket -h localhost -e "SELECT 1" >/dev/null 2>&1 && break
    sleep 1
  done

  # Config initiale (root, DB, user)
  mariadb --protocol=socket -uroot -h localhost <<SQL
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

  # Arrêt propre du mysqld temporaire
  mysqladmin --protocol=socket -uroot -p"${ROOT}" shutdown || kill "$TMP_PID"
  wait "$TMP_PID"
fi

# bind sur 0.0.0.0 pour que WordPress (autre conteneur) puisse se connecter
exec mysqld --user=mysql --bind-address=0.0.0.0
