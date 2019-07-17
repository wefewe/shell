#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#check root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }


CUR_VER=""
NEW_VER=""
ARCH=""
VDIS="64"
V2RAY_RUNNING=0
ZIPFILE="/tmp/v2ray/v2ray.zip"
VSRC_ROOT="/tmp/v2ray"
EXTRACT_ONLY=0
ERROR_IF_UPTODATE=0

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


#########################
while [[ $# > 0 ]];do
    key="$1"
    case $key in
        -p|--proxy)
        PROXY="-x ${2}"
        shift # past argument
        ;;
        -h|--help)
        HELP="1"
        ;;
        -f|--force)
        FORCE="1"
        ;;
        -c|--check)
        CHECK="1"
        ;;
        --remove)
        REMOVE="1"
        ;;
        --version)
        VERSION="$2"
        shift
        ;;
        --extract)
        VSRC_ROOT="$2"
        shift
        ;;
        --extractonly)
        EXTRACT_ONLY="1"
        ;;
        -l|--local)
        LOCAL="$2"
        LOCAL_INSTALL="1"
        shift
        ;;
        --source)
        DIST_SRC="$2"
        shift
        ;;
        --errifuptodate)
        ERROR_IF_UPTODATE="1"
        ;;
        *)
                # unknown option
        ;;
    esac
    shift # past argument or value
done

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
#检查系统信息
if [ -f /etc/redhat-release ];then
        OS='CentOS'
    elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS='Debian'
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS='Ubuntu'
    else
        echo "Not support OS, Please reinstall OS and retry!"
        exit 1
fi

#禁用SELinux
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi

#安装依赖
if [[ ${OS} == 'CentOS' ]];then
	yum install -q curl wget unzip git ntp ntpdate lrzsz python socat -y
elif [[ ${OS} == 'Debian' ]] && [[ ${OS} == 'Ubuntu' ]];then
	apt-get -q update
	apt-get install -q curl unzip git ntp wget ntpdate python socat lrzsz -y
fi
#install acme.sh
curl -s https://get.acme.sh | sh

#clone V2Proxy
cd /usr/local/
rm -rf V2Proxy
git clone https://git.coding.net/yushang86/V2Proxy.git

downloadV2Ray(){
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
    return 0
}

installSoftware(){
    COMPONENT=$1
    if [[ -n `command -v $COMPONENT` ]]; then
        return 0
    fi

    getPMT
    if [[ $? -eq 1 ]]; then
        colorEcho ${RED} "The system package manager tool isn't APT or YUM, please install ${COMPONENT} manually."
        return 1 
    fi
    if [[ $SOFTWARE_UPDATED -eq 0 ]]; then
        colorEcho ${BLUE} "Updating software repo"
        $CMD_UPDATE      
        SOFTWARE_UPDATED=1
    fi

    colorEcho ${BLUE} "Installing ${COMPONENT}"
    $CMD_INSTALL $COMPONENT
    if [[ $? -ne 0 ]]; then
        colorEcho ${RED} "Failed to install ${COMPONENT}. Please install it manually."
        return 1
    fi
    return 0
}

# return 1: not apt, yum, or zypper
getPMT(){
    if [[ -n `command -v apt-get` ]];then
        CMD_INSTALL="apt-get -y -qq install"
        CMD_UPDATE="apt-get -qq update"
    elif [[ -n `command -v yum` ]]; then
        CMD_INSTALL="yum -y -q install"
        CMD_UPDATE="yum -q makecache"
    elif [[ -n `command -v zypper` ]]; then
        CMD_INSTALL="zypper -y install"
        CMD_UPDATE="zypper ref"
    else
        return 1
    fi
    return 0
}

extract(){
    colorEcho ${BLUE}"Extracting V2Ray package to /tmp/v2ray."
    mkdir -p /tmp/v2ray
    unzip $1 -d ${VSRC_ROOT}
    if [[ $? -ne 0 ]]; then
        colorEcho ${RED} "Failed to extract V2Ray."
        return 2
    fi
    if [[ -d "/tmp/v2ray/v2ray-${NEW_VER}-linux-${VDIS}" ]]; then
      VSRC_ROOT="/tmp/v2ray/v2ray-${NEW_VER}-linux-${VDIS}"
    fi
    return 0
}


# 1: new V2Ray. 0: no. 2: not installed. 3: check failed. 4: don't check.
getVersion(){
    if [[ -n "$VERSION" ]]; then
        NEW_VER="$VERSION"
        if [[ ${NEW_VER} != v* ]]; then
          NEW_VER=v${NEW_VER}
        fi
        return 4
    else
        VER=`/usr/bin/v2ray/v2ray -version 2>/dev/null`
        RETVAL="$?"
        CUR_VER=`echo $VER | head -n 1 | cut -d " " -f2`
        if [[ ${CUR_VER} != v* ]]; then
            CUR_VER=v${CUR_VER}
        fi
        TAG_URL="https://api.github.com/repos/v2ray/v2ray-core/releases/latest"
        NEW_VER=`curl ${PROXY} -s ${TAG_URL} --connect-timeout 10| grep 'tag_name' | cut -d" -f4`
        if [[ ${NEW_VER} != v* ]]; then
          NEW_VER=v${NEW_VER}
        fi
        if [[ $? -ne 0 ]] || [[ $NEW_VER == "" ]]; then
            colorEcho ${RED} "Failed to fetch release information. Please check your network or try again."
            return 3
        elif [[ $RETVAL -ne 0 ]];then
            return 2
        elif [[ $NEW_VER != $CUR_VER ]];then
            return 1
        fi
        return 0
    fi
}

