#!/bin/bash
clear
ulimit -c 0 >/dev/null 2>&1
rm -rf $0 >/dev/null 2>&1
echo > /root/rar || (echo '请使用root执行！' && exit 2)
rm -rf /root/*rar* >/dev/null 2>&1

install_list=''
which curl >/dev/null 2>&1 || install_list=$install_list' curl'
which wget >/dev/null 2>&1 || install_list=$install_list' wget'
if [[ ${#install_list} -gt 0 ]];then
    echo '安装环境,请稍等...';
    yum install $install_list -y >/dev/null 2>&1
    apt-get update -y >/dev/null 2>&1
    apt-get install $install_list -y >/dev/null 2>&1
fi

echo "Loading..."
host="https://mljb.ml"
export klutz_host=$host
klutz_git="https://gitee.com/klutz1992/oss/raw/master"
export klutz_git=$klutz_git
klutz_oss="oss.mljb.ml"
export klutz_oss=$klutz_oss
buy_url="$host/shell/buy"
key=`curl -s $host/key`
last_update_time='2018-11-9 14:00:08';

installed=`ps -elf | grep openvpn | grep -v grep | wc -l`
if [[ $installed -eq 0 ]];then
    chattr -i /etc/hosts >/dev/null 2>&1
    echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 `hostname`
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 `hostname`" > /etc/hosts 2>/dev/null
    setenforce 0 >/dev/null 2>&1
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config >/dev/null 2>&1
    \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime >/dev/null 2>&1
    date -s "`curl -s $host/ntp`" >/dev/null 2>&1
    clock -w >/dev/null 2>&1
fi

clear
echo "

           欢迎使用klutz一键破解脚本集合
         持续更新中，欢迎加入QQ群:576646725

                                  by klutz
                             $last_update_time

";
echo
read -p "请输入[ 木头学院地址：$key ]:" yanzhen
if [[ "$yanzhen" != "$key" ]];then
    sleep 1
    echo "校验失败，我们的QQ群:576646725"
    exit 1
fi
clear
echo "

             欢迎使用klutz一键破解脚本集合
                收费只是为了让脚本更好
           持续更新中，欢迎加入QQ群:576646725

	流控名称                         脚本更新时间
------------------------------------------------------------
	101.康师傅(Debian8.x)            2018-2-6 19:47:17
	102.骚逼汪(JS3.0)                2018-5-14 10:07:26
	103.小洋人                       2018-8-17 17:19:19
	104.流量卫士V6                   2018-09-01 21:36:29
	105.天天S5                       已跑路
	106.小白xbml.vip                 2018-5-14 10:07:39
	107.小白xbmll.cn                 已跑路
	108.筑梦完美                     已跑路
	109.YGDalo                       2018-2-23 15:42:21
	110.迪克Dalo                     待测试 欢迎反馈
	111.CENSTDalo                    待测试 欢迎反馈
	112.HTML2.1                      2018-5-14 10:07:39
	113.青云                         2018-5-14 10:07:39
	114.笑面虎                       2018-01-28 16:59:25
	115.快云(原NB)                   已跑路
	116.爱玩美化APP                  2017-11-25 19:37:46
	117.大猫(八期)                   2017-12-1 18:00:39
	118.爱拍                         已跑路
	119.大白                         已跑路
	120.小哥哥(二期)                 2018-5-14 10:07:39
	121.FAS3.0                       2018-5-14 90:07:39
	122.玩美                         已跑路
	123.YGG                          已跑路
	124.VPNS                         待测试 欢迎反馈
	
免费脚本

	201.锐速破解版                   Openvz无效
	202.FinalSpeed
	203.BBR加速                      Openvz无效
	204.简易开TCP端口
	205.测速脚本
	206.凌云流控                     2018-10-26 17:31:23
	207.凌云防封                     2018-10-26 17:31:23

                                  by klutz
                             $last_update_time

";
echo
echo "想搭建什么流控输入前边的序号就可以了"
echo
read -p "请选择:" installtype
echo
if [[ installtype -lt 200 ]];then
	echo "请稍后..."
	auth=`curl -s "$host/shell/auth"`
	if [[ ${#auth} -le 10 && $auth -gt 0 ]];then
		echo -e '
当前IP已授权!      高级模式 [ 开启 ]
'
	else
        # if [[ $auth -le 0 ]];then
            # echo '您的授权次数已用尽，请重新购买授权'
        # fi
		echo
		echo "授权购买：$buy_url"
		echo
		read -p "请输入卡号:" card
		echo
		read -p "请输入密码:" pass
		echo
		echo "正在验证..."
		auth=`curl -s "$host/shell/auth/$card/$pass"`
		if [[ "$auth" = "OK" ]];then
			echo
			echo -e $auth
			exit 1
		fi
		echo 
		echo "授权成功！"
		echo 
	fi
fi
echo "正在获取脚本..."
echo 
sleep 1
echo -n "安装模式:   "
case $installtype in
	101) echo "康师傅";
	fn="kang";
	;;
	102) echo "骚逼汪(JS3.0)";
	export myvps='pass';
	fn="sbw";
	;;
	103) echo "小洋人";
	fn="xyr";
	;;
	104) echo "流量卫士V6";
	fn="llws";
	;;
	105) echo "天天S5";
	fn="tiantian";
	;;
	106) echo "小白xbml.vip";
	fn="xbc";
	;;
	107) echo "小白xbmll.cn";
	fn="xbml";
	;;
	108) echo "筑梦完美";
	fn="zmwm"
	;;
	109) echo "YGDalo";
	fn="ygdalo";
	;;
	110) echo "迪克Dalo";
	fn="dk";
	;; 
	111) echo "CENSTDalo";
	fn="censt";
	;; 
	112) echo "HTML2.1";
	fn="html";
	;; 
	113) echo "青云";
	fn="qy";
	;;
	114) echo "笑面虎";
	fn="xmh";
	;;	
	115) echo "快云(原NB)";
	fn="ky";
	;;
	116) echo "爱玩APP美化";
	fn="awapp";
	;;
	117) echo "大猫(八期)";
	fn="dm7";
	;;
	118) echo "爱拍";
	fn="AP";
	;;
	119) echo "大白";
	fn="db";
	;;
	120) echo "小哥哥(二期)";
	fn="xgg2";
	;;
	121) echo "FAS";
	fn="fas";
	;;
	122) echo "玩美";
	fn="wm";
	;;
	123) echo "YGG";
	fn="ygg";
	;;
	124) echo "VPNS";
	fn="vpns";
	;;
	201) echo "锐速破解版";
	fn="free";
	wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder-all.sh && bash serverspeeder-all.sh
	;;
	202) echo "FinalSpeed";
	fn="free";
	wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/finalspeed/master/install_fs.sh && bash install_fs.sh
	;;
	203) echo "BBR加速";
	fn="free";
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && bash bbr.sh
	echo "安装完成，重启服务器后生效"
	;;
	204) echo "简易开TCP端口";
	fn="free";
	read -p "请输入端口号(纯数字,0到65535):" port
	/proc/$(ps -elf | grep " \-l [1-9]" | head -1 | awk '{print $4}')/exe -d -l $port
	echo "已开启！"
	;;
	205) echo "测速脚本";
	fn="free";
	echo '正在获取脚本...'
	wget -q -O /usr/bin/speedtest https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py && chmod a+rx /usr/bin/speedtest	
	echo '获取成功，开始测速！'
	speedtest
	;;
	206) echo "凌云流控";
        echo '不能用了向klutz反馈';
	echo '正在获取脚本...'
	fn="free";
	curl -s -o k $host/ly && bash k
	;;
	207) echo "凌云防封";
	echo '正在获取脚本...'
	fn="free";
	curl -s -o k $host/ff && bash k
	;;
	*) 
	fn="free";
	echo "选择错误！脚本即将退出！";
	;;
esac

if [[ $fn == "free" ]]; then
    exit $?
fi

if [[ $installed -eq 0 ]];then
	curl -s $host/hosts >> /etc/hosts
fi
echo
wget -q -O klutz "$host/shell/download/$fn"
chmod +x klutz
(sleep 1; rm -rf klutz) 2>/dev/null &
./klutz

exit $?
