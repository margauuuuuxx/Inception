#!/bin/bash

set -e

if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ]; then
    # -x509                 --> generates a certificate instead of a certificate request
    # -nodes                --> do not encryot the private key because needed by nginx
    # -days 365             --> valid for 1 year
    # -subj "/CN=localhost" --> sets certificate subject: CN is the Common Name (domain name)
    # -newkey rsa:2048      --> creates a new 2048-bits (min recommended key size) RSA key pair
    # -keyout <>            --> path to save the private key
    # -out <>               --> path to save the certificate
    open ssl req -x509 -nodes -days 365 \
    -subj "/CN=localhost" \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt
fi

wait-for-it.sh wordpress:9000 --timeout=30 --strict -- echo "Wordpress is ready"

# -g 'daemon off;' --> overrides nginx default config to make sure that it runs in the foreground (and not background)
# important bc otherwise it'll be daemonized (= go to the background) and the containers will exit immediately
exec nginx -g 'daemon off;'