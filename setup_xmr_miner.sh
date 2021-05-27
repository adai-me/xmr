#!/bin/bash

VERSION=0.1

export LC_ALL=en_US.UTF-8

echo "XMR mining setup script v$VERSION."

chmod +x xmrig

cat >/tmp/monero_miner.service <<EOL
[Unit]
Description=Monero miner service

[Service]
ExecStart=$HOME/Monero/xmrig --config=$HOME/Monero/config.json
Restart=always
Nice=10
CPUWeight=1

[Install]
WantedBy=multi-user.target
EOL

sudo mv /tmp/monero_miner.service /etc/systemd/system/monero_miner.service

sudo systemctl daemon-reload
sudo systemctl enable monero_miner.service
sudo systemctl start monero_miner.service

rm setup_xmr_miner.sh
