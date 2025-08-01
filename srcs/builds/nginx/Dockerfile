# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fcoullou <fcoullou@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/24 14:39:20 by fcoullou          #+#    #+#              #
#    Updated: 2025/08/01 18:58:25 by fcoullou         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Base image
FROM debian:bookworm

# Expose port 80
EXPOSE 80

# Install security features
RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Create necessary directories
RUN mkdir -p /var/www/html

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
