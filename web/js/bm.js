$(function(){
    //文件上传弹出
    $("a[name='file_div']").click(function(){
    	$("#file_select_div").fadeIn(200);
    	$("#fileCode").val($(this).attr("code"));
    });
    
    //文件上传关闭按钮
    $("#close_file_btn").click(function(){
    	$("#file_select_div").fadeOut(200);
        $("#loadingToast").hide();
        $("#uploaderInput").val("");
    });
    
    /**
     * 文件上传提交
    **/
    var run = false;
    var $tooltips = $('#js_tooltips');
    $("#submit_file_btn").click(function(){

        if ($("#uploaderInput").val()==""){
            $tooltips.html("请选择上传文件!");
            $tooltips.show();
            setTimeout(function () {
                $tooltips.hide();
            },2000);
            return;
        }
        var f = document.getElementById("uploaderInput").files;
    	var fileName=f[0].name;
        var type=(fileName.substr(fileName.lastIndexOf("."))).toLowerCase();
        if (type!=".doc"&&type!=".docx"&&type!=".txt"&&type!=".rar"&&type!=".jpg"&&type!=".jpeg"&&type!=".pdf"&&type!=".mp3"&&type!=".xls"&&type!=".xlsx"&&type!=".gif"&&type!=".bmp"){
            $tooltips.html("请上传后缀名为doc,docx,txt,rar,jpg,jpeg,pdf,mp3,xls,xlsx,gif,bmp类型的文件! \n上传文件名称请勿含特殊符号! ");
            $tooltips.show();
            setTimeout(function () {
                $tooltips.hide();
            },2000);
            return;
        }

        if(!run){
            run = true;
        }else{
            return;
        }

        // console.log(f[0].size); //大小 字节

        $("#toast_div").text("文件上传中!");
    	$('#loadingToast').fadeIn(100);
    	var form=document.getElementById("upform");
        var fileform =new FormData(form);
        $("#uploaderInput").val("");
        $.ajax({
            url: "file_upload",
            type: "POST",
            data: fileform,
            processData: false,
            contentType: false,
            success: function(res,status,xhr){
            	run = false;
            	if(res){
            		if(res.code==0){
            			$("#toast_div").text("上传成功!");
                    	$('#loadingToast').fadeOut(100);
                    	loadFile();
                    	$("#close_file_btn").click();
            		}
            	}else{
                    $("#toast_div").text("上传失败!");
                    $('#loadingToast').fadeOut(3000);
				}
            	
            },
			error:function () {
                $("#toast_div").text("上传失败!");
                $('#loadingToast').fadeOut(3000);
            }
        });
    });	
    
    /**
	 * 关闭报名回执
	 */
	$("#zdl_btn").on('click',function () {
		$('#iosDialog').fadeOut(100);
    });

    /**
     * 控制数据只能输入0-9,回退
     */
    $('input[type="number"]').keydown(function (e) {
        var keyCode = e.keyCode;
        if (keyCode != 48 && keyCode != 49 && keyCode != 50 && keyCode != 51 && keyCode != 52 && keyCode != 53 && keyCode != 54 && keyCode != 55 && keyCode != 56 && keyCode != 57 && keyCode != 8) {
            return false;
        }
    });

    /**
     * 开户账号可以有-
     */
    $('input[type="khzh"]').on("keyup",function(e){
        NumAndGang(e.target);
    });
    // $('input[type="khzh"]').keydown(function (e) {
    //     var keyCode = e.keyCode;
    //     if (keyCode != 48 && keyCode != 49 && keyCode != 50 && keyCode != 51 && keyCode != 52 && keyCode != 53 && keyCode != 54 && keyCode != 55 && keyCode != 56 && keyCode != 57 && keyCode != 8 && keyCode != 189) {
    //         return false;
    //     }
    // });

    /**
     * 资本可以有.
     */
    $('input[type="zb"]').on("keyup",function(e){
        NumAndDot(e.target);
    });

});

/**
 * 附件删除
*/
function del(fid){
	$("#toast_div").text("删除中!");$('#loadingToast').fadeIn(100);	
	$.ajax({
        url: "file_del",
        type: "POST",
        data: "fileid="+fid,
        success: function(res,status,xhr){
        	if(res && res.code==0){
				$("#toast_div").text("删除成功!");
          	}
			loadFile();
			$('#loadingToast').fadeOut(100);
        }
	});
};

/**
  * 打印报名回执
  * @param RowGuid
*/
function printHZ(guid,type){		
	$("#loadingToast").fadeIn(100);		
	$iosDialog2 = $('#iosDialog');		
    $.ajax({
        type:"GET",
        url:"getReceipt?type="+type+"&rowGuid="+guid,
        dataType:"json",
        success: function(data){
            $("#loadingToast").fadeOut(100);
            if(data.code!="0"){
            	alert(data.msg);
            	return false;
            }            	
            $(".weui-dialog__bd").html(data.data[0].content);                
            $iosDialog2.fadeIn(100);
        },
        error:function () {
            $(".weui-dialog__bd").html("获取数据失败!");
            $("#loadingToast").fadeOut(100);
        }
    });       
}


// 验证手机号
function isPhoneNo(phone) {
    var pattern = /^1[34578]\d{9}$/;
    return pattern.test(phone);
}

//验证密码必须同时含有数字和字母
function isRegularPassword(password) {
    var pattern = /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]/;
    return pattern.test(password);
}

// 验证身份证
function isCardNo(card) {
    //var pattern = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
	var pattern = /(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/;
	var p = (pattern.test(card));
	return p;
}

function NumAndDot(obj){
    console.log("键入的值: "+obj.value);
    obj.value = obj.value.replace(/[^\d.]/g,"");  //清除“数字”和“.”以外的字符

    obj.value = obj.value.replace(/^\./g,"");  //验证第一个字符是数字而不是.

    obj.value = obj.value.replace(/\.{2,}/g,"."); //只保留第一个. 清除多余的.

    obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");

}

function NumAndGang(obj){

    obj.value = obj.value.replace(/[^\d-]/g,"");  //清除“数字”和“-”以外的字符

    obj.value = obj.value.replace(/^-/g,"");  //验证第一个字符是数字而不是-

}

	
