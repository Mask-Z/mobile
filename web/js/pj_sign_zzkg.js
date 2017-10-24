
$(function(){
    	
    	//个人所在地区
    	$("#szdq_geren").cityPicker({
            title: "所在地区",
            onChange: function(picker,values,displayValues){
                areaCode = values[2];
                areaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2]; 
                $("#AreaCode").val(areaCode);
                $("#AreaName").val(areaName);
            }
        });

    	/**
    	 * 是否原股东
    	 */
    	$("#hasPriority_box").click(function(){
    		//显示股东列表
    		$("#ygd_div").toggle();
    	});
    	
    	/**
    	 * 会员机构选择
    	 */
    	    $("input:radio[name='sshyjg']").change(function (){
    	    	
    			$("#BelongDLJGName").val($(this).attr("hyname"));
    			$("#sshyjh_value_div").text($(this).attr("hyname"));
    			
    			$("#BelongDLJGGuid").val($(this).val());
    	    });
    	    
    	    /**
    	     * 会员机构点击弹出
    	     */
    	    
    	    $("#pj_sign_hyjg").on("click",function(){
    	    	
    	    	$("#jmrlx_select_div").fadeIn(200);
    	    	
    	    })
    	    
    	    //弹出会员机构选择完成
    	    $("#hyjg_sel_ok").on("click",function(){
    	    	
    	    	$("#jmrlx_select_div").fadeOut(200);
    	    });
    	    //关闭会员机构选择
    	    $("#hyjg_sel_cancel").on("click",function(){
    	    	$("#jmrlx_select_div").fadeOut(200);
    	    });
    	    
    	    /**
    	     * 所有的下拉框初始化
    	     */
    	    $("select").each(function(i,o){
    	    	var cur = $(this);
    	    	var val = cur.attr("value"); 
    	    	cur.val($.trim(val));
    	    	
    	    });
    	    
    	    /**
    	     * 报表数据处理
    	     */
    	    $("input[name='sjly']").on("click",function(){
    	    	//
    	    	var val = "";
    	    	$("input[name='sjly']").each(function(i,o){
    	    		if($(this).prop("checked")){
    	    			val += $(this).val() + ";";
    	    		}
    	    	})
    	    	$("#JinQiZiChan").val(val);
    	    })
    	    
    	    /**
    	     * 原股东选择
    	     */
    	    $("#YuanCompanyGuDongXuHao_s").change(function(){
    	    	var txt = $(this).find("option:selected").text();
    	    	$("#YuanCompanyGuDong").val(txt);
    	    });

    	    /**
    	     * 
    	     */
    	    $("#HangYeType").change(function(){
    	    	$("#HangYeTypeCode").val($.trim($(this).val()));
    	    	var te = $('#HangYeType  option:selected').text();
    	    	$("#HangYeType_name").val(te);
    	    });
    	    
    	    var sjly = $("#JinQiZiChan").val();
    	    
    	    if(sjly && sjly!=""){
    	    	var arr = sjly.split(";");
    	    	var len = arr.length;
    	    	if(len==3){
    	    		$("input[name='sjly']").each(function(){
    	    			$(this).prop("checked",true);
    	    		})
    	    	}else if(len=2){
    	    		if(arr[0]==1){
    	    			$("#sj1").prop("checked",true);
    	    		} else if(arr[0]==0){
    	    			$("#sj2").prop("checked",true);
    	    		}
    	    	}
    	    }
    	    
    })