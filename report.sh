#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=/root/logs/report-$folder
source ~/.bash_profile
source $path/env

version=$(cat /root/logs/t3rn-version)
service=$(sudo systemctl status $folder --no-pager | grep "active (running)" | wc -l)
errors=$(journalctl -u $folder.service --since "1 day ago" --no-hostname -o cat | grep -c -E "rror|ERR")
tx=$(journalctl -u $folder.service --since "1 day ago" --no-hostname -o cat | grep -c -E "Tx batch item successful")

status="ok" && message="tx=$tx"
[ $errors -gt 1000 ] && status="warning" && message="errors=$errors tx=$tx";
[ $service -ne 1 ] && status="error" && message="service not running";

cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
       "id":"$folder",
       "machine":"$MACHINE",
       "grp":"node",
       "owner":"$OWNER"
  },
  "fields": {
        "chain":"t2",
        "network":"testnet",
        "version":"$version",
        "status":"$status",
        "message":"$message",
        "service":$service,
        "errors":$errors,
        "tx":$tx
  }
}
EOF

cat $json | jq
