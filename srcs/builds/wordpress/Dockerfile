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
    apt-get install -y php php-mysql php-fpm

# Copie des fichiers WordPress
COPY ./wpStart.sh /home/wpStart.sh

# Permissions d'exécution pour le script
RUN chmod 777 /home/wpStart.sh

# Lancement du script au démarrage du conteneur
ENTRYPOINT ["/home/wpStart.sh"]
