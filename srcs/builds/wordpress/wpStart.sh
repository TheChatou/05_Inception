#!/bin/sh
set -eu          # -e : exit on error ; -u : exit on undefined var

# On associe les variables d'environnement aux variables utilisées dans le script
DB_PASS="$(cat /run/secrets/db_password)"
WP_ADMIN_PASS="$(cat /run/secrets/wp_password)"

DB_NAME="${WORDPRESS_DB_NAME}"
DB_USER="${WORDPRESS_DB_USER}"
DB_HOST="${WORDPRESS_DB_HOST}"

SITE_DOMAIN="${DOMAIN_NAME}"
ADMIN_USER="${WP_ADMIN_USER}"
ADMIN_EMAIL="${WP_ADMIN_EMAIL}"

WEBROOT="/var/www/html"

# Eviter les problèmes de droits
mkdir -p "${WEBROOT}"
chown -R www-data:www-data "${WEBROOT}"
cd "${WEBROOT}"

# 1) Créer wp-config.php si absent
if [ ! -f wp-config.php ]; then
  wp config create \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASS}" \
    --dbhost="${DB_HOST}" \
    --skip-check \        # on ne teste pas la DB maintenant
    --force \
    --allow-root
  wp config shuffle-salts --allow-root
fi

# 2) Installer WordPress si pas déjà installé
if ! wp core is-installed --allow-root >/dev/null 2>&1; then
  # Installation. Si la DB n'est pas prête, wp-cli échouera, mais le conteneur redémarrera et rejouera ce script.
  wp core install \
    --url="https://${SITE_DOMAIN}" \
    --title="${SITE_DOMAIN}" \
    --admin_user="${ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASS}" \
    --admin_email="${ADMIN_EMAIL}" \
    --skip-email \
    --allow-root || true
fi

# 3) Second utilisateur (bonus du sujet)
# SECOND_USER="${WP_SECOND_USER:-editor42}"
# SECOND_EMAIL="${WP_SECOND_EMAIL:-editor42@example.local}"
# if ! wp user get "${SECOND_USER}" --field=ID --allow-root >/dev/null 2>&1; then
#   SEC_PASS="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 24 || true)"
#   wp user create "${SECOND_USER}" "${SECOND_EMAIL}" \
#     --role=editor \
#     --user_pass="${SEC_PASS}" \
#     --allow-root || true
# fi

chown -R www-data:www-data "${WEBROOT}"

# (optionnel) chown -R www-data:www-data /var/www/html
exec php-fpm8.2 -F