<title>软件中心 - 自动签到 2.1.2b</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
	input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript">
var dbus;
var softcenter = 0;
var _responseLen;
var noChange = 0;
var reload = 0;
var Scorll = 1;
get_dbus_data();
setTimeout("get_run_status();", 1000);
tabSelect('app1');

		if (typeof btoa == "Function") {
			Base64 = {
				encode: function(e) {
					return btoa(e);
				},
				decode: function(e) {
					return atob(e);
				}
			};
		} else {
			Base64 = {
				_keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
				encode: function(e) {
					var t = "";
					var n, r, i, s, o, u, a;
					var f = 0;
					e = Base64._utf8_encode(e);
					while (f < e.length) {
						n = e.charCodeAt(f++);
						r = e.charCodeAt(f++);
						i = e.charCodeAt(f++);
						s = n >> 2;
						o = (n & 3) << 4 | r >> 4;
						u = (r & 15) << 2 | i >> 6;
						a = i & 63;
						if (isNaN(r)) {
							u = a = 64
						} else if (isNaN(i)) {
							a = 64
						}
						t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a)
					}
					return t
				},
				decode: function(e) {
					var t = "";
					var n, r, i;
					var s, o, u, a;
					var f = 0;
					if (typeof(e) == "undefined"){
						return t = "";
					}
					e = e.replace(/[^A-Za-z0-9\+\/\=]/g, "");
					while (f < e.length) {
						s = this._keyStr.indexOf(e.charAt(f++));
						o = this._keyStr.indexOf(e.charAt(f++));
						u = this._keyStr.indexOf(e.charAt(f++));
						a = this._keyStr.indexOf(e.charAt(f++));
						n = s << 2 | o >> 4;
						r = (o & 15) << 4 | u >> 2;
						i = (u & 3) << 6 | a;
						t = t + String.fromCharCode(n);
						if (u != 64) {
							t = t + String.fromCharCode(r)
						}
						if (a != 64) {
							t = t + String.fromCharCode(i)
						}
					}
					t = Base64._utf8_decode(t);
					return t
				},
				_utf8_encode: function(e) {
					e = e.replace(/\r\n/g, "\n");
					var t = "";
					for (var n = 0; n < e.length; n++) {
						var r = e.charCodeAt(n);
						if (r < 128) {
							t += String.fromCharCode(r)
						} else if (r > 127 && r < 2048) {
							t += String.fromCharCode(r >> 6 | 192);
							t += String.fromCharCode(r & 63 | 128)
						} else {
							t += String.fromCharCode(r >> 12 | 224);
							t += String.fromCharCode(r >> 6 & 63 | 128);
							t += String.fromCharCode(r & 63 | 128)
						}
					}
					return t
				},
				_utf8_decode: function(e) {
					var t = "";
					var n = 0;
					var r = c1 = c2 = 0;
					while (n < e.length) {
						r = e.charCodeAt(n);
						if (r < 128) {
							t += String.fromCharCode(r);
							n++
						} else if (r > 191 && r < 224) {
							c2 = e.charCodeAt(n + 1);
							t += String.fromCharCode((r & 31) << 6 | c2 & 63);
							n += 2
						} else {
							c2 = e.charCodeAt(n + 1);
							c3 = e.charCodeAt(n + 2);
							t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63);
							n += 3
						}
					}
					return t
				}
			}
		}
		//============================================

