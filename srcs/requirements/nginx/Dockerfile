FROM debian:bullseye
WORKDIR /usr/local/bin

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

COPY ./nginx/entrypoint.sh ./
COPY ./common/wait-for-it.sh ./

RUN chmod +x ./entrypoint.sh ./wait-for-it.sh

#expose port 443 for HTTPS
EXPOSE 443 

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]