stopV2ray(){
    colorEcho ${BLUE} "Shutting down V2Ray service."
    if [[ -n "${SYSTEMCTL_CMD}" ]] || [[ -f "/lib/systemd/system/v2ray.service" ]] || [[ -f "/etc/systemd/system/v2ray.service" ]]; then
        ${SYSTEMCTL_CMD} stop v2ray
    elif [[ -n "${SERVICE_CMD}" ]] || [[ -f "/etc/init.d/v2ray" ]]; then
        ${SERVICE_CMD} v2ray stop
    fi
    if [[ $? -ne 0 ]]; then
        colorEcho ${YELLOW} "Failed to shutdown V2Ray service."
        return 2
    fi
    return 0
}

startV2ray(){
    if [ -n "${SYSTEMCTL_CMD}" ] && [ -f "/lib/systemd/system/v2ray.service" ]; then
        ${SYSTEMCTL_CMD} start v2ray
    elif [ -n "${SYSTEMCTL_CMD}" ] && [ -f "/etc/systemd/system/v2ray.service" ]; then
        ${SYSTEMCTL_CMD} start v2ray
    elif [ -n "${SERVICE_CMD}" ] && [ -f "/etc/init.d/v2ray" ]; then
        ${SERVICE_CMD} v2ray start
    fi
    if [[ $? -ne 0 ]]; then
        colorEcho ${YELLOW} "Failed to start V2Ray service."
        return 2
    fi
    return 0
}

copyFile() {
    NAME=$1
    ERROR=`cp "${VSRC_ROOT}/${NAME}" "/usr/bin/v2ray/${NAME}" 2>&1`
    if [[ $? -ne 0 ]]; then
        colorEcho ${YELLOW} "${ERROR}"
        return 1
    fi
    return 0
}

makeExecutable() {
    chmod +x "/usr/bin/v2ray/$1"
}

installV2Ray(){
    # Install V2Ray binary to /usr/bin/v2ray
    mkdir -p /usr/bin/v2ray
    copyFile v2ray
    if [[ $? -ne 0 ]]; then
        colorEcho ${RED} "Failed to copy V2Ray binary and resources."
        return 1
    fi
    makeExecutable v2ray
    copyFile v2ctl && makeExecutable v2ctl
    copyFile geoip.dat
    copyFile geosite.dat

    # Install V2Ray server config to /etc/v2ray
    if [[ ! -f "/etc/v2ray/config.json" ]]; then
        mkdir -p /etc/v2ray
        mkdir -p /var/log/v2ray
        cp "${VSRC_ROOT}/vpoint_vmess_freedom.json" "/etc/v2ray/config.json"
        if [[ $? -ne 0 ]]; then
            colorEcho ${YELLOW} "Failed to create V2Ray configuration file. Please create it manually."
            return 1
        fi
        let PORT=$RANDOM+10000
        UUID=$(cat /proc/sys/kernel/random/uuid)

        sed -i "s/10086/${PORT}/g" "/etc/v2ray/config.json"
        sed -i "s/23ad6b10-8d1a-40f7-8ad0-e3e35cd38297/${UUID}/g" "/etc/v2ray/config.json"

        colorEcho ${BLUE} "PORT:${PORT}"
        colorEcho ${BLUE} "UUID:${UUID}"
    fi
    return 0
}


installInitScript(){
    if [[ -n "${SYSTEMCTL_CMD}" ]];then
        if [[ ! -f "/etc/systemd/system/v2ray.service" ]]; then
            if [[ ! -f "/lib/systemd/system/v2ray.service" ]]; then
                cp "${VSRC_ROOT}/systemd/v2ray.service" "/etc/systemd/system/"
                systemctl enable v2ray.service
            fi
        fi
        return
    elif [[ -n "${SERVICE_CMD}" ]] && [[ ! -f "/etc/init.d/v2ray" ]]; then
        installSoftware "daemon" || return $?
        cp "${VSRC_ROOT}/systemv/v2ray" "/etc/init.d/v2ray"
        chmod +x "/etc/init.d/v2ray"
        update-rc.d v2ray defaults
    fi
    return
}

Help(){
    echo "./install-release.sh [-h] [-c] [--remove] [-p proxy] [-f] [--version vx.y.z] [-l file]"
    echo "  -h, --help            Show help"
    echo "  -p, --proxy           To download through a proxy server, use -p socks5://127.0.0.1:1080 or -p http://127.0.0.1:3128 etc"
    echo "  -f, --force           Force install"
    echo "      --version         Install a particular version, use --version v3.15"
    echo "  -l, --local           Install from a local file"
    echo "      --remove          Remove installed V2Ray"
    echo "  -c, --check           Check for update"
    return 0
}

