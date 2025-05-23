#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=/root/logs/report-$folder
source /root/.bash_profile
source $path/env

version=$(cat /root/logs/t3rn-version)
service=$(sudo systemctl status $folder --no-pager | grep "active (running)" | wc -l)
errors=$(journalctl -u $folder.service --since "1 hour ago" --no-hostname -o cat | grep -c -E "level\":\"error")
tx=$(journalctl -u $folder.service --since "1 hour ago" --no-hostname -o cat | grep -c -E "Tx batch item successful|Tx single item successful")
fail=$(journalctl -u $folder.service --since "1 hour ago" --no-hostname -o cat | grep -c -E "Execution failed|Transmitter failed to submit tx")
funds=$(journalctl -u t3rn-3.service --since "1 hour ago" --no-hostname -o cat | grep -E "INSUFFICIENT_FUNDS" | tail -1 | jq -r .networkId)
balance=$(curl -sX 'GET' 'https://b2n.explorer.caldera.xyz/api/v2/addresses/'$WALLET -H 'accept: application/json' | jq -r .coin_balance | awk '{ printf ("%.0f\n",$1/1000000000000000000) }')

status="ok" && message="tx=$tx fail=$fail bal=$balance"
[ $errors -gt 200 ] && status="warning" && message="tx=$tx fail=$fail bal=$balance errors=$errors";
[ ! -z $funds ] && status="warning" && message="tx=$tx fail=$fail bal=$balance funds=$funds";
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
        "tx":$tx,
        "gas":"$EXECUTOR_MAX_L3_GAS_PRICE",
        "url":"rpc=$RPC_PROVIDER",
        "balance":"$balance",
        "insufficient_funds":"$funds"
  }
}
EOF

cat $json | jq
