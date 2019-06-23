#!/bin/bash
#所有项目的搭建程序
bule="\033[34m"
green="\033[32m"
clear="\033[0m"
url="https://raw.githubusercontent.com/MaruKoh"
rm -rf root/build.sh
echo -e "$bule   欢迎使用  Sakura 管理程序 Author:南音$clear"
echo ""
echo -e "\n1.SSR"
echo -e "\n2.V2Ray"
echo -e "\n3.SeVPN"
echo -e "\n4.OpenVPN"
echo -e "\n请选择需要搭建的程序："
while :; do echo
	read -p "请选择： " choice
	if [[ ! $choice =~ ^[1-4]$ ]]; then
        if [[ -z ${choice} ]];then
            exit 0
        fi
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
done
#项目选择
if [[ $choice == 1 ]];then
    echo "该项目正在构建中…";fi
if [[ $choice == 2 ]];then
    wget -N --no-check-certificate $url/V2Proxy/master/install.sh && bash install.sh;fi
if [[ $choice == 3 ]];then
	wget -N --no-check-certificate $url/shell/master/sevpn && bash sevpn;fi
if [[ $choice == 4 ]]; then
    echo -e "\n1.Fas"
    echo -e "\n2.快云"
    echo -e "\n3.小洋人"
	    read -p "请选择： " schoice
	    if [[ ! $schoice =~ ^[1-3]$ ]]; then
            if [[ -z ${schoice} ]];then
                bash /root/build.sh
                exit 0
            fi
		    echo "输入错误! 请输入正确的数字!"
	    else
		    break
	    fi
    done
read -p "请选择： " schoice    
if [[ ${schoice} == 1 ]]; then
    wget -N --no-check-certificate $url/fas-/master/fast.bin && bash fast.bin;fi
if [[ ${schoice} == 2 ]]; then
    wget $url/ky/master/ky.sh && bash ky.sh;fi
if [[ ${schoice} == 3 ]]; then
    wget $url/shell/master/install.sh && bash install.sh;fi
fi
