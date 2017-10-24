<!DOCTYPE html>
<html lang="en">

<head>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <jsp:include page="mate.jsp"></jsp:include>
	
	<link rel="stylesheet" type="text/css" href="m/weui/weui.css">
	<link rel="stylesheet" type="text/css" href="css/jquery-weui.css">
    
	<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
	<script type="text/javascript" src="js/jquery-weui.js"></script>
    <script type="text/javascript" src="m/js/DateOp.js"></script>

    <link rel="stylesheet" href="m/css/index.css">
	
  </head>
  
  <body>
  <style>
      .weui-cells .weui-cell-srf:nth-child(2n+2){background-color: #f5f5f5;}
  </style>
    <script type="text/javascript">
    var code = '${result.code}';
    if(code==='-2'){
    	alert("${result.msg}");
    	window.location.href = "pj_list_cqjy";
    }else if(code!='0'){
    	alert("系统错误,请联系管理员");
    	window.location.href = "pj_list_cqjy";
    }
	
    +function(a){
    	a.rawCitiesData = '${citys}';
    }($);


    $(function(){
        $("#area").cityPicker({
            title: "所在地区",
            onChange: function(picker,values,displayValues){
                areaCode = values[2];
                areaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2];
//                $("#area_code").val(areaCode);
//                $("#area_name").val(areaName);
                $("#AreaCode").val(areaCode);
                $("#AreaName").val(areaName);
            }
        });


        var endTime=Date.parse(new Date('${data.GongGaoToDate }'));
        function addEndTime() {
            var nowTime = new Date().getTime();
            if (nowTime>=endTime){
                $("#bmjzsj").html("报名已结束");
            }else{
                $("#bmjzsj").html(DateOp.formatMsToStr2(endTime-nowTime));
            }
        }
        addEndTime();
        setInterval(addEndTime,1000);

        //设置搜索结果高度
        var dHeight=document.documentElement?document.documentElement.clientHeight:document.body.clientHeight;//浏览器高度
        $("#searchResult").height(dHeight-120);

    	//股份 or 资本金
    	var zengzhitype = '${data.ZZKG_ZZType}';
    	
    	var $tooltips = $('#js_tooltips');
    	
    	
    	if("1"==="${data.hasPriority}"){
    		$("#hasPriority_box").prop("checked",true);
    		$("#ygd_div").show();
    	}

        /**
    	报名保存
        **/
	    $("#btn_save").click(function(){
	    	/**
	    	 * 是否原股东
	    	 */
	        if($("#hasPriority_box").prop("checked")){
	            $("#hasPriority").val(1);
	    	}else{
	    		$("#hasPriority").val(0);
	    	}	    	
	    	$("#IsJinChang").val(1);//默认进场
	    	/**
	    	 * 是否管理层
	    	 */
	    	if($("#IsManagerLayer_box").prop("checked")){
	    		$("#IsManagerLayer").val(1);
	    	}else{
	    		$("#IsManagerLayer").val(0);
	    	}


	    	var rs = true;

            var lxtel = $("#lianxidianhua").val();
            var lxr = $("#lianxiren").val();

            /**
             * 文件必须上传时验证
             * */
            var IsBMNeedFile='${data.IsBMNeedFile}';
            if (IsBMNeedFile === '1') {
                var filelist = '${filelist}';
                var json1 = JSON.parse(filelist);
                for (var i = 0; i < json1.length; i++) {
                    if (json1[i].IsMustNeed == "1" && $("#"+json1[i].FileCode).find("p").length==0) {
                        $tooltips.html(json1[i].FileName+"必须选择上传文件!");
                        rs = false;
                    }
                }
            }

            if (!isPhoneNo(lxtel)) {
                $tooltips.html("联系电话格式不正确!");
                rs = false;
            }

            if ($.trim(lxtel) === "") {
                $tooltips.html("联系电话不能为空!");
                rs = false;
            }

            if ($.trim(lxr) === "") {
                $tooltips.html("联系人不能为空!");
                rs = false;
            }


            var ntze = $.trim($("#input_InvestPriceLeft").val());
            if(ntze==""){
                $tooltips.html("拟投资额不能为空!");
                rs = false;
            }

            if (zengzhitype == 'BL') {
                var zbj = $.trim($("#input_InvestZiBen").val());
                if (zbj == "") {
                    $tooltips.html("拟认购资本金不能为空!");
                    rs = false;
                }
            }
            if (zengzhitype == 'GF') {
                var gfs = $.trim($("#input_InvestAmountLeft").val());
                if (gfs == "") {
                    $tooltips.html("拟认购股份数不能为空!");
                    rs = false;
                }
            }
            


            <c:if test="${user_type==1}">//个人
            var idcard=$('#idcard').val();
            if(!isCardNo(idcard)){
                $tooltips.html("身份证号码格式不正确!");
                rs = false;
            }

            if(idcard==''){
                $tooltips.html("证件号码不能为空!");
                rs = false;
            }
            </c:if>
            
            var ischecked=$("#hasPriority_box").prop("checked");//是否原股东
            
            var ygdmc = $("#YuanCompanyGuDongXuHao_s").find("option:selected").text();
            console.log('${data.YuanCompanyGuDongXuHao}');
	    	$("#YuanCompanyGuDong").val(ygdmc);//原股东名称赋值
            
            if(ischecked && ygdmc==""){
                $tooltips.html("原股东名称必填!");
                rs = false;
            }


            <c:if test="${user_type==0}">//单位
            var zhucedi=$("#zhucedi").val();//注册地
            var zhuceziben=$("#zhuceziben").val();//注册资本
            var val_sel_gslx = $.trim($("#sel_gslx").val());//公司类型(经济性质)
            
            if(val_sel_gslx==""){
                $tooltips.html("公司类型(经济性质)必填!");
                rs = false;
            }

            if (val_sel_gslx !== "A19003"){
            if (zhuceziben === '') {
                $tooltips.html("注册资本必填!");
                rs = false;
            }
            }

            if (zhucedi === '') {
                $tooltips.html("注册地必填!");
                rs = false;
            }

            </c:if>
            var diqu=$("#AreaCode").val();
            if (diqu === '' || diqu == '请选择') {
                $tooltips.html("所在地区必填!");
                rs = false;
            }

	    	if(!rs){
	    		$tooltips.css('display', 'block');
	            setTimeout(function () {
	                $tooltips.css('display', 'none');
	            }, 2000);
	            
	            return;
	    	}	    	
	    	var param = $("#zzkg_submit").serialize();
	    	
	    	$.ajax({
	       	    type: "POST",
	       	    url: "pj_sign_up_submit",
	       	    dataType:"json",
	       	    data: param,
	       	    success: function(msg){
	       	        if(msg){
	       	    	    if(msg.code==0){
	       	    		    $("#toast_div").text("数据提交中");
	       	    		    $('#loadingToast').fadeIn(100);
	       	    		    window.location.href = "pj_sign_up_view?infoid=${ProjectGuid}&type=ZZKG&bmguid=${data.RowGuid }";
	       	    	    }else {
	       	    	    	if(msg.code==-2){
	       	    	    		$tooltips.html(msg.msg);
	       	    	    		$tooltips.css('display', 'block');
		       	 	            setTimeout(function () {
		       	 	                $tooltips.css('display', 'none');
		       	 	            }, 2000);
	       	    	    	}else{
	       	    	    		alert("系统错误,请联系管理员!");
	       	    	    	}
	       	    		    $('#loadingToast').fadeIn(100);
	       	    	    }
	       	    	    $('#loadingToast').fadeOut(100);
	       	        }	       	  	    
	       	    },
	       	    error:function (XMLHttpRequest, textStatus, errorThrown){
	       	   		alert(errorThrown);
	       	    }
	       	});
	    })	   
	     
	    /**
		修改时附件加载
		**/
		if('${bmguid}'!=''){
			loadFile();
		}
		
		var $iosActionsheet = $('#iosActionsheet');
    	var $iosMask = $('#iosMask');

    	function hideActionSheet() {
        	$iosActionsheet.removeClass('weui-actionsheet_toggle');
        	$iosMask.fadeOut(200);
    	}

    	$iosMask.on('click', hideActionSheet);
    	$('#iosActionsheetCancel').on('click', hideActionSheet);
    	$("#union_div").on("click", ".ios_menu", function(){
        	$("#union_waiting_handle").val($(this).next().val());
        	$iosActionsheet.addClass('weui-actionsheet_toggle');
        	$iosMask.fadeIn(200);
    	});
    
        $("#union_delete").on("click", function(){
        	hideActionSheet();
        	var rowGuid = $("#union_waiting_handle").val();
        	$.ajax({
            	type: "POST",
       	    	url: "pj_gq_delUnion",
       	    	dataType:"json",
       	    	data: "rowGuid=" + rowGuid,
       	    	success: function(result){
       	        	if(result){
       	            	if(result.code==0){
       	    		    	$("#toast_div").text("删除成功"); 
       	    		        $('#loadingToast').fadeIn(100);			    		    
       	    		    	setUnionDiv($("#union_baoMing_guid").val());
       	    	    	}else{
       	    		    	$("#toast_div").text("删除失败"); 
       	    		        $('#loadingToast').fadeIn(100);	
       	    	    	}
       	    	    	$('#loadingToast').fadeOut(100);
       	        	}
       	    	},
       	    	error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   			alert(errorThrown); 
       	    	}
       		});        	        
    	});
    
    	$("#union_view").on("click", function(){
        	initUnionDialog("union_view");       	        
    	});
    
    	$("#union_edit").on("click", function(){
        	initUnionDialog("union_edit");       	        
    	});
    
    	function initUnionDialog(type){
        	hideActionSheet();
        	var rowGuid = $("#union_waiting_handle").val();
        	$.ajax({
            	type: "POST",
       	    	url: "pj_gq_getUnion",
       	    	dataType:"json",
       	    	data: "rowGuid=" + rowGuid,
       	    	success: function(result){
       	        	if(result){
       	            	$("#shouRang_name").val(result.ShouRangName);
       	            	$("#shouRangRen_type").val(result.ShouRangRenType);
       	            	$("#shouRang_percent").val(result.ShouRangPercent);
       	            	$("#shouRang_gufen").val(result.ShouRangGuFen);
       	            	$("#lianXi_name").val(result.LianXiName);
       	            	$("#lianXi_tel").val(result.LianXiTel);
       	            	$("#lianXi_email").val(result.LianXiEmail);
       	            	$("#lianXi_fax").val(result.LianXiFax);
       	            	$("#weiTuoDW_name").val(result.WeiTuoDWName);
       	            	$("#weiTuoDW_lianXiTel").val(result.WeiTuoDWLianXiTel);
       	            	$("#weiTuoHY_heShi").val(result.WeiTuoHYHeShi);
       	            	$("#weiTuoHY_No").val(result.WeiTuoHYNo);
       	            	$("#weiTuoHY_name").val(result.WeiTuoHYName);
       	            	$("#weiTuoHY_code").val(result.WeiTuoHYCode);
       	            	$("#weiTuoHY_lianXiName").val(result.WeiTuoHYLianXiName);
       	            	if(type == "union_view"){       	                
       	                	//查看时禁用所有输入并隐藏确定按钮
       	                	$("#union_select_div").find("*").each(function(){ 
       	                    	$(this).attr("disabled","disabled");
       	                	});
       	                	$("#btn_ok").hide();       	                       	                 
       	            	}
       	            	if(type == "union_edit"){
       	                	$("#union_row_guid").val(rowGuid);
       	                	//修改时启用所有输入并显示确定按钮
       	                	$("#union_select_div").find("*").each(function(){ 
       	                    	$(this).removeAttr("disabled"); 
       	                	});
       	                	$("#btn_ok").show(); 
       	                	$("#union_type").val("union_edit");      	                       	                 
       	            	}
       	            	$("#union_select_div").fadeIn(200);    	
       	        	}
       	    	},
       	    	error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   			alert(errorThrown);
       	    	}
       		}); 
    	}
    	
    	//新增联合受让方
    	$("#btn_add").on("click",function(){
            //重置表单数据
//            $("#pj_gq_addUnion").reset();
            document.getElementById("pj_gq_addUnion").reset();
            //新增时启用所有输入并显示确定按钮
       		$("#union_select_div").find("*").each(function(){ 
       	    	$(this).removeAttr("disabled"); 
       		});
       		$("#btn_ok").show();
       		$("#union_type").val("union_add");
    		$("#union_select_div").fadeIn(200);
    		$("#zzkg_submit").hide();
    		//设置默认投资方类型为法人
            var $shouRangRen_type=$("#shouRangRen_type");
            if ($.trim($shouRangRen_type.val())==""||$shouRangRen_type.val()==null){
                $shouRangRen_type.val('1');
            }
    	});
    	
    	$("#pj_sign_srf").on("click",function(){
            if($(this).attr("disabled") == "disabled"){
                return;
            }
            $("#shouRang_name").val('');
    	    $("#srf_select_div").fadeIn(200);
    	    $("#zzkg_submit").hide();
        });
    
        $("#srf_sel_ok").on("click",function(){
            $(".weui-srf").each(function(){ 
                if($(this).is(':checked')){
                    $("#shouRang_name").val($.trim($(this).next().next().next().val()));
                    $("#shouRang_guid").val($.trim($(this).next().next().val()));
//                }else{
//                    $("#shouRang_name").val('');
                }
            });
            if ($.trim($("#shouRang_name").val()) == ''){
                $("#shouRang_name").val($("#searchInput").val());
            }
    	    $("#srf_select_div").fadeOut(200);
            $("#zzkg_submit").show();
        });
    
        $("#srf_sel_cancel").on("click",function(){
    	    $("#srf_select_div").fadeOut(200);
            $("#zzkg_submit").show();
        });
    
        //新增/修改联合受让方保存
        $("#btn_ok").click(function(){
            if($.trim($("#shouRang_name").val())==""){
                $("#union_js_tooltips").html("投资方名称必填");
                $("#union_js_tooltips").css('display', 'block');
                setTimeout(function(){
                    $("#union_js_tooltips").css('display', 'none');
                }, 2000);
                return false;
            }
    	    var param = $("#pj_gq_addUnion").serialize();    	
    	    $.ajax({
                type: "POST",
       	        url: "pj_gq_addUnion_submit",
       	        dataType:"json",
       	        data: param,
       	        success: function(result){
       	            if(result){
       	                if(result.code==0){
       	                    $("#toast_div").text("操作成功");
       	    	            $('#loadingToast').fadeIn(100);
       	    		        setUnionDiv($("#union_baoMing_guid").val());
       	    		        $('#union_select_div').hide();
                            $("#zzkg_submit").show();
       	    	        }else{
       	    		        $("#toast_div").text("操作失败");
       	    	            $('#loadingToast').fadeIn(100);
       	    	        }
       	    	        $('#loadingToast').fadeOut(500);
       	            }
       	        },
       	        error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   		    alert(errorThrown);
       	        }
       	    });    	
        });
    
        //新增/修改联合受让方取消
        $("#btn_cancel").on("click",function(){    	    	
    	    $("#union_select_div").fadeOut(200);
            $("#zzkg_submit").show();
        });
    
        //动态展示当前报名的所有联合受让方
        function setUnionDiv(baoMingGuid){
            if(baoMingGuid != ''){
                $.ajax({
       	            type: "POST",
       	            url: "pj_gq_getUnionList",
       	            dataType:"json",
       	            data: "baoMingGuid=" + baoMingGuid,
       	            success: function(result){
       	                if(result.length>0){
       	                    $("#is_unionShouRang").val("1");
       	                }else{
       	                    $("#is_unionShouRang").val("0");
       	                }
       	                $("#union_div").empty();
       	                var innerHtml="";
//       	                $("#union_div").append("<div class='weui-cell'>"
//       	                                 + "<div class='weui-cell__hd'><label class='weui-label'>序号</label></div>"
//                                         + "<div class='weui-cell__hd'><label class='weui-label'>联合受让方名称</label></div>"
//                                         + "<div class='weui-cell__hd'><label class='weui-label'>投资方类型</label></div>"
//                                         + "</div>");
//       	                $("#union_div").append('   <table class="table" width="100%"> <tbody> <tr> <td height="30">序号</td> <td>联合受让方名称</td> <td>投资方类型</td> </tr>');
       	                innerHtml+=' <table class="table" width="100%"> <tbody> <tr> <td height="50" width="70" align="center">序号</td> <td>联合受让方名称</td> <td align="center"  width="120">投资方类型</td> </tr>';
       	            $.each(result,function(i,data){
//       	                var innerHtml = "<div class='weui-cell weui-cell_access ios_menu'>"
//                                      + "<div class='weui-cell__hd'><label class='weui-label'>" + (i+1) + "</label></div>"
//                                      + "<div class='weui-cell__hd'><label class='weui-label'>" + data.ShouRangName + "</label></div>"
//                                      + "<div class='weui-cell__hd'><label class='weui-label'>" + data.ShouRangRenType + "</label></div>"
//                                      + "<div class='weui-cell__ft' style='font-size: 0'><span></span></div>"
//                                      + "</div>"
//                                      + "<input type='hidden' value='" + data.RowGuid + "'>";
       	                innerHtml +=  '<tr class="ios_menu"> <td height="30" align="center" >'+(i+1)+'</td>'
                                        +'<td>'+data.ShouRangName+'</td>'
                                        +'<td align="center">'+data.ShouRangRenType+'</td></tr>'
                                        +'<input type="hidden" value="' + data.RowGuid + '">';
//       	                $("#union_div").append(innerHtml);
       	            });
                        $("#union_div").append(innerHtml+"</tbody></table>");
       	        },
       	        error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   		    alert(errorThrown); 
       	        }
       	    });
        }
    }

    var $searchBar = $('#searchBar'),
        $searchResult = $('#searchResult'),
        $searchText = $('#searchText'),
        $searchInput = $('#searchInput');

        function hideSearchResult(){
            $searchResult.hide();
            $searchInput.val('');
        }
        
        function cancelSearch(){
            hideSearchResult();
            $searchBar.removeClass('weui-search-bar_focusing');
            $searchText.show();
        }

        $searchText.on('click', function(){
            $searchBar.addClass('weui-search-bar_focusing');
            $searchInput.focus();
        });
        
        $searchInput.on('blur', function(){
            if(!this.value.length) cancelSearch();
        }).on('input', function(){
            if(this.value.length){
                $.ajax({
                   type: "POST",
       	           url: "get_srf_list",
       	           dataType: "json",
       	           data: "srfNameOrUnitCode="+$("#searchInput").val()+"&projectGuid=${ProjectGuid}&rowGuid="+$("#union_baoMing_guid").val()+"&type=0",
       	           success: function(result){
       	               $searchResult.empty();
       	               $searchResult.append('<div class="weui-cell-srf weui-check__label"><div class="weui-cell-srf" style="    width: 100%;    padding: 3px 0px;"><div class="weui-cell__hd"><label class="weui-label" style="font-weight: bold;">序号</label></div><div class="weui-cell__hd"><label class="weui-label" style="font-weight: bold;">组织机构代码</label></div>'
                           +'<div class="weui-cell__bd"><label class="weui-label" style="color: #353535;font-weight: bold;">竞买方</label></div><!--<div class="weui-cell__bd"><label class="weui-label">选择</label></div> --></div></div>');
       	               $.each(result,function(i,data){
       	                   var j=i+1;
       	                   var innerHtml = "<label class='weui-cell-srf weui-check__label' for='i" + i +"' style='text-align: left;font-size: 14px'>"
			                         + "<div class='weui-cell__bd'>"
			                         + "<div class='weui-cell-srf' style='padding: 3px 0px;'>"

                               + "<div class='weui-cell__hd'>"
                               + "<span class='weui-label' style='width: 28px;text-align: center;'>" + j + "</span>"
                               + "</div>"

        	                         + "<div class='weui-cell__hd'>"
        	                         + "<span class='weui-label'>" + data.UnitOrgNum + "</span>"
        	                         + "</div>"
                                     + "<div class='weui-cell__bd'>"
                                     + "<span class='weui-input'>" + data.DanWeiName + "</span>"
                                     + "</div>"
                                     + "</div>"
			                         + "</div>"
			                         + "<div class='weui-cell__ft'>"
			                         + "<input type='radio' class='weui-check weui-srf' name='radio1234' id='i" + i +"'>"
			                         + "<span class='weui-icon-checked'></span>"
			                         + "<input type='hidden' value='" + data.DanWeiGuid + "'>"
			                         + "<input type='hidden' value='" + data.DanWeiName + "'>"
			                         + "</div>"
			                         + "</label>";
       	                   $searchResult.append(innerHtml);
       	               });       	               
       	               $searchResult.show();       	           
       	           },
       	           error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   		       alert(errorThrown);
       	           }
       	        });                  
            }else{
                $searchResult.hide();
            }
        });
        
        //公司类型变更
        $("#sel_gslx").change(function(){
        	if('A19003'==$(this).val()){
        		$("#div_gbze").css("display","");
        		$("#div_zczb").css("display","none");
        	}else{
        		$("#div_gbze").css("display","none");
        		$("#div_zczb").css("display","");
        	}
        	
        })
        
        
    });

    var task_code = "CQJY_ZZKGBaoMing";
    /**
     * 附件加载
     */
    function loadFile(){
        $("#toast_div").text("加载中!");$('#loadingToast').fadeIn(100);
        var data = {};
        data.bmguid = "${data.RowGuid }";
        data.taskCode = task_code;
        $.ajax({
            url: "getFileList",
            type: "POST",
            data: data,
            success: function(res,status,xhr){
                try{
                    if(res && res.code==0){

                        var files = (res.data);
                        if(files.length==0){
                            $("div[name='init_files']").each(function(){
                                $(this).html("");
                            })
                        }else{
                            $("div[name='init_files']").each(function(){
                                $(this).html("");
                            });
                            for(var i=0;i<files.length;i++){
                                var code = files[i].type;
                                var list = files[i].fileList;
                                $("#"+code).html("");
                                for(var j=0;j<list.length;j++){
//                                    var html = "<p><span><a href=\"javascript:openfj('"+list[j].RowGuid+"')\">"+list[j].AttachFileName+"</a></span><a href=\"javascript:del('"+list[j].RowGuid+"');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a></p>";
//                                    $("#"+code).append(html);
                                    var html = "<p><span><a target='_blank' href=\""+list[j].url+"\">"+list[j].AttachFileName+"</a></span><a href=\"javascript:del('"+list[j].RowGuid+"');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a></p>";
                                    $("#"+code).append(html);
                                }
                            }
                        }
                    }
                    $('#loadingToast').fadeOut(100);
                }catch(e){
                    alert(e.toLocaleString());
                }
            }
        });
    }
    
    /**
		附件下载
     **/
    function openfj(guid){
        window.location.href = "${bm_file_download}"+guid;
    }    
    </script>
	<script type="text/javascript" src="js/city-picker.js"></script>
	<script type="text/javascript" src="js/pj_sign_zzkg.js"></script>
	
	<script type="text/javascript" src="js/bm.js"></script>


