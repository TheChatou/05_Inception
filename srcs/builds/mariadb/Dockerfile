# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: chatou <chatou@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/24 14:39:12 by fcoullou          #+#    #+#              #
#    Updated: 2025/09/10 13:57:01 by chatou           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Image
FROM debian:bookworm

# Installation des dépendances
RUN apt-get update && apt-get upgrade && apt-get install -y mariadb-server

# Configuration de MariaDB
COPY dbStart.sh /home/dbStart.sh

# Permissions d'exécution pour le script
RUN chmod 777 /home/dbStart.sh

# Une fois la base de données créée, le script sera exécuté
ENTRYPOINT [ "/home/dbStart.sh" ]