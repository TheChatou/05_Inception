# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fcoullou <fcoullou@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/24 14:39:20 by fcoullou          #+#    #+#              #
#    Updated: 2025/05/05 13:51:54 by fcoullou         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Base image
FROM nginx:alpine

#Copy the index.html file /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
