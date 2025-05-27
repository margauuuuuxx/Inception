FROM debian:bullseye
WORKDIR /usr/local/bin

RUN

COPY ./entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

CMD

ENTRYPOINT ["/entrypoint.sh"]
