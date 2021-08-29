#!/bin/bash
# Proxy Penjelajahvpn
# ==============================

# Getting Proxy Template
wget -q -O /usr/local/bin/edu-proxy linkproxy.py
chmod +x /usr/local/bin/edu-proxy

# Installing Service
cat > /etc/systemd/system/edu-proxy.service << END
[Unit]
Description=Python Penjelajahvpn
Documentation=admin@penjelajahvpn
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/edu-proxy 2086
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable edu-proxy
systemctl restart edu-proxy

clear
echo -e Penjelajahvpn
