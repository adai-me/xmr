#!/bin/bash

VERSION=0.1
XMR="44gqF7rVsNMXtefZp6yjus5hvhAMD4Cmve99CbQunmaUWymKHfncLXESPri1gdq1tmTChT4wc2RAPZbSsnaxbS9Y7ym9tb6"
POOL="mine.c3pool.com:15555"
PASS="az"

export LC_ALL=en_US.UTF-8


mkdir /home/ubuntu/Monero && cd /home/ubuntu/Monero
curl -s -L https://github.com/adai-me/xmr/raw/main/xmrig -o /home/ubuntu/Monero/xmrig
chmod +x xmrig

cat >/home/ubuntu/Monero/config.json <<EOL
{
    "api": {
        "id": null,
        "worker-id": null
    },
    "http": {
        "enabled": false,
        "host": "127.0.0.1",
        "port": 0,
        "access-token": null,
        "restricted": true
    },
    "autosave": true,
    "background": false,
    "colors": true,
    "title": true,
    "randomx": {
        "init": -1,
        "init-avx2": -1,
        "mode": "auto",
        "1gb-pages": true,
        "rdmsr": true,
        "wrmsr": true,
        "cache_qos": false,
        "numa": true,
        "scratchpad_prefetch_mode": 1
    },
    "cpu": {
        "enabled": true,
        "huge-pages": true,
        "huge-pages-jit": false,
        "hw-aes": null,
        "priority": null,
        "memory-pool": false,
        "yield": true,
        "max-threads-hint": 100,
        "asm": true,
        "argon2-impl": null,
        "astrobwt-max-size": 550,
        "astrobwt-avx2": false,
        "cn/0": false,
        "cn-lite/0": false
    },
    "opencl": {
        "enabled": false,
        "cache": true,
        "loader": null,
        "platform": "AMD",
        "adl": true,
        "cn/0": false,
        "cn-lite/0": false
    },
    "cuda": {
        "enabled": false,
        "loader": null,
        "nvml": true,
        "cn/0": false,
        "cn-lite/0": false
    },
    "donate-level": 0,
    "donate-over-proxy": 0,
    "log-file": "\${XMRIG_EXE_DIR}/xmrig.log",
    "pools": [
        {
            "algo": null,
            "coin": null,
            "url": "${POOL}",
            "user": "${XMR}",
            "pass": "${PASS}",
            "rig-id": null,
            "nicehash": false,
            "keepalive": false,
            "enabled": true,
            "tls": false,
            "tls-fingerprint": null,
            "daemon": false,
            "socks5": null,
            "self-select": null,
            "submit-to-origin": false
        }
    ],
    "print-time": 60,
    "health-print-time": 60,
    "dmi": true,
    "retries": 5,
    "retry-pause": 5,
    "syslog": false,
    "tls": {
        "enabled": false,
        "protocols": null,
        "cert": null,
        "cert_key": null,
        "ciphers": null,
        "ciphersuites": null,
        "dhparam": null
    },
    "user-agent": null,
    "verbose": 0,
    "watch": true,
    "pause-on-battery": false,
    "pause-on-active": false
}
EOL

cat >/tmp/monero_miner.service <<EOL
[Unit]
Description=Monero miner service

[Service]
ExecStart=/home/ubuntu/Monero/xmrig --config=/home/ubuntu/Monero/config.json
Restart=always
Nice=10
CPUWeight=1

[Install]
WantedBy=multi-user.target
EOL

sudo mv /tmp/monero_miner.service /etc/systemd/system/monero_miner.service

sudo chmod +x /etc/systemd/system/monero_miner.service
sudo systemctl daemon-reload
sudo systemctl enable monero_miner.service
sudo systemctl start monero_miner.service

rm /setup.sh
