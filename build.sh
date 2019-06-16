#!/bin/bash
#所有项目的搭建程序
echo -e "所有项目的搭建程序:	
1. SSR
2. Sevpn
3. Fas
4. V2ray"
#赋值
read pro
url='https://github.com/MaruKoh'
#项目选择
while :; do echo
	read -p "请选择需要搭建的程序:" pro
	if [[ ! $pro =~ ^[1-4]$ ]]; then
        if [[ -z ${pro} ]];then
            exit 0
        fi
		echo "输入错误,请输入正确的数字!"
	else
		break	
	fi
done
if [[ $pro == 1 ]];then
    echo "该项目正在构建中…";fi
if [[ $pro == 2 ]];then
	wget -N --no-check-certificate $url/shell/master/sevpn && bash sevpn;fi
if [[ $pro == 3 ]];then
    wget -N --no-check-certificate $url/fas-/master/fast.bin && bash fast.bin;fi
if [[ $pro == 4 ]];then
    wget -N --no-check-certificate $url/V2Proxy/master/install.sh && bash install.sh;fi
exit;0
