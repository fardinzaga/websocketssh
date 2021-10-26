#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
echo "Authentikasi pada server"
IZIN=$( curl icanhazip.com | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${green}Permintaan Diterima...${NC}"
else
echo -e "${red}Permintaan Ditolak!${NC}";
echo "Hanya untuk pengguna terdaftar"
rm -f setup.sh
exit 0
fi
mkdir /var/lib/premium-script;
mkdir /etc/v2ray;
echo "Tolong masukan domain yang sudah dipointing agar v2ray service work"
read -p "Hostname / Domain: " host
echo "IP=$host" >> /var/lib/premium-script/ipvps.conf
echo "$host" >> /etc/v2ray/domain

#install ssh ovpn
wget https://raw.githubusercontent.com/fardinzaga/websocketssh/master/ssh-vpn.sh && chmod +x ssh-vpn.sh && screen -S ssh-vpn.sh ./ssh-vpn.sh

rm -f /root/ssh-vpn.sh
history -c
echo "1.2" > /home/ver
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "=================================-Script Premium-===========================" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "--------------------------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH              : 22"  | tee -a log-install.txt
echo "   - OpenVPN              : TCP 1194, UDP 2200, SSL 442"  | tee -a log-install.txt
echo "   - Stunnel4             : 444, 777"  | tee -a log-install.txt
echo "   - Dropbear             : 109, 143"  | tee -a log-install.txt
echo "   - Ws SSL/TLS           : 443"  | tee -a log-install.txt
echo "   - WebSocket            : 80, 2095"  | tee -a log-install.txt
echo "   - WsDropbear           : 8880, 2086"  | tee -a log-install.txt
echo "   - WsOpenssh            : 2052, 2082"  | tee -a log-install.txt
echo "   - WsOvpn               : 2097"  | tee -a log-install.txt
echo "   - Squid Proxy          : 3128, 8080 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn               : 7100, 7200, 7300"  | tee -a log-install.txt
echo "   - Nginx                : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone             : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban             : [ON]"  | tee -a log-install.txt
echo "   - Dflate               : [ON]"  | tee -a log-install.txt
echo "   - IPtables             : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot          : [ON]"  | tee -a log-install.txt
echo "   - IPv6                 : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On 08.00 - 00.00 GMT +7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   - Dev/Main            : FauzanVpn"  | tee -a log-install.txt
echo "   - Telegram            : Gapunya"  | tee -a log-install.txt
echo "   - Instagram           : Gapunya"  | tee -a log-install.txt
echo "   - Whatsapp            : Gapunya"  | tee -a log-install.txt
echo "   - Facebook            : Gapunya" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "------------------Script By Fauzan-Vpn-----------------" | tee -a log-install.txt
echo ""
echo " Reboot 10 Sec"
sleep 10
rm -f setup.sh
reboot
