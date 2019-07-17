#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#check root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

NEW_VER=""
ARCH=""
VDIS="64"
V2RAY_RUNNING=0
ZIPFILE="/tmp/v2ray/v2ray.zip"
VSRC_ROOT="/tmp/v2ray"
EXTRACT_ONLY=0
ERROR_IF_UPTODATE=0
url="https://raw.githubusercontent.com/MaruKoh/shell/master"

CMD_INSTALL=""
CMD_UPDATE=""
SOFTWARE_UPDATED=0

SYSTEMCTL_CMD=$(command -v systemctl 2>/dev/null)
SERVICE_CMD=$(command -v service 2>/dev/null)

CHECK=""
FORCE=""
HELP=""

#######color code########
RED="31m"      # Error message
GREEN="32m"    # Success message
YELLOW="33m"   # Warning message
BLUE="36m"     # Info message

###############################
colorEcho(){
    COLOR=$1
    echo -e "\033[${COLOR}${@:2}\033[0m"
}

sysArch(){
    ARCH=$(uname -m)
    if [[ "$ARCH" == "i686" ]] || [[ "$ARCH" == "i386" ]]; then
        VDIS="32"
    elif [[ "$ARCH" == *"armv7"* ]] || [[ "$ARCH" == "armv6l" ]]; then
        VDIS="arm"
    elif [[ "$ARCH" == *"armv8"* ]] || [[ "$ARCH" == "aarch64" ]]; then
        VDIS="arm64"
    elif [[ "$ARCH" == *"mips64le"* ]]; then
        VDIS="mips64le"
    elif [[ "$ARCH" == *"mips64"* ]]; then
        VDIS="mips64"
    elif [[ "$ARCH" == *"mipsle"* ]]; then
        VDIS="mipsle"
    elif [[ "$ARCH" == *"mips"* ]]; then
        VDIS="mips"
    elif [[ "$ARCH" == *"s390x"* ]]; then
        VDIS="s390x"
    elif [[ "$ARCH" == "ppc64le" ]]; then
        VDIS="ppc64le"
    elif [[ "$ARCH" == "ppc64" ]]; then
        VDIS="ppc64"
    fi
    return 0
}

#config
echo
read -p "请输入安装路径(默认/usr/bin/v2ray):" install_v2ray
	if [ -z "$install_v2ray" ];then
	install_v2ray=/usr/bin/v2ray
	fi
echo -e "已设置安装路径为:\033[32m "$install_v2ray"\033[0m"
read -p "请输入HTTP端口(默认80):" v2port
	if [ -z "$v2port" ];then
	v2port=80
	fi
echo -e "已设置HTTP端口为:\033[32m "$v2port"\033[0m"
echo
read -p "请输入AlterId(默认32):" AlterId
	if [ -z "$AlterId" ];then
	AlterId=32
	fi
echo -e "已设置AlterId为:\033[32m "$AlterId"\033[0m"
echo
read -p "请输入Security(默认none):" Security
	if [ -z "$Security" ];then
	Security=none
	fi
echo -e "已设置Security为:\033[32m "$Security"\033[0m"
echo
read -p "请输入伪装的域名:" Domain
	if [ -z "$Domain" ];then
	Domain=bing.cn
	fi
echo -e "已设置伪装的域名为:\033[32m "$Domain"\033[0m"
echo
    echo "请选择V2Proxy搭建源:"
    echo
    echo "1、Github源"
    echo 
    echo "2、国内源址"
    echo
    read -p "请输入: " DIST_SRC
    echo
#禁用SELinux
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi

echo -e "\033[32minstalling base…\033[0m"
#安装依赖
opkg install update 2>/dev/null
opkg install unzip 2>/dev/null
opkg install curl 2>/dev/null
#install acme.sh
#curl -s https://get.acme.sh | sh

