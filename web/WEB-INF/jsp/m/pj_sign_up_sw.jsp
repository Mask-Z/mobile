<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">

<head>
    
	<jsp:include page="mate.jsp"></jsp:include>

    <link rel="stylesheet" href="m/css/index.css">
    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    <link rel="stylesheet" type="text/css" href="css/jquery-weui.css">
	<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
	<script type="text/javascript" src="js/pj_sign_sw.js"></script>
	<script type="text/javascript" src="js/bm.js"></script>
	<script type="text/javascript" src="m/js/DateOp.js"></script>
    <script type="text/javascript" src="js/jquery-weui.js"></script>
</head>
  
  <body>
    
<script type="text/javascript">

    var code = '${result.code}';
    if(code==='-2'){
    	alert("${result.msg}");
    	window.location.href = "pj_list_cqjy";
    }else if(code!='0'){
    	alert("系统错误,请联系管理员");
    	window.location.href = "pj_list_cqjy";
    }

    +function (a) {
        a.rawCitiesData = ${citys};
    }($);
    

$(function(){
    
   /* $("#area").cityPicker({
        title: "所在地区",
        onChange: function(picker,values,displayValues){
            areaCode = values[2];
            areaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2];
            $("#AreaCode").val(areaCode);
            $("#AreaName").val(areaName);
        }
    });*/


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

 
	var $tooltips = $('#js_tooltips');
	/**
	   报名保存
    **/
    $("#btn_save").click(function(){
    	var rs = true;
    	var lxtel = $("#LianXiTel").val();
    	var lxr = $("#LianXiUser").val();
//        var email = document.getElementById("lxr_email");

//        if(!email.validity.valid){
//            $tooltips.html("电子邮箱格式不正确!");
//            rs = false;
//        }
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

        if(!isPhoneNo(lxtel)){
            $tooltips.html("联系电话格式不正确!");
            rs=false;
        }

    	if($.trim(lxtel)==""){
    		$tooltips.html("联系电话不能为空!");
    		rs = false;
    	}

    	if($.trim(lxr)==""){
    		$tooltips.html("联系人不能为空!");
    		rs = false;
    	}

        /*var diqu=$("#AreaCode").val();
        if (diqu === '' || diqu == '请选择') {
            $tooltips.html("所在地区必填!");
            rs = false;
        }*/


    	if(!rs){
    		$tooltips.css('display', 'block');
            setTimeout(function () {
                $tooltips.css('display', 'none');
            }, 2000);            
            return;
    	}    	
    	var param = $("#pj_ws_submit").serialize();
    	$("#toast_div").text("数据提交中"); 
   		$('#loadingToast').fadeIn(100);
    	$.ajax({
       	   type: "POST",
       	   url: "pj_sign_up_submit",
       	   dataType:"json",
       	   data: param,
       	   success: function(msg){
       	     if(msg){
       	    	if(msg.code==0){
       	    		
       	    		window.location.href = "pj_sign_up_view?infoid=${ProjectGuid}&type=NMG&bmguid=${data.RowGuid }";
       	    	}else{
       	    		$("#toast_div").text(msg.msg);
       	    		$('#loadingToast').fadeIn(100);
       	    	}
       	    	$('#loadingToast').fadeOut(3000);
       	     }       	     
       	   },
       	   error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   		alert(errorThrown);
       	   }
       	});
    });
	
    /**
                修改时附件加载
    **/
	if('${bmguid}'!=''){
		loadFile();
	}    
});

    /**
               附件加载
     */
	var task_code = "CQJY_BaoMingNMG";
	function loadFile(){
		$("#toast_div").text("加载中");
		$('#loadingToast').fadeIn(100);
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
//										var html = "<p><span><a href=\"javascript:openfj('"+list[j].RowGuid+"')\">"+list[j].AttachFileName+"</a></span><a href=\"javascript:del('"+list[j].RowGuid+"');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a></p>";
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
<header class="h43">
    <div class="index-header">
        <a href="pj_list_cqjy" class="back"></a>
        <div class="title">项目报名</div>
    </div>
</header>

<form id="pj_ws_submit">
<input type="hidden" name="bmguid" value="${bmguid}"><!-- 修改时,被修改的报名guid,新增时该只为空 -->
<input type="hidden" name="info['type']" value="NMG"><!-- 系统类别-->
<input type="hidden" name="info['RowGuid']" value="${data.RowGuid }"><!-- 报名唯一标识 -->
<input type="hidden" name="info['AuditStatus']" value="${data.AuditStatus }"><!-- 审核状态 --><!-- AuditStatus 1:初始信息录入   2:待审核    3:审核通过   4:审核不通过 -->
<input type="hidden" name="info['ProjectGuid']" value="${ProjectGuid}"><!-- 项目guid -->
<input type="hidden" name="info['IsBMNeedFile']" value="${data.IsBMNeedFile}"><!-- 是否必须上传电子件 -->
<input type="hidden" name="info['BelongXiaQuCode']" value="${data.BelongXiaQuCode }" ><!-- 所属地区 -->

<input type="hidden" name="info['XiaQuCode']" value="${data.XiaQuCode }"><!-- 机构代码 -->
<input type="hidden" name="info['DanWeiName']" value="${data.DanWeiName }"><!-- 单位名称 -->
<input type="hidden" name="info['IsGuoZi']" value="${data.IsGuoZi }"><!-- 是否国资 -->
<input type="hidden" name="info['FaRenType']" value="${data.FaRenType }"><!-- 法人类型 -->
<input type="hidden" name="info['GuoZiJianGuanType']" value="${data.GuoZiJianGuanType }"><!-- 国资监管类型 -->
<input type="hidden" name="info['YQGuoZiJG']" value="${data.YQGuoZiJG }"><!-- 央企国资机构 -->
<input type="hidden" name="info['FYQGuoZiJG']" value="${data.FYQGuoZiJG }"><!-- 非央企国资机构 -->
<input type="hidden" name="info['ZhuGuanJiTuan']" value="${data.ZhuGuanJiTuan }"><!-- 主管集团 -->
<input type="hidden" name="info['ZhuGuanJiTuanCode']" value="${data.ZhuGuanJiTuanCode }"><!-- 主管集团代码 -->
<input type="hidden" name="info['AreaName']" value="${data.AreaName }" id="AreaName"><!-- 地区名称 -->
<input type="hidden" name="info['AreaCode']" value="${data.AreaCode }" id="AreaCode"><!-- 地区代码 -->
<input type="hidden" name="info['ZhuCeDi']" value="${data.ZhuCeDi }"><!-- 注册地 -->
<input type="hidden" name="info['FaRen_13003']" value="${data.FaRen_13003 }"><!-- 法人 -->
<input type="hidden" name="info['HangYeType']" value="${data.HangYeType }"><!-- 所属行业 -->
<input type="hidden" name="info['GongSiType']" value="${data.GongSiType }"><!-- 公司类型 -->
<input type="hidden" name="info['JingJiType']" value="${data.JingJiType }"><!-- 经济类型 -->
<input type="hidden" name="info['GuiMo']" value="${data.GuiMo }"><!-- 经营规模 -->
<input type="hidden" name="info['GongShangHao']" value="${data.GongShangHao }"><!-- 工商号 -->
<input type="hidden" name="info['JingYingFanWei']" value="${data.JingYingFanWei }"><!-- 经营范围 -->
<input type="hidden" name="info['ShouRangZiGe']" value="${data.ShouRangZiGe }"><!-- 受让资格 -->
<input type="hidden" name="info['ZhengName']" value="${data.ZhengName }"><!-- 证件类型 -->
<input type="hidden" name="info['ZhengNo']" value="${data.ZhengNo }"><!-- 证件号 -->
<input type="hidden" name="info['GongZuoDanWei']" value="${data.GongZuoDanWei }"><!-- 工作单位 -->
<input type="hidden" name="info['ZhiWu']" value="${data.ZhiWu }"><!-- 职务 -->
<input type="hidden" name="info['ZiJinLaiYuan']" value="${data.ZiJinLaiYuan }"><!-- 资金来源 -->
<input type="hidden" name="info['GeRenZiChan']" value="${data.GeRenZiChan }"><!-- 个人资产 -->

<input type="hidden" name="info['BiaoDiName']" value="${data.BiaoDiName }"><!-- 标的名称 -->
<input type="hidden" name="info['BiaoDiNo']" value="${data.BiaoDiNo }"><!-- 标的编号 -->
<input type="hidden" name="info['JiaoNaBZJ']" value="${data.JiaoNaBZJ }"><!-- 保证金金额 -->
<input type="hidden" name="info['ZhuCeZiBen']" value="${data.ZhuCeZiBen }"><!-- 注册资本 -->
<input type="hidden" name="info['BelongAreaCode']" value="${data.BelongAreaCode }"><!-- 所属地区 -->
<input type="hidden" name="info['UnitOrgNum']" value="${data.UnitOrgNum }"><!-- 组织机构代码 -->
<input type="hidden" name="info['DanWeiXingZhi']" value="${data.DanWeiXingZhi }"><!-- 单位性质 -->
<input type="hidden" name="info['YingYeZhiZhaoNo']" value="${data.YingYeZhiZhaoNo }"><!-- 营业执照号码 -->
<input type="hidden" name="info['BZJIsjiaoNa']" value="${data.BZJIsjiaoNa }"><!-- 保证金是否缴纳 -->
<input type="hidden" name="info['JiaoNaEndDate']" value="${data.JiaoNaEndDate }"><!-- 保证金缴纳截至日期 -->
<input type="hidden" name="info['BelongDLJGGuid']" value="${data.BelongDLJGGuid }" id="BelongDLJGGuid"><!-- 所属会员机构guid -->
<input type="hidden" name="info['BelongDLJGName']" value="${data.BelongDLJGName }" id="BelongDLJGName"><!-- 所属会员机构名称 -->

<input type="hidden" name="info['FaRen_3008']" value="${data.FaRen_3008 }"><!--  -->
<input type="hidden" name="info['UserID']" value="${data.UserID }"><!--  -->
<input type="hidden" name="info['IpAddress']" value="${data.IpAddress }"><!-- Ip地址 -->


<div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="js_tooltips"></div>

<div class="weui-cells weui-cells_form no-mt">
	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">标的编号</label></div>
        <div class="weui-cell__bd">${data.BiaoDiNo }
        </div>
    </div>
    
    <div class="weui-cell ">
        <div class="weui-cell__hd"><label class="weui-label">标的名称</label></div>
        <div class="weui-cell__bd">${data.BiaoDiName }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">产权类型</label></div>
        <div class="weui-cell__bd">${data.ProjectType_3001_name}
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">交易方式</label></div>
        <div class="weui-cell__bd">${data.lblJiaoYiFangShi }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">保证金</label></div>
        <div class="weui-cell__bd" style="color: red">${data.lblBZJ }元
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">服务费</label></div>
        <div class="weui-cell__bd" style="color: red">${data.lblFWF }
        </div>
    </div>


    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">挂牌价</label></div>
        <div class="weui-cell__bd" style="color: red">
            <fmt:formatNumber type="number" value="${data.GuaPaiPrice }" pattern="0.00" maxFractionDigits="2"/> 元
        </div>
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
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">竞价会开始时间</label></div>
        <div class="weui-cell__bd">${data.lblJJStartTime}
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">竞价会结束时间</label></div>
        <div class="weui-cell__bd">${data.lblJJEndTime}
        </div>
    </div>

    <div class="weui-btn-area">
        <%--<a class="weui-btn weui-btn_primary" href="infodetail?infoid=${ProjectGuid}" >查看网站公告原文</a>--%>
        <a class="weui-btn weui-btn_primary" href="infodetail?${fn:split(data.GongGaoUrl,'?')[1]}" >查看网站公告原文</a>
    </div>
	<div class="weui-cells__title">报名信息</div>
	<c:if test="${user_type==1 }">
	<!-- 个人会员信息  begin -->
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">竞买人</label></div>
        <div class="weui-cell__bd">${data.DanWeiName }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">法人类型</label></div>
        <div class="weui-cell__bd"><c:if test="${data.FaRenType==2}">自然人</c:if><c:if test="${data.FaRenType==1}">企事业单位</c:if>
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">证件名称</label></div>
        <div class="weui-cell__bd">${data.ZhengName }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">证件号码<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.ZhengNo }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">工作单位</label></div>
        <div class="weui-cell__bd">${data.GongZuoDanWei }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">职务</label></div>
        <div class="weui-cell__bd">${data.ZhiWu }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">资金来源</label></div>
        <div class="weui-cell__bd">${data.ZiJinLaiYuan_name }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">个人资产申报</label></div>
        <div class="weui-cell__bd">${data.GeRenZiChan }
        </div>
    </div>
    <!-- 个人会员信息 end -->
	</c:if>
	
	
	
	<c:if test="${user_type==0 }">
	<!-- 单位信息  begin -->
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">竞买人</label></div>
        <div class="weui-cell__bd">${user.danWeiName}
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">组织机构代码</label></div>
        <div class="weui-cell__bd">${data.UnitOrgNum }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">国资类型<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><c:choose><c:when test="${data.IsGuoZi =='F'}">非国资</c:when><c:otherwise>国资</c:otherwise> </c:choose> 
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">法人类型<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><c:choose><c:when test="${data.FaRenType =='1'}">企事业单位</c:when><c:otherwise>自然人</c:otherwise> </c:choose>
        </div>
    </div>
    
    
    
    <c:if test="${data.IsGuoZi !='F'}">
    <div class="weui-cells__title">监管</div>
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">国资监管类型<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd"><c:choose><c:when test="${data.GuoZiJianGuanType =='1'}">非央企</c:when><c:otherwise>央企</c:otherwise> </c:choose>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">国资监管机构</label></div>
        <div class="weui-cell__bd">
        <c:choose><c:when test="${data.GuoZiJianGuanType !='1'}">${data.YQGuoZiJG_name}</c:when><c:otherwise>${data.FYQGuoZiJG_name }</c:otherwise> </c:choose>
        </div>
    </div>

    <%--<div class="weui-cell">--%>
        <%--<div class="weui-cell__hd"><label class="weui-label">国资监管机构地区代码</label></div>--%>
        <%--<div class="weui-cell__bd">${data.BelongAreaCode }--%>
        <%--</div>--%>
    <%--</div>--%>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">主管集团或其他部门名称<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.ZhuGuanJiTuan }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">主管集团或其他部门组织机构代码</label></div>
        <div class="weui-cell__bd">${data.ZhuGuanJiTuanCode }
        </div>
    </div>
    </c:if>
    
    
    <div class="weui-cells__title">基本情况</div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">所在地区<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.AreaName }
        </div>
        <%--<div class="weui-cell__bd">--%>
            <%--<input class="weui-input" id="area" type="text" value="${data.AreaName.replace("·"," ")}" readonly>--%>
        <%--</div>--%>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">注册地<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.ZhuCeDi }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">注册资本(万元)</label></div>
        <div class="weui-cell__bd">${data.ZhuCeZiBen }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">公司类型(经济性质)<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.gsType_name }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经济类型<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.JingJiType_name }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">法定代表人<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.FaRen_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">所属行业<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.HangYeType }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经济规模<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.GuiMo_name }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">工商注册号<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.GongShangHao }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经营范围<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">${data.JingYingFanWei }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">受让资格陈述</label></div>
        <div class="weui-cell__bd">${data.ShouRangZiGe }
        </div>
    </div>
    
    <!-- 单位信息 end -->
	</c:if>
	
    
    
    <div class="weui-cell weui-cell_access" id="pj_sign_hyjg">
        <div class="weui-cell__hd">所属会员机构</div>
        <div class="weui-cell__bd" id="sshyjh_value_div">
        ${data.BelongDLJGName }
        </div>
        <div class="weui-cell__ft" style="font-size: 0">
			<span></span>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
        <input class="weui-input" name="info['LianXiUser']" id="LianXiUser" value="${data.LianXiUser }" placeholder="请输入联系人" >
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系电话<font color="red">(*)</font></label></div>
        <div class="weui-cell__bd">
        <input class="weui-input" name="info['LianXiTel']" id="LianXiTel" value="${data.LianXiTel }" placeholder="请输入联系电话" type="number">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">电子邮箱</label></div>
        <div class="weui-cell__bd">
        <input class="weui-input" name="info['Email']" type="email" id="lxr_email" value="${data.Email }" placeholder="请输入电子邮箱">
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">传真号码</label></div>
        <div class="weui-cell__bd">
        <input class="weui-input" name="info['ChuanZhen']" value="${data.ChuanZhen }" placeholder="请输入传真号码">
        </div>
    </div>
    
    <!-- file start -->
    <div class="weui-cells__title">相关附件</div>
    
    <c:forEach items="${filelist}" var="file">
  
    <div class="weui-cell weui-cell_vcode">
        <div class="weui-cell__hd">
            <label class="weui-label">${file.FileName} <c:if test="${file.IsMustNeed eq '1' and data.IsBMNeedFile eq '1' }"><font color="red">(*)</font></c:if></label>
        </div>
        <div class="weui-cell__bd" name="init_files" id="${file.FileCode}" need="${file.IsMustNeed}">
        </div>
        <div class="weui-cell__ft">
            <a class="weui-vcode-btn" name="file_div" code="${file.FileCode}">文件管理</a>
        </div>
    </div>
    
    </c:forEach>
    
    <!-- file end -->
    
    
</div>
</form>
<div class="weui-btn-area">
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_save">确定</a>
</div>
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


    <!-- loading -->
    <div id="loadingToast" style="display:none;">
        <div class="weui-mask_transparent"></div>
        <div class="weui-toast">
            <i class="weui-loading weui-icon_toast"></i>
            <p class="weui-toast__content" id="toast_div">数据加载中</p>
        </div>
    </div>
    
  </body>
</html>
