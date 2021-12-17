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

### app image
FROM base as app

# install additional programs
RUN microdnf install supervisor cronie

RUN mkdir /app/
WORKDIR /app/
ENV PATH="${PATH}:/app/bin"
COPY ./docker/php/etc/ /etc/
COPY ./docker/php/php.ini /etc/php.d/998-php.ini
COPY ./docker/php/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

### app prod image
FROM app as app_prod
ENV APP_ENV prod
COPY ./composer.* /app/
COPY ./symfony.* /app/
RUN composer install --no-ansi --no-progress --no-interaction --prefer-dist --no-scripts --no-autoloader --no-dev
COPY . /app
RUN composer dump-autoload --no-ansi --classmap-authoritative --no-scripts --no-dev && \
    php bin/console secrets:decrypt-to-local --force --env=prod && \
    composer dump-env prod
COPY ./docker/php/php.prod.ini /etc/php.d/999-php.prod.ini

### app dev image
FROM app as app_dev
ENV APP_ENV dev
