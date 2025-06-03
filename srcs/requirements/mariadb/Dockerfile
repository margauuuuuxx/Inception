FROM debian:bullseye

# /usr/local/bin = destination path inside the docker image filesystem --> common dir in Linux to store executables
WORKDIR /usr/local/bin

# all these commands are part of the OS utilities installed in the base image
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

RUN sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# copies from the local build context (= the folder where docker build runs) into the image at build time
# entrypoint.sh = source file ; ./ = WORKDIR 
COPY ./entrypoint.sh ./
# changes the permissions of the file to make executable 
RUN chmod +x ./entrypoint.sh

# the cmd the container is going to run as soon as initiated 
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]