#clone V2Proxy
cd /usr/local/
rm -rf V2Proxy
curl -s -O $url/install.sh
curl -s -O $url/v2ray
    rm -rf /tmp/v2ray
    mkdir -p /tmp/v2ray
    cd /tmp/v2ray
    if [[ "${DIST_SRC}" == "2" ]]; then
        DOWNLOAD_LINK="https://coding.net/u/yushang86/p/Core/git/raw/master/v2ray-linux-${VDIS}.zip"
    else
        DOWNLOAD_LINK="https://github.com/v2ray/v2ray-core/releases/download/${NEW_VER}/v2ray-linux-${VDIS}.zip"
    fi
    V2Ray_version="v2ray-linux-${VDIS}.zip"
    colorEcho ${BLUE} "Downloading V2Ray: ${V2Ray_version}"
    curl ${PROXY} -L -H "Cache-Control: no-cache" -o ${ZIPFILE} ${DOWNLOAD_LINK}
    if [ $? != 0 ];then
        colorEcho ${RED} "Failed to download! Please check your network or try again."
        return 3
    fi
unzip -q v2ray.zip
mkdir /var/log/v2ray /usr/bin/v2ray /etc/v2ray
chmod +x v2ray v2ctl
rm -rf /etc/v2ray/config.json
UUID=$(cat /proc/sys/kernel/random/uuid)
echo -E '
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
  {
    "port": '$v2port',
    "protocol": "vmess",
    "settings": {
      "udp": true,
      "clients": [
        {
          "id": "'$UUID'",
          "alterId": '$AlterId',
          "security": "'$Security'"
        }
      ]
    },
      "streamSettings": {
      "network": "tcp",
      "tcpSettings": {
      "header": {
      "type": "http",
      "Host": "'$Domain'"
            }
         }
       }
     }
  ],
  "outbounds": [
  {
    "protocol": "freedom",
    "settings": {}
    }
  ]
}
'> /etc/v2ray/config.json
chmod 777 /etc/v2ray/config.json

mv v2ray v2ctl $install_v2ray
curl -s -O $url/v2ray.service
mv v2ray.service /etc/systemd/system
chmod 777 /etc/systemd/system/v2ray.service
systemctl enable v2ray

#配置V2ray初始环境
rm -rf /tmp/v2ray
cp /usr/local/V2Proxy/v2ray /usr/local/bin/v2ray
chmod +x /usr/local/
chmod +x /usr/local/bin/v2ray
rm -rf /usr/local/V2Proxy
#Restart v2ray
service v2ray restart
clear
#config information
       config_file=`cat /etc/v2ray/config.json`
       address=`curl -s http://members.3322.org/dyndns/getip`
       Network=`echo "${config_file#*streamSettings}" | awk -F ':' '/network/{print $2}' | awk -F ',' '{print $1}' | awk -F ' ' '{print $1}' | sed 's/"//g'`
       echo "V2Ray配置信息:"
       echo -e "\033[32mIP=$address\033[0m"
       echo -e "\033[32mPort=$v2port\033[0m"
       echo -e "\033[32mUUID=$UUID\033[0m"
       echo -e "\033[32mAlterId=$AlterId\033[0m"
       echo -e "\033[32mSecurity=$Security\033[0m"
       echo -e "\033[32mNetwork=$Network\033[0m"
       echo -e "\033[32mHost=$Domain\033[0m"
       if [[ ${Network} == tcp ]]; then
       v2rayNG=$(echo -n '{"add":"'$address'","aid":"'$AlterId'","host":"'$Host'","id":"'$UUID'","net":"'$Network'","path":"/","port":"'$v2port'","ps":"v2配置","tls":"","type":"http","v":"2"}' | base64 | tr -d "\n|=" | sed 's|^|vmess://|')
       else
       v2rayNG=$(echo -n '{"add":"'$address'","aid":"'$AlterId'","host":"'$Host'","id":"'$UUID'","net":"'$Network'","path":"/","port":"'$v2port'","ps":"v2配置","tls":"","type":"none","v":"2"}' | base64 | tr -d "\n|=" | sed 's|^|vmess://|')
       fi
       echo "v2rayNG的vmess链接"
       echo -e "\033[32m$v2rayNG\033[0m"
echo -e "\n\033[34mInstall success! manage:v2ray \033[0m"
exit;0
