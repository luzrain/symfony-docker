.PHONY: help
help: ## Показать справку
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z1-9_-]+:.*?## / {printf "  \033[32m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: start
start: ## Сборка и запуск докер контейнеров (dev)
	docker-compose -f docker-compose.yaml up -d --force-recreate --build

.PHONY: stop
stop: ## Остановка докер контейнеров
	docker-compose down

.PHONY: clean
clean: ## Удалить образы и директории
	docker-compose rm --force --stop
	rm -rf var/cache
	rm -rf var/log
	rm -rf vendor

.PHONY: logs
logs: ## Показать логи
	docker-compose logs -f app

.PHONY: sh
sh: ## Запустить консоль
	docker-compose exec app sh
