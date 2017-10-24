/**
 *
 * @param guid  projectGuid
 * @param systype   类别
 * @param bmguid 报名guid
 */
var p_guid, p_systype,p_bmguid,djs;

function bm_sub(isOpen,guid, systype, bmguid, zhuanRangType,baoming_status) {
	if (baoming_status==0){
		alert("该项目还未开始报名,无法查看!");
		return;
	}
	if (baoming_status==2){
		alert("该项目已结束报名,无法查看!");
		return;
	}
    if (bmguid && bmguid.length == 36) {
        window.location.href = "pj_sign_up_view?infoid=" + guid + "&type=" + systype + "&bmguid=" + bmguid + "&zhuanRangType=" + zhuanRangType;
    } else {
	    if("1"==isOpen && bmguid.length != 36 ){
	        p_guid = guid;
	        p_systype = systype;
	        p_bmguid=bmguid;
	        $.ajax({
	            type: "GET",
	            url: "getJMRProvisions?ProjectGuid="+guid+"&systemType="+systype,
	            dataType: "json",
	            success: function (data){
	                if (data.code==0){
	                	var result="";
	                	if (null !=data.data )
                            var result=data.data[0].JmrProvisions;
	                    $(".weui-dialog__bd").html(result);
	                    change(6);
	                    $("#dytk").show();
	                    var p = $("#btnAgree");
	                }else if (data.code==-100){
	                    $("#toast_div").html(data.msg);
	                    $("#loadingToast").show();
	                }else{
                        $("#toast_div").html(data);
                        $("#loadingToast").show();
					}
	            },
	            error: function (e) {
	                // $("#toast_div").html("无法获取竞买人条款");
	                // $("#loadingToast").show();
                    // console.log("ajax拦截信息: "+e.responseText);
                    alert('您没有登录或登录已超时,请重新登录.');
                    window.location.href='login';

                }
	        });
	    }else{
	    	p_guid = guid;
	        p_systype = systype;
	        p_bmguid=bmguid;
	    	agree();
	    }
    }
}

function agree() {
    window.location.href = "pj_sign_up?infoid=" + p_guid + "&type=" + p_systype + "&bmguid=" + p_bmguid;
}

function disagree() {
    clearTimeout(djs);
    $("#agree").html( '<a onclick="disagree()" class="weui-dialog__btn weui-dialog__btn_primary">不同意</a> <input type="submit"  value="同意" id="btnAgree" class="weui-dialog__btn weui-dialog__btn_primary">');
    $("#dytk").hide();
    $("#loadingToast").hide();
}

function change(secn) {
        var p = document.getElementById("btnAgree");
        secn--;
        p.value = "同意(" + secn + ")";
        if (secn == 0) {
            $("#agree").html( '<a onclick="disagree()" class="weui-dialog__btn weui-dialog__btn_primary">不同意</a><a onclick="agree()" class="weui-dialog__btn weui-dialog__btn_primary" >同意</a>');
        } else
            djs=setTimeout("change("+secn+")", 1000);
 }

