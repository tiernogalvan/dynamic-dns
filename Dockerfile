FROM alpine:3.20

RUN apk add --no-cache curl tzdata jq webhook
ENV TZ=Europe/Madrid

COPY ./etc/periodic /etc/periodic
COPY ./etc/crontabs /etc/crontabs
COPY ./status /dynamic-dns/status

COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
