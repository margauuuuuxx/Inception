# Inception

sequenceDiagram
    participant User
    participant Nginx
    participant Wordpress
    participant MariaDB

    User->>Nginx: HTTPS Request (443)
    Nginx->>Wordpress: Proxy to Wordpress (9000)
    Wordpress->>MariaDB: Database Query (3306)
    MariaDB-->>Wordpress: Data Response
    Wordpress-->>Nginx: HTML Response
    Nginx-->>User: HTTPS Response


***** NON MANDATORY THINGS THAT I'VE DONE *****
    - logs specifiers in nginx conf file
    - entrypoint scripts in my servuces dockerfiles
    - use of docker secrets (used in my docker compose file)
    - use of a wait-for-it script for services that depends on other (used in dockerfiles of wordpress and nginx)
    - options to my subj flag in nginx entrypoint
    - use of envsubset in my nginx entrypoint to be able to refer to envv in my conf file 
    - flags for docker commands in my makefile