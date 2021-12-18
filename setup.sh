#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
DOMAIN=anggunvpn.tk
#read -rp "Masukkan Domain: " -e DOMAIN
#echo ""
#echo "Domain: ${DOMAIN}" 
#echo ""
read -rp "Masukkan Subdomain: " -e sub
SUB_DOMAIN=${sub}.${DOMAIN}
CF_ID=seribukisah@darazdigital.com
CF_KEY=e3432a763cbdc9f999bb92917ddd4fbf695cc
set -euo pipefail
IP=$(wget -qO- ipinfo.io/ip);
echo "Pointing DNS Untuk Domain ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo "Host : $SUB_DOMAIN"
echo "IP=$SUB_DOMAIN" >> /var/lib/premium-script/ipvps.conf

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
echo "   - OpenSSH              : 22, 200"  | tee -a log-install.txt
echo "   - OpenVPN              : TCP 1194, UDP 2200, SSL 442"  | tee -a log-install.txt
echo "   - Stunnel4             : 444, 777"  | tee -a log-install.txt
echo "   - Dropbear             : 109, 143"  | tee -a log-install.txt
echo "   - Ws SSL/TLS           : 443, 2096"  | tee -a log-install.txt
echo "   - WebSocket            : 2095, 2086"  | tee -a log-install.txt
echo "   - WsOvpn               : 2082"  | tee -a log-install.txt
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
echo "   - Autoreboot On 05.00 GMT +7" | tee -a log-install.txt
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
