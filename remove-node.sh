#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

cd $path
./stop.sh
./remove-service.sh
cp /root/t3rn /root/backup
cp /root/scripts/$folder /root/backup/scripts/$folder

cd /root/scripts/system
./influx-remove-id.sh $folder
