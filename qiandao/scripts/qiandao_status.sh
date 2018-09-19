#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

pid=`cat /etc/crontabs/root|grep qiandao_config.sh`
date=`echo_date1`

if [ -n "$pid" ];then
	http_response "【$date】 自动签到 已开启！"
else
	http_response "<font color='#FF0000'>【警告】：自动签到未开启！</font>"
fi
