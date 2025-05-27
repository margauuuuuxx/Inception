NAME	= inception
COMPOSE	= docker compose
DC_FILE	= srcs/docker-compose.yml

.PHONY: all build up down clean flcean re

build:
#	--> -f to specify that the docker compose file isnt at the root
	$(COMPOSE) -f $(DC_FILE) build 

up:
#	--> -d to run in detach mode = in the background, as a daemon : keep the control of the terminal  
	$(COMPOSE) -f $(DC_FILE) up -d

down:
	$(COMPOSE) -f $(DC_FILE) down

clean:
#	--> -v removes named volumes created by the compose file
	$(COMPOSE) -f $(DC_FILE) down -v

fclean: clean
#	--> prune = clean up unused stuff 
	docker image prune -af
	docker volume prune -f

re: fclean build up 