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

FROM debian:bookworm

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y php php-mysql php-fpm
    
# Copy WordPress files
COPY ./wpStart.sh /usr/local/bin/wpStart.sh

RUN chmod 777 /usr/local/bin/wpStart.sh

ENTRYPOINT ["/usr/local/bin/wpStart.sh"]
