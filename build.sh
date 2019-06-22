#!/bin/bash
#所有项目的搭建程序
echo -e "\n1. SSR
2. Sevpn
3. Fas
4. V2ray\n
请选择需要搭建的程序:"
#赋值
read pro
url='https://raw.githubusercontent.com/MaruKoh'
#项目选择
if [[ $pro == 1 ]];then
    echo "该项目正在构建中…";fi
if [[ $pro == 2 ]];then
	wget -N --no-check-certificate -q $url/shell/master/sevpn && bash sevpn;fi
if [[ $pro == 3 ]];then
    wget -N --no-check-certificate -q $url/fas-/master/fast.bin && bash fast.bin;fi
if [[ $pro == 4 ]];then
    wget -N --no-check-certificate -q $url/V2Proxy/master/install.sh && bash install.sh;fi
exit;0
rm -rf /root/build.sh
