#!/usr/bin/env sh
#
# Realiza DNS dinámico con IONOS.
# Asocia a lan.tiernogalvan.es a la IP pública desde la que se ejecute esto.
#
# Se deben establecer como variables de entorno:
# - IONOS_UPDATE_URL
#
# API de IONOS:
# https://developer.hosting.ionos.es/docs/dns
#

last_req_file='/dynamic-dns/last_request'
date="$(date +"%Y-%m-%d %H:%M:%S")"
if [ -z $IONOS_UPDATE_URL ]; then
  echo "ERROR: Variables no configurada IONOS_UPDATE_URL"
  echo "{\"\date\":\"${date}\",\"error\":\"Missing IONOS_UPDATE_URL environment variable\"}" > $last_req_file
  exit 1
fi

temp_file=$(mktemp)
code=$(curl -s -w "%{http_code}" "$IONOS_UPDATE_URL" -o $temp_file)

# Juntar la respuesta en JSON
if [ ! -s "$temp_file" ]; then
    parsed_json='{}'
else
    # Handle non-json content
    parsed_json=$(jq -c '.' "$temp_file" 2>/dev/null || echo '{}')
fi
echo $parsed_json | jq ". + {date: \"${date}\", return_code: \"${code}\"}" | tee $last_req_file
rm $temp_file
