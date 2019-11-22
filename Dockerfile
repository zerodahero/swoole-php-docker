FROM php:7-alpine
LABEL maintainer="Zack Teska <zerodahero@gmail.com>"

# Alpine SDK tools
RUN apk add --update --virtual .build-deps \
    alpine-sdk \
    autoconf \
    git

# Install Dependencies
RUN apk add --update openssl openssl-dev wget procps git libstdc++ dumb-init

# Install Swoole
RUN cd /tmp && git clone https://github.com/swoole/swoole-src.git && \
    cd swoole-src && \
    git checkout v4.4.12 && \
    phpize  && \
    ./configure  --enable-openssl && \
    make && make install

# PHP Extensions
RUN docker-php-ext-install pdo pdo_mysql && \
    docker-php-ext-enable swoole pdo pdo_mysql

# remove build tools
RUN apk del .build-deps && \
    rm -r /tmp/swoole-src

ENTRYPOINT ["dumb-init", "--", "php"]
