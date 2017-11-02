<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">

<head>
<jsp:include page="mate.jsp"></jsp:include>

	<link rel="stylesheet" type="text/css" href="m/weui/weui.css">
	<link rel="stylesheet" type="text/css" href="css/jquery-weui.css">
	<link rel="stylesheet" href="m/css/bootstrap.min.css">
    <link rel="stylesheet" href="m/css/iconfont.css">
    <link rel="stylesheet" href="m/css/index.css">

	<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
	<script type="text/javascript" src="js/jquery-weui.js"></script>
	<script type="text/javascript" src="js/bm.js"></script>
  </head>
  <body>
<script type="text/javascript">
$(function(){

	var code = '${result.code}';
	if(code==='-2'){
		alert("${result.msg}");
		window.location.href = "pj_list_cqjy";
	}else if(code!='0'){
		alert("系统错误,请联系管理员");
		window.location.href = "pj_list_cqjy";
	}

    //设置高度
    function initHeight() {
        var $button=$(".fixed-btn-area");
        var $form=$(".fixed-weui-cells_form");
        var $buttonHeight=$button.height();
        var $formHeight=$form.height();
        $form.height($formHeight+$buttonHeight+10);
    }
    
    initHeight();

	$("a[name='flow_submit']").click(function(){
		var btn = $(this);
		var t = btn.attr("operationType");
		if(t){
			if("Save"==t){//修改
				window.location.href = "pj_sign_up?infoid=${params.ProjectGuid }&type=ZZKG&bmguid=${params.RowGuid }";
			} else {
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

    //审计报告:0,财务报表:1
    var sjly_str = '${data.JinQiZiChan_13003 }';
    var ly = "";
    if(sjly_str && sjly_str!=""){
    	if(sjly_str.indexOf("0") >=0){
    		ly += "审计报告";
    	}
		if(sjly_str.indexOf("1") >=0){
			if(ly!="")ly+=",";
			ly += "财务报表";
    	}

		$("#sjly").text(ly);
    }
});

    var task_code = "CQJY_ZZKGBaoMing";

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
                                    var html = "<p><span><a target='_blank'  href=\""+list[j].url+"\">"+list[j].AttachFileName+"</a></span></p>";
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

    /**
    * 提交审核
    **/
    function next_step(btn){
    	$('#loadingToast').fadeIn(100);
    	$("#operationName").val(btn.attr("operationName"));
		$("#operationGuid").val(btn.attr("operationGuid"));
		$("#transitionGuid").val(btn.attr("transitionGuid"));
		$("#operationType").val(btn.attr("operationType"));
    	var param = $("#pj_zzkg_audit").serialize();
        $.ajax({
            type: "POST",
            url: "pj_sign_up_audit",
           	dataType:"json",
           	data: param,
           	success: function(msg){
                if(msg){
           	        if(msg.code==0){
           	    	    $("#toast_div").text("报名成功");
           	    	    $('#loadingToast').fadeIn(100);
           	    		window.location.href="pj_list_cqjy";
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
    };
    </script>
	<script type="text/javascript" src="js/city-picker.js"></script>

<header class="h43" >
    <div class="index-header">
        <a href="" class="back" onclick="window.history.back(-1);return false;"></a>
        <div class="title">报名查看</div>
    </div>
</header>

<form id="pj_zzkg_audit" >
<input type="hidden" name="info['ProjectName']" value="${data.ProjectName_3001}">
<input type="hidden" name="info['ProjectGuid']" value="${params.ProjectGuid }">
<input type="hidden" name="info['RowGuid']" value="${params.RowGuid }">
<input type="hidden" name="info['type']" value="ZZKG">

<input type="hidden" name="info['processVersionInstanceGuid']" value="${data.WorkFlowInfo.processVersionInstanceGuid}"><!-- 流程唯一标识 -->
<input type="hidden" name="info['activityInstanceGuid']" value="${data.WorkFlowInfo.activityInstanceGuid}"><!-- 步骤唯一标识 -->
<input type="hidden" name="info['workItemGuid']" value="${data.WorkFlowInfo.workItemGuid}"><!-- 工作项唯一标识 -->


<input type="hidden" name="info['operationName']" id="operationName" value=""><!-- 按钮名称 -->
<input type="hidden" name="info['operationGuid']" id="operationGuid" value=""><!-- 按钮唯一标识 -->
<input type="hidden" name="info['transitionGuid']" id="transitionGuid" value=""><!-- 变迁唯一标识 -->
<input type="hidden" name="info['operationType']" id="operationType" value=""><!-- 操作类型 -->

</form>

<div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="js_tooltips"></div>
<div class="base-important-note" id="wfInfo" style="display: none"></div>
<div class="weui-cells__title">查看报名信息</div>
<div class="weui-cells weui-cells_form no-mt fixed-weui-cells_form">
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
        <div class="weui-cell__hd"><label class="weui-label">是否联合投资</label></div>
        <div class="weui-cell__bd">
        <c:if test="${data.lblUnionShouRang ==1}">是</c:if>
        <c:if test="${data.lblUnionShouRang !=1}">否</c:if>

        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">保证金金额</label></div>
        <div class="weui-cell__bd">${data.lblJiaoNaBZJ }元
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">保证金是否缴纳 </label></div>
        <div class="weui-cell__bd" style="color: red">${data.BZJIsjiaoNa_13003 }
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



	<div class="weui-cells__title">报名信息</div>

	<c:if test="${user_type==1 }">
	<!-- 个人会员信息  begin -->

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">会员类型</label></div>
        <div class="weui-cell__bd"><c:if test="${data.FaRenType_13003==2}">自然人</c:if><c:if test="${data.FaRenType_13003==1}">企事业单位</c:if>
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">投资方名称</label></div>
        <div class="weui-cell__bd">${data.DanWeiName_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">所在地区</label></div>
        <div class="weui-cell__bd">${data.AreaName_13003 }
        </div>
    </div>

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
        <div class="weui-cell__hd"><label class="weui-label">职务</label></div>
        <div class="weui-cell__bd">${data.ZhiWu_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">资金来源</label></div>
        <div class="weui-cell__bd">${data.ZiJinLaiYuan_13003_name }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">个人资产申报</label></div>
        <div class="weui-cell__bd">${data.GeRenZiChan_13003 }

        </div>
    </div>



    <!-- 个人会员信息 end -->
	</c:if>



	<c:if test="${user_type==0 }">

	<!-- 单位信息  begin -->

	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">类型</label></div>
        <div class="weui-cell__bd">
        <c:if test="${data.IsGuoZi_13003=='F' }">非国资</c:if>
        <c:if test="${data.IsGuoZi_13003=='T' }">国资</c:if>
        </div>
    </div>

	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">会员类型</label></div>
        <div class="weui-cell__bd"><c:if test="${data.FaRenType_13003==2}">自然人</c:if><c:if test="${data.FaRenType_13003==1}">企事业单位</c:if>
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">投资方名称</label></div>
        <div class="weui-cell__bd">${data.DanWeiName_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">所在地区</label></div>
        <div class="weui-cell__bd" >${data.AreaName_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">注册地</label></div>
        <div class="weui-cell__bd">${data.ZhuCeDi_13003 }
        </div>
    </div>


    <c:if test="${'A19003'!=data.CompanyLeiXing_13003  }">
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">注册资本(万元)</label></div>
        <div class="weui-cell__bd">${data.ZhuCeZiBen_13003 }
        </div>
    </div>
    </c:if>

    <c:if test="${'A19003'==data.CompanyLeiXing_13003  }">
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">股本总额(万元)</label></div>
        <div class="weui-cell__bd">${data.TotalStockCapital_13003 }
        </div>
    </div>
    </c:if>




    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
        <div class="weui-cell__bd">
        ${data.BiZhong_13003_name }
        </div>
    </div>


    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">成立时间</label></div>
        <div class="weui-cell__bd">${data.ChengLiDate_13003} <!-- 成立时间 -->
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">法定代表人</label></div>
        <div class="weui-cell__bd">${data.FaRen_13003}<!-- 法定代表人 -->
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">所属行业</label></div>
        <div class="weui-cell__bd">
        ${data.HangYeType_13003}
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">公司类型(经济性质)</label></div>
        <div class="weui-cell__bd">
        ${data.CompanyLeiXing_13003_name }<!-- 公司类型(经济性质) -->
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">企业性质(经济类型)</label></div>
        <div class="weui-cell__bd">
        ${data.CompanyXingZhi_13003_name }<!-- 企业性质(经济类型) -->
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经济规模</label></div>
        <div class="weui-cell__bd">
        ${data.GuiMo_13003_name }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
        <div class="weui-cell__bd">
        ${data.UnitOrgNum_13003 }<!-- 组织机构代码 -->
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经营范围</label></div>
        <div class="weui-cell__bd">
        ${data.JingYingFanWei_13003 }<!-- 经营范围 -->
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">受让资格陈述</label></div>
        <div class="weui-cell__bd">
        ${data.ShouRangZiGe_13003 }<!-- 受让资格陈述 -->
        </div>
    </div>


    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">数据来源</label></div>
        <div class="weui-cell__bd" id="sjly">

        </div>
    </div>


    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">报表日期</label></div>
        <div class="weui-cell__bd">
        ${data.BaoBiaoDate_13003 }<!-- 报表日期  -->
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
        <div class="weui-cell__bd">
		${data.MoneyType_13003_name }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">资产总计(万元)</label></div>
        <div class="weui-cell__bd">
        ${data.ZiChanTotal_13003 }<!-- 资产总计(万元) -->
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">负债总计(万元)</label></div>
        <div class="weui-cell__bd">
        ${data.FuZhaiTotal_13003 }<!-- 负债总计(万元) -->
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">净资产(万元)</label></div>
        <div class="weui-cell__bd">
        ${data.JingZiChan_13003 }<!--净资产(万元) -->
        </div>
    </div>

    <!-- 单位信息 end -->
	</c:if>


	<div class="weui-cell">
	    <div class="weui-cell__hd">是否标的公司原股东</div>
	    <div class="weui-cell__bd">
	      <c:if test="${data.hasPriority_13003==1}">是</c:if><!-- 是否标的公司原股东 -->
	      <c:if test="${data.hasPriority_13003!=1}">否</c:if>
	    </div>
	</div>

	<c:if test="${data.hasPriority_13003==1}">
	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">原股东名称</label></div>
        <div class="weui-cell__bd">
        ${data.YuanCompanyGuDong_13003 }
        </div>
    </div>
    </c:if>

    <div class="weui-cell">
	    <div class="weui-cell__hd">是否进场</div>
	    <div class="weui-cell__bd">
	    <c:if test="${data.IsJinChang_13003==1}">是</c:if>
	    <c:if test="${data.IsJinChang_13003!=1}">否</c:if><!-- 是否进场 -->
	    </div>
	</div>


    <div class="weui-cells__title">投资意向</div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">是否是增资企业管理层、员工或其出资企业 </label></div>
         <div class="weui-cell__bd">
         	<c:if test="${data.lblIsManagerLayer==1}">是</c:if>
	    	<c:if test="${data.lblIsManagerLayer!=1}">否</c:if><!-- 是否管理层 -->
	    </div>
    </div>

    <c:if test="${data.ZZKG_ZZType=='GF' }"><!-- 增资方式-按股份 -->
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">拟认购股份数(万股) </label></div>
        <div class="weui-cell__bd">
        ${data.InvestAmountLeft_13003 }
        </div>
    </div>
    </c:if>
    <!-- 股份end -->
	<c:if test="${data.ZZKG_ZZType=='BL' }"><!-- 增资方式-按元 -->

	<div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">拟认购资本金(万元) </label></div>
        ${data.InvestZiBen_13003 }
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">拟投资比例（%）  </label></div>
        <div class="weui-cell__bd">
        ${data.InvestPercentLeft_13003 }至${data.InvestPercentRight_13003 }
    	</div>
    </div>

    </c:if>
    <!-- 按元end -->

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">拟投资额(万元) </label></div>
        ${data.InvestPriceLeft_13003}
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">投资意向备注说明 </label></div>
        <div class="weui-cell__bd">
        ${data.InvestRemark_13003 }
        </div>
    </div>


    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人</label></div>
        ${data.LianXiUser_13003 }
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系电话</label></div>
        ${data.LianXiTel_13003 }
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">电子邮箱</label></div>
        ${data.Email_13003 }
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">传真号码</label></div>
        ${data.ChuanZhen_13003 }
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">资信证明</label></div>
        <div class="weui-cell__bd">
        ${data.ZiXinZhengMing_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">机构名称</label></div>
        <div class="weui-cell__bd">
        ${data.BelongDLJGName_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">工位号</label></div>
        ${data.GongWeiNo_13003 }
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经纪人</label></div>
        ${data.JingJiRen_13003 }
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">经纪人编码</label></div>
        ${data.JingJiRenCode_13003 }
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人</label></div>
        ${data.LianXiRen_13003 }
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系电话</label></div>
        ${data.JGLianXiTel_13003 }
    </div>

    <div class="weui-cells__tips">联合受让方</div>
    <div class="weui-cells weui-cells_form" id="union_div">
        <table class="table" width="100%">
            <tbody>
            <tr>
                <td height="30">序号</td>
                <td>联合受让方名称</td>
                <td>投资方类型</td>
            </tr>
        <c:forEach items="${data.unionList}" var="union" varStatus="vs">
            <tr class="ios_menu" >
                <td height="30">${vs.index+1 }</td>
                <td>${union.ShouRangName}</td>
                <td>${union.ShouRangRenType }</td>
            </tr>
            <input type="hidden" value="${union.RowGuid}">
        </c:forEach>
            </tbody>
        </table>
    </div>
    <input type="hidden" id="union_waiting_handle" value="">

    <!-- file start -->
    <div class="weui-cells__title">相关附件</div>

    <c:forEach items="${filelist}" var="file">
		<div class="weui-cells">
		        <div class="weui-cell">
		            <div class="weui-cell__hd">
		                <label class="weui-label">${file.FileName}</label>
		            </div>
		            <div class="weui-cell__bd" name="init_files" id="${file.FileCode}" need="${file.IsMustNeed}">
		
		            </div>
		
		        </div>
		</div>
    </c:forEach>

    <!-- file end -->


</div>

<div class="weui-btn-area fixed-btn-area" style="position: fixed;bottom: 0px;z-index:9; background-color: #FFFFFF;">
<%
Object obj = request.getAttribute("data");
if(obj!=null){
	try{

		Map m = (Map) obj;
		if(m.containsKey("WorkFlowInfo")){
			Map bs = (Map) m.get("WorkFlowInfo");

			if(bs.containsKey("btnList")){
				List btnList = (List) bs.get("btnList");
				if(btnList != null){
					for(Object btnObj : btnList){
						Map btn = (Map) btnObj;
						out.println("<a href=\"javascript:;\" name=\"flow_submit\" class=\"weui-btn weui-btn_mini weui-btn_warn\" transitionGuid=\""+btn.get("transitionGuid")+"\"  operationType=\""+btn.get("operationType")+"\" operationGuid=\""+btn.get("operationGuid")+"\" operationName=\""+btn.get("operationName")+"\"  id=\""+btn.get("operationType")+"\">"+btn.get("operationName")+"</a>");
					}
				}
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
}
%>
<%--<c:if testWebService="${data.WorkFlowInfo.wfIsBtnTdShow=='1' }">--%>

<a href="javascript:printHZ('${params.RowGuid }','zzkg')" class="weui-btn weui-btn_mini weui-btn_primary">打印回执</a>

<%--</c:if>--%>

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

<div class="js_dialog" id="union_select_div" style="display: none;">
<div class="weui-mask"></div>
<div class="weui-dialog_srf" style="height: 600px;overflow-y:scroll;">
<div class="weui-dialog__hd_srf" style="height: 30px"><strong class="weui-dialog__title">查看联合投资方</strong></div>
<div class="weui-dialog__bd_srf">
<form id="pj_gq_addUnion">

<input type="hidden" id="union_baoMing_guid" name="info['baoMingGuid']" value="${data.RowGuid }"><!-- 联合受让方报名统一标识 -->
<input type="hidden" id="shouRang_guid" name="info['shouRangGuid']" value="">
<input type="hidden" id="union_row_guid" name="info['rowGuid']" value=""><!-- 联合受让方唯一标识 -->
<input type="hidden" name="info['zhuanRangType']" value="${data.ZhuanRangType }"><!-- 转让方式 -->
<input type="hidden" name="info['unionType']" id="union_type" value=""><!-- 转让方式 -->

<div class="weui-toptips weui-toptips_warn js_tooltips"></div>
<div class="weui-cells weui-cells_form">
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">投资方名称</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['shouRangName']" type="text" id="shouRang_name" value=""/>
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">投资方类型</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['shouRangName']" type="text" id="shouRangRen_type" value=""/>
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
    	<div class="weui-dialog__hd"><strong class="weui-dialog__title">增资扩股报名确认单</strong></div>
        <div class="weui-dialog__bd"></div>
        <div class="weui-dialog__ft">
            <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary zdl" id="zdl_btn">知道了</a>
        </div>
    </div>
</div>

  </body>
</html>