<header class="h43">
    <div class="index-header">
        <%--<a href="pj_list_cqjy" class="baoming"></a>--%>
        <a href="" class="back" onclick="window.history.back(-1);return false;"></a>
        <div class="title">项目报名</div>
    </div>
</header>

<form id="zzkg_submit">
<%
        Object obj = request.getAttribute("data");
    	String bbdate = "";
    	String cldate = "";
    	String areaName = "";
    	if(obj!=null){
    		Map map = (Map)obj;
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			SimpleDateFormat sdf_ = new SimpleDateFormat("yyyy-MM-dd");
    		
    			try{

    				if(map.containsKey("BaoBiaoDate")){
    					String bd = map.get("BaoBiaoDate").toString();
    					if(StringUtils.isNotBlank(bd)){
    						bbdate = sdf_.format(sdf.parse(bd));	
    					}
    					
    				}
    				
    				if(map.containsKey("ChengLiDate")){
    					String bd = map.get("ChengLiDate").toString();
    					if(StringUtils.isNotBlank(bd)){
    						cldate = sdf_.format(sdf.parse(bd));
    					}
    					
    				}
    				if(map.containsKey("AreaName")){
    					String bd = map.get("AreaName").toString();
    					
    					
    					if(bd.indexOf("·") < 0){
    						areaName = bd + " " + bd + " " + bd;
    					} else {
    						
    						areaName = bd.replace("·", " ");
    					}
    				}
    			}catch(Exception e){
					e.printStackTrace();
    			}
    		
    	}
        %>

