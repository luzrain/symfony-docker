FROM nginx:alpine

ENV TZ Europe/Moscow
ENV USERID 11001
ENV USERNAME app

RUN	addgroup -S -g ${USERID} ${USERNAME} && adduser -S -H -u ${USERID} ${USERNAME} -G ${USERNAME}

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./app.conf /etc/nginx/conf.d/app.conf

CMD ["nginx", "-g", "daemon off;"]
