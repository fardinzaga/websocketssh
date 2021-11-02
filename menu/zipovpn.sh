#!/bin/bash
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
clear
figlet -f slant SUKSES | lolcat
rm -rf /root/OpenVPN
rm -f /root/openvpn.zip
