#!/usr/bin/env bash

USERNAME=app
USERID=11001

groupadd -g $USERID $USERNAME && useradd -u $USERID -g $USERNAME $USERNAME
chown -R $USERNAME:$USERNAME /var/lib/php
chown -R $USERNAME:$USERNAME /var/log/php-fpm

# The first time volumes are mounted, the project needs to be recreated
if [ ! -f "composer.json" ]; then
    composer create-project symfony/skeleton /tmp/install --no-ansi --no-progress --no-interaction --no-install --prefer-dist
    composer require "php:>=8.1.0" --working-dir=/tmp/install --no-ansi --no-progress --no-interaction --no-install
    composer config --json extra.symfony.docker true --working-dir=/tmp/install
    cp /tmp/install/composer.json .
    rm -rf /tmp/install
fi

if [ "$APP_ENV" != "prod" ]; then
    rm -rf /etc/supervisord.d/*.prod.conf
fi

if [ "$APP_ENV" = "dev" ]; then
    composer install --no-ansi --no-progress --no-interaction --prefer-dist
    php bin/console cache:clear
fi

# Apply database Migrations
if [ -d "migrations" ]; then
    echo "Waiting for database..."
    DB_CONNECT_ATTEMPTS=60
    until [ $DB_CONNECT_ATTEMPTS -eq 0 ] || DB_ERROR=$(php bin/console dbal:run-sql "SELECT 1" --no-ansi 2>&1); do
        sleep 1
        DB_CONNECT_ATTEMPTS=$((DB_CONNECT_ATTEMPTS - 1))
    done

    if [ $DB_CONNECT_ATTEMPTS -eq 0 ]; then
        echo "Database is not reachable."
        echo "$DB_ERROR"
    else
        echo "Database is ready."
        php bin/console doctrine:migration:migrate --no-ansi --no-interaction
    fi
fi

chmod +x /app/bin/console
setfacl -R -d -m u:$USERNAME:rwx var
setfacl -R -m u:$USERNAME:rwx var

supervisord
