#!/bin/bash
#installer Websocker tunneling 
#created Bye HideSSH

cd

#Install Script Websocket-SSH Python
wget -O /usr/local/bin/ws-openssh https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/openssh-socket.py
wget -O /usr/local/bin/ws-dropbear https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/dropbear-ws.py
wget -O /usr/local/bin/ws-stunnel https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/ws-stunnel && chmod +x /usr/local/bin/ws-stunnel
wget -O /usr/local/bin/ws-fauzanvpn https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/fauzanvpn-ws.py
#wget -O /usr/local/bin/ws-ovpn https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/ws-ovpn && chmod +x /usr/local/bin/ws-ovpn
wget -O /usr/local/bin/ws-maulana https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/maulana-ws.py

#izin permision
chmod +x /usr/local/bin/ws-openssh
chmod +x /usr/local/bin/ws-dropbear
chmod +x /usr/local/bin/ws-stunnel
chmod +x /usr/local/bin/ws-fauzanvpn
#chmod +x /usr/local/bin/ws-ovpn
chmod +x /usr/local/bin/ws-maulana

#System OpenSSH Websocket-SSH Python
wget -O /etc/systemd/system/ws-openssh.service https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/service-wsopenssh && chmod +x /etc/systemd/system/ws-openssh.service

#System Dropbear Websocket-SSH Python
wget -O /etc/systemd/system/ws-dropbear.service https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/service-wsdropbear && chmod +x /etc/systemd/system/ws-dropbear.service

#System SSL/TLS Websocket-SSH Python
wget -O /etc/systemd/system/ws-stunnel.service https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/ws-stunnel.service && chmod +x /etc/systemd/system/ws-stunnel.service

#System OpenSSH Websocket-SSH Python
wget -O /etc/systemd/system/ws-stunnel.service https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/service-wsfauzanvpn && chmod +x /etc/systemd/system/ws-fauzanvpn.service

##System Websocket-OpenVPN Python
wget -O /etc/systemd/system/ws-ovpn.service https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/ws-ovpn.service && chmod +x /etc/systemd/system/ws-ovpn.service

#System OpenSSH Websocket-SSH Python
wget -O /etc/systemd/system/ws-stunnel.service https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/service-wsfauzanvpn && chmod +x /etc/systemd/system/ws-fauzanvpn.service

#restart service
#
systemctl daemon-reload
#Enable & Start & Restart ws-openssh service
systemctl enable ws-openssh.service
systemctl start ws-openssh.service
systemctl restart ws-openssh.service

#Enable & Start & Restart ws-dropbear service
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service

#Enable & Start & Restart ws-stunnel service
#systemctl enable ws-stunnel.service
#systemctl start ws-stunnel.service
#systemctl restart ws-stunnel.service

#Enable & Start & Restart ws-fauzanvpn service
systemctl enable ws-fauzanvpn.service
systemctl start ws-fauzanvpn.service
systemctl restart ws-fauzanvpn.service

#Enable & Start ws-ovpn service
#systemctl enable ws-ovpn.service
#systemctl start ws-ovpn.service
#systemctl restart ws-ovpn.service

#Enable & Start & Restart ws-maulana service
systemctl enable ws-maulana.service
systemctl start ws-maulana.service
systemctl restart ws-maulana.service
