### base php image
FROM oraclelinux:8-slim as base

RUN curl -sS https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -o epel.rpm && \
    curl -sS https://rpms.remirepo.net/enterprise/remi-release-8.rpm -o remi.rpm && \
    rpm -Uvh epel.rpm remi.rpm && \
    rm -rf epel.rpm remi.rpm

# install php
RUN microdnf module enable php:remi-8.1 && \
    microdnf install php php-apcu php-mbstring php-simplexml php-pdo php-mysqlnd php-zip php-intl

# install composer
RUN microdnf install unzip && \
    curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin/

ENV COMPOSER_ALLOW_SUPERUSER=1

# install additional programs
RUN microdnf install supervisor cronie

ENV USERNAME app
ENV USERID 11001
ENV PATH "${PATH}:/app/bin"

RUN groupadd -g $USERID $USERNAME && useradd -u $USERID -g $USERNAME $USERNAME && \
    chown -R $USERNAME:$USERNAME /var/lib/php && \
    chown -R $USERNAME:$USERNAME /var/log/php-fpm

COPY ./docker/php/etc/ /etc/
COPY ./docker/php/php.ini /etc/php.d/98-php.ini
COPY ./docker/php/entrypoint.sh /entrypoint.sh

RUN mkdir /app/
WORKDIR /app/

RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

### app prod image
FROM base as app_prod
ENV APP_ENV prod
COPY ./composer.* /app/
RUN composer install --no-ansi --no-progress --no-interaction --prefer-dist --no-scripts --no-autoloader --no-dev
COPY . /app
RUN composer dump-autoload --no-ansi --classmap-authoritative --no-scripts --no-dev && \
    php bin/console secrets:decrypt-to-local --force --env=prod && \
    composer dump-env prod
COPY ./docker/php/php.prod.ini /etc/php.d/99-php.prod.ini

### app dev image
FROM base as app_dev
ENV APP_ENV dev
