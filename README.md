# Docker environment for symfony application

A dockerized environment for [Symfony](https://github.com/symfony/symfony) PHP framework. Ready for production and development.

## Getting started

- Install [Docker Compose](https://docs.docker.com/compose/install/)
- Run `make start`
- Open `http://localhost:8080`
- Run `make stop` to stop the Docker containers.
- Run `make help` to show all available commands.

## Features

- PHP 8.1
- Nginx web server
- Supervisor for manage [messenger](https://symfony.com/doc/current/messenger.html) consumers, cron and php-fpm
