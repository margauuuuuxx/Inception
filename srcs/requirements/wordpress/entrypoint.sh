#!/bin/bash

# wait for mariadb
#   --timeout=30    --> waits for 30 secs max before returning an error
#   --strict        --> if the service is not ready the script exits with an error (otherwise it would continue and run the next command anyway)
wait-for-it.sh mariadb:3306 --timeout=30 --strict -- echo "MariaDB is ready"

# use of the exec keyword --> replaces the current shell process with the proccess newly launched
# by default in a container the first process started iks PID 1 (signa handling: SIGTERM, SIGINT, ...)
# if no use of exec --> the script (= shell) remains PID 1 and the actual app becomes a child problem which is not good
exec php-fpm7.4