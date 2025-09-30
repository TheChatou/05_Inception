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

ARG DOMAIN_NAME=localhost
ENV DOMAIN_NAME=${DOMAIN_NAME}

# Installation de nginx et openssl pour les certificats SSL | nginx minimal et remove le cache apt
RUN apt-get update \
 && apt-get install -y --no-install-recommends nginx openssl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Création des répertoires nécessaires
RUN mkdir -p /etc/nginx/certs /var/www/html

# Génération d'un certificat auto-signé pour le SSL - necessite de valider sur le navigateur
RUN openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout /etc/nginx/certs/server.key \
  -out    /etc/nginx/certs/server.crt \
  -subj "/CN=${DOMAIN_NAME}" \
  -addext "subjectAltName=DNS:${DOMAIN_NAME},DNS:www.${DOMAIN_NAME},DNS:localhost,IP:127.0.0.1" \
 && chmod 600 /etc/nginx/certs/server.key

# Copie de la configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY site.conf /etc/nginx/conf.d/site.conf
RUN rm -f /etc/nginx/conf.d/default.conf

# Port 443 pour le https
EXPOSE 443

# Démarrage de Nginx
CMD ["nginx", "-g", "daemon off;"]