<input type="hidden" name="bmguid" value="${bmguid}"><!-- 修改时,被修改的报名guid,新增时该值为空 -->
<input type="hidden" name="info['type']" value="ZZKG"><!-- 系统类别-->

<input type="hidden" name="info['RowGuid']" value="${data.RowGuid }"><!-- 报名唯一标识 -->
<input type="hidden" name="info['ProjectGuid']" value="${ProjectGuid}"><!-- 项目guid -->

<input type="hidden" name="info['BelongXiaQuCode']" value="${data.BelongXiaQuCode }"><!-- 所属地区 -->

<input type="hidden" name="info['XiaQuCode']" value="${data.XiaQuCode }"><!-- 机构代码 -->

<input type="hidden" name="info['DanWeiName']" value="${data.DanWeiName }"><!-- 单位名称 -->

<input type="hidden" name="info['IsGuoZi']" value="${data.IsGuoZi }"><!-- 是否国资 -->
<input type="hidden" name="info['FaRenType']" value="${data.FaRenType }"><!-- 法人类型 -->

<input type="hidden" name="info['AreaCode']" id="AreaCode" value="${data.AreaCode }"><!-- 地区编码 -->
<input type="hidden" name="info['AreaName']" id="AreaName" value="${data.AreaName }"><!-- 地区名称 -->

