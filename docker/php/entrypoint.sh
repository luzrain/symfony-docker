#!/usr/bin/env bash

USERNAME=app
USERID=11001

groupadd -g $USERID $USERNAME && useradd -u $USERID -g $USERNAME $USERNAME
chown -R $USERNAME:$USERNAME /var/lib/php
chown -R $USERNAME:$USERNAME /var/log/php-fpm

# The first time volumes are mounted, the project needs to be recreated
if [ ! -f composer.json ]; then
    composer create-project symfony/skeleton /tmp/install --no-ansi --no-progress --no-interaction --no-install --prefer-dist
    composer require "php:>=8.1.0" --working-dir=/tmp/install --no-ansi --no-progress --no-interaction --no-install
    composer config --json extra.symfony.docker true --working-dir=/tmp/install
    cp /tmp/install/composer.json .
    rm -rf /tmp/install
fi

chmod +x /app/bin/console

if [ "$APP_ENV" != "prod" ]; then
    composer install --no-ansi --no-progress --no-interaction --prefer-dist
    rm -rf /etc/supervisord.d/*.prod.conf
fi

if [ "$APP_ENV" = "dev" ]; then
    console cache:clear
fi

setfacl -R -d -m u:$USERNAME:rwx var
setfacl -R -m u:$USERNAME:rwx var

#console doctrine:migration:migrate --no-ansi --no-interaction

supervisord
