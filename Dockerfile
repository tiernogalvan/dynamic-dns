FROM alpine:3.20

RUN apk add --no-cache curl lighttpd tzdata jq
ENV TZ=Europe/Madrid

COPY ./etc/periodic /etc/periodic
COPY ./etc/crontabs /etc/crontabs
RUN touch /var/www/localhost/htdocs/status

COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