function get_dbus_data(){
	$.ajax({
	  	type: "GET",
	 	url: "/_api/qiandao_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	dbus = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "qiandao_status.sh", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_qiandao_status").innerHTML = response.result;
			setTimeout("get_run_status();", 3000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_qiandao_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}

function verifyFields(focused, quiet){
	if(E('_qiandao_enable').checked){
		$('input').prop('disabled', false);
		$('select').prop('disabled', false);
	}else{
		$('input').prop('disabled', true);
		$('select').prop('disabled', true);
		$(E('_qiandao_enable')).prop('disabled', false);
	}
	return true;
}

function init_qiandao(){
	verifyFields();
	setTimeout("get_run_status();", 1000);
}

function toggleVisibility(whichone) {
	if(E('sesdiv' + whichone).style.display=='') {
		E('sesdiv' + whichone).style.display='none';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-up"></i>';
		cookie.set('ss_' + whichone + '_vis', 0);
	} else {
		E('sesdiv' + whichone).style.display='';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-down"></i>';
		cookie.set('ss_' + whichone + '_vis', 1);
	}
}

function tabSelect(obj){
	var tableX = ['app1-server1-jb-tab','app3-server1-rz-tab'];
	var boxX = ['boxr1','boxr3'];
	var appX = ['app1','app3'];
	for (var i = 0; i < tableX.length; i++){
		if(obj == appX[i]){
			$('#'+tableX[i]).addClass('active');
			$('.'+boxX[i]).show();
		}else{
			$('#'+tableX[i]).removeClass('active');
			$('.'+boxX[i]).hide();
		}
	}
	if(obj=='app3'){
		setTimeout("get_log();", 400);
		elem.display('save-button', false);
		elem.display('cancel-button', false);
	}else{
		elem.display('save-button', true);
		elem.display('cancel-button', true);
	}
}

function showMsg(Outtype, title, msg){
	$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
	$('#'+Outtype).show();
}

function save(){
	var para_chk = ["qiandao_enable"];
	var para_inp = ["qiandao_time"];
	// collect data from checkbox
	for (var i = 0; i < para_chk.length; i++) {
		dbus[para_chk[i]] = E('_' + para_chk[i] ).checked ? '1':'0';
	}
	// data from other element
	for (var i = 0; i < para_inp.length; i++) {
		console.log(E('_' + para_inp[i] ).value)
		if (!E('_' + para_inp[i] ).value){
			dbus[para_inp[i]] = "";
		}else{
			dbus[para_inp[i]] = E('_' + para_inp[i]).value;
		}
	}
	// data need base64 encode
	var paras_base64 = ["qiandao_baidu", "qiandao_v2ex", "qiandao_hostloc", "qiandao_bilibili", "qiandao_smzdm", "qiandao_jd", "qiandao_cloudmusic", "qiandao_koolshare", "qiandao_acfun", "qiandao_qq", "qiandao_qqgroup", "qiandao_rrtv", "qiandao_phicomm", "qiandao_cmcc", "qiandao_discuzName1", "qiandao_discuzUrl1", "qiandao_discuzCookie1", "qiandao_discuzName2", "qiandao_discuzUrl2", "qiandao_discuzCookie2", "qiandao_discuzName3", "qiandao_discuzUrl3", "qiandao_discuzCookie3"];
	for (var i = 0; i < paras_base64.length; i++) {
		if (typeof(E('_' + paras_base64[i] ).value) == "undefined"){
			dbus[paras_base64[i]] = "";
		}else{
			dbus[paras_base64[i]] = Base64.encode(E('_' + paras_base64[i]).value);
		}
	}
	//-------------- post dbus to dbus ---------------
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method":'qiandao_config.sh', "params":[1], "fields": dbus};
	var success = function(data) {
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 1000);
	};
	$('#footer-msg').text('保存中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  dataType: "json"
	});
}

function get_log(){
	$.ajax({
		url: '/_temp/qiandao_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("_qiandao_log");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				retArea.scrollTop = retArea.scrollHeight;
				if (reload == 1){
					setTimeout("window.location.reload()", 1200);
					return true;
				}else{
					return true;
				}
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 1000) {
				tabSelect("app1");
				return false;
			} else {
				setTimeout("get_log();", 200);
			}
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function() {
			E("_qiandao_log").value = "获取日志失败！";
			return false;
		}
	});
}

