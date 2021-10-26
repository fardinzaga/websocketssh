#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
echo "Checking VPS"
IZIN=$( curl icanhazip.com | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${green}Permission Accepted...${NC}"
else
echo -e "${red}Permission Denied!${NC}";
echo "Only For Premium Users"
exit 0
fi
clear
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

IP=$(wget -qO- icanhazip.com);
domain=$(cat /etc/v2ray/domain)
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
wsl="$(cat ~/log-install.txt | grep -w "Ws" | cut -d: -f2)"
web="$(cat ~/log-install.txt | grep -w "WebSocket" | cut -d: -f2)"
wso="$(cat ~/log-install.txt | grep -w "WsOpenssh" | cut -d: -f2)"
won="$(cat ~/log-install.txt | grep -w "WsOvpn" | cut -d: -f2)"
wsd="$(cat ~/log-install.txt | grep -w "WsDropbear" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
sleep 1
echo Ping Host
echo Cek Hak Akses...
sleep 0.5
echo Permission Accepted
clear
sleep 0.5
echo Membuat Akun: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "Thank You For Using Our Services"
echo -e "SSH & OpenVPN Account Info"
echo -e "Username         : $Login "
echo -e "Password         : $Pass"                                  
echo -e "================================="
echo -e "Host             : $domain"
echo -e "OpenSSH          : 22"
echo -e "Dropbear         : 109, 143"
echo -e "SSL/TLS          :$ssl"
echo -e "Port Squid       :$sqd"
echo -e "Ws SSL/TLS       :$wsl"
echo -e "Port Websocket   :$web" 
echo -e "Port Ws Openssh  :$wso"
echo -e "Port Ws Ovpn     :$won"
echo -e "Port Ws Dropbear :$wsd"
echo -e "OpenVPN          : TCP 1194 http://$domain:81/client-tcp-1194.ovpn"
echo -e "OpenVPN          : UDP 2200 http://$domain:81/client-udp-2200.ovpn"
echo -e "OpenVPN          : SSL 992 http://$domain:81/client-tcp-ssl.ovpn"
echo -e "badvpn           : 7100 , 7200 , 7300"
echo -e "================================="
echo -e "Expired On       : $exp"
echo -e "================================="
echo -e "Payload SSH Websocket HTTP"                                                          
echo -e "GET / HTTP/1.1[crlf]Host: $domain[crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]"
echo -e "================================="
echo -e "Payload SSH Websocket SSL"
echo -e "GET wss://bug [protocol][crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "================================="
echo -e "Script Mod By Fauzanvpn"
