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

# Base image
FROM debian:bookworm

# Install dependencies
RUN apt-get update && apt-get upgrade && apt-get install -y mariadb-server

# Configure MariaDB
COPY dbStart.sh /usr/local/bin/dbStart.sh

RUN chmod 777 /usr/local/bin/dbStart.sh

# Once the database is created, the script will be executed
ENTRYPOINT [ "dbStart.sh" ]

