#!/bin/bash
bule="\033[34m"
green="\033[32m"
clear="\033[0m"

url="https://raw.githubusercontent.com/MaruKoh"
coding="https://coding.net/u/yushang86/p/ky/git/raw/master"

echo -e "$bule   欢迎使用  Sakura 管理程序 Author:南音$clear"
echo -e "$green\n1.SSR$clear"
echo -e "$green\n2.V2Ray$clear"
echo -e "$green\n3.V2Ray(web)$clear"
echo -e "$green\n4.SeVPN$clear"
echo -e "$green\n5.OpenVPN$clear"
echo -e "$green\n6.Aria2$clear"
echo -e "$green\n7.Shc解密$clear"
echo
read -p "请选择需要搭建的程序： " choice
if [[ $choice == 1 ]];then
    echo "该项目正在构建中…";fi
if [[ $choice == 2 ]];then
if [ -f /etc/redhat-release ];then
        OS='CentOS'
    elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS='Debian'
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS='Ubuntu'
fi 2>/dev/null
if [[ ${OS} == 'CentOS' ]]
then wget -q https://coding.net/u/yushang86/p/V2Proxy/git/raw/master/install.sh && bash install.sh
elif [[ ${OS} == 'Debian' ]]
then wget -q https://coding.net/u/yushang86/p/V2Proxy/git/raw/master/install.sh && bash install.sh
elif [[ ${OS} == 'Ubuntu' ]]
then wget -q https://coding.net/u/yushang86/p/V2Proxy/git/raw/master/install.sh && bash install.sh
else wget -q $url/shell/master/install.sh && bash install.sh;fi
fi

if [[ $choice == 3 ]];then
    wget 
-q $url/South/master/install.sh && bash install.sh;fi
if [[ $choice == 4 ]];then
	wget -N --no-check-certificate -q $url/shell/master/sevpn && bash sevpn;fi
if [[ $choice == 5 ]]; then
    echo -e "$green\n1.Fas$clear"
    echo -e "$green\n2.快云$clear"
    echo -e "$green\n3.小洋人$clear"
echo ""
read -p "请选择需要搭建的程序： " schoice
if [[ ${schoice} == 1 ]]; then
    wget -N --no-check-certificate -q $url/fas-/master/fast.bin && bash fast.bin;fi
if [[ ${schoice} == 2 ]]; then
    wget -N --no-check-certificate -q $coding/ky.sh && bash ky.sh;fi
if [[ ${schoice} == 3 ]]; then
    wget -q $url/cherry/master/cherry.sh && bash cherry.sh;fi
fi
if [[ $choice == 6 ]];then
echo "正在开发中…"
fi
if [[ $choice == 7 ]];then
wget -q https://raw.githubusercontent.com/yanncam/UnSHc/master/latest/unshc.sh && chmod +x unshc.sh
read -p "请输入加密文件名称(确保加密文件在root目录下):" en
./unshc.sh $en 2>/dev/null
fi
rm -rf build.sh
rm -rf ssr.sh
rm -rf install.sh
rm -rf fas.bin
rm -rf ky.sh
rm -rf cherry.sh