<input type="hidden" name="info['BiaoDiName']" value="${data.BiaoDiName }"><!-- 标的名称 -->
<input type="hidden" name="info['BiaoDiNo']" value="${data.BiaoDiNo }"><!-- 标的编号 -->

<input type="hidden" name="info['BelongAreaCode']" value="${data.BelongAreaCode }"><!-- 所属地区代码 -->

<input type="hidden" name="info['DanWeiXingZhi']" value="${data.DanWeiXingZhi }"><!-- 单位性质 -->
<input type="hidden" name="info['YingYeZhiZhaoNo']" value="${data.YingYeZhiZhaoNo }"><!-- 营业执照号码 -->
<input type="hidden" name="info['JiaoNaBZJ']" value="${data.JiaoNaBZJ }"><!-- 保证金金额 -->
<input type="hidden" name="info['BZJIsjiaoNa']" value="${data.BZJIsjiaoNa }"><!-- 保证金是否缴纳 -->
<input type="hidden" name="info['JiaoNaEndDate']" value="${data.JiaoNaEndDate }"><!-- 保证金缴纳截至日期 -->
<input type="hidden" name="info['BelongDLJGGuid']" value="${data.BelongDLJGGuid }" id="BelongDLJGGuid"><!-- 机构guid委托会员) -->
<input type="hidden" name="info['BelongDLJGName']" value="${data.BelongDLJGName }" id="BelongDLJGName"><!-- 机构名称(委托会员) -->

<input type="hidden" name="info['IsUnionShouRang']" id="is_unionShouRang" value="${data.IsUnionShouRang }"><!-- 是否联合受让 -->

<input type="hidden" name="info['YuanCompanyGuDong']" id="YuanCompanyGuDong" value="${data.YuanCompanyGuDong }"><!-- 原股东名称 -->



<input type="hidden" name="info['FaRen_13003']" value="${data.FaRen_13003 }"><!-- 法定代表人 -->

<input type="hidden" name="info['HangYeTypeCode']" id="HangYeTypeCode" value="${data.HangYeTypeCode }"><!-- 所属行业代码 -->

<input type="hidden" name="info['HangYeType']" id="HangYeType_name" value="${data.HangYeType }"><!-- 所属行业代码 -->

<input type="hidden" name="info['JinQiZiChan']" id="JinQiZiChan" value="${data.JinQiZiChan }"><!-- 数据来源 -->

<input type="hidden" name="info['UserID']" value="${data.UserID }"><!-- 法人身份证号码 -->

<input name="info['hasPriority']" id="hasPriority" type="hidden" value="${data.hasPriority}"><!-- 是否标的公司原股东 -->
<input name="info['IsJinChang']" id="IsJinChang" type="hidden" value="${data.IsJinChang }"><!-- 是否进场 -->
<input name="info['IsManagerLayer']" id="IsManagerLayer" type="hidden" value="${data.IsManagerLayer }"><!-- 是否管理层 -->

<div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="js_tooltips"></div>

