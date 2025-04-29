#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

journalctl --since "1 day ago" -u $folder.service -f --no-hostname -o cat | grep "level\":\"error"
