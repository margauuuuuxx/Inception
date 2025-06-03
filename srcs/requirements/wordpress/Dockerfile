FROM debian:bullseye
WORKDIR /usr/local/bin

# Install PHP & some PHP extensions
RUN apt-get update && \
    apt-get install -y \
        php7.4 php7.4-fpm php7.4-mysql php7.4-curl php7.4-mbstring \
        php7.4-xml php7.4-gd php7.4-zip curl unzip mariadb-client wget && \
    rm -rf /var/lib/apt/lists/*

# Install the wordpress CLI to run easier commands in the entrypoint
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./wordpress/www.conf /etc/php/7.4/fpm/pool.d/
RUN mkdir -p /run/php && chown www-data:www-data /run/php

COPY ./wordpress/entrypoint.sh ./
COPY ./common/wait-for-it.sh ./

RUN chmod +x ./entrypoint.sh ./wait-for-it.sh 

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