<div class="weui-cells weui-cells_form no-mt">
	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">标的编号</label></div>
        <div class="weui-cell__bd">${data.ProjectNo_3001 }
        </div>
    </div>
    
    <div class="weui-cell ">
        <div class="weui-cell__hd"><label class="weui-label">标的名称</label></div>
        <div class="weui-cell__bd">${data.ProjectName_3001 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">业务类别</label></div>
        <div class="weui-cell__bd">${data.CQYWType_3001_name }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">产权类型</label></div>
        <div class="weui-cell__bd">增资扩股
        </div>
    </div>
    <div class="weui-cell">
        <c:if test="${data.ZZKG_GuaPaiType eq '0'}">
            <div class="weui-cell__hd"><label class="weui-label">挂牌单价 </label></div>
            <div class="weui-cell__bd" style="color: red">
                <fmt:formatNumber type="number" value="${data.GuaPaiPrice }" pattern="0.00" maxFractionDigits="2"/> 元
            </div>
        </c:if>
        <c:if test="${data.ZZKG_GuaPaiType eq '1'}">
            <div class="weui-cell__hd"><label class="weui-label">挂牌总价 </label></div>
            <div class="weui-cell__bd" style="color: red">
                <fmt:formatNumber type="number" value="${data.ZZKG_GuaPaiTotalPrice }" pattern="0.000000" maxFractionDigits="6"/> 万元
            </div>
        </c:if>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">报名截止时间</label></div>
        <div class="weui-cell__bd" >
            ${data.GongGaoToDate}
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">距离报名截止时间</label></div>
        <div class="weui-cell__bd" id="bmjzsj">
        </div>
    </div>


    <div class="weui-btn-area">
        <%--<a class="weui-btn weui-btn_primary" href="infodetail?infoid=${ProjectGuid}" >查看网站公告原文</a>--%>
        <a class="weui-btn weui-btn_primary" href="infodetail?${fn:split(data.GongGaoUrl,'?')[1]}" >查看网站公告原文</a>
    </div>
	<div class="weui-cells__title">基本情况</div>
	
	<c:if test="${user_type==1 }">
	<!-- 个人会员信息  begin -->
	
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">会员类型</label></div>
        <div class="weui-cell__bd"><c:if test="${data.FaRenType==2}">自然人</c:if><c:if test="${data.FaRenType==1}">企事业单位</c:if>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">投资方名称</label></div>
        <div class="weui-cell__bd">${data.DanWeiName }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">所在地区<font color="red">(*)</font></label></div>
        
        <div class="weui-cell__bd">
            <input class="weui-input" id="area" type="text" value="${data.AreaName.replace("·"," ")}" >
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">证件名称</label></div>
        <div class="weui-cell__bd"><input class="weui-input" name="info['ZhengName']" value="${data.ZhengName }"> 
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">证件号码<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><input class="weui-input" name="info['ZhengNo']" value="${data.ZhengNo }" id="idcard">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">工作单位</label></div>
        <div class="weui-cell__bd"><input class="weui-input" placeholder="请输入工作单位" name="info['GongZuoDanWei']" value="${data.GongZuoDanWei }">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">职务</label></div>
        <div class="weui-cell__bd"><input class="weui-input" placeholder="请输入职务" name="info['ZhiWu']" value="${data.ZhiWu }">
        </div>
    </div>
    
    
    
    <div class="weui-cell weui-cell_select weui-cell_select-after">
        <div class="weui-cell__hd"><label class="weui-label">资金来源</label></div>
        <div class="weui-cell__bd">
        <select class="weui-select" name="info['ZiJinLaiYuan']" value="${data.ZiJinLaiYuan}" >
        <c:forEach items="${zjly }" var="ly">
        <option value="${ly.code }">${ly.value }</option>
        </c:forEach> 
		</select>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">个人资产申报</label></div>
        <div class="weui-cell__bd">
        <textarea class="weui-textarea" placeholder="请输入个人资产申报" rows="3" name="info['GeRenZiChan']">${data.GeRenZiChan }</textarea>
        
        </div>
    </div>
    
    
    
    <!-- 个人会员信息 end -->
	</c:if>
	
	<%--${data.IsGuoZi_13003}_________________--%>
	<%--${data.IsGuoZi}_________________--%>
	
	<c:if test="${user_type==0 }">

	<!-- 单位信息  begin -->


	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">类型</label></div>
        <div class="weui-cell__bd">
        <c:if test="${data.IsGuoZi=='F' }">非国资</c:if>
        <c:if test="${data.IsGuoZi=='T' }">国资</c:if>
        </div>
    </div>
    
	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">会员类型</label></div>
        <div class="weui-cell__bd"><c:if test="${data.FaRenType==2}">自然人</c:if><c:if test="${data.FaRenType==1}">企事业单位</c:if>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">投资方名称</label></div>
        <div class="weui-cell__bd">${data.DanWeiName }
        </div>
    </div>
    
    <div class="weui-cell weui-cell_select">
        <div class="weui-cell__hd"><label class="weui-label">所在地区<font color="red">(*)</font></label></div>
        <%--<div class="weui-cell__bd" ><input class="weui-input" style="height: 40px" id="szdq_geren" type="text" value="<%=areaName%>">--%>
        <%--</div>--%>
        <div class="weui-cell__bd">
            <input class="weui-input" id="area" type="text" value="${data.AreaName }" >
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">注册地<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><input type="text" id="zhucedi" class="weui-input" name="info['ZhuCeDi']" value="${data.ZhuCeDi }"><!-- 注册地 -->
        </div>
    </div>
    
    <div class="weui-cell" id="div_zczb">
        <div class="weui-cell__hd"><label class="weui-label">注册资本(万元)<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><input type="zb" class="weui-input " name="info['ZhuCeZiBen']" id="zhuceziben" value="${data.ZhuCeZiBen }" ><!-- 注册资本 -->
        </div>
    </div>
    
    <div class="weui-cell" id="div_gbze" style="display: none"><!--  -->
        <div class="weui-cell__hd"><label class="weui-label">股本总额(万元)<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><input type="zb" class="weui-input " name="info['TotalStockCapital']" value="${data.totalStockCapital }" ><!-- 股本总额(万元) -->
        </div>
    </div>
    
    <div class="weui-cell weui-cell_select weui-cell_select-after">
        <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
        <div class="weui-cell__bd">
            <select class="weui-select" name="info['BiZhong']" id="zczb_bizhong">
                <c:forEach items="${bz_list}" var="biZhong" varStatus="bz">
                    <option value="${biZhong.code}" >${biZhong.value}</option>
                </c:forEach>
            </select>
        </div>
    </div>
	
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">成立时间</label></div>
        <div class="weui-cell__bd"><input class="weui-input" type="date" name="info['ChengLiDate']" value="<%=cldate %>"><!-- 成立时间 -->
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">法定代表人</label></div>
        <div class="weui-cell__bd"><input type="text" class="weui-input" name="info['FaRen_3008']" value="${data.FaRen_13003 }"><!-- 法定代表人 -->
        </div>
    </div>
    
    <div class="weui-cell weui-cell_select weui-cell_select-after">
        <div class="weui-cell__hd"><label class="weui-label">所属行业<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
        <select class="weui-select"  id="HangYeType" value='${data.HangYeTypeCode }'><!-- 所属行业 -->
	        <c:forEach items="${sshy}" var="biZhong">
	            <option value="${biZhong.code}">${biZhong.value}</option>
	        </c:forEach>
        </select>
        </div>
    </div>
    
    <div class="weui-cell weui-cell_select weui-cell_select-after">
        <div class="weui-cell__hd"><label class="weui-label">公司类型(经济性质)<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
        <select class="weui-select" name="info['CompanyLeiXing']" id="sel_gslx"><!-- 公司类型 -->
	        <c:forEach items="${companyTypes}" var="biZhong">
	            <option value="${biZhong.code}">${biZhong.value}</option>
	        </c:forEach>
        </select>
        </div>
    </div>
    
    <div class="weui-cell weui-cell_select weui-cell_select-after">
        <div class="weui-cell__hd"><label class="weui-label">企业性质(经济类型)<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
        
        <select class="weui-select" name="info['CompanyXingZhi']" value=${data.CompanyXingZhi }><!-- 企业性质 -->
	        <c:forEach items="${qyxz}" var="biZhong">
	            <option value="${biZhong.code}">${biZhong.value}</option>
	        </c:forEach>
        </select>
        
        </div>
    </div>
    
    <div class="weui-cell weui-cell_select weui-cell_select-after">
        <div class="weui-cell__hd"><label class="weui-label">经济规模<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
        
        <select class="weui-select" name="info['GuiMo']" id="info_guimo" ><!-- 经济规模 -->
	        <c:forEach items="${jjgm_jmr}" var="biZhong">
	            <option value="${biZhong.code}">${biZhong.value}</option>
	        </c:forEach>
        </select>
        
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
        <div class="weui-cell__bd">
        <input type="text" class="weui-input" name="info['UnitOrgNum']" value="${data.UnitOrgNum }"><!-- 组织机构代码 -->
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经营范围</label></div>
        <div class="weui-cell__bd">
        <input type="text" class="weui-input" name="info['JingYingFanWei']" value="${data.JingYingFanWei }"><!-- 经营范围 -->
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">受让资格陈述</label></div>
        <div class="weui-cell__bd">
        <textarea class="weui-textarea" name="info['ShouRangZiGe']" rows="3">${data.ShouRangZiGe}</textarea><!-- 受让资格陈述 -->
        </div>
    </div>
    
    
    <div class="weui-cells__tips">近期资产情况</div>
    <div class="weui-cells__title">数据来源</div>
    <div class="weui-cells weui-cells_checkbox">
       <label class="weui-cell weui-check__label" for="sj1">
           <div class="weui-cell__hd">
               <input type="checkbox" class="weui-check" name="sjly" value="1" id="sj1"/>
               <i class="weui-icon-checked"></i>
           </div>
           <div class="weui-cell__bd">
               <p>财务报表</p>
           </div>
       </label>
       <label class="weui-cell weui-check__label" for="sj2">
           <div class="weui-cell__hd">
               <input type="checkbox" class="weui-check" name="sjly" value="0" id="sj2"/>
               <i class="weui-icon-checked"></i>
           </div>
           <div class="weui-cell__bd">
               <p> 审计报告</p>
           </div>
        </label>
    </div>


    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">报表日期</label></div>
        <div class="weui-cell__bd">
        
        <input class="weui-input" type="date" name="info['BaoBiaoDate']" value="<%=bbdate%>"><!-- 报表日期  -->
        </div>
    </div>
    
    <div class="weui-cell weui-cell_select weui-cell_select-after">
        <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
        <div class="weui-cell__bd">
        <select class="weui-select" name="info['MoneyType']" id="info_MoneyType"><!-- 币种(近期资产) -->
                <c:forEach items="${bz_list}" var="biZhong">
                    <option value="${biZhong.code}">${biZhong.value}</option>
                </c:forEach>
        </select>
            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">资产总计(万元)</label></div>
        <div class="weui-cell__bd">
        <input type="zb" class="weui-input" name="info['ZiChanTotal']" value="${data.ZiChanTotal }"><!-- 资产总计(万元) -->
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">负债总计(万元)</label></div>
        <div class="weui-cell__bd">
        <input type="zb" class="weui-input" name="info['FuZhaiTotal']" value="${data.FuZhaiTotal }"><!-- 负债总计(万元) -->
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">净资产(万元)</label></div>
        <div class="weui-cell__bd">
        <input type="zb" class="weui-input" name="info['JingZiChan']" value="${data.JingZiChan }"><!--净资产(万元) -->
        </div>
    </div>
    
    <!-- 单位信息 end -->
	</c:if>
	
	<div class="weui-cell weui-cell_switch">
	    <div class="weui-cell__bd">是否标的公司原股东<font color="red">(*)</font></div>
	    <div class="weui-cell__ft">
	        <input class="weui-switch" id="hasPriority_box"  type="checkbox" value="${data.hasPriority }" >
	    </div>
	</div>
	
	
	<div class="weui-cell weui-cell_select weui-cell_select-after" id="ygd_div"  style="display: none" >
        <div class="weui-cell__hd"><label class="weui-label">原股东名称<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
            <select class="weui-select" name="info['YuanCompanyGuDongXuHao']" id="YuanCompanyGuDongXuHao_s" autocomplete="off">
                <c:forEach items="${gdList}" var="ly">
                    <option value="${ly.code}"   >${ly.value}</option>
                </c:forEach>
            </select>
        </div>

    </div>
    
    <div class="weui-cell weui-cell_switch">
	    <div class="weui-cell__bd">是否进场<font color="red">(*)</font></div>
	    <div class="weui-cell__ft">
	        <input class="weui-switch" id="IsJinChang_box" disabled="disabled" <c:if test="${data.IsJinChang==1 }"></c:if> checked=true type="checkbox">
	    </div>
	</div>
    
    <div class="weui-cells__title">投资意向</div>
    <div class="weui-cell weui-cell_switch">
        <div class="weui-cell__hd"><label class="weui-label">是否是增资企业管理层、员工或其出资企业 </label></div>
        <div class="weui-cell__bd">
         <div class="weui-cell__ft">
	        <input class="weui-switch" id="IsManagerLayer_box" <c:if test="${data.IsManagerLayer==1 }">checked=true</c:if> type="checkbox"><!-- 是否管理层 -->
	    </div>
        </div>
    </div>
    <c:if test="${data.ZZKG_ZZType=='GF' }"><!-- 增资方式-按股份 -->
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">拟认购股份数(万股)<font color="red">(*)</font> </label></div>
        <div class="weui-cell__bd"><input class="weui-input" id="input_InvestAmountLeft" name="info['InvestAmountLeft']" value="${data.InvestAmountLeft }">
        </div>
    </div>
    </c:if>
    <!-- 股份end -->
	<c:if test="${data.ZZKG_ZZType=='BL' }"><!-- 增资方式-按元 -->
	
	
	<script type="text/javascript">
	$(function(){
	
		var zczb = parseFloat('${data.ZZKG_OrgZhuCeZiBen}');
		var zczb_l = parseFloat('${data.ZZKG_NiAddZhuCeZiBenLeft}');
		var zczb_r = parseFloat('${data.ZZKG_NiAddZhuCeZiBenRight}');
		$("#input_InvestZiBen").blur(function(){
			var ntz = parseFloat($("#input_InvestZiBen").val());
//			if (null == ntz || NaN == ntz || '' == ntz ){
//			    ntz=0;
//            }
//            console.log(typeof ntz+"  :"+ntz);
			if(ntz){
				$("#tz_r").val((ntz/(zczb+zczb_l)*100).toFixed(4));
				$("#tz_l").val((ntz/(zczb+zczb_r)*100).toFixed(4));
			}else{
                $("#tz_r").val('0.0000');
                $("#tz_l").val('0.0000');
            }
			
			
		})
	})	
	</script>
	
	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">拟认购资本金(万元) <font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><input type="zb" id="input_InvestZiBen" class="weui-input" name="info['InvestZiBen']" value="${data.InvestZiBen }" placeholder="请输入拟认购资本金">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">拟投资比例（%）  </label></div>
        <div class="weui-cell__bd">
        <input class="weui-input" id = "tz_l" readonly name="info['InvestPercentLeft']" value="${data.InvestPercentLeft }">
        <input class="weui-input" id = "tz_r" readonly name="info['InvestPercentRight']" value="${data.InvestPercentRight }">
    	</div>
    </div>
    
    </c:if>
    <!-- 按元end -->
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">拟投资额(万元)<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><input type="zb" class="weui-input" id="input_InvestPriceLeft" name="info['InvestPriceLeft']" value="${data.InvestPriceLeft }" placeholder="请输入拟投资额">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">投资意向备注说明 </label></div>
        <div class="weui-cell__bd">
        <textarea class="weui-textarea" placeholder="请输入文本" rows="3" name="info['InvestRemark']">${data.InvestRemark }</textarea>
        </div>
    </div>
    
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><input class="weui-input" id="lianxiren" name="info['LianXiUser']" value="${data.LianXiUser }" placeholder="请输入联系人">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系电话<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><input class="weui-input"  id="lianxidianhua" type="number" name="info['LianXiTel']" value="${data.LianXiTel }" placeholder="请输入联系电话">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">电子邮箱</label></div>
        <div class="weui-cell__bd"><input class="weui-input" name="info['Email']" value="${data.Email }" placeholder="请输入电子邮箱">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">传真号码</label></div>
        <div class="weui-cell__bd"><input class="weui-input" name="info['ChuanZhen']" value="${data.ChuanZhen }" placeholder="请输入传真号码">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">资信证明</label></div>
        <div class="weui-cell__bd">
        <input class="weui-input" name="info['ZiXinZhengMing']" value="${data.ZiXinZhengMing }" readonly="readonly">
        </div>
    </div>
    
    <div class="weui-cells__title">委托会员</div>
    <div class="weui-cell weui-cell_access" id="pj_sign_hyjg">
        <div class="weui-cell__hd"><label class="weui-label">机构名称</label></div>
        <div class="weui-cell__bd" id="sshyjh_value_div">
        ${data.BelongDLJGName }
        </div>
        <div class="weui-cell__ft" style="font-size: 0">
			<span></span>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">工位号</label></div>
        <div class="weui-cell__bd"><input class="weui-input" name="info['GongWeiNo']" value="${data.GongWeiNo }" placeholder="请输入工位号">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经纪人</label></div>
        <div class="weui-cell__bd"><input class="weui-input" name="info['JingJiRen']" value="${data.JingJiRen }" placeholder="请输入经纪人">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经纪人编码</label></div>
        <div class="weui-cell__bd"><input class="weui-input" name="info['JingJiRenCode']" value="${data.JingJiRenCode }" placeholder="请输入经纪人编码">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人</label></div>
        <div class="weui-cell__bd"><input class="weui-input" name="info['LianXiRen']" value="${data.LianXiRen }" placeholder="请输入联系人">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系电话</label></div>
        <div class="weui-cell__bd"><input class="weui-input" type="number" name="info['JGLianXiTel']" value="${data.JGLianXiTel }" placeholder="请输入联系电话">
        </div>
    </div>
</div>

    <div class="weui-cells__title">联合投资方</div>
    <div class="weui-cells" id="union_div">
            <table class="table" width="100%">
                <tbody>
                <tr>
                    <td height="50" width="70" align="center">序号</td>
                    <td>联合受让方名称</td>
                    <td align="center"  width="120" >投资方类型</td>
                </tr>
                <c:forEach items="${data.unionList}" var="union" varStatus="vs">
                    <tr class="ios_menu" >
                        <td height="30" align="center">${vs.index+1 }</td>
                        <td>${union.ShouRangName}</td>
                        <td align="center">${union.ShouRangRenType }</td>
                    </tr>
                    <input type="hidden" value="${union.RowGuid}">
                </c:forEach>
                </tbody>
            </table>
    </div>
    <div class="weui-btn-area">
        <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_add">新增联合投资方</a>
    </div>    
    <input type="hidden" id="union_waiting_handle" value=""> 
    
    <!-- file start -->
    <div class="weui-cells__title">相关附件</div>
    
    <c:forEach items="${filelist}" var="file">
   <div class="weui-cells">
    <div class="weui-cell weui-cell_vcode">
        <div class="weui-cell__hd">
            <label class="weui-label">${file.FileName}<c:if test="${file.IsMustNeed eq '1' and data.IsBMNeedFile eq '1' }"><font color="red">(*)</font></c:if></label>
        </div>
        <div class="weui-cell__bd" name="init_files" id="${file.FileCode}" need="${file.IsMustNeed}">
        
        
        </div>
        <div class="weui-cell__ft">
            <a class="weui-vcode-btn" name="file_div" code="${file.FileCode}">文件管理</a>
        </div>
    </div>
    </div>
    </c:forEach>
    
    <!-- file end -->
    
    </form>
    
<div class="weui-btn-area">
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_save">确定</a>
</div>

<!--新增联合投资方dialog start-->
<div class="js_dialog" id="union_select_div" style="display: none;">
<div class="weui-mask"></div>
<div class="weui-dialog_srf" style="overflow-y:scroll;">
<div class="weui-dialog__hd_srf" style="height: 30px;background: #f1f1f1;border-bottom: 1px #e6e6e6 solid;
    line-height: 30px; "><strong class="weui-dialog__title">新增联合投资方</strong></div>
<div class="weui-dialog__bd_srf">   
<form id="pj_gq_addUnion">

<input type="hidden" id="union_baoMing_guid" name="info['baoMingGuid']" value="${data.RowGuid }"><!-- 联合投资方报名统一标识 -->
<input type="hidden" id="shouRang_guid" name="info['shouRangGuid']" value="">
<input type="hidden" id="union_row_guid" name="info['rowGuid']" value=""><!-- 联合投资方唯一标识 -->
<input type="hidden" name="info['zhuanRangType']" value="${data.ZhuanRangType }"><!-- 转让方式 -->
<input type="hidden" name="info['unionType']" id="union_type" value=""><!-- 转让方式 -->
<%--<input type="hidden"  id="area_code" value="">--%>
<%--<input type="hidden"  id="area_name" value="">--%>

<div class="weui-toptips weui-toptips_warn js_tooltips" id="union_js_tooltips"></div>
<div class="weui-cells weui-cells_form no-mt">    
    <div class="weui-cell weui-cell_access" id="pj_sign_srf">
        <div class="weui-cell__hd"><label class="weui-label">投资方名称<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['shouRangName']" type="text" id="shouRang_name" value="" onfocus="this.blur()"/>
        </div>
        <div class="weui-cell__ft" style="font-size: 0">
			<span></span>
        </div>
    </div>
    
    <div class="weui-cell weui-cell_select weui-cell_select-after">
        <div class="weui-cell__hd"><label class="weui-label">投资方类型</label></div>
        <div class="weui-cell__bd">
            <select class="weui-select" name="info['shouRangRenType']" id="shouRangRen_type" >
                <option value="1">法人</option>
                <option value="2">自然人</option>
            </select>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人姓名</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['lianXiName']" type="text" id="lianXi_name" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人电话</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['lianXiTel']" type="text" id="lianXi_tel" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人邮件</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['lianXiEmail']" type="text" id="lianXi_email" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人传真</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['lianXiFax']" type="text" id="lianXi_fax" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员单位名称</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoDWName']" type="text" id="weiTuoDW_name" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员联系人电话</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoDWLianXiTel']" type="text" id="weiTuoDW_lianXiTel" value=""/>
        </div>
    </div>
    
    <div class="weui-cells__tips">委托会员核实意见</div>
    <div class="weui-cell">
        <div class="weui-cell__bd">
            <textarea class="weui-textarea" name="info['weiTuoHYHeShi']" id="weiTuoHY_heShi" rows="3"></textarea>
        </div>
    </div>   
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员工位号</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoHYNo']" type="text" id="weiTuoHY_No" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员经纪人</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoHYName']" type="text" id="weiTuoHY_name" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员经纪人编码</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoHYCode']" type="text" id="weiTuoHY_code" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员联系人</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoHYLianXiName']" type="text" id="weiTuoHY_lianXiName" value=""/>
        </div>
    </div>    
