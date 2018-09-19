#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export qiandao_`

mkdir -p $KSROOT/init.d
mkdir -p $KSROOT/qiandao

cp -rf /tmp/qiandao/qiandao/* $KSROOT/qiandao/
cp -rf /tmp/qiandao/scripts/* $KSROOT/scripts/
cp -rf /tmp/qiandao/webs/* $KSROOT/webs/
cp -rf /tmp/qiandao/uninstall.sh $KSROOT/scripts/uninstall_qiandao.sh

chmod +x $KSROOT/qiandao/qiandao
chmod +x $KSROOT/scripts/qiandao_*
rm -rf $KSROOT/install.sh

# add icon into softerware center
dbus set softcenter_module_qiandao_install=1
dbus set softcenter_module_qiandao_name=qiandao
dbus set softcenter_module_qiandao_title=自动签到
dbus set softcenter_module_qiandao_description="帮助你完成自动签到"
dbus set softcenter_module_qiandao_version=2.1.2b

# remove old files if exist
find /etc/rc.d/ -name *qiandao.sh* | xargs rm -rf

return 0
