$(function(){
	
    /**
     * 会员机构点击弹出
     */    
    $("#pj_sign_hyjg").on("click",function(){
    	
    	$("#jmrlx_select_div").fadeIn(200);    	
    })
    
    /**
     * 会员机构选择
     */
    $("input:radio[name='sshyjg']").change(function (){
		$("#BelongDLJGName").val($(this).attr("hyname"));
		$("#sshyjh_value_div").text($(this).attr("hyname"));
		
		$("#BelongDLJGGuid").val($(this).val());
    });
    
    //弹出会员机构选择完成
    $("#hyjg_sel_ok").on("click",function(){
    	
    	$("#jmrlx_select_div").fadeOut(200);
    });
    
    //关闭会员机构选择
    $("#hyjg_sel_cancel").on("click",function(){
    	$("#jmrlx_select_div").fadeOut(200);
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
}


