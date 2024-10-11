#!/usr/bin/env sh

/etc/periodic/ddns/ionos-ddns.sh
lighttpd -f /etc/lighttpd/lighttpd.conf
/usr/sbin/crond -f -L /dev/stdout
