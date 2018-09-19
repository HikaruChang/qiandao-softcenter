#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export qiandao_`
logfile="/tmp/upload/qiandao_log.txt"

start_qiandao(){
	[ -n "$qiandao_baidu" ] && baidu="\"baidu\"=$(echo $qiandao_baidu | base64_decode)" || baidu="\"baidu\"="
	[ -n "$qiandao_v2ex" ] && v2ex="\"v2ex\"=$(echo $qiandao_v2ex | base64_decode)" || v2ex="\"v2ex\""
	[ -n "$qiandao_hostloc" ] && hostloc="\"hostloc\"=$(echo $qiandao_hostloc | base64_decode)" || hostloc="\"hostloc\""
	[ -n "$qiandao_bilibili" ] && bilibili="\"bilibili\"=$(echo $qiandao_bilibili | base64_decode)" || bilibili="\"bilibili\""
	[ -n "$qiandao_smzdm" ] && smzdm="\"smzdm\"=$(echo $qiandao_smzdm | base64_decode)" || smzdm="\"smzdm\""
	[ -n "$qiandao_jd" ] && jd="\"jd\"=$(echo $qiandao_jd | base64_decode)" || jd="\"jd\""
	[ -n "$qiandao_cloudmusic" ] && cloudmusic="\"cloudmusic\"=$(echo $qiandao_cloudmusic | base64_decode)" || cloudmusic="\"cloudmusic\""
	[ -n "$qiandao_koolshare" ] && koolshare="\"koolshare\"=$(echo $qiandao_koolshare | base64_decode)" || koolshare="\"koolshare\""
	[ -n "$qiandao_acfun" ] && acfun="\"acfun\"=$(echo $qiandao_acfun | base64_decode)" || acfun="\"acfun\""
	[ -n "$qiandao_qq" ] && qq="\"qq\"=$(echo $qiandao_qq | base64_decode)" || qq="\"qq\""
	[ -n "$qiandao_qqgroup" ] && qqgroup="\"qqgroup\"=$(echo $qiandao_qqgroup | base64_decode)" || qqgroup="\"qqgroup\""
	[ -n "$qiandao_rrtv" ] && rrtv="\"rrtv\"=$(echo $qiandao_rrtv | base64_decode)" || rrtv="\"rrtv\""
	[ -n "$qiandao_phicomm" ] && phicomm="\"phicomm\"=$(echo $qiandao_phicomm | base64_decode)" || phicomm="\"phicomm\""
	[ -n "$qiandao_cmcc" ] && cmcc="\"cmcc\"=$(echo $qiandao_cmcc | base64_decode)" || cmcc="\"cmcc\""
	[ -n "$qiandao_discuzName1" ] && discuzName1="\"discuzName1\"=$(echo $qiandao_discuzName1 | base64_decode)" || discuzName1="\"discuzName1\""
	[ -n "$qiandao_discuzUrl1" ] && discuzUrl1="\"discuzUrl1\"=$(echo $qiandao_discuzUrl1 | base64_decode)" || discuzUrl1="\"discuzUrl1\""
	[ -n "$qiandao_discuzCookie1" ] && discuzCookie1="\"discuzCookie1\"=$(echo $qiandao_discuzCookie1 | base64_decode)" || discuzCookie1="\"discuzCookie1\""
	[ -n "$qiandao_discuzName2" ] && discuzName2="\"discuzName2\"=$(echo $qiandao_discuzName2 | base64_decode)" || discuzName2="\"discuzName2\""
	[ -n "$qiandao_discuzUrl2" ] && discuzUrl2="\"discuzUrl2\"=$(echo $qiandao_discuzUrl2 | base64_decode)" || discuzUrl2="\"discuzUrl2\""
	[ -n "$qiandao_discuzCookie2" ] && discuzCookie2="\"discuzCookie2\"=$(echo $qiandao_discuzCookie2 | base64_decode)" || discuzCookie2="\"discuzCookie2\""
	[ -n "$qiandao_discuzName3" ] && discuzName3="\"discuzName3\"=$(echo $qiandao_discuzName3 | base64_decode)" || discuzName3="\"discuzName3\""
	[ -n "$qiandao_discuzUrl3" ] && discuzUrl3="\"discuzUrl3\"=$(echo $qiandao_discuzUrl3 | base64_decode)" || discuzUrl3="\"discuzUrl3\""
	[ -n "$qiandao_discuzCookie3" ] && discuzCookie3="\"discuzCookie3\"=$(echo $qiandao_discuzCookie3 | base64_decode)" || discuzCookie3="\"discuzCookie3\""
	echo -e "$baidu\n$v2ex\n$hostloc\n$bilibili\n$smzdm\n$jd\n$cloudmusic\n$koolshare\n$acfun\n$qq\n$qqgroup\n$rrtv\n$phicomm\n$cmcc\n\n##### Discuz Forum Custom #####\n$discuzName1\n$discuzUrl1\n$discuzCookie1\n$discuzName2\n$discuzUrl2\n$discuzCookie2\n$discuzName3\n$discuzUrl3\n$discuzCookie3" > $KSROOT/qiandao/qiandao.ini
	sed -i '/qiandao/d' /etc/crontabs/root
	echo "0 $qiandao_time * * * $KSROOT/scripts/qiandao_config.sh" >> /etc/crontabs/root
	cd /koolshare/qiandao && ./qiandao > $logfile 2>&1 &
}

stop_qiandao(){
	sed -i '/qiandao/d' /etc/crontabs/root
}

# used by httpdb
if [ "$qiandao_enable" == "1" ];then
	touch $KSROOT/qiandao/.qiandao.lock
	start_qiandao
	http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
else
	stop_qiandao
	http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
fi
