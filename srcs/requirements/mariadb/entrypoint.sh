#!/bin/bash

# exit immediatly if a command exits with a non-0 status
set -e

# if the data directiry doesnt exist create it
if [ ! -d "/var/lib/mysql/mysql" ]; then 
    mysql_install_db --user=mysql --datadir=/var/lib/mysql #initializes the dir
fi

exec mysqld_safe #starts the database with an extra security layer (restarts the serber in case of error)