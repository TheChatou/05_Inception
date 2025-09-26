# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: chatou <chatou@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/24 14:39:20 by fcoullou          #+#    #+#              #
#    Updated: 2025/09/10 14:27:53 by chatou           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#   NGINX va etre la seule porte d'entree de l'infrastructure
#   Il doit donc etre le plus securise possible, d'ou l'utilisation du port 443
#  pour le SSL.
#   Il doit servir les fichiers statiques (html, css, js) et faire du reverse proxy
#  vers le service php-fpm pour les fichiers dynamiques (php).


# image
FROM debian:bookworm

# Port 443 pour le https
EXPOSE 443

# Installation de nginx
RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx

# Copie de la configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY site.conf /etc/nginx/conf.d/site.conf

# Copie des certificats SSL
COPY server.crt /etc/nginx/certs/server.crt
COPY server.key /etc/nginx/certs/server.key

# Création des répertoires nécessaires
RUN mkdir -p /var/www/wordpress

# Démarrage de Nginx
CMD ["nginx", "-g", "daemon off;"]