</div>
</form>
</div>
<div class="weui-btn-area clearfix">
 <a class="weui-btn weui-btn_default" href="javascript:" id="btn_cancel">取消</a>   
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_ok">确定</a>    
    
</div>
</div>
</div>
<!--新增联合投资方dialog end-->

<!--竞买人查询dialog start-->
<div class="js_dialog" id="srf_select_div" style="display: none;">
    <div class="weui-dialog_srf" id="autodiv">
        <%--<div class="weui-dialog__bd" style="height: 400px;overflow-y:scroll;padding:0px;" id="autodiv">--%>
        <div class="weui-dialog__bd" style="padding:0px;" >
            <div class="weui-search-bar" id="searchBar">
                <div class="weui-cell__hd" style="padding:5px 5px;">投资方</div>
                <form class="weui-search-bar__form">
                    <div class="weui-search-bar__box">
                        <input type="search" class="weui-search-bar__input" id="searchInput" placeholder="输入投资方名称搜索" required=""  autofocus >
                    </div>
                    <label class="weui-search-bar__label" id="searchText" style="transform-origin: 0px 0px 0px; opacity: 1; transform: scale(1, 1);    line-height: 25px;">
                        <i class="weui-icon-search"></i>
                        <span>搜索</span>
                    </label>
                </form>
            </div>
            <div class="weui-cells searchbar-result weui-cells_radio" id="searchResult" style="transform-origin: 0px 0px 0px; opacity: 1; transform: scale(1, 1); display: none;overflow-y: scroll;">

            </div>
        </div>
        <div class="weui-btn-area">
        
            <a class="weui-btn weui-btn_default" href="javascript:" id="srf_sel_cancel">取消</a> 
            <a class="weui-btn weui-btn_primary" href="javascript:" id="srf_sel_ok">确定</a>       
        </div>
    </div>
