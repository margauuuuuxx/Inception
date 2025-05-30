FROM debian:bullseye
WORKDIR /usr/local/bin

RUN mkdir -p var/run/gninx

RUN apt-get update && \
    apt-get install -y nginx openssl gettext && \
    rm -rf /var/lib/apt/lists/*

COPY ./nginx/entrypoint.sh ./
COPY ./common/wait-for-it.sh ./

COPY ./nginx/nginx.conf /etc/nginx/conf.d/.

RUN chmod +x ./entrypoint.sh ./wait-for-it.sh

#expose port 443 for HTTPS
EXPOSE 443 

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]