</script>
<div class="box">
	<div class="heading">自动签到 2.1.2b<a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
	<div class="content">
		<span class="col" style="line-height:30px;width:700px">
		Rewrite by Hikaru (i@rua.moe)<br />
		Special thanks:fw867、Carseason<br />
		本插件实现帮你自动签到，请填写<strong>cookie</strong>而不是账号密码<br />
		如果你觉得本插件好用，可以捐献给我们<br />
		(BTC) 114Tg7mcVvUntUe1kw7HzaHByeypk2EJYb / (ETH) 0xa8a8640086a1acd6fd76b78ad3d4736871e76161<br />
		关于本插件的BUG反馈以及建议：<a href="https://github.com/hikaruchang/qiandao-koolsoft" target="_blank"><u>Github</u></a> | <a href="mailto:i@rua.moe" target="_blank"><u>Email</u></a><br />
		<font color="#FF0033"><b>本程序并不会主动将您的账号信息泄漏给第三方，但并不意味着您的账号处于安全状态，您在使用本程序时默认已知晓安全性风险。</b></font>
		</span>
	</div>
</div>
<ul class="nav nav-tabs">
	<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 配置</a></li>
	<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-server1-rz-tab"><i class="icon-info"></i> 日志</a></li>
</ul>
<div class="box boxr1" style="margin-top: 0px;">
	<div class="heading">配置</div>
	<hr>
	<div class="content">
		<div id="qiandao-fields"></div>
		<script type="text/javascript">
			$('#qiandao-fields').forms([
			{ title: '开启自动签到', name: 'qiandao_enable', type: 'checkbox', value: dbus.qiandao_enable == 1},
			{ title: '运行状态', text: '<font id="_qiandao_status" name=_qiandao_status color="#1bbf35">正在检查运行状态...</font>' },
			{ title: '运行时间', name: 'qiandao_time', type:'select', options:[['3','3点'],['6','6点'],['9','9点'],['12','12点'],['15','15点'],['18','18点'],['21','21点'],['0','0点']],value: dbus.qiandao_time || "12", suffix: ' 默认:12点' },
			{ title: '百度贴吧', name: 'qiandao_baidu', type: 'textarea', value: Base64.decode(dbus.qiandao_baidu) ||"",suffix: ' 注意，只需填写BDUSS段。', style: 'width: 100%; height:150px;' },
			{ title: 'v2ex', name: 'qiandao_v2ex', type: 'textarea', value: Base64.decode(dbus.qiandao_v2ex) ||"", style: 'width: 100%; height:150px;'},
			{ title: 'hostloc', name: 'qiandao_hostloc', type: 'textarea', value: Base64.decode(dbus.qiandao_hostloc) ||"", style: 'width: 100%; height:150px;'},
			{ title: '哔哩哔哩（主站、直播）', name: 'qiandao_bilibili', type: 'textarea', value: Base64.decode(dbus.qiandao_bilibili) ||"", style: 'width: 100%; height:150px;'},
			{ title: '什么值得买', name: 'qiandao_smzdm', type: 'textarea', value: Base64.decode(dbus.qiandao_smzdm) ||"", style: 'width: 100%; height:150px;'},
			{ title: '京东（商城、金融、APP）', name: 'qiandao_jd', type: 'textarea', value: Base64.decode(dbus.qiandao_jd) ||"", style: 'width: 100%; height:150px;'},
			{ title: '网易云音乐（PC、手机）', name: 'qiandao_cloudmusic', type: 'textarea', value: Base64.decode(dbus.qiandao_cloudmusic) ||"", style: 'width: 100%; height:150px;'},
			{ title: 'Koolshare', name: 'qiandao_koolshare', type: 'textarea', value: Base64.decode(dbus.qiandao_koolshare) ||"", style: 'width: 100%; height:150px;'},
			{ title: 'Acfun', name: 'qiandao_acfun', type: 'textarea', value: Base64.decode(dbus.qiandao_acfun) ||"", style: 'width: 100%; height:150px;'},
			{ title: 'QQ（资料卡、QQ群）', name: 'qiandao_qq', type: 'textarea', value: Base64.decode(dbus.qiandao_qq) ||"",suffix: ' 请使用 qun.qq.com 的cookie信息，由于腾讯cookie时效特殊性，如果发现不能签到，请更新cookie。', style: 'width: 100%; height:150px;'},
			{ title: 'QQ群号', name: 'qiandao_qqgroup', type: 'textarea', value: Base64.decode(dbus.qiandao_qqgroup) ||"",suffix: ' 填写格式为：\"123\",\"321\"，群号需要加英文半角双引号，多个群号用英文半角逗号分割', style: 'width: 100%; height:29px;'},
			{ title: '人人视频（rr.tv）', name: 'qiandao_rrtv', type: 'textarea', value: Base64.decode(dbus.qiandao_rrtv) ||"", style: 'width: 100%; height:150px;'},
			{ title: '斐讯商城', name: 'qiandao_phicomm', type: 'textarea', value: Base64.decode(dbus.qiandao_phicomm) ||"", style: 'width: 100%; height:150px;'},
			{ title: '山东移动', name: 'qiandao_cmcc', type: 'textarea', value: Base64.decode(dbus.qiandao_cmcc) ||"", style: 'width: 100%; height:150px;'},
			{ title: '自定义论坛1-名称', name: 'qiandao_discuzName1', type: 'textarea', value: Base64.decode(dbus.qiandao_discuzName1) ||"", style: 'width: 100%; height:29px;'},
			{ title: '自定义论坛1-网址', name: 'qiandao_discuzUrl1', type: 'textarea', value: Base64.decode(dbus.qiandao_discuzUrl1) ||"", style: 'width: 100%; height:29px;'},
			{ title: '自定义论坛1-Cookie', name: 'qiandao_discuzCookie1', type: 'textarea', value: Base64.decode(dbus.qiandao_discuzCookie1) ||"", style: 'width: 100%; height:150px;'},
			{ title: '自定义论坛2-名称', name: 'qiandao_discuzName2', type: 'textarea', value: Base64.decode(dbus.qiandao_discuzName2) ||"", style: 'width: 100%; height:29px;'},
			{ title: '自定义论坛2-网址', name: 'qiandao_discuzUrl2', type: 'textarea', value: Base64.decode(dbus.qiandao_discuzUrl2) ||"", style: 'width: 100%; height:29px;'},
			{ title: '自定义论坛2-Cookie', name: 'qiandao_discuzCookie2', type: 'textarea', value: Base64.decode(dbus.qiandao_discuzCookie2) ||"", style: 'width: 100%; height:150px;'},
			{ title: '自定义论坛3-名称', name: 'qiandao_discuzName3', type: 'textarea', value: Base64.decode(dbus.qiandao_discuzName3) ||"", style: 'width: 100%; height:29px;'},
			{ title: '自定义论坛3-网址', name: 'qiandao_discuzUrl3', type: 'textarea', value: Base64.decode(dbus.qiandao_discuzUrl3) ||"", style: 'width: 100%; height:29px;'},
			{ title: '自定义论坛3-Cookie', name: 'qiandao_discuzCookie3', type: 'textarea', value: Base64.decode(dbus.qiandao_discuzCookie3) ||"", style: 'width: 100%; height:150px;'},
			]);
			$('#_qiandao_enable').parent().parent().css("margin-left","-10px");
		</script>
	</div>
</div>

<div class="box boxr3">
	<div class="heading">运行日志</div>
	<div class="content">
		<div class="section qiandao_log content">
			<script type="text/javascript">
				y = Math.floor(docu.getViewSize().height * 0.55);
				s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
				$('.section.qiandao_log').append('<textarea class="as-script" name="qiandao_log" id="_qiandao_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

			</script>
		</div>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_qiandao();</script>
</content>