</div>
<!--竞买人查询dialog end-->

<!-- 所属会员机构 -->
<div class="js_dialog" id="jmrlx_select_div" style="display: none;height: 400px;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
        <div class="weui-dialog__hd" style="height: 30px"><strong class="weui-dialog__title" >所属会员机构</strong></div>
        <div class="weui-dialog__bd" style="height: 330px;overflow-y:scroll;">
        	<div class="weui-cells weui-cells_radio">
			    <c:forEach items="${sshyjg }" var="hyjg" varStatus="jg">
			    <label class="weui-cell weui-check__label" for="x${jg.index }" style="text-align: left;font-size: 14px">
			        <div class="weui-cell__bd">
			            <p>${hyjg.name }</p>
			        </div>
			        <div class="weui-cell__ft">
			            <input type="radio" class="weui-check" hyname="${hyjg.name }" value="${hyjg.guid }" name="sshyjg" id="x${jg.index }">
			            <span class="weui-icon-checked"></span>
			        </div>
			    </label>
				</c:forEach>
			</div>
        </div>
        <div class="weui-dialog__ft">
            <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary" id="hyjg_sel_ok">确定</a>
        </div>
    </div>
</div>

<!-- 附件管理 -->
<div class="js_dialog" id="file_select_div" style="display: none;height: 400px;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
        <div class="weui-dialog__hd" style="height:30px"><strong class="weui-dialog__title" id="file_div_title"></strong></div>
        	<div class="weui-uploader__bd">
				<div class="weui-uploader__input-box">
					<form id="upform">
					<input name="fileCode" id="fileCode" type="hidden">
					<input name="rowGuid" type="hidden" value="${data.RowGuid }">
					<input id="uploaderInput" name="file" class="weui-uploader__input" type="file" accept="*" multiple/>
					</form>
				</div>
			</div>

        <div class="weui-dialog__ft">
	        <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_default" id="close_file_btn">关闭</a>
	        <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary" id="submit_file_btn">上传</a>
        </div>
        
    </div>
