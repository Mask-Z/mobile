<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">

<head>
<jsp:include page="mate.jsp"></jsp:include>
	
	<link rel="stylesheet" type="text/css" href="css/jquery-weui.css">
	<link rel="stylesheet" type="text/css" href="m/weui/weui.css">
	<link rel="stylesheet" href="m/css/bootstrap.min.css">
    <link rel="stylesheet" href="m/css/iconfont.css">
    <link rel="stylesheet" href="m/css/index.css">
    
	<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
	<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js"></script>    
    
    <script type="text/javascript" src="js/jquery-weui.js"></script>
    <script type="text/javascript" src="js/bm.js"></script>
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

$(function(){
	if($("#zhuanRang_type").val() == '1'){
	    $("#shouRang_gufen_div").hide();
	    $("#shou_RangGuFen_div").hide();
	}else{
	    $("#shouRang_percent_div").hide();
	    $("#shou_RangPercent_div").hide();
	}
	
	if($("#lbl_isManagerLayer").val() == '1'){
	    $("#zhiwu_div").show();
	}
	
	$("#btn_cancel").on("click",function(){    	    	
    	$("#union_select_div").fadeOut(200);
    });
	
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
    
    $("#union_view").on("click", function(){
        initUnionDialog();       	        
    });

    //设置高度
    function initHeight() {
        var $button=$(".fixed-btn-area");
        var $form=$(".fixed-weui-cells_form");
        var $buttonHeight=$button.height();
        var $formHeight=$form.height();
        $form.height($formHeight+$buttonHeight+10);
    }
    
    initHeight();

    function initUnionDialog(){
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
       	            if(result.ShouRangRenType == '1'){
       	                $("#shouRangRen_type").val("法人");
       	            }else if(result.ShouRangRenType == '2'){
       	                $("#shouRangRen_type").val("自然人");
       	            }
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
       	            //查看时禁用所有输入并隐藏确定按钮
       	            $("#union_select_div").find("*").each(function(){ 
       	                $(this).attr("disabled","disabled");
       	            });
       	            $("#btn_ok").hide();
       	            $("#union_select_div").fadeIn(200);
       	        }
       	    },
       	    error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   		alert(errorThrown);
       	    }
       	}); 
    }

    var wfInfo = "${data.WorkFlowInfo.wfInfo}";

    if(wfInfo){
        $("#wfInfo").html(wfInfo);
        $("#wfInfo").css('display', 'block');
    }

   	$("a[name='flow_submit']").click(function(){
		var btn = $(this);
		var t = btn.attr("operationType");
		if(t){
			if("Save"==t){//修改
				window.location.href = "pj_sign_up?infoid=${params.ProjectGuid }&type=GQ&bmguid=${params.RowGuid }";
			}else{
                /**
                 * 提交审核前再判断一次是否上传了必需附件
                 */
                var IsBMNeedFile='${data.IsBMNeedFile}';
                if (IsBMNeedFile === '1') {
                    var filelist = '${filelist}';
                    var json1 = JSON.parse(filelist);
                    for (var i = 0; i < json1.length; i++) {
                        if (json1[i].IsMustNeed == "1" && $("#"+json1[i].FileCode).find("p").length==0) {
                            $tooltips=$('#js_tooltips');
                            $tooltips.html(json1[i].FileName+"必须选择上传文件!");
                            $tooltips.css('display', 'block');
                            setTimeout(function () {
                                $tooltips.css('display', 'none');
                            }, 2000);
                            return;
                        }
                    }
                }
			    next_step(btn);			    
			}
		}
	});

    /**
     * 加载附件
     **/
    loadFile();

});

