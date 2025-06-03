NAME	= inception
COMPOSE	= docker compose
DC_FILE	= srcs/docker-compose.yml

.PHONY: all build up down clean flcean re

all: build up

build:
	$(COMPOSE) -f $(DC_FILE) build 
	@echo "🔨 Building Docker images from $(DC_FILE)..."
#	--> -f to specify that the docker compose file isnt at the root

up:
#	--> -d to run in detach mode = in the background, as a daemon : keep the control of the terminal  
	$(COMPOSE) -f $(DC_FILE) up -d
	@echo "🚀 Starting Inception containers in detached mode..."

down:
	$(COMPOSE) -f $(DC_FILE) down
	@echo "🛑 Shutting down all containers..."

start:
	$(COMPOSE) -f $(DC_FILE) start
	@echo "▶️  Starting stopped containers without rebuilding..."

stop:
	$(COMPOSE) -f $(DC_FILE) stop
	@echo "⏹️  Stopping running containers without removing them..."

restart:
	$(MAKE) stop
	$(MAKE) start
	@echo "🔁 Restarting all containers..."

logs:
	$(COMPOSE) -f $(DC_FILE) logs -f
	@echo "📜 Streaming live logs from all services (Press Ctrl+C to stop)..."

clean:
#	--> -v removes named volumes created by the compose file
	$(COMPOSE) -f $(DC_FILE) down -v
	@echo "🧹 Stopping and removing containers and named volumes..."

fclean: clean
#	--> prune = clean up unused stuff 
	docker image prune -af
	docker volume prune -f
	@echo "🔥 Removing all images and orphaned volumes..."

re: fclean build up 
	@echo "♻️  Rebuilt and restarted everything from scratch!"