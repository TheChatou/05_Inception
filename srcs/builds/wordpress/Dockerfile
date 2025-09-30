# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fcoullou <fcoullou@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/24 14:39:23 by fcoullou          #+#    #+#              #
#    Updated: 2025/08/01 15:03:51 by fcoullou         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Image
FROM debian:bookworm

# Installation des dépendances
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y php php-mysql php8.2-fpm

# Installation de iproute2 pour la commande ss (non c'est pas une connerie)
# C'est pour vérifier que le port 9000 est bien ouvert avant de lancer PHP-FPM
RUN apt-get install -y iproute2

# Installation de WordPress dans /var/www/html
RUN apt-get install -y wget unzip && \
    wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip && \
    mkdir -p /var/www/html && \
    unzip /tmp/wordpress.zip -d /tmp && \
    mv /tmp/wordpress/* /var/www/html/ && \
    rm -rf /tmp/wordpress /tmp/wordpress.zip

# Installation de curl pour wp-cli
RUN apt-get install -y curl

# Installation de wp-cli pour l'auto-config WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Configuration de PHP-FPM pour écouter sur toutes les interfaces réseau
RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf

# Copie des fichiers WordPress
COPY ./wpStart.sh /home/wpStart.sh

# Permissions d'exécution pour le script
RUN chmod 777 /home/wpStart.sh

# Lancement du script au démarrage du conteneur
ENTRYPOINT ["/home/wpStart.sh"]
