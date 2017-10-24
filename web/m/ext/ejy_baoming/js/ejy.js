$(function($) {
	//----------E交易测试系统
	//var ejy_login_url ="http://58.216.221.106:8001/cjshy/DanDianLogin/Pages/login.ashx";//登录接口
	//var ejy_baoming_url ="http://58.216.221.106:8001/cjshy/DanDianLogin/Pages/Redirect.aspx?Projectno=";//项目报名接口

	//----------E交易正式系统
	var ejy_login_url ="http://www.e-jy.com.cn/ejyhy/DanDianLogin/Pages/login.ashx";
	var ejy_baoming_url ="http://www.e-jy.com.cn/ejyhy/DanDianLogin/Pages/Redirect.aspx?Projectno=";

	//登录
	$(".ejy_huiyuan_dl").click(function(){
		var u =$("#ejy_huiyuan_baoming input[name=username]").val();
		var p =$("#ejy_huiyuan_baoming input[name=password]").val();
		var projectNo =$("#ejy_huiyuan_baoming input[name=projectNo]").val();
		//alert(u +"," +p +" ," +projectNo);
		_loginOrBaoMing(projectNo ,true ,u ,p);
	});
	
	//报名
	$(".ejy_huiyuan_bm").bind("click",function(){
		//获取浏览器和版本
		if(explorer !="IE"){
			alert("您的浏览器非IE版本可能会影响正常报价，建议使用IE9以上");
		}else{
			if(explorer_version <10){
				alert("您的浏览器IE版本过低，建议使用IE9以上");
			}
		}
		var projectNo =$(this).attr("id");
		//console.log("projectNo: "+projectNo);
		_loginOrBaoMing(projectNo ,false);
	});
	
	
	//竞价规则
	$(".ejy_huiyuan_jjgz").click(function(){
		var biaoDiNO = $(this).attr("id");
		var kssj_biaoDiNO = $("#kssj_"+biaoDiNO).val();
		var JingJiaFangShi_biaoDiNO = $("#JingJiaFangShi_"+biaoDiNO).val();
		var price_biaoDiNO = $("#price_"+biaoDiNO).val();
		var YanShiSecond_biaoDiNO = $("#YanShiSecond_"+biaoDiNO).val();
		var JingJiaSetp_biaoDiNO = $("#JingJiaSetp_"+biaoDiNO).val();
		var hasPriority_biaoDiNO = $("#hasPriority_"+biaoDiNO).val();
		var SystemType_biaoDiNO = $("#SystemType_"+biaoDiNO).val();
		var yxq = "";
		$("#kssj").html(kssj_biaoDiNO);
		$("#jjfs").html(JingJiaFangShi_biaoDiNO);
		$("#qsj").html(price_biaoDiNO+"元");
		$("#yczq").html(YanShiSecond_biaoDiNO+"秒");
		$("#jjjt").html(JingJiaSetp_biaoDiNO+"元");
		if(SystemType_biaoDiNO=='GQ'){
			if(hasPriority_biaoDiNO=='1'){
				yxq = "否"
			}else{
				yxq = "是"
			}
		}else{
			if(hasPriority_biaoDiNO=='1'){
				yxq = "是"
			}else{
				yxq = "否"
			}
		}		
		$("#yxq").html(yxq);
		if(JingJiaFangShi_biaoDiNO=='一次性'){
			$("#p_qsj").hide();
			$("#p_yczq").hide();
			$("#p_jjjt").hide();
			$("#p_yxq").hide();
		}
		$('#ejy_huiyuan_jjgz .theme-popover-mask').fadeIn(100);
		$('#ejy_huiyuan_jjgz .theme-popover').slideDown(200);
		$("#ejy_huiyuan_jjgz").show();
	});
	
	$("#ejy_huiyuan_jjgz .theme-poptit .close").click(function(){
		$("#ejy_huiyuan_jjgz .theme-popover-mask").fadeOut(100);
		$("#ejy_huiyuan_jjgz .theme-popover").slideUp(200);
	});
	
	function _showDialog(data ,isLogin ,projectNo){
		$("#ejy_huiyuan_baoming input[name=projectNo]").val(projectNo);
		if(!isLogin){
			data ="请先登录";
		}
		$("#ejy_huiyuan_baoming #error").show();
		$('#ejy_huiyuan_baoming .theme-popover-mask').fadeIn(100);
		$('#ejy_huiyuan_baoming .theme-popover').slideDown(200);
		//alert(data);
		$("#ejy_huiyuan_baoming #error").html("提示：" +data);
		$("#ejy_huiyuan_baoming #error").fadeOut(3000);
	}
	
	function _loginOrBaoMing(projectNo ,isLogin ,u ,p){
		var url;
		/*if(!isLogin){//报名的时候
			if(projectNo ==null || projectNo ==""){
				alert("调用接口失败：请检查是否对按钮设置项目编号的属性id");
				return;
			}
			url =ejy_baoming_url + projectNo;
		}*/
		if(projectNo ==null || projectNo ==""){
			alert("调用接口失败：请检查是否对按钮设置项目编号的属性id");
			return;
		}
		url =ejy_baoming_url + projectNo;
		
		var params ={"u" :"" ,"p" :""};
		if(isLogin){
			params.u =u;
			params.p =p;
		}
		$.ajax({
		    type:"post",
			url: ejy_login_url,
			dataType: "jsonp",
			jsonp:"callback",
			data :params,
			jsonpCallback:"successCallback",
			xhrFields:{ 
				withCredentials:true 
			},
		    success:function(data){
				//TODO...
				// alert(json);
				var login =data ==null ?false :data =="success";
				if(login){
					if(isLogin){
						_ejyLgoinHideDialog();
						//if(confirm("登录成功，确定要跳转到报名页面？"))
						//window.open(url);
						//$("#ejy_huiyuan_baoming input[name=username]").val("");
						$("#ejy_huiyuan_baoming input[name=password]").val("");//为了安全：清空密码
						//var $hide_login =$("#ejy_huiyuan_baoming #ejy_huiyuan_baoming_loginHide");
						//$hide_login.attr("href" ,ejy_login_url +"?u=" +u +"&p=" +p);
						//$hide_login.find("i").click();
						//window.open(ejy_login_url +"?u=" +u +"&p=" +p,"_blank");
						//window.close();
						var obj_window = window.open(ejy_login_url +"?u=" +u +"&p=" +p, '_blank');    
						obj_window.opener = window;    
						obj_window.focus();
						obj_window.close();   
						//alert("登录成功");
						window.open(url);
					}else{
						//alert("isLogin="+isLogin+",准备请求：" +url);
						window.open(url);
						//console.log(url);
					}
				}else{
					_showDialog(data ,isLogin ,projectNo);
				}
		     },error:function(XMLHttpRequest, textStatus, errorThrown) {
		     	//alert(XMLHttpRequest.status +"," +XMLHttpRequest.readyState +"," +textStatus);
			   	alert("登录异常，检查网络");
		     }
		});
	}
	
	function _ejyLgoinHideDialog(){
		$("#ejy_huiyuan_baoming .theme-popover-mask").fadeOut(100);
		$("#ejy_huiyuan_baoming .theme-popover").slideUp(200);
	}

	$(".theme-poptit .close").click(function(){
		_ejyLgoinHideDialog();
	});
})