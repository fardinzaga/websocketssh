#!/bin/bash
# Mod By Fauzanvpn
# 
# ==================================================

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=fauzanvpnxanggun.com
organizationalunit=fauzanvpnxanggun.com
commonname=fauzanvpnxanggun.com
email=admin@fauzanvpnxanggunvpn.com

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

# install wget and curl
apt -y install wget curl

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install screenfetch
cd
wget -O /usr/bin/screenfetch "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/tool/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/nginx/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/nginx/vps.conf"
/etc/init.d/nginx restart

# Creating a SSH server config using cat eof tricks
cat <<'MySSHConfig' > /etc/ssh/sshd_config
# Setup By Fauzan-Vpn
Port 22
AddressFamily inet
ListenAddress 0.0.0.0
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
PermitRootLogin yes
MaxSessions 1024
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
ClientAliveInterval 240
ClientAliveCountMax 2
UseDNS no
Banner /etc/banner
AcceptEnv LANG LC_*
Subsystem   sftp  /usr/lib/openssh/sftp-server
MySSHConfig

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
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=44/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 143 -p 77 "/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# update dropbear 2020
wget https://matt.ucc.asn.au/dropbear/releases/dropbear-2020.81.tar.bz2
bzip2 -cd dropbear-2020.81.tar.bz2 | tar xvf -
cd dropbear-2020.81
./configure
make && make install
mv /usr/sbin/dropbear /usr/sbin/dropbear1
ln /usr/local/sbin/dropbear /usr/sbin/dropbear
cd

# install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/squid/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

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
connect = 127.0.0.1:109

[ws-stunnel]
accept = 2096
connect = 127.0.0.1:700

[openvpn]
accept = 777
connect = 127.0.0.1:1194 

END

echo "=================  membuat Sertifikat OpenSSL ======================"
echo "========================================================="
#membuat sertifikat
cd /etc/stunnel/
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
cd
# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
cd
/etc/init.d/stunnel4 restart
cd
#install sslh
cd
apt-get install sslh -y

#konfigurasi
wget -O /etc/default/sslh "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/sslh/sslh"
service sslh restart

#OpenVPN
wget https://raw.githubusercontent.com/fardinzaga/websocketssh/master/vpn/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

#install zipopenvpn
if [ ! -e /home/vps/public_html/TCP.ovpn ]; then
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/TCP.ovpn
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/UDP.ovpn
cp /etc/openvpn/client-tcp-ssl.ovpn /home/vps/public_html/SSL.ovpn

mkdir /root/OpenVPN
cp -r /etc/openvpn/client-tcp-ssl.ovpn OpenVPN/SSL.ovpn
cp -r /etc/openvpn/client-udp-2200.ovpn OpenVPN/UDP.ovpn
cp -r /etc/openvpn/client-tcp-1194.ovpn OpenVPN/TCP.ovpn
cd /root
zip -r openvpn.zip OpenVPN > /dev/null 2>&1
cp -r /root/openvpn.zip /home/vps/public_html/ALL.zip
rm -rf /root/OpenVPN
rm -f /root/openvpn.zip
fi

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# xml parser
cd
apt install -y libxml-parser-perl

# banner /etc/bnr
wget -O /etc/bnr "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/banner/bnr"
wget -O /etc/banner "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/banner/banner"
sed -i 's@#Banner@Banner /etc/banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/bnr"@g' /etc/default/dropbear

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin
wget -O add-host "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/add-host.sh"
wget -O add-host2 "https://raw.githubusercontent.com/fardinzaga/websocketssh/master/menu/add-host2.sh"
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
chmod +x add-host2 
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

echo '#!/bin/bash' > /usr/local/bin/reboot_otomatis 
echo 'tanggal=$(date +"%m-%d-%Y")' >> /usr/local/bin/reboot_otomatis 
echo 'waktu=$(date +"%T")' >> /usr/local/bin/reboot_otomatis
echo 'clear-log' >> /usr/local/bin/reboot-otomatis
echo 'resett' >> /usr/local/bin/reboot-otomatis
echo 'echo "Server Berhasil Reboot Pada Tanggal $tanggal Dan Jam $waktu." >> /root/log-reboot.txt' >> /usr/local/bin/reboot_otomatis 
echo '/sbin/shutdown -r now' >> /usr/local/bin/reboot_otomatis 
chmod +x /usr/local/bin/reboot_otomatis
echo "0 5 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
# remove unnecessary files
apt-get -y autoclean
apt-get -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt-get -y autoremove

# finishing
cd
service cron restart
service sshd restart
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500

history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/ssh-vpn.sh
rm -f /root/cert.pem
rm -f /root/key.pem

echo -e "Done Install SSH Services" | lolcat
figlet -f slant OnePieceVPN | lolcat
# finihsing
clear
