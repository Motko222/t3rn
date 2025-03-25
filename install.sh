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
Environment=\"ENVIRONMENT=testnet\"
Environment=\"LOG_LEVEL=debug\"
Environment=\"LOG_PRETTY=false\"
Environment=\"EXECUTOR_PROCESS_BIDS_ENABLED=true\"
Environment=\"EXECUTOR_PROCESS_ORDERS_ENABLED=true\"
Environment=\"EXECUTOR_PROCESS_CLAIMS_ENABLED=true\"
Environment=\"EXECUTOR_MAX_L3_GAS_PRICE=30000\"
Environment=\"PRIVATE_KEY_LOCAL=$PK\"
Environment=\"ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l2rn'\"
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
