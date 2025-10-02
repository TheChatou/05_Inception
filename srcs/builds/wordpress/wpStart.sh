#!/bin/sh
set -eux         # -e : exit on error ; -u : exit on undefined var ; -x : debug

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

if [ ! -f wp-includes/version.php ]; then
  wp core download --allow-root
fi

# 1) Créer wp-config.php si absent
if [ ! -f wp-config.php ]; then
  wp config create \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASS}" \
    --dbhost="${DB_HOST}" \
    --skip-check \
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

chown -R www-data:www-data "${WEBROOT}"

exec php-fpm8.2 -F