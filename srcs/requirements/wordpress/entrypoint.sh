#!/bin/bash

# use of the exec keyword --> replaces the current shell process with the proccess newly launched
# by default in a container the first process started iks PID 1 (signa handling: SIGTERM, SIGINT, ...)
# if no use of exec --> the script (= shell) remains PID 1 and the actual app becomes a child problem which is not good
exec php-fpm