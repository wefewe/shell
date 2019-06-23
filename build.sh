#!/bin/bash
bule="\033[34m"
green="\033[32m"
clear="\033[0m"

url="https://raw.githubusercontent.com/MaruKoh"
coding="https://coding.net/u/yushang86/p/ky/git/raw/master"
rm -rf build.sh
rm -rf ssr.sh
rm -rf install.sh
rm -rf fas.bin
rm -rf ky.sh
rm -rf cherry.sh

echo -e "$bule   欢迎使用  Sakura 管理程序 Author:南音$clear"
echo -e "\n1.SSR"
echo -e "\n2.V2Ray"
echo -e "\n3.SeVPN"
echo -e "\n4.OpenVPN"
while :; do echo
	read -p "请选择需要搭建的程序： " choice
	if [[ ! $choice =~ ^[1-4]$ ]]; then
        if [[ -z ${choice} ]];then
            exit 0
        fi
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
done

if [[ $choice == 1 ]];then
    echo "该项目正在构建中…";fi
if [[ $choice == 2 ]];then
    wget -N --no-check-certificate -q $url/V2Proxy/master/install.sh && bash install.sh;fi
if [[ $choice == 3 ]];then
	wget -N --no-check-certificate -q $url/shell/master/sevpn && bash sevpn;fi
if [[ $choice == 4 ]]; then
    echo -e "\n1.Fas"
    echo -e "\n2.快云"
    echo -e "\n3.小洋人"
echo ""
read -p "请选择需要搭建的程序： " schoice
if [[ ${schoice} == 1 ]]; then
    wget -N --no-check-certificate -q $url/fas-/master/fast.bin && bash fast.bin;fi
if [[ ${schoice} == 2 ]]; then
    wget -q $coding/ky.sh && bash ky.sh;fi
if [[ ${schoice} == 3 ]]; then
    wget -q $url/shell/master/cherry.sh && bash cherry.sh;fi
fi

rm -rf build.sh
rm -rf ssr.sh
rm -rf install.sh
rm -rf fas.bin
rm -rf ky.sh
rm -rf cherry.sh
