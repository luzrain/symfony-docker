FROM nginx:alpine as base

ENV USERID 11001
ENV USERNAME app

RUN addgroup -S -g ${USERID} ${USERNAME} && adduser -S -H -u ${USERID} ${USERNAME} -G ${USERNAME}

COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/app.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]

### nginx prod image
FROM base as nginx_prod
COPY ./public/ /app/public/

### nginx dev image
FROM base as nginx_dev
