$(function(){
	newimg();
	function newimg(){
		$("#authimg").attr("src","authimg?"+new Date().getTime());
	}
	
	$("#authimg").click(function(){
		newimg();
	});
	
	$('#get_weui-loginName-btn').on('click', function(){
		if($.trim($('.loginName').val()) == ''){
            $('.js_tooltips').html('登录名不能为空');
            $('.js_tooltips').css('display', 'block');
            setTimeout(function(){
                $('.js_tooltips').css('display', 'none');
            }, 2000);
            return false;
        }
        checkLoginName();   
    });
	    
    var InterValObj; //timer变量，控制时间
    var count = 60; //间隔函数，1秒执行
    var curCount;//当前剩余秒数
    $('#get_weui-vcode-btn').on('click', function(){
        if($('.vercode').val() == ''){
            $('.js_tooltips').html('图形验证码不能为空');
            $('.js_tooltips').css('display', 'block');
            setTimeout(function(){
                $('.js_tooltips').css('display', 'none');
            }, 2000);
            return false;
        }
        if($('.phoneNum').val() == ''){
            $('.js_tooltips').html('手机号码不能为空');
            $('.js_tooltips').css('display', 'block');
            setTimeout(function(){
                $('.js_tooltips').css('display', 'none');
            }, 2000);
            return false;
        }
        if(!isPhoneNo($('.phoneNum').val())){
            $('.js_tooltips').html('请输入有效的手机号码');
            $('.js_tooltips').css('display', 'block');
            setTimeout(function(){
                $('.js_tooltips').css('display', 'none');
            }, 2000);
            return false;
        }
        if(curCount > 0){
            return false; 
        }
        $.ajax({
       	    type: "POST",
       	    url: "reg_getVercode",
       	    dataType:"json",
       	    data: "phoneNum=" + $.trim($('.phoneNum').val()) + "&imgVerCode=" + $('.vercode').val(),
       	    success: function(result){
       	        if(result.msg != ""){
       	            $('.js_tooltips').html(result.msg);
       	            $('.js_tooltips').css('display', 'block');
                    setTimeout(function () {
                        $('.js_tooltips').css('display', 'none');
                    }, 2000);
       	        }else{
       	            curCount = count;
                    InterValObj = window.setInterval(SetRemainTime, 1000); //启动计时器，1秒执行一次
       	        }
       	    },
       	    error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   	   
       	    }
       	});
    });
    
    function SetRemainTime(){
        if (curCount == 0){                
            window.clearInterval(InterValObj);//停止计时器
            $("#get_weui-vcode-btn").text("获取短信验证码");
        }
        else{
            curCount--;
            $("#get_weui-vcode-btn").text(curCount + "秒后重新获取");
        }
    } 
});

function checkLoginName(){		
    $.ajax({  
        type: "POST", 
        url: "reg_checkLoginName",
        datatype:"json", 
        data: "loginName="+$.trim($('.loginName').val()),  
        success: function(result){
            if(result.msg != ""){
   	            $('.js_tooltips').html(result.msg);
   	            $('.js_tooltips').css('display', 'block');
                setTimeout(function(){
                    $('.js_tooltips').css('display', 'none');
                }, 2000);
                return false;
   	        }                      
        },  
        error: function(XMLHttpRequest, textStatus, errorThrown) {    

        }  
    });     
}

	
