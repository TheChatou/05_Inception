#!/bin/sh
set -eu

# injecter le mdp depuis le secret
PASS="$(cat /run/secrets/db_pswd)"

# générer wp-config.php si absent
if [ ! -f /var/www/html/wp-config.php ]; then
  php -r '
  $cfg = file_get_contents("/var/www/html/wp-config-sample.php");
  $cfg = preg_replace("/define\\(\\s*\\x27DB_NAME\\x27.*;/", "define( \x27DB_NAME\x27, getenv(\x27WORDPRESS_DB_NAME\x27) );", $cfg);
  $cfg = preg_replace("/define\\(\\s*\\x27DB_USER\\x27.*;/", "define( \x27DB_USER\x27, getenv(\x27WORDPRESS_DB_USER\x27) );", $cfg);
  $cfg = preg_replace("/define\\(\\s*\\x27DB_PASSWORD\\x27.*;/", "define( \x27DB_PASSWORD\x27, getenv(\x27WORDPRESS_DB_PASSWORD\x27) );", $cfg);
  $cfg = preg_replace("/define\\(\\s*\\x27DB_HOST\\x27.*;/", "define( \x27DB_HOST\x27, getenv(\x27WORDPRESS_DB_HOST\x27) );", $cfg);
  file_put_contents("/var/www/html/wp-config.php", $cfg);
  ';
  chown -R www-data:www-data /var/www/html
fi

# (optionnel) install auto via wp-cli si tu l'as dans l'image et si pas encore installé
# wp core install --url="https://${DOMAIN_NAME}" --title="${WORDPRESS_TITLE}" \
#   --admin_user="${WP_ADMIN_USER}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_ADMIN_EMAIL}" --path=/var/www/html --allow-root

exec php-fpm -F
