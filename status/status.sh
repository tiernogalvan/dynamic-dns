#!/usr/bin/env sh

last_req_file='/dynamic-dns/last_request'

if [ ! -f $last_req_file ] || [ -z "$(cat $last_req_file)" ]; then
  echo '{"status": "dynamic-dns not running"}'
  exit 1
fi

last_date="$(jq -r '.date' $last_req_file)"
last_timestamp=$(date -d "$last_date" +%s)
current_timestamp="$(date +%s)"
time_diff=$((current_timestamp - last_timestamp))

if [ "$time_diff" -gt 300 ]; then
  jq '{status: "DynDNS not updating", last_request: .}' $last_req_file
  exit 1
else
  jq '{status: "OK", last_request: .}' $last_req_file
fi
