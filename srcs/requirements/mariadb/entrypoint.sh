#!/bin/bash

# exit immediatly if a command exits with a non-0 status
set -e

if [ -f "/run/secrets/mysql_root_password" ]; then 
    export MYSQL_ROOT_PASSWORD=$(< /run/secrets/mysql_root_password)
else 
    echo "❌ Error: Missing MySQL root password secret"
    exit 1
fi

if [ -f "/run/secrets/mysql_user_password" ]; then 
    export MYSQL_USER_PASSWORD=$(< /run/secrets/mysql_user_password)
else 
    echo "❌ Error: Missing MySQL user password secret"
    exit 1
fi

MYSQL_DATA_DIR="/var/lib/mysql/mysql"

# # if the data directiry doesnt exist create it
# if [ ! -d "/var/lib/mysql/mysql" ]; then 
#     mysql_install_db --user=mysql --datadir=/var/lib/mysql #initializes the dir
# fi

# Check if DB is initialized
if [ ! -d "${MYSQL_DATA_DIR}" ]; then
    echo "📦 Initialisation de MariaDB..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal --skip-test-db

    echo "🚀 Starting MariaDB temporarily for initialization..."
    mysqld_safe --datadir=/var/lib/mysql &
    pid="$!"

    echo "⏳ Waiting for MariaDB to start..."
    until mysqladmin ping --silent; do
        sleep 1
    done

    echo "🛠️ Initializing database..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" << EOF
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOF

    echo "✅ Initialization complete."

    # Stop the temporary MariaDB daemon
    echo "🛑 Stopping temporary MariaDB..."
    mysqladmin shutdown

    # Wait for the daemon to really stop before continuing
    wait "$pid" || true
fi

# Now start MariaDB in foreground as PID 1 so container keeps running
exec /usr/bin/mysqld_safe --datadir=/var/lib/mysql