var task_code = "CQJY_GQBaoMing";
function loadFile(){
    $("#toast_div").text("加载中");
    $('#loadingToast').fadeIn(100);
    var data = {};
    data.bmguid = "${params.RowGuid }";
    data.taskCode = task_code;
    $.ajax({
        url: "getFileList",
        type: "POST",
        data: data,
        success: function(res,status,xhr){
            try{
                if(res && res.code==0){
                    var files = (res.data);
                    for(var i=0;i<files.length;i++){
                        var code = files[i].type;
                        var list = files[i].fileList;

                        for(var j=0;j<list.length;j++){
                            var html = "<p><span><a target='_blank' href=\""+list[j].url+"\">"+list[j].AttachFileName+"</a></span></p>";
                            $("#"+code).append(html);
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

function openfj(guid){
    window.location.href = "${bm_file_download}"+guid;
}

function next_step(btn){
	$("#operationName").val(btn.attr("operationName"));
	$("#operationGuid").val(btn.attr("operationGuid"));
	$("#transitionGuid").val(btn.attr("transitionGuid"));
	$("#operationType").val(btn.attr("operationType"));
	var param = $("#pj_gq_audit").serialize();		
    $.ajax({
        type: "POST",
       	url: "pj_sign_up_audit",
       	dataType:"json",
       	data: param,
       	success: function(result){
            if(result){
       	        if(result.code==0){
       	    	    $("#toast_div").text("报名成功");
       	    	    $('#loadingToast').fadeIn(100);		
       	    		window.location.href="pj_list_cqjy";
                }else{
                    $("#toast_div").text(result.msg);
                    $('#loadingToast').fadeIn(100);
                }
                $('#loadingToast').fadeOut(3000);
       	    }       	    
       	},
       	error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   	alert(errorThrown);
       	}
    });
}
</script>

<header class="h43">
    <div class="index-header">
        <a href="pj_list_cqjy" class="back"></a>
        <div class="title">报名查看</div>
    </div>
</header>

<form id="pj_gq_audit" action="pj_sign_up_submit" method="post">
        <%
        Object data = request.getAttribute("data");
    	String bbdate = "";
    	String cldate = "";
    	String areaName = "";
    	if(data!=null){
    		Map map = (Map)data;
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			SimpleDateFormat sdf_ = new SimpleDateFormat("yyyy-MM-dd");    		
    		try{
    		    if(map.containsKey("BaoBiaoDate_13003")){
    		        String bd = map.get("BaoBiaoDate_13003").toString();
    				if(StringUtils.isNotBlank(bd)){
    				    bbdate = sdf_.format(sdf.parse(bd));	
    				}
    			}
    			if(map.containsKey("ChengLiDate_13003")){
    			    String bd = map.get("ChengLiDate_13003").toString();
    				if(StringUtils.isNotBlank(bd)){
    				    cldate = sdf_.format(sdf.parse(bd));
    				}
    			}
    		}catch(Exception e){
				e.printStackTrace();
    		}    		
    	}
        %>
        
<input type="hidden" name="info['ProjectName']" value="${data.ProjectName_3001}">
<input type="hidden" name="info['ProjectGuid']" value="${params.ProjectGuid }">
<input type="hidden" name="info['RowGuid']" value="${params.RowGuid }">

<input type="hidden" name="info['type']" value="GQ">
<input type="hidden" name="info['processVersionInstanceGuid']" value="${data.WorkFlowInfo.processVersionInstanceGuid}"><!-- 流程唯一标识 -->
<input type="hidden" name="info['activityInstanceGuid']" value="${data.WorkFlowInfo.activityInstanceGuid}"><!-- 步骤唯一标识 -->
<input type="hidden" name="info['workItemGuid']" value="${data.WorkFlowInfo.workItemGuid}"><!-- 工作项唯一标识 -->
<input type="hidden" name="info['operationName']" id="operationName" value=""><!-- 按钮名称 -->
<input type="hidden" name="info['operationGuid']" id="operationGuid" value=""><!-- 按钮唯一标识 -->
<input type="hidden" name="info['transitionGuid']" id="transitionGuid" value=""><!-- 变迁唯一标识 -->
<input type="hidden" name="info['operationType']" id="operationType" value=""><!-- 操作类型 -->
</form>
<input type="hidden" id="zhuanRang_type" value="${data.ZhuanRangType}">
<input type="hidden" id="lbl_isManagerLayer" value="${data.lblIsManagerLayer}">

<div class="base-important-note" id="wfInfo" style="display: none"></div>
<div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="js_tooltips"></div>
<div class="weui-cells__title">查看报名信息</div>
<div class="weui-cells weui-cells_form fixed-weui-cells_form">
	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">标的编号</label></div>
        <div class="weui-cell__bd">${data.ProjectNo_3001 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">标的名称</label></div>
        <div class="weui-cell__bd">${data.ProjectName_3001 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">标的类型</label></div>
        <div class="weui-cell__bd">
        <c:choose><c:when test="${data.BiaoDiType_3001=='GQ'}">股权</c:when><c:otherwise>股权+债权</c:otherwise></c:choose>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">是否联合受让</label></div>
        <div class="weui-cell__bd"><c:choose><c:when test="${data.lblUnionShouRang=='1'}">是</c:when><c:otherwise>否</c:otherwise></c:choose>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">保证金金额</label></div>
        <div class="weui-cell__bd">${data.lblJiaoNaBZJ }万元
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">是否缴纳</label></div>
        <div class="weui-cell__bd" style="color: red">${data.BZJIsjiaoNa_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">挂牌价 </label></div>
        <div class="weui-cell__bd" style="color: red">
            <fmt:formatNumber type="number" value="${data.GuaPaiPrice }" pattern="0.000000" maxFractionDigits="6"/> 万元
        </div>
    </div>

	<div class="weui-cells__title">报名信息</div>
	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">是否国资</label></div>
        <div class="weui-cell__bd">
        <c:choose><c:when test="${data.IsGuoZi_13003=='F'}">非国资</c:when><c:otherwise>国资</c:otherwise></c:choose>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">法人类型</label></div>
        <div class="weui-cell__bd"><c:if test="${data.FaRenType_13003==2}">自然人</c:if><c:if test="${data.FaRenType_13003==1}">企事业单位</c:if>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">受让方名称</label></div>
        <div class="weui-cell__bd">${data.DanWeiName_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">是否标的企业管理层直接或间接出资</label></div>
        <div class="weui-cell__bd">
        <c:choose><c:when test="${data.lblIsManagerLayer=='1'}">是</c:when><c:otherwise>否</c:otherwise></c:choose>
        </div>
    </div>
    
    <c:if test="${data.lblIsManagerLayer=='1'}">
	    <div class="weui-cell" id="zhiwu_div" style="display: none;">
	        <div class="weui-cell__hd"><label class="weui-label">职务</label></div>
	        <div class="weui-cell__bd">${data.ZhiWu_13003 }
	        </div>
	    </div>
	    
	    <div class="weui-cell">
	        <div class="weui-cell__hd"><label class="weui-label">是否进行了经济责任审计</label></div>
	        <div class="weui-cell__bd">
	        <c:choose><c:when test="${data.hasAudit_13003=='1'}">是</c:when><c:otherwise>否</c:otherwise></c:choose>
	        </div>
	    </div>
    </c:if>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label for="" class="weui-label">所在地区</label></div>
        <div class="weui-cell__bd">${data.AreaName_13003 }
        </div>
    </div>
    
    <c:if test="${user_type==1 }">
	<!-- 个人会员信息  begin -->
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">证件名称</label></div>
        <div class="weui-cell__bd">${data.ZhengName_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">证件号码</label></div>
        <div class="weui-cell__bd">${data.ZhengNo_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">工作单位</label></div>
        <div class="weui-cell__bd">${data.GongZuoDanWei_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">资金来源</label></div>
        <div class="weui-cell__bd">
        <c:if test="${data.ZiJinLaiYuan_13003==0}">自有</c:if>
        <c:if test="${data.ZiJinLaiYuan_13003==1}">融资</c:if>
        <c:if test="${data.ZiJinLaiYuan_13003==2}">其他</c:if>
        </div>
    </div>
    
    <div class="weui-cells__tips">个人资产申报</div>
    <div class="weui-cell">
        <div class="weui-cell__bd">
            <textarea class="weui-textarea" rows="3" disabled>${data.GeRenZiChan_13003 }</textarea>
        </div>
    </div>
    <!-- 个人会员信息 end -->
	</c:if>
	
	<c:if test="${user_type==0 }">
	<!-- 单位信息  begin --> 
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">注册地</label></div>
        <div class="weui-cell__bd">${data.ZhuCeDi_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">注册资本（万元）</label></div>
        <div class="weui-cell__bd">${data.ZhuCeZiBen_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
        <div class="weui-cell__bd">
        <c:if test ="${data.BiZhong_13003=='1'}">人民币 </c:if>
        <c:if test ="${data.BiZhong_13003=='2'}">美元 </c:if>
        <c:if test ="${data.BiZhong_13003=='3'}">欧元 </c:if>
        <c:if test ="${data.BiZhong_13003=='4'}">日元 </c:if>
        <c:if test ="${data.BiZhong_13003=='5'}">英镑 </c:if>
        <c:if test ="${data.BiZhong_13003=='6'}">港元 </c:if>
        <c:if test ="${data.BiZhong_13003=='7'}">新加坡币</c:if>
        <c:if test ="${data.BiZhong_13003=='8'}">瑞士法郎</c:if>
        <c:if test ="${data.BiZhong_13003=='9'}">韩元</c:if>       
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label for="" class="weui-label">成立时间</label></div>
        <div class="weui-cell__bd"><%=cldate %>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label for="" class="weui-label">法定代表人</label></div>
        <div class="weui-cell__bd">${data.FaRen_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">所属行业</label></div>
        <div class="weui-cell__bd">${data.HangYeType_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">金融类所属行业</label></div>
        <div class="weui-cell__bd">${data.IndustryCName_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd">
            <label for="" class="weui-label">公司类型（经济性质）</label>
        </div>
        <div class="weui-cell__bd">
        <c:if test="${data.CompanyLeiXing_13003=='A19001'}">全民所有制企业</c:if>
        <c:if test="${data.CompanyLeiXing_13003=='A19002'}">有限责任公司</c:if>
        <c:if test="${data.CompanyLeiXing_13003=='A19003'}">股份有限公司</c:if>
        <c:if test="${data.CompanyLeiXing_13003=='A19004'}">集体所有制企业</c:if>
        <c:if test="${data.CompanyLeiXing_13003=='A19005'}">合伙企业</c:if>
        <c:if test="${data.CompanyLeiXing_13003=='A19006'}">其他</c:if>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd">
            <label for="" class="weui-label">企业性质（经济类型）</label>
        </div>
        <div class="weui-cell__bd">
        <c:if test="${data.CompanyXingZhi_13003=='A05001'}">国资监管机构/政府部门</c:if>
        <c:if test="${data.CompanyXingZhi_13003=='A05002'}">国有独资公司（企业）/国有全资企业</c:if>
        <c:if test="${data.CompanyXingZhi_13003=='A05003'}">国有控股企业</c:if>
        <c:if test="${data.CompanyXingZhi_13003=='A05004'}">国有事业单位，国有社团等</c:if>
        <c:if test="${data.CompanyXingZhi_13003=='A05010'}">国有实际控制企业</c:if>
        <c:if test="${data.CompanyXingZhi_13003=='A05006'}">国有参股企业</c:if>
        <c:if test="${data.CompanyXingZhi_13003=='A05007'}">非国有企业</c:if>
        <c:if test="${data.CompanyXingZhi_13003=='A05008'}">外资企业</c:if>
        <c:if test="${data.CompanyXingZhi_13003=='A05009'}">其他</c:if>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd">
            <label for="" class="weui-label">经济规模</label>
        </div>
        <div class="weui-cell__bd">
        <c:if test="${data.GuiMo_13003=='0'}">大型</c:if>
        <c:if test="${data.GuiMo_13003=='1'}">中型</c:if>
        <c:if test="${data.GuiMo_13003=='2'}">小型</c:if>
        <c:if test="${data.GuiMo_13003=='3'}">微型</c:if>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
        <div class="weui-cell__bd">${data.UnitOrgNum_13003 }
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经营范围</label></div>
        <div class="weui-cell__bd">${data.JingYingFanWei_13003 }            
        </div>
    </div>
    
    <div class="weui-cells__tips">受让资格陈述</div>
    <div class="weui-cell">
        <div class="weui-cell__bd">
            <textarea class="weui-textarea" rows="3" disabled>${data.ShouRangZiGe_13003 }</textarea>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">以下数据出自</label></div>
        <div class="weui-cell__bd">        
        <c:if test="${data.JinQiZiChan_13003=='0;1;'}">审计报告;财务报表</c:if>
        <c:if test="${data.JinQiZiChan_13003=='0;'}">审计报告</c:if>
        <c:if test="${data.JinQiZiChan_13003=='1;'}">财务报表</c:if>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label for="" class="weui-label">报表日期</label></div>
        <div class="weui-cell__bd"><%=bbdate%>      
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">资产总计（万元）</label></div>
        <div class="weui-cell__bd">${data.ZiChanTotal_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">负债总计（万元）</label></div>
        <div class="weui-cell__bd">${data.FuZhaiTotal_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">净资产（万元）</label></div>
        <div class="weui-cell__bd">${data.JingZiChan_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
        <div class="weui-cell__bd">  
        <c:if test ="${data.MoneyType_13003==1}">人民币 </c:if> 
        <c:if test ="${data.MoneyType_13003==2}">美元 </c:if> 
        <c:if test ="${data.MoneyType_13003==3}">欧元 </c:if> 
        <c:if test ="${data.MoneyType_13003==4}">日元 </c:if> 
        <c:if test ="${data.MoneyType_13003==5}">英镑 </c:if> 
        <c:if test ="${data.MoneyType_13003==6}">港元 </c:if> 
        <c:if test ="${data.MoneyType_13003==7}">新加坡币</c:if> 
        <c:if test ="${data.MoneyType_13003==8}">瑞士法郎</c:if> 
        <c:if test ="${data.MoneyType_13003==9}">韩元</c:if>          
        </div>
    </div>    
    <!-- 单位信息 end -->
	</c:if>
	
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">是否标的公司原股东</label></div>
        <div class="weui-cell__bd"> 
        <c:if test ="${data.hasPriority_13003==1}">是 </c:if> 
        <c:if test ="${data.hasPriority_13003==0}">否 </c:if>      
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">受让底价（万元）</label></div>
        <div class="weui-cell__bd">${data.ShouRangDiJia_13003 }          
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
        <div class="weui-cell__bd">  
        <c:if test ="${data.ShouRangBiZhong_13003==1}">人民币 </c:if> 
        <c:if test ="${data.ShouRangBiZhong_13003==2}">美元 </c:if> 
        <c:if test ="${data.ShouRangBiZhong_13003==3}">欧元 </c:if> 
        <c:if test ="${data.ShouRangBiZhong_13003==4}">日元 </c:if> 
        <c:if test ="${data.ShouRangBiZhong_13003==5}">英镑 </c:if> 
        <c:if test ="${data.ShouRangBiZhong_13003==6}">港元 </c:if> 
        <c:if test ="${data.ShouRangBiZhong_13003==7}">新加坡币</c:if> 
        <c:if test ="${data.ShouRangBiZhong_13003==8}">瑞士法郎</c:if> 
        <c:if test ="${data.ShouRangBiZhong_13003==9}">韩元</c:if>         
        </div>
    </div>
    
    <div class="weui-cell" id="shou_RangPercent_div">
        <div class="weui-cell__hd"><label class="weui-label">拟受让比例（%）</label></div>
        <div class="weui-cell__bd">${data.ShouRangPercent_13003 }            
        </div>
    </div>
    
    <div class="weui-cell" id="shou_RangGuFen_div">
        <div class="weui-cell__hd"><label class="weui-label">拟受让股份（股）</label></div>
        <div class="weui-cell__bd">${data.ShouRangGuFen_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人</label></div>
        <div class="weui-cell__bd">${data.LianXiUser_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系电话</label></div>
        <div class="weui-cell__bd">${data.LianXiTel_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">电子邮箱</label></div>
        <div class="weui-cell__bd">${data.Email_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">传真号码</label></div>
        <div class="weui-cell__bd">${data.ChuanZhen_13003 }            
        </div>
    </div>
    
    <div class="weui-cells__tips">资信证明</div>
    <div class="weui-cell">
        <div class="weui-cell__bd">
            <textarea class="weui-textarea" rows="3" disabled>${data.ZiXinZhengMing_13003 }</textarea>
        </div>
    </div>  
    
    <div class="weui-cells__tips">委托会员</div>
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">机构名称</label></div>
        <div class="weui-cell__bd">${data.BelongDLJGName_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">工位号</label></div>
        <div class="weui-cell__bd">${data.GongWeiNo_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经纪人</label></div>
        <div class="weui-cell__bd">${data.JingJiRen_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经纪人编码</label></div>
        <div class="weui-cell__bd">${data.JingJiRenCode_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人</label></div>
        <div class="weui-cell__bd">${data.LianXiRen_13003 }            
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系电话</label></div>
        <div class="weui-cell__bd">${data.JGLianXiTel_13003 }            
        </div>
    </div>    
    
    <div class="weui-cells__tips">联合受让方</div>
    <div class="weui-cells weui-cells_form" id="union_div">
        <table class="table" width="100%">
            <tbody>
            <tr>
                <td height="30">序号</td>
                <td>联合受让方名称</td>
                <c:if test ="${data.ZhuanRangType=='1'}">
                    <td>拟受让比例（%）</td>
                </c:if>
                <c:if test ="${data.ZhuanRangType=='2'}">
                    <td>拟受让股份（股）</td>
                </c:if>
            </tr>
        <c:forEach items="${data.unionList}" var="union" varStatus="vs">
            <tr class="ios_menu">
                <td height="30">${vs.index+1 }</td>
                <td>${union.ShouRangName}</td>
                <c:if test ="${data.ZhuanRangType=='1'}">
                    <td>${union.ShouRangPercent }</td>
                </c:if>
                <c:if test ="${data.ZhuanRangType=='2'}">
                    <td>${union.ShouRangGufen }</td>
                </c:if>
            </tr>
            <input type="hidden" value="${union.RowGuid}">
        </c:forEach>
            </tbody>
        </table>
    </div>
    <input type="hidden" id="union_waiting_handle" value="">
    
    <div class="weui-cells__title">相关附件</div>
    <c:forEach items="${filelist}" var="file">
    <div class="weui-cell">
        <div class="weui-cell__hd">
            <label class="weui-label">${file.FileName}</label>
        </div>
        <div class="weui-cell__bd" name="init_files" id="${file.FileCode}" need="${file.IsMustNeed}">        
        </div>
    </div>    
    </c:forEach>
</div>

<div class="weui-btn-area fixed-btn-area" style="position: fixed;bottom: 0px;z-index:9;background-color: #FFFFFF;">
<%
Object obj = request.getAttribute("data");
if(obj!=null){
	try{		
		Map m = (Map)obj;
		if(m.containsKey("WorkFlowInfo")){
			Map bs = (Map)m.get("WorkFlowInfo");			
			if(bs.containsKey("btnList")){
				List btnList = (List)bs.get("btnList");
				if(btnList != null){
					for(Object btnObj : btnList){
						Map btn = (Map)btnObj;
						out.println("<a href=\"javascript:;\" name=\"flow_submit\" class=\"weui-btn weui-btn_mini weui-btn_warn\" transitionGuid=\""
						+btn.get("transitionGuid")+"\" operationType=\""+btn.get("operationType")+"\" operationGuid=\""+btn.get("operationGuid")
						+"\" is_ShowOpinionTemplete=\""+btn.get("is_ShowOpinionTemplete")+"\" is_RequireOpinion=\""+btn.get("is_RequireOpinion")+"\" defaultOpinion=\""+btn.get("defaultOpinion")
						+"\" operationName=\""+btn.get("operationName")+"\" id=\""+btn.get("operationType")+"\">"+btn.get("operationName")+"</a>");
					}
				}
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
}
%>
<%--<c:if test="${data.WorkFlowInfo.wfIsBtnTdShow=='1'&&auditStatus.AuditStatus=='3' }">--%>
<c:if test="${auditStatus.AuditStatus=='3' }">
    <a href="javascript:printHZ('${params.RowGuid }','gq')" class="weui-btn weui-btn_mini weui-btn_primary">打印回执</a>
</c:if>
</div>

<div class="js_dialog" id="union_select_div" style="display: none;">
<div class="weui-mask"></div>
<div class="weui-dialog_srf" style="height: 600px;overflow-y:scroll;">
<div class="weui-dialog__hd_srf" style="height: 30px"><strong class="weui-dialog__title">查看联合受让方</strong></div>
<div class="weui-dialog__bd_srf">   
<form id="pj_gq_addUnion">

<input type="hidden" id="union_baoMing_guid" name="info['baoMingGuid']" value="${data.RowGuid }"><!-- 联合受让方报名统一标识 -->
<input type="hidden" id="shouRang_guid" name="info['shouRangGuid']" value="">
<input type="hidden" id="union_row_guid" name="info['rowGuid']" value=""><!-- 联合受让方唯一标识 -->
<input type="hidden" name="info['zhuanRangType']" value="${data.ZhuanRangType }"><!-- 转让方式 -->
<input type="hidden" name="info['unionType']" id="union_type" value=""><!-- 转让方式 -->

<div class="weui-cells weui-cells_form">    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">受让方名称</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['shouRangName']" type="text" id="shouRang_name" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">受让方类型</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['shouRangName']" type="text" id="shouRangRen_type" value=""/>
        </div>
    </div>
    
    <div class="weui-cell" id="shouRang_percent_div">
        <div class="weui-cell__hd"><label class="weui-label">受让比例（%）</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['shouRangPercent']" type="text" id="shouRang_percent" value=""/>
        </div>
    </div>
    
    <div class="weui-cell" id="shouRang_gufen_div">
        <div class="weui-cell__hd"><label class="weui-label">受让股份（股）</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['shouRangGuFen']" type="text" id="shouRang_gufen" value=""/>
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
<div class="weui-btn-area">
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_ok">确定</a>    
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_cancel">取消</a>    
</div>
</div>
</div>

    <%--<div>--%>
        <div class="weui-mask" id="iosMask" style="display: none">
        <div class="weui-actionsheet" id="iosActionsheet">
            <div class="weui-actionsheet__menu">
                <div class="weui-actionsheet__cell" id="union_view">查看</div>
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="iosActionsheetCancel">取消</div>
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
    
<!-- 报名回执 -->
<div class="js_dialog" id="iosDialog" style="display: none;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
        <div class="weui-dialog__bd"></div>
        <div class="weui-dialog__ft">
            <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary zdl" id="zdl_btn">知道了</a>
        </div>
    </div>
</div>
    
  </body>
</html>