</div>
    

    

        <div class="weui-mask" id="iosMask" style="display: none">
        <div class="weui-actionsheet" id="iosActionsheet">
            <div class="weui-actionsheet__menu">
                <div class="weui-actionsheet__cell" id="union_view">查看</div>
                <div class="weui-actionsheet__cell" id="union_edit">修改</div>
                <div class="weui-actionsheet__cell" id="union_delete">删除</div>
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="iosActionsheetCancel">取消</div>
            </div>
        </div>
        </div>
    
    <!-- loading -->
    <div id="loadingToast" style="display:none;z-index: 10000">
        <div class="weui-mask_transparent"></div>
        <div class="weui-toast">
            <i class="weui-loading weui-icon_toast"></i>
            <p class="weui-toast__content" id="toast_div">数据加载中</p>
        </div>
    </div>

<script type="text/javascript">
$(function(){
	//币种默认值处理
    var bi = '${data.BiZhong}';
    if(bi == ''){
    	$("#zczb_bizhong option:first").prop("selected",true);

    } else {
    	$("#zczb_bizhong").val(bi);
    }
    
    var gm = '${data.GuiMo}';
    if(gm == ''){
    	$("#info_guimo option:first").prop("selected",true);

    } else {
    	$("#info_guimo").val(gm);
    }
    
    var mt = '${data.MoneyType}';
    if(mt == ''){
    	$("#info_MoneyType option:first").prop("selected",true);

    } else {
    	$("#info_MoneyType").val(gm);
    }

    var gdmc='${data.YuanCompanyGuDongXuHao}';
    if (gdmc == ''){
        $("#YuanCompanyGuDongXuHao_s option:first").prop("selected",true);
    }else{
        $("#YuanCompanyGuDongXuHao_s").val(gdmc);
    }
    var gslx = '${data.CompanyLeiXing}';
    console.log(gslx.indexOf('A'));
    if(gslx == ''|| gslx.indexOf('A')!=0){
    	$("#sel_gslx option:first").prop("selected",true);//值无法匹配,所以默认选中第一个
    } else {
    	$("#sel_gslx").val(gslx);
    }
    if('A19003'==gslx){
        $("#div_gbze").css("display","");
        $("#div_zczb").css("display","none");
    }
	
});
</script>
  </body>
</html>
