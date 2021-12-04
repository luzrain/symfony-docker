#!/usr/bin/env bash

#configure php-fpm
sed -i -e "s/user = .*/user = $USERNAME/" /etc/php-fpm.d/www.conf && \
sed -i -e "s/group = .*/group = $USERNAME/" /etc/php-fpm.d/www.conf && \
sed -i -e 's/listen = .*/listen = 9000/' /etc/php-fpm.d/www.conf && \
sed -i -e 's/listen.allowed_clients = .*/;/' /etc/php-fpm.d/www.conf && \
sed -i -e 's/php_admin_value\[error_log\] = .*/php_admin_value\[error_log\] = \/dev\/stderr/' /etc/php-fpm.d/www.conf && \
echo "catch_workers_output = yes" >> /etc/php-fpm.d/www.conf && \
echo "decorate_workers_output = no" >> /etc/php-fpm.d/www.conf && \
sed -i -e 's/pid = .*/pid = \/run\/php-fpm.pid/' /etc/php-fpm.conf && \
sed -i -e 's/error_log = .*/error_log = \/dev\/stderr/' /etc/php-fpm.conf
groupadd -g $USERID $USERNAME && useradd -u $USERID -g $USERNAME $USERNAME
chown -R $USERNAME:$USERNAME /var/lib/php
chown -R $USERNAME:$USERNAME /var/log/php-fpm

chmod +x /app/bin/console

if [ "$APP_ENV" = "dev" ]
then
    echo "START IN DEV MODE"
    rm /etc/supervisord.d/*.prod.conf
    composer install --no-ansi --no-interaction
else
    echo "START IN PRODUCTION MODE"
    rm /etc/supervisord.d/*.dev.conf
fi

console cache:clear
#wait-for-it.sh --timeout=300 database:3306
#console doctrine:migration:migrate --no-ansi --no-interaction

supervisord
