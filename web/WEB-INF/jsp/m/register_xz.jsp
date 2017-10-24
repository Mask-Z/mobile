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
    <link rel="stylesheet" href="m/css/index.css">
    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js"></script>
</head>

<body>
<script type="text/javascript">
$(function(){
    $("#is_ok").on("click",function(){
    	$("#reg_select_div").fadeIn(200);
    });
    
    $("#is_not_ok").on("click",function(){
    	location.href = "login";
    });
    
    $("#reg_sel_ok").on("click",function(){
	    $(".reg_sel").each(function(){ 
            if($(this).is(':checked')){
                var val = $(this).val();
                if(val == "1"){
                    location.href = "unit_reg";
                }else{
                    location.href = "user_reg";
                }            
            }
        });
        $("#reg_select_div").fadeOut(200);
    }); 
});
</script>

<header class="h43" style="height: 27px">
    <div class="index-header">
        <a href="login" class="back"></a>
        <div class="title">报名须知</div>
    </div>
</header>

<div>
    <div class="weui-cells" style="margin-top:0px;"> 
            <div style="padding:5px">
                ${register_xz.ProtocolInfo}
            </div>
            <div class="weui-btn-area">
            	<a href="javascript:;" class="weui-btn weui-btn_default" id="is_not_ok">不同意</a>
                <a href="javascript:;" class="weui-btn weui-btn_primary" id="is_ok">同意</a>
                
            </div>
        
    </div>
</div>
</body>
    <!-- 会员类型-->
    <div id="reg_select_div" style="display:none;">
    <div class="weui-mask"></div>
    <div class="weui-dialog" style="width: 100%;">
        <div class="weui-dialog__hd"><strong class="weui-dialog__title">选择注册类型</strong></div>
        <div class="weui-dialog__bd">			
			<div class="weui-cells weui-cells_radio">
            <label class="weui-cell weui-check__label" for="x11">
                <div class="weui-cell__bd">
                    <p align="left">单位注册</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" class="weui-check reg_sel" name="radio1" id="x11" checked="checked" value="1">
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
            <label class="weui-cell weui-check__label" for="x12">

                <div class="weui-cell__bd">
                    <p align="left">个人注册</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" name="radio1" class="weui-check reg_sel" id="x12" value="2">
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
        </div>				
		</div>
        <div class="weui-dialog__ft">
            <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary" id="reg_sel_ok">确定</a>
        </div>
    </div>
    </div>
</html>
