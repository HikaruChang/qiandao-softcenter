#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export qiandao_`

# remove dbus data in softcenter
confs=`dbus list qiandao_|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

sed -i '/qiandao/d' /etc/crontabs/root

# remove files
rm -rf $KSROOT/qiandao*
rm -rf $KSROOT/scripts/uninstall_qiandao*
rm -rf $KSROOT/init.d/S99qiandao.sh
rm -rf /etc/rc.d/S99qiandao.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_qiandao.asp
rm -rf $KSROOT/webs/res/icon-qiandao.png
rm -rf $KSROOT/webs/res/icon-qiandao-bg.png

# remove skipd data of qiandao
dbus remove softcenter_module_qiandao_home_url
dbus remove softcenter_module_qiandao_install
dbus remove softcenter_module_qiandao_md5
dbus remove softcenter_module_qiandao_version
dbus remove softcenter_module_qiandao_name
dbus remove softcenter_module_qiandao_title
dbus remove softcenter_module_qiandao_description
