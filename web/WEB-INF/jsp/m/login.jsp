<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en">

<head>
<jsp:include page="mate.jsp"></jsp:include>
    <title></title>
    <link rel="stylesheet" href="m/css/bootstrap.min.css">
    <link rel="stylesheet" href="m/css/index.css">
    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js"></script>
</head>

<body>
<script type="text/javascript">
$(function(){
    newimg();
	function newimg(){
		$("#authimg").attr("src","authimg?"+new Date().getTime());
	}

	$("#authimg").click(function(){
		newimg();
	});

	$("#reg_type_sel").on("click",function(){
    	location.href = "reg_xz";
    });

    var $tooltips = $('.js_tooltips');
    $('#jmr_login_in').on('click', function(){
        if($tooltips.css('display') != 'none') return;

        var flag = true;
        if($.trim($('#ver_code').val()) == ''){
            $tooltips.html('验证码必填');
            flag = false;
        }
        if($.trim($('#pass_word').val()) == ''){
            $tooltips.html('密码必填');
            flag = false;
        }
        if($.trim($('#login_name').val()) == ''){
            $tooltips.html('登录名必填');
            flag = false;
        }

        if(!flag){
            $tooltips.css('display', 'block');
            setTimeout(function () {
                $tooltips.css('display', 'none');
            }, 2000);
            return;
        }
        $('#loginLoadingToast').fadeIn(100);
        var data = $("#login_form").serialize();
        $.ajax({
       	   type: "POST",
       	   url: "login_in",
       	   dataType:"json",
       	   data: data,
       	   success: function(message){
       	       if(message.msg != ""){
                   $('#loginLoadingToast').fadeOut(100);
       	           $tooltips.html(message.msg);
       	           $tooltips.css('display', 'block');
                   setTimeout(function () {
                       $tooltips.css('display', 'none');
                   }, 2000);
       	       }else{
       	           if(message.isFinish){
       	               location.href = "pj_list_cqjy";
       	           }else{
       	               $.cookie("danWeiGuid", message.danWeiGuid);
       	               $.cookie("userGuid", message.userGuid);
       	               $.cookie("userName", message.danWeiName);
       	               $.cookie("phoneNum", message.companyPhone);
       	               if(message.memberType == "0"){
       	                   location.href = "unit_reg_sub_more";
       	               }else{
       	                   location.href = "user_reg_sub_more";
       	               }
       	           }
       	       }
       	   },
       	   error:function (XMLHttpRequest, textStatus, errorThrown) {

       	   }
       	});
    });
});
</script>
<div class="login-bg">
<div class="weui-toptips weui-toptips_warn js_tooltips"></div>
    <img src="m/images/login-bg.jpg" alt="" class="bg" width="100%">
    <div class="login-title">
        <div class="logo"><img src="m/images/logo3.png" alt="" width="100%" class="dsb"></div>
    </div>
    <form id="login_form">
    <div class="login-contant">
        <ul class="box">
            <li>
                <label class="login-label glyphicon glyphicon-user"></label>
                <input type="text" name="loginName" value="" class="login-input" id="login_name" placeholder="请输入登录名">
            </li>
            <li>
                <label class="login-label glyphicon glyphicon-lock"></label>
                <input type="passWord" name="passWord" value="" class="login-input" id="pass_word" placeholder="请输入密码">
            </li>
            <dl>
                <dd>
                    <input type="text" name="vercode" class="form-control input input-sm" id="ver_code" placeholder="请输入验证码">
                </dd>
                <dt class="small">
                <div class="ml10">
                    <img src="" id="authimg" class="weui-vcode-img">
                </div>
                </dt>
            </dl>
            <li>
                <a href="javascript:" class="login-btn" id="jmr_login_in">登录</a>
            </li>
            <li>
                <a href="javascript:" id="reg_type_sel" class="fr f14 fcff">我要注册</a>
            </li>
        </ul>
    </div>
    </form>
</div>
<!-- loading -->
<div id="loginLoadingToast" style="display:none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
        <i class="weui-loading weui-icon_toast"></i>
        <p class="weui-toast__content" id="toast_div">正在登录</p>
    </div>
</div>
</body>
</html>
