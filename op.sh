#变量定义
url="路径"
mulu="文件名"
echo ""
echo -e "\033[36m 美化运行中... \033[0m"
echo ""
echo -e "\033[36m 正在处理管理中心文件 \033[0m"
rm -rf /var/www/html/admin/add_gg.php
rm -rf /var/www/html/admin/add_tc.php
rm -rf /var/www/html/admin/admin.php
rm -rf /var/www/html/admin/AdminShengji.php
rm -rf /var/www/html/admin/cat_add.php
rm -rf /var/www/html/admin/create_app.php
rm -rf /var/www/html/admin/dl_add.php
rm -rf /var/www/html/admin/dl_list.php
rm -rf /var/www/html/admin/feedback.php
rm -rf /var/www/html/admin/float.php
rm -rf /var/www/html/admin/footer.php
rm -rf /var/www/html/admin/fwq_add.php
rm -rf /var/www/html/admin/fwq_list.php
rm -rf /var/www/html/admin/goods.php
rm -rf /var/www/html/admin/head.php
rm -rf /var/www/html/admin/hosts.php
rm -rf /var/www/html/admin/index.php
rm -rf /var/www/html/admin/km_list.php
rm -rf /var/www/html/admin/line_add.php
rm -rf /var/www/html/admin/line_list.php
rm -rf /var/www/html/admin/list_gg.php
rm -rf /var/www/html/admin/list_tc.php
rm -rf /var/www/html/admin/login.php
rm -rf /var/www/html/admin/mysql.php
rm -rf /var/www/html/admin/nav.php
rm -rf /var/www/html/admin/net.php
rm -rf /var/www/html/admin/note_add.php
rm -rf /var/www/html/admin/note_list.php
rm -rf /var/www/html/admin/online.php
rm -rf /var/www/html/admin/pay.php
rm -rf /var/www/html/admin/pay_user.php
rm -rf /var/www/html/admin/qq_admin.php
rm -rf /var/www/html/admin/qset.php
rm -rf /var/www/html/admin/safe.php
rm -rf /var/www/html/admin/system.php
rm -rf /var/www/html/admin/type_add.php
rm -rf /var/www/html/admin/type_list.php
rm -rf /var/www/html/admin/user.php
rm -rf /var/www/html/admin/user_add.php
rm -rf /var/www/html/admin/user_create.php
rm -rf /var/www/html/admin/user_list.php
rm -rf /var/www/html/admin/zs.php
rm -rf /var/www/html/admin/kmlastkm.php
echo ""
echo -e "\033[36m 正在处理用户中心文件 \033[0m"
rm -rf /var/www/html/user/api_footer.php
rm -rf /var/www/html/user/api_head.php
rm -rf /var/www/html/user/app_reg.php
rm -rf /var/www/html/user/dx_reg.php
rm -rf /var/www/html/user/index.php
rm -rf /var/www/html/user/iosline.php
rm -rf /var/www/html/user/line.php
rm -rf /var/www/html/user/login.php
rm -rf /var/www/html/user/mod.php
rm -rf /var/www/html/user/nav.php
rm -rf /var/www/html/user/reg.php
rm -rf /var/www/html/user/system.php
rm -rf /var/www/html/user/getLine.php
echo ""
echo -e "\033[36m 正在处理代理中心文件 \033[0m"
rm -rf /var/www/html/daili/add_gg.php
rm -rf /var/www/html/daili/admin.php
rm -rf /var/www/html/daili/do.php
rm -rf /var/www/html/daili/footer.php
rm -rf /var/www/html/daili/head.php
rm -rf /var/www/html/daili/kf.php
rm -rf /var/www/html/daili/km_last.php
rm -rf /var/www/html/daili/km_list.php
rm -rf /var/www/html/daili/list_gg.php
rm -rf /var/www/html/daili/login.php
rm -rf /var/www/html/daili/nav.php
rm -rf /var/www/html/daili/order.php
rm -rf /var/www/html/daili/pay.php
rm -rf /var/www/html/daili/reg.php
rm -rf /var/www/html/daili/system.php
rm -rf /var/www/html/daili/user.php
rm -rf /var/www/html/daili/user_list.php
echo ""
echo -e "\033[36m 正在处理其它文件 \033[0m"
rm -rf /var/www/html/config.php
rm -rf /var/www/html/index.php
rm -rf /var/www/html/system.php
rm -rf /var/www/html/app_api/mode/app_reg.php
rm -rf /var/www/html/app_api/mode/dx_reg.php
rm -rf /var/www/html/app_api/mode/line.php
rm -rf /var/www/html/app_api/api.php
rm -rf /var/www/html/app_api/getLine.php
echo ""
echo -e "\033[36m 美化运行中，请稍等... \033[0m"
wget -c $url/$mulu/fasmeihua.tar.gz 1>/dev/null 2>&1
tar -zxvf /root/fasmeihua.tar.gz -C / 1>/dev/null 2>&1
cp -r ~/html /var/www/ 1>/dev/null 2>&1
rm -rf /root/fasmeihua.tar.gz
rm -rf /root/html
echo ""
echo ""
echo -e "\033[31m \033[05m ☆☆☆ 恭喜，美化成功！ ☆☆☆ \033[0m"
echo ""
echo ""
echo ""
echo -e "\033[36m 请配置好var/www/html/config.php数据库文件后即可！ \033[0m"
echo ""
echo ""
exit
