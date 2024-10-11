#!/usr/bin/env sh
#
# Este script es el primer paso para DNS dinámico en IONOS
# IONOS funciona en dos pasos:
# 1. Este script, que hace una llamara con la API key y obtiene 
#    como resultado una URL con un token privado.
# 2. En cualquier momento futuro se puede hacer una llamada a esa URL, 
#    que es la que establece el DynDNS.
#

# ESTABLECE LAS VARIABLES DEL FICHERO ./get-ionos-url.env
. ./get-ionos-url.env

date="$(date +"%Y-%m-%d %H:%M:%S %Z")"
if [ -z $IONOS_PUBLIC_PREFIX ] || [ -z $IONOS_SECRET ]; then
  echo "ERROR: Variables no configuradas IONOS_PUBLIC_PREFIX, IONOS_SECRET"
  exit 1
fi

API_KEY="${IONOS_PUBLIC_PREFIX}.${IONOS_SECRET}"
URL='https://api.hosting.ionos.com/dns/v1/dyndns'

data='{
  "domains": [
    "lan.tiernogalvan.es"
  ],
  "description": "Tierno lan dyndns"
}'
curl -s -X POST "$URL" -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  --data "$data"

echo
echo
echo 'Para hacer DynDNS haz una consulta a la updateUrl recibida.'
echo 'Guarda la URL en el fichero .env:'
echo 'IONOS_UPDATE_URL=https://ipv4.api.hosting.ionos.com/dns/v1/dyndns?q=XXXXX'
