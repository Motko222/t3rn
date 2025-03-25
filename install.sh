path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
source /$path/config 

cd /root
mkdir t3rn
cd t3rn
wget https://github.com/t3rn/executor-release/releases/download/$TAG/executor-linux-$TAG.tar.gz
tar -xzf executor-linux-$TAG.tar.gz

#create service
printf "[Unit]
Description=T3RN executor node
After=network.target
Wants=network-online.target

[Service]
EnvironmentFile=/root/scripts/$folder/config
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
