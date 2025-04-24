# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fcoullou <fcoullou@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/24 14:39:23 by fcoullou          #+#    #+#              #
#    Updated: 2025/04/24 14:39:24 by fcoullou         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM wordpress:5.7-php7.4-fpm
ENV WORDPRESS_DB_HOST=mariadb:3306
ENV WORDPRESS_DB_NAME=${MARIADB_DATABASE}
ENV WORDPRESS_DB_USER=${MARIADB_USER}
ENV WORDPRESS_DB_PASSWORD=${MARIADB_PASSWORD}
EXPOSE 9000
