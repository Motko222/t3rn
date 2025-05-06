path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env
tag=v0.74.0

read -p "Sure? " c
case $c in y|Y) ;; *) exit ;; esac

#install binary
cd /root
[ -d t3rn ] && rm -r t3rn
mkdir t3rn
cd t3rn
wget https://github.com/t3rn/executor-release/releases/download/$tag/executor-linux-$tag.tar.gz
tar -xzf executor-linux-$tag.tar.gz
echo $tag >/root/logs/t3rn-version

#create env
cd $path
[ -f env ] || cp env.sample env
nano env

#create service
printf "[Unit]
Description=T3RN executor node
After=network.target
Wants=network-online.target

[Service]
EnvironmentFile=/root/scripts/$folder/env
User=root
Group=root
ExecStart=/root/t3rn/executor/executor/bin/executor
Restart=always
RestartSec=30
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=$folder
WorkingDirectory=/root/t3rn

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/$folder.service

sudo systemctl daemon-reload
sudo systemctl enable $folder
