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
	
	<link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    
    <link rel="stylesheet" href="m/css/index.css">
    <link rel="stylesheet" href="m/css/dropload.css">
    
	<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="js/register.js"></script>
    <script type="text/javascript" src="js/bm.js"></script>
  </head>
  
  <body>
    
<script type="text/javascript">
$(function(){	
    var $tooltips = $('.js_tooltips');
	var $userName = $('.userName');	
	var $loginName = $('.loginName');
	var $passWord = $('.passWord');
	var $againPwd = $('.againPwd');
	var $phoneNum = $('.phoneNum');
	var $vercode = $('.vercode');
	var $verificationCode = $('.verificationCode');
	
	$('#showTooltips').on('click', function(){
        if($tooltips.css('display') != 'none') return false;
        
        var flag = true;
        if($.trim($verificationCode.val()) == ''){
            $tooltips.html('短信验证码不能为空');
            flag = false;
        }
        if($.trim($vercode.val()) == ''){
            $tooltips.html('图形验证码不能为空');
            flag = false;
        }
        if(!isPhoneNo($.trim($phoneNum.val()))){
            $tooltips.html('手机号码格式不正确');
            flag = false;
        }
        if($.trim($phoneNum.val()) == ''){
            $tooltips.html('手机号码不能为空');
            flag = false;
        }
        if($.trim($againPwd.val()) != $.trim($passWord.val())){
            $tooltips.html('密码与确认密码不一致');
            flag = false;
        }
        if($.trim($againPwd.val()) == ''){
            $tooltips.html('确认密码不能为空');
            flag = false;
        }
        if(!isRegularPassword($.trim($passWord.val()))){
            $tooltips.html('密码必须同时含有数字和字母');
            flag = false;
        }
        if(($.trim($passWord.val())).length < 6){
            $tooltips.html('密码长度不能少于6位');
            flag = false;
        }
        if($.trim($passWord.val()) == ''){
            $tooltips.html('密码不能为空');
            flag = false;
        }
        if($.trim($loginName.val()) == ''){
            $tooltips.html('登录名不能为空');
            flag = false;
        }

        var reg = /^[\u4E00-\u9FA5]+$/;
        if (!reg.test($userName.val())) {
            $tooltips.html("姓名必须为中文！");
            flag = false;
        }

        if($.trim($userName.val()) == ''){
            $tooltips.html('姓名不能为空');
            flag = false;
        }

        if(!flag){
            $tooltips.css('display', 'block');
            setTimeout(function(){
                $tooltips.css('display', 'none');
            }, 2000);
            return false;
        }
                
        var data = $("#user_reg_1_form").serialize();
        $("#register_loading_toast").show();
        $.ajax({
       	    type: "POST",
       	    url: "user_reg_sub",
       	    dataType:"json",
       	    data: data,
       	    success: function(result){
       	        if(result.msg != ""){
                    $("#register_loading_toast").hide();
       	            $tooltips.html(result.msg);
       	            $tooltips.css('display', 'block');
                    setTimeout(function(){
                        $tooltips.css('display', 'none');
                    }, 2000);
       	        }else{
       	            $.cookie("danWeiGuid", result.danWeiGuid);
       	            $.cookie("userGuid", result.userGuid);
       	            $.cookie("userName", $userName.val());
       	            $.cookie("phoneNum", $phoneNum.val());
       	            location.href = "user_reg_sub_more";
       	        }
       	    },
       	    error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   		
       	    }
       	});
    });   
});
</script>

<header class="h43" style="height: 27px">
    <div class="index-header">
        <a href="login" class="back"></a>
        <div class="title">个人会员注册</div>
    </div>
</header>

<div class="weui-toptips weui-toptips_warn js_tooltips"></div>

<div class="weui-cells weui-cells_form">
	<form id="user_reg_1_form">
	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">姓名<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
            <input class="weui-input userName" name="userName" type="text" placeholder="请输入真实姓名"/>
        </div>
    </div>
    
    <div class="weui-cell weui-cell_vcode">
        <div class="weui-cell__hd"><label class="weui-label">登录名<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
            <input class="weui-input loginName" name="loginName" type="text" placeholder="请输入登录名"/>
        </div>
        <div class="weui-cell__ft">
            <a class="weui-vcode-btn" id="get_weui-loginName-btn">检测登录名</a>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">密码<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
            <input class="weui-input passWord" name="passWord" type="password" placeholder="请输入密码"/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">确认密码<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
            <input class="weui-input againPwd" name="againPwd" type="password" placeholder="请再次输入密码"/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">手机号<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
            <input class="weui-input phoneNum" name="phoneNum" type="text" placeholder="请输入真实手机号"/>
        </div>
    </div>
    
    <div class="weui-cell weui-cell_vcode">
        <div class="weui-cell__hd"><label class="weui-label">图形验证码<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
            <input class="weui-input vercode" name="vercode" placeholder="请输入图形验证码"/>
        </div>
        <div class="weui-cell__ft">
            <img class="weui-vcode-img" width="108.08px" height="30px" id="authimg" src="" />
        </div>
    </div>
    
    <div class="weui-cell weui-cell_vcode">
        <div class="weui-cell__hd">
            <label class="weui-label">短信验证码<font color="red">(*)</font></label>
        </div>
        <div class="weui-cell__bd">
            <input class="weui-input verificationCode" name="verificationCode" type="tel" placeholder="请输入短信验证码">
        </div>
        <div class="weui-cell__ft">
            <a class="weui-vcode-btn" id="get_weui-vcode-btn">获取验证码</a>
        </div>
    </div>
    
    </form>
    
</div>

<div class="weui-btn-area">
    <a class="weui-btn weui-btn_primary" href="javascript:" id="showTooltips">确定</a>
</div>


<div id="register_loading_toast" style="display:none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
        <i class="weui-loading weui-icon_toast"></i>
        <p class="weui-toast__content" id="toast_div">数据提交中</p>
    </div>
</div>
  </body>
</html>
