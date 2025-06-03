#!/bin/bash

set -e

DOMAIN="${DOMAIN_NAME:-localhost}"

CRT="/etc/ssl/certs/${DOMAIN_NAME}.crt"
KEY="/etc/ssl/private/${DOMAIN_NAME}.key"

if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ]; then
    # -x509                 --> generates a certificate instead of a certificate request
    # -nodes                --> do not encryot the private key because needed by nginx
    # -days 365             --> valid for 1 year
    # -subj                 --> sets certificate subject: CN is the Common Name (domain name) 
    #            --> the other flags are optional: C = country ; O = organization ; ST = state 
    # -newkey rsa:2048      --> creates a new 2048-bits (min recommended key size) RSA key pair
    # -keyout <>            --> path to save the private key
    # -out <>               --> path to save the certificate
    openssl req -x509 -nodes -days 365 \
    -subj "/C=FR/O=42/CN=${DOMAIN_NAME}" \
    -newkey rsa:2048 \
    -keyout "$KEY" \
    -out "$CRT"
fi
echo "End of openssl command .."

wait-for-it.sh wordpress:9000 --timeout=30 --strict -- echo "Wordpress is ready"

# -g 'daemon off;' --> overrides nginx default config to make sure that it runs in the foreground (and not background)
# important bc otherwise it'll be daemonized (= go to the background) and the containers will exit immediately
exec nginx -g 'daemon off;'