#!/bin/bash

# exit immediatly if a command exits with a non-0 status
set -e

if [ -f "/run/secrets/mysql_user_password" ]; then 
    export MYSQL_USER_PASSWORD=$(< /run/secrets/mysql_user_password)
else 
    echo "❌ Error: Missing MySQL user password secret"
    exit 1
fi

MYSQL_DATA_DIR="/var/lib/mysql/mysql"

# Check if DB is initialized
if [ ! -d "${MYSQL_DATA_DIR}" ]; then
    echo "📦 Initialisation of MariaDB..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal --skip-test-db

    echo "🚀 Starting MariaDB temporarily for initialization..."
    mysqld_safe --datadir=/var/lib/mysql &

    echo "⏳ Waiting for MariaDB to start..."
    until mysqladmin ping --silent; do
        sleep 1
    done

    echo "🛠️ Initializing database..."
    mysql -u root << EOF
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOF

    echo "✅ Initialization complete."

    # Stop the temporary MariaDB daemon
    echo "🛑 Stopping temporary MariaDB..."
    mysqladmin shutdown
fi

# Now start MariaDB in foreground as PID 1 so container keeps running
exec /usr/bin/mysqld_safe --datadir=/var/lib/mysql