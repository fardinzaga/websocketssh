#!/bin/bash
clear
echo -e ""
echo -e "=============================-Menu-============================="
echo -e "* menu         : List of Main Commands"
echo -e ""
echo -e "=========================-SSH & OpenVPN-========================"
echo -e "* usernew      : Create SSH & OpenVPN Account"
echo -e "* trial        : Generate SSH & OpenVPN Trial Account"
echo -e "* renew        : Extending SSH & OpenVPN Account Active Life"
echo -e "* deluser      : Delete SSH & OpenVPN Account"
echo -e "* cek          : Check User Login SSH & OpenVPN"
echo -e "* member       : Daftar Member SSH & OpenVPN"
echo -e "* delete       : Delete User Expired SSH & OpenVPN"
echo -e "* autokill     : Set up Autokill SSH"
echo -e "* ceklim       : Displays Users Who Do Multi Login SSH"
echo -e "* restart      : Restart Service Dropbear, Squid3, OpenVPN dan SSH"
echo -e "================================================================"
echo -e ""
echo -e "=============================-SYSTEM-==========================="
echo -e "* add-host     : Add Or Change Subdomain Host For VPS"
echo -e "* add-host2    : Change Domains That Have Been Pointed To Work"
echo -e "* wbmn         : Webmin Menu"
echo -e "* kernel-updt  : Update To Latest Kernel"
echo -e "* ram          : Check Usage of VPS Ram"
echo -e "* reboot       : Reboot VPS"
echo -e "* info         : Displaying System Information"
echo -e "* about        : Info Script Auto Install"
echo -e "* exit         : Exit From VPS "
echo -e ""
echo -e "================================================================"
echo -e ""
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
IPVPS=$(curl -s ipinfo.io/ip )
jam=$(date +"%T")
hari=$(date +"%A")
tnggl=$(date +"%d-%B-%Y")
echo -e "* Waktu         : $jam"
echo -e "* Hari          : $hari"
echo -e "* Tanggal       : $tnggl"
echo -e "* ISP Name      : $ISP"
echo -e "* City          : $CITY"
echo -e "* IP VPS        : $IPVPS"
echo -e ""
echo -e "Created By Fauzanvpn"
echo -e "==============================================================="