remove(){
    if [[ -n "${SYSTEMCTL_CMD}" ]] && [[ -f "/etc/systemd/system/v2ray.service" ]];then
        if pgrep "v2ray" > /dev/null ; then
            stopV2ray
        fi
        systemctl disable v2ray.service
        rm -rf "/usr/bin/v2ray" "/etc/systemd/system/v2ray.service"
        if [[ $? -ne 0 ]]; then
            colorEcho ${RED} "Failed to remove V2Ray."
            return 0
        else
            colorEcho ${GREEN} "Removed V2Ray successfully."
            colorEcho ${BLUE} "If necessary, please remove configuration file and log file manually."
            return 0
        fi
    elif [[ -n "${SYSTEMCTL_CMD}" ]] && [[ -f "/lib/systemd/system/v2ray.service" ]];then
        if pgrep "v2ray" > /dev/null ; then
            stopV2ray
        fi
        systemctl disable v2ray.service
        rm -rf "/usr/bin/v2ray" "/lib/systemd/system/v2ray.service"
        if [[ $? -ne 0 ]]; then
            colorEcho ${RED} "Failed to remove V2Ray."
            return 0
        else
            colorEcho ${GREEN} "Removed V2Ray successfully."
            colorEcho ${BLUE} "If necessary, please remove configuration file and log file manually."
            return 0
        fi
    elif [[ -n "${SERVICE_CMD}" ]] && [[ -f "/etc/init.d/v2ray" ]]; then
        if pgrep "v2ray" > /dev/null ; then
            stopV2ray
        fi
        rm -rf "/usr/bin/v2ray" "/etc/init.d/v2ray"
        if [[ $? -ne 0 ]]; then
            colorEcho ${RED} "Failed to remove V2Ray."
            return 0
        else
            colorEcho ${GREEN} "Removed V2Ray successfully."
            colorEcho ${BLUE} "If necessary, please remove configuration file and log file manually."
            return 0
        fi       
    else
        colorEcho ${YELLOW} "V2Ray not found."
        return 0
    fi
}

checkUpdate(){
    echo "Checking for update."
    VERSION=""
    getVersion
    RETVAL="$?"
    if [[ $RETVAL -eq 1 ]]; then
        colorEcho ${BLUE} "Found new version ${NEW_VER} for V2Ray.(Current version:$CUR_VER)"
    elif [[ $RETVAL -eq 0 ]]; then
        colorEcho ${BLUE} "No new version. Current version is ${NEW_VER}."
    elif [[ $RETVAL -eq 2 ]]; then
        colorEcho ${YELLOW} "No V2Ray installed."
        colorEcho ${BLUE} "The newest version for V2Ray is ${NEW_VER}."
    fi
    return 0
}

main(){
    #helping information
    [[ "$HELP" == "1" ]] && Help && return
    [[ "$CHECK" == "1" ]] && checkUpdate && return
    [[ "$REMOVE" == "1" ]] && remove && return
    
    sysArch
    # extract local file
    if [[ $LOCAL_INSTALL -eq 1 ]]; then
        colorEcho ${YELLOW} "Installing V2Ray via local file. Please make sure the file is a valid V2Ray package, as we are not able to determine that."
        NEW_VER=local
        installSoftware unzip || return $?
        rm -rf /tmp/v2ray
        extract $LOCAL || return $?
    else
        installSoftware "curl" || return $?
        getVersion
        RETVAL="$?"
        if [[ $RETVAL == 0 ]] && [[ "$FORCE" != "1" ]]; then
            colorEcho ${BLUE} "Latest version ${CUR_VER} is already installed."
            if [[ "${ERROR_IF_UPTODATE}" == "1" ]]; then
              return 10
            fi
            return
        elif [[ $RETVAL == 3 ]]; then
            return 3
        else
            colorEcho ${BLUE} "Installing V2Ray ${NEW_VER} on ${ARCH}"
            downloadV2Ray || return $?
            installSoftware unzip || return $?
            extract ${ZIPFILE} || return $?
        fi
    fi 
    
    if [[ "${EXTRACT_ONLY}" == "1" ]]; then
        colorEcho ${GREEN} "V2Ray extracted to ${VSRC_ROOT}, and exiting..."
        return 0
    fi

    if pgrep "v2ray" > /dev/null ; then
        V2RAY_RUNNING=1
        stopV2ray
    fi
    installV2Ray || return $?
    installInitScript || return $?
    if [[ ${V2RAY_RUNNING} -eq 1 ]];then
        colorEcho ${BLUE} "Restarting V2Ray service."
        startV2ray
    fi
    colorEcho ${GREEN} "V2Ray ${NEW_VER} is installed."
    rm -rf /tmp/v2ray
    return 0
}

main

#配置V2ray初始环境
cp /usr/local/V2Proxy/v2ray /usr/local/bin
chmod +x /usr/bin/v2ray
chmod +x /usr/local/bin/v2ray
rm -rf /etc/v2ray/config.json
UUID=$(cat /proc/sys/kernel/random/uuid)

echo -E '
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "info"
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
rm -rf /root/install.sh
exit;0
