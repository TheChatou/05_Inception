# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fcoullou <fcoullou@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/24 14:33:15 by fcoullou          #+#    #+#              #
#    Updated: 2025/08/01 15:02:29 by fcoullou         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

################################################################################
##	PROG NAME	################################################################

################################################################################
##	FILES		################################################################

################################################################################
##	COMPILER	################################################################


################################################################################
##	+++++		################################################################
GREEN=\033[0;32m
RED=\033[0;31m
RESET=\033[0m
CLEAR_EOL=\033[K
CLEAR_EOL_FROM_CURSOR=; tput el; printf 

COMPOSE = docker compose -f srcs/docker-compose.yml -p inception

################################################################################
##	RULES		################################################################

all: mariadb_data wordpress_data build up 

#build les dossiers des data
mariadb_data:
	@mkdir -p /home/fcoullou/data/mariadb

wordpress_data:
	@mkdir -p /home/fcoullou/data/wordpress
	
#verifie la construction et construit
up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build --no-cache

#	ATTENTION: supprime les commentaires et tout
docker-rm:
	docker volume rm mariadb

#	ATTENTION: supprime les dossiers de data
purge:
	sudo rm -rf /home/fcoullou/data/wordpress/*	|| true
	sudo rm -rf /home/fcoullou/data/mariadb/*	|| true

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

clean:
	$(COMPOSE) down -v --remove-orphans

fclean: clean
	docker image prune -f
	docker builder prune -f

re: fclean build up

.PHONY: up down build ps logs clean fclean purge re
#------------------------------------------------------------------------------#