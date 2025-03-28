#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')

journalctl -u $folder.service --since "1 day ago" --no-hostname -o cat | grep -E "rror|ERR"
