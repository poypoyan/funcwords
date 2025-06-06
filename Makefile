.PHONY: build up down restart logs shell django-shell test migrate makemigrations static clean help

# Default target
.DEFAULT_GOAL := help

build: ## Build the Docker images
	docker compose build

up: ## Start the application
	docker compose up

up-d: ## Start the application in detached mode
	docker compose up -d

down: ## Stop the application
	docker compose down

restart: down up ## Restart the application

logs: ## View application logs
	docker compose logs -f

shell: ## Access the web container's shell
	docker compose exec web /bin/bash

django-shell: ## Access Django's Python shell
	docker compose exec web python manage.py shell

test: ## Run Django tests
	docker compose exec web python manage.py test

migrate: ## Apply database migrations
	docker compose exec web python manage.py migrate

makemigrations: ## Create new database migrations
	docker compose exec web python manage.py makemigrations

makemigrations-fwapp: ## Create new database migrations for fwapp
	docker compose exec web python manage.py makemigrations fwapp

static: ## Collect static files (run as root in container)
	docker compose exec -u 0 web python manage.py collectstatic --noinput

superuser: ## Create superuser
	docker compose exec web python manage.py createsuperuser

clean: ## Remove all containers, volumes, and images
	docker compose down -v --rmi all

ps: ## Show running containers
	docker compose ps

help: ## Display this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "  %-20s %s\n", $$1, $$NF }' $(MAKEFILE_LIST)