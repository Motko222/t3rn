#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

cd $path
./stop.sh
./remove-service.sh
mv /root/t3rn /root/backup
mv /root/scripts/$folder /root/backup/scripts

cd /root/scripts/system
./influx-delete-id.sh $folder
