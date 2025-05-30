#!/bin/bash

set -e

if [ -f "/run/secrets/mysql_root_password" ]; then 
    DB_PASSWORD=$(cat /run/secrets/mysql_root_password)
else 
    echo "❌ Error: Missing MySQL user password secret"
    exit 1
fi

# wait for mariadb
#   --timeout=30    --> waits for 30 secs max before returning an error
#   --strict        --> if the service is not ready the script exits with an error (otherwise it would continue and run the next command anyway)
#wait-for-it.sh mariadb:3306 --timeout=30 --strict -- echo "MariaDB is ready"

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "📝 Creating wp-config.php..."

    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

    # sed -i replaces the values of the default wp-config.php file 
    sed -i "s/database_name_here/$MYSQL_DATABASE/" /var/www/html/wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$MYSQL_HOST/" /var/www/html/wp-config.php
fi

# use of the exec keyword --> replaces the current shell process with the proccess newly launched
# by default in a container the first process started iks PID 1 (signa handling: SIGTERM, SIGINT, ...)
# if no use of exec --> the script (= shell) remains PID 1 and the actual app becomes a child problem which is not good
# -F = foreground mode 
exec php-fpm7.4 -F