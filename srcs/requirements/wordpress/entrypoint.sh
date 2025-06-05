#!/bin/bash

set -e

if [ -f "/run/secrets/mysql_user_password" ]; then 
    export MYSQL_USER_PASSWORD=$(< /run/secrets/mysql_user_password)
else 
    echo "❌ Error: Missing MySQL user password secret"
    exit 1
fi

if [ -f "/run/secrets/wp_user_password" ]; then 
    export WP_USER_PASSWORD=$(< /run/secrets/wp_user_password)
else 
    echo "❌ Error: Missing WordPress user password secret"
    exit 1
fi

if [ -f "/run/secrets/wp_admin_password" ]; then 
    export WP_ADMIN_PASSWORD=$(< /run/secrets/wp_admin_password)
else 
    echo "❌ Error: Missing WordPress admin password secret"
    exit 1
fi

# wait for mariadb
#   --timeout=30    --> waits for 30 secs max before returning an error
#   --strict        --> if the service is not ready the script exits with an error (otherwise it would continue and run the next command anyway)
wait-for-it.sh mariadb:3306 --timeout=30 --strict -- echo "MariaDB is ready"

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "📝 Creating wp-config.php..."

    cd /var/www/html

	echo "⬇️ Downloading WordPress with WP-CLI..."
	wp core download --allow-root

	echo "✅ Wordpress has been succesfully  downloaded!"

	echo "⚙️ Configuration of wp-config.php file ..."
	wp config create	--dbname=${MYSQL_DATABASE} \
						--dbuser=${MYSQL_USER} \
						--dbpass=${MYSQL_USER_PASSWORD} \
						--dbhost=${MYSQL_HOST} \
						--allow-root

	echo "🛠 WordPress website installation ..."
	wp core install		--url=${DOMAIN_NAME} \
						--title="${WP_TITLE}" \
						--admin_user=${WP_ADMIN} \
						--admin_password=${WP_ADMIN_PASSWORD} \
						--admin_email=${WP_ADMIN_EMAIL} \
						--skip-email \
						--allow-root

	echo "👤 Creation of another WordPress user .."
	wp user create 		${WP_USER} ${WP_USER_EMAIL} \
						--user_pass=${WP_USER_PASSWORD} \
						--role=author \
						--allow-root
else
	echo "✅ wp-config.php déjà présent, aucune installation nécessaire."
fi

# use of the exec keyword --> replaces the current shell process with the proccess newly launched
# by default in a container the first process started iks PID 1 (signa handling: SIGTERM, SIGINT, ...)
# if no use of exec --> the script (= shell) remains PID 1 and the actual app becomes a child problem which is not good
# -F = foreground mode 
exec /usr/sbin/php-fpm7.4 -F