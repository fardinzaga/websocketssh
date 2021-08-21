#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
source /etc/os-release
OS=$ID
if [[ $OS == 'ubuntu' ]]; then
wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
install ubuntu-mainline-kernel.sh /usr/local/bin/
rm -f ubuntu-mainline-kernel.sh
ubuntu-mainline-kernel.sh -c
if [ $ver == $now ]; then
echo "Your Kernel Is The Latest Version"
rm -f /usr/bin/ubuntu-mainline-kernel.sh
exit 0
else
printf "y" | ubuntu-mainline-kernel.sh -i
rm -f /usr/bin/ubuntu-mainline-kernel.sh
elif [[ $OS == 'debian' ]]; then
ver=(`apt-cache search linux-image | grep "^linux-image" | cut -d'-' -f 3-4 |tail -n1`)
now=$(uname -r | cut -d "-" -f 1-2)
if [ $ver == $now ]; then
echo "Your Kernel Is The Latest Version"
exit 0
else
apt install linux-image-$ver-amd64
fi
reboot
