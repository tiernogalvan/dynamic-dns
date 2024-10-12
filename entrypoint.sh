#!/usr/bin/env sh

# Execute DynDNS now
/etc/periodic/ddns/ionos-ddns.sh

# Launch the status webhook
webhook -hooks /dynamic-dns/status/hooks.yml -urlprefix '' -port 80 &

# Execure DynDNS periodically
/usr/sbin/crond -f -L /dev/stdout

# TODO: maybe launch webhooks and crond using openrc
