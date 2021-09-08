#!/bin/bash
# By Fauzanvpn
# Tunneling SSH Websocket + Stunnel + SSLH
# ==================================================

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=fauzanvpn.com
organizationalunit=fauzanvpn.com
commonname=fauzanvpn.com
email=admin@fauzanvpn.com

cd
# common password debian 
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/password/common-password-deb9"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install wget and curl
apt -y install wget curl

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "neofetch" >> .profile
echo "echo Selamat Datang Fauzanvpn !" >> .profile
echo "echo Ketik menu untuk melihat list" >> .profile
echo "echo VPSmu Terinstall AutoScript by Fauzanvpn" >> .profile
echo "echo Terimakasih !" >> .profile

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/nginx/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/nginx/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/updgw/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500

# setting port ssh
cd
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 88' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=44/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 143 -p 50000 -p 109 -p 77 "/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/squid/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# install stunnel
apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 444
connect = 127.0.0.1:44

[OpenSSH]
accept = 222
connect = 127.0.0.1:22

[openvpn]
accept = 442
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#install sslh
cd
apt-get install sslh -y

#konfigurasi
wget -O /etc/default/sslh "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/sslh/sslh"
service sslh restart

# Installl SSH Websocket 

#wget -q -O /usr/local/bin/edu-proxy https://raw.githubusercontent.com/fardinzaga/websocketssh/master/proxy/proxy-cf.py
#chmod +x /usr/local/bin/edu-proxy

# Installing Service WebSocket
#cat > /etc/systemd/system/edu-proxy.service << END
#[Unit]
#Description=Autoscript by Fauzanvpn
#Documentation=https://hidessh.com/blog
#After=network.target nss-lookup.target
#[Service]
#Type=simple
#User=root
#CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
#NoNewPrivileges=true
#ExecStart=/usr/bin/python -O /usr/local/bin/edu-proxy 2053
#Restart=on-failure
#[Install]
#WantedBy=multi-user.target
#END

#systemctl daemon-reload
#systemctl enable edu-proxy
#systemctl restart edu-proxy

#OpenVPN
#wget https://raw.githubusercontent.com/fardinzaga/websocketssh/master/vpn/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# install fail2ban
apt -y install fail2ban

# Custom Banner SSH
echo "================  Banner ======================"
wget -O /etc/issue.net "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/banner/banner-custom.conf"
chmod +x /etc/issue.net

# banner /etc/issue.net
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blockir torrent
apt install iptables-persistent -y
wget https://raw.githubusercontent.com/fardinzaga/websocketssh/master/security/torrent && chmod +x torrent && ./torrent
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin
wget -O add-host "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/add-host.sh"
wget -O about "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/about.sh"
wget -O menu "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/hapus.sh"
wget -O member "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/member.sh"
wget -O delete "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/delete.sh"
wget -O cek "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/cek.sh"
wget -O restart "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/restart.sh"
wget -O info "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/info.sh"
wget -O ram "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/ram.sh"
wget -O renew "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/renew.sh"
wget -O autokill "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/tendang.sh"
wget -O wbmn "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/webmin.sh"
wget -O kernel-updt "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/karnel-update.sh"
chmod +x add-host 
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renew
chmod +x wbmn
chmod +x kernel-updt

#install websocker SSH dan Dropbear
wget https://raw.githubusercontent.com/fardinzaga/websocketssh/master/websocket/install-ws.sh && chmod +x install-ws.sh && ./install-ws.sh

# Delete Acount SSH Expired
echo "================  Auto deleted Account Expired ======================"
wget -O /usr/local/bin/userdelexpired "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/userdelexpired" && chmod +x /usr/local/bin/userdelexpired

#auto reboot server
echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab

# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500

history -c
echo "unset Fauzanvpn" >> /etc/profile

#hapus file
cd
rm -f /root/ssh.sh

apt install dnsutils jq -y
apt-get install net-tools -y
apt-get install tcpdump -y
apt-get install dsniff -y
apt install grepcidr -y
# Instal DDOS Flate
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip -O ddos.zip
unzip ddos.zip
cd ddos-deflate-master
./install.sh

# finihsing
clear
