FROM debian:bullseye
WORKDIR /usr/local/bin

# Install PHP & some PHP extensions
RUN apt-get update && \
    apt-get install -y \
    php php-fpm php-mysql php-mbstring php-xml php-curl php-gd php-zip \
    wget unzip mariadb-client && \
    mkdir -p /run/php && \
    rm -rf /var/lib/apt/lists/*

# Download & extract Wordpress
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    rm latest.zip && \
    mkdir -p /var/www/html && \
    mv wordpress/* /var/www/html/ && \
    rmdir wordpress && \
    # changing files ownership to make sure that the server has all needed permissions
    chown -R www-data:www-data /var/www/html 

COPY ./wordpress/entrypoint.sh ./
COPY ./common/wait-for-it.sh ./

RUN chmod +x ./entrypoint.sh ./wait-for-it.sh 

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
