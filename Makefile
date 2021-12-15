.PHONY: help
help: ## Show this help
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z1-9_-]+:.*?## / {printf "  \033[32m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: build
build: ## Builds the docker images
	docker-compose build --pull --no-cache

.PHONY: start
start: ## Start the containers
	docker-compose up -d --force-recreate --build

.PHONY: start
start-prod: ## Start the containers in produnction environment
	docker-compose -f docker-compose.yaml up -d --force-recreate --build

.PHONY: stop
stop: ## Stop the containers
	docker-compose down

.PHONY: clean
clean: ## Delete the docker images, volumes and autogenerated files
	docker-compose down -v
	rm -rf var vendor node_modules

.PHONY: logs
logs: ## Show live logs
	docker-compose logs --tail=30 --follow app

.PHONY: sh
sh: ## Connect to the php container
	docker-compose exec app sh
