<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
<%@ page import="java.util.List" %>
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

    <link rel="stylesheet" type="text/css" href="css/jquery-weui.css">
    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    <link rel="stylesheet" href="m/css/index.css">
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="js/jquery-weui.js"></script>
    <script type="text/javascript" src="js/bm.js"></script>
    <script type="text/javascript" src="m/js/DateOp.js"></script>
    <!-- easyui-start-->
    <link href="<%=basePath%>easyui/themes/insdep/easyui.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>easyui/themes/insdep/easyui_animation.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>easyui/themes/insdep/easyui_plus.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>easyui/themes/insdep/insdep_theme_default.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>easyui/themes/insdep/icon.css" rel="stylesheet" type="text/css">
    <%--<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>--%>
    <script type="text/javascript" src="<%=basePath%>easyui/jquery.easyui.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>easyui/themes/insdep/jquery.insdep-extend.min.js"
            charset="UTF-8"></script>
    <!-- easyui-end -->
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

    $(function(){

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

        //设置高度
        function initHeight() {
            var $button=$(".fixed-btn-area");
            var $form=$(".myform");
            var $buttonHeight=$button.height();
            var $formHeight=$form.height();
            $form.height($formHeight+$buttonHeight+100);
        }

        initHeight();

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
                               alert(json1[i].FileName+"必须选择上传文件!");
                                return;
                            }
                        }
                    }
                    next_step(btn);
                }
            }
        });
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
                            alert("报名成功");
                            window.location.href="pj_list_cqjy";
                        }else{
                            alert(result.msg);
                        }
                    }
                },
                error:function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        }
    })
</script>
<script type="text/javascript" src="js/city-picker.js"></script>
<style type="text/css">
    .title {
        background: skyblue;
    }

    table.myform {
        line-height: 24px;
    }

    table.myform td {
        padding: 2px;
    }

</style>
<header class="h43">
    <div class="index-header">
        <a href="pj_list_cqjy" class="back"></a>
        <div class="title">报名信息查看</div>
        <a href="javascript:showRule1();" class="h-r"><i class="glyphicon glyphicon-filter"></i></a>
    </div>
</header>

<form id="pj_gq_audit">
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

    <div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="srf_js_tooltips"></div>
    <div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="js_tooltips"></div>
    <table class="myform" title="查看报名信息" style="width:100%;height:250px" border="1">
        <thead>
        <tr>
            <td class="title">标的编号</td>
            <td colspan="3">${data.ProjectNo_3001 }</td>
            <td class="title">标的名称</td>
            <td colspan="2">${data.ProjectName_3001 }</td>
        </tr>
        <tr>
            <td class="title">标的类型</td>
            <td colspan="3">
                <c:choose><c:when test="${data.BiaoDiType_3001=='GQ'}">股权</c:when><c:otherwise>股权+债权</c:otherwise></c:choose>
            </td>
            <td class="title">是否联合受让</td>
            <td colspan="2">
                <c:choose><c:when test="${data.lblUnionShouRang=='1'}">是</c:when><c:otherwise>否</c:otherwise></c:choose>
            </td>
        </tr>
        <tr>
            <td class="title">保证金金额</td>
            <td colspan="3">${data.lblJiaoNaBZJ }</td>
            <td class="title">是否缴纳</td>
            <td colspan="2">${data.BZJIsjiaoNa_13003 }</td>
        </tr>
        <tr>
            <td class="title">挂牌价</td>
            <td colspan="5"><fmt:formatNumber type="number" value="${data.GuaPaiPrice }" pattern="0.000000"
                                              maxFractionDigits="6"/> 万元
            </td>
        </tr>
        <tr>
            <td colspan="6">报名信息</td>
        </tr>
        <tr>
            <td class="title">是否国资</td>
            <td colspan="3">
                <c:choose><c:when test="${data.IsGuoZi_13003=='F'}">非国资</c:when><c:otherwise>国资</c:otherwise></c:choose>
            </td>
            <td class="title">法人类型</td>
            <td colspan="2">
                <c:if test="${data.FaRenType_13003==2}">自然人</c:if><c:if test="${data.FaRenType_13003==1}">企事业单位</c:if>
            </td>
        </tr>


        <c:if test="${user_type==0 }">
            <!-- 单位信息 begin -->
            <tr>
                <td class="title" rowspan="11" id="row_danwei">基本情况</td>
                <td class="title">受让方名称</td>
                <td colspan="2">${data.DanWeiName_13003 }</td>
                <td class="title">所在地区</td>
                <td colspan="1" >${data.AreaName_13003 }</td>
            </tr>
            <tr>
                <td class="title">是否标的企业管理层直接或间接出资</td>
                <td colspan="4" >
                    <c:choose><c:when test="${data.lblIsManagerLayer=='1'}">是</c:when><c:otherwise>否</c:otherwise></c:choose>
                </td>
            </tr>
            <tr id="zhiwu_div" style="display: none;">
                <td class="title">职务</td>
                <td colspan="2">
                        ${data.ZhiWu_13003 }
                </td>
                <td class="title">是否进行了经济责任审计</td>
                <td colspan="1" >
                    <c:choose><c:when test="${data.hasAudit_13003=='1'}">是</c:when><c:otherwise>否</c:otherwise></c:choose>
                </td>
            </tr>
            <tr>
                <td class="title">注册地</td>
                <td colspan="2">
                        ${data.ZhuCeDi_13003 }
                </td>
                <td class="title">注册资本</td>
                <td colspan="1">
                        ${data.ZhuCeZiBen_13003 }(万元) 人民币
                </td>
            </tr>
            <tr>
                <td class="title">成立时间</td>
                <td colspan="2">
                  <%=cldate %>
                </td>
                <td class="title">法定代表人</td>
                <td colspan="1">
                   ${data.FaRen_13003 }
                </td>
            </tr>
            <tr>
                <td class="title">所属行业</td>
                <td colspan="4">
                  ${data.HangYeType_13003}

                </td>
            </tr>
            <tr>
                <td class="title">金融类所属行业</td>
                <td colspan="4">
                    ${data.IndustryCName_13003}
                </td>
            </tr>
            <tr>
                <td class="title">公司类型(经济性质)</td>
                <td colspan="2">
                    <c:if test="${data.CompanyLeiXing_13003=='A19001'}">全民所有制企业</c:if>
                    <c:if test="${data.CompanyLeiXing_13003=='A19002'}">有限责任公司</c:if>
                    <c:if test="${data.CompanyLeiXing_13003=='A19003'}">股份有限公司</c:if>
                    <c:if test="${data.CompanyLeiXing_13003=='A19004'}">集体所有制企业</c:if>
                    <c:if test="${data.CompanyLeiXing_13003=='A19005'}">合伙企业</c:if>
                    <c:if test="${data.CompanyLeiXing_13003=='A19006'}">其他</c:if>
                </td>
                <td class="title">企业性质(经济类型)</td>
                <td colspan="1">
                    <c:if test="${data.CompanyXingZhi_13003=='A05001'}">国资监管机构/政府部门</c:if>
                    <c:if test="${data.CompanyXingZhi_13003=='A05002'}">国有独资公司（企业）/国有全资企业</c:if>
                    <c:if test="${data.CompanyXingZhi_13003=='A05003'}">国有控股企业</c:if>
                    <c:if test="${data.CompanyXingZhi_13003=='A05004'}">国有事业单位，国有社团等</c:if>
                    <c:if test="${data.CompanyXingZhi_13003=='A05010'}">国有实际控制企业</c:if>
                    <c:if test="${data.CompanyXingZhi_13003=='A05006'}">国有参股企业</c:if>
                    <c:if test="${data.CompanyXingZhi_13003=='A05007'}">非国有企业</c:if>
                    <c:if test="${data.CompanyXingZhi_13003=='A05008'}">外资企业</c:if>
                    <c:if test="${data.CompanyXingZhi_13003=='A05009'}">其他</c:if>
                </td>
            </tr>
            <tr>
                <td class="title">企业组织机构代码</td>
                <td colspan="2">${data.UnitOrgNum_13003 }</td>
                <td class="title">经营规模</td>
                <td colspan="1">
                    <c:if test="${data.GuiMo_13003=='0'}">大型</c:if>
                    <c:if test="${data.GuiMo_13003=='1'}">中型</c:if>
                    <c:if test="${data.GuiMo_13003=='2'}">小型</c:if>
                    <c:if test="${data.GuiMo_13003=='3'}">微型</c:if>
                </td>
            </tr>
            <tr>
                <td class="title">经营范围</td>
                <td colspan="4">
                    <input class="easyui-textbox" style="height:80px;width: 100%" data-options="multiline:true"
                            value="${data.JingYingFanWei_13003 }" readonly>
                </td>
            </tr>
            <tr>
                <td class="title">受让资格陈述</td>
                <td colspan="4">
                    <input class="easyui-textbox" style=" height:80px;width: 100%" data-options="multiline:true"
                            value="${data.ShouRangZiGe_13003}" readonly>
                </td>
            </tr>
            <tr>
                <td class="title">近期资产情况</td>
                <td colspan="5">
                    <table border="1" width="100%">
                        <thead>
                        <tr>
                            <td class="title">数据来源</td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td class="title">报表日期</td>
                            <td><%=bbdate %>
                            </td>
                        </tr>
                        <tr>
                            <td class="title">币种</td>
                            <td>

                            </td>
                        </tr>
                        <tr>
                            <td class="title">资产情况</td>
                            <td> 资产总计:${data.ZiChanTotal}(万元);
                                负债总计:${data.FuZhaiTotal}(万元);
                                净资产:${data.JingZiChan}(万元)
                            </td>
                        </tr>
                        </thead>
                    </table>
                </td>
            </tr>
            <!-- 单位信息 end -->
        </c:if>
        <c:if test="${user_type==1 }">
            <!-- 个人会员信息 begin -->
            <tr>
                <td class="title" rowspan="6" id="row_geren">基本情况</td>
                <td class="title">受让方名称</td>
                <td colspan="2">${data.DanWeiName }</td>
                <td class="title">所在地区</td>
                <td colspan="1" id="area">${data.AreaName }</td>
            </tr>

            <tr>
                <td colspan="5"><input name="info['IsManagerLayer']" type="checkbox" id="managerLayer_geren"
                                       <c:if test="${data.IsManagerLayer=='1'}">checked</c:if>>标的企业管理层直接或间接出资
                </td>
            </tr>
            <tr id="zhiwu_div" style="display: none;">
                <td class="title">职务</td>
                <td colspan="2">
                    <input class="easyui-textbox" name="info['ZhiWu']" type="text" id="zhi_wu" value="${data.ZhiWu }" placeholder="请输入职务"/>
                </td>
                <td class="title">是否进行了经济责任审计</td>
                <td colspan="1" >
                    <input type="radio" value="1" name="info['hasAudit']" <c:if test="${empty data.hasAudit or data.hasAudit=='1'}">checked="true"</c:if>>是
                    <input type="radio" value="0" name="info['hasAudit']" <c:if test="${data.hasAudit=='0'}">checked="true"</c:if>>否
                </td>
            </tr>
            <tr>
                <td class="title">证件名称</td>
                <td colspan="2"><input class="easyui-textbox" name="info['ZhengName']" type="text"
                                       value="${data.ZhengName }"/></td>
                <td class="title">证件号码</td>
                <td colspan="1"><input class="easyui-textbox" name="info['ZhengNo']" type="text" id="zheng_No"
                                       value="${data.ZhengNo }"/></td>
            </tr>
            <tr>
                <td class="title">工作单位</td>
                <td colspan="4"> <input class="easyui-textbox" name="info['GongZuoDanWei']" type="text" value="${data.GongZuoDanWei }"/></td>
            </tr>
            <tr>
                <td class="title">资金来源</td>
                <td colspan="4">
                    <input type="radio" value="0" name="info['ZiJinLaiYuan']" <c:if test="${data.ZiJinLaiYuan=='0'}">checked="true"</c:if>>自有
                    <input type="radio" value="1" name="info['ZiJinLaiYuan']" <c:if test="${data.ZiJinLaiYuan=='1'}">checked="true"</c:if>>融资
                    <input type="radio" value="2" name="info['ZiJinLaiYuan']" <c:if test="${data.ZiJinLaiYuan=='2'}">checked="true"</c:if>>其他
                </td>
            </tr>
            <tr>
                <td class="title">个人资产申报</td>
                <td colspan="4">
                    <input class="easyui-textbox" style="width:100%; height:80px;" data-options="multiline:true"  name="info['GeRenZiChan']" value="${data.GeRenZiChan }">
                </td>
            </tr>
            <!-- 个人会员信息 end -->
        </c:if>
        <tr>
            <td class="title">是否标的公司原股东</td>
            <td colspan="5">
                        <c:if test="${ data.hasPriority=='1'}">是</c:if>
                        <c:if test="${empty data.hasPriority || data.hasPriority=='0'}">否</c:if>
            </td>
        </tr>
        <tr>
            <td class="title">受让意愿</td>
            <td colspan="5">
                受让底价${data.ShouRangDiJia_13003}(万元)
                <c:if test="${data.ZhuanRangType eq '1'}">;&nbsp;&nbsp;&nbsp;拟受让比例${data.ShouRangPercent_13003 }%</c:if>
                <c:if test="${data.ZhuanRangType ne '1'}">;&nbsp;&nbsp;&nbsp;拟受让股份${data.ShouRangGuFen_13003 }</c:if>
            </td>
        </tr>
        <tr>
            <td class="title">联系人</td>
            <td colspan="3">${data.LianXiUser_13003 }</td>
            <td class="title">联系电话</td>
            <td colspan="2">${data.LianXiTel_13003 }</td>
        </tr>
        <tr>
            <td class="title">电子邮箱</td>
            <td colspan="3">
                ${data.Email_13003 }
            </td>
            <td class="title">传真号码</td>
            <td colspan="2">${data.ChuanZhen_13003 }
            </td>
        </tr>
        <tr>
            <td class="title">资信证明</td>
            <td colspan="5">${data.ZiXinZhengMing_13003 }
            </td>
        </tr>
        <tr>
            <td class="title" rowspan="3">委托会员</td>
            <td class="title">机构名称</td>
            <td colspan="2">
                ${data.BelongDLJGName_13003 }
            </td>
            <td class="title">工位号</td>
            <td colspan="1">
                ${data.GongWeiNo_13003 }
            </td>
        </tr>
        <tr>
            <td class="title">经纪人</td>
            <td colspan="2">
                ${data.JingJiRen_13003 }
            </td>
            <td class="title">经纪人编码</td>
            <td colspan="1">
                ${data.JingJiRenCode_13003 }
            </td>
        </tr>
        <tr>
            <td class="title">联系人</td>
            <td colspan="2">
                ${data.LianXiRen_13003 }
            </td>
            <td class="title">联系电话</td>
            <td colspan="1">
                ${data.JGLianXiTel_13003 }
            </td>
        </tr>
        <tr>
            <td colspan="6">
                <table  width="100%" border="1px">
                <tbody>
                <tr>
                    <td  width="10%" align="center" class="title">序号</td>
                    <td class="title" width="45%" align="center">联合受让方名称</td>
                    <c:if test="${data.ZhuanRangType=='1'}">
                        <td align="center"  width="45%" class="title">拟受让比例（%）</td>
                    </c:if>
                    <c:if test="${data.ZhuanRangType=='2'}">
                        <td align="center"  width="45%" class="title">拟受让股份（股）</td>
                    </c:if>
                </tr>
                <c:forEach items="${data.unionList}" var="union" varStatus="vs">
                    <tr>
                        <td  align="center">${vs.index+1 }</td>
                        <td align="center">${union.ShouRangName}</td>
                        <c:if test="${data.ZhuanRangType=='1'}">
                            <td  align="center">${union.ShouRangPercent }</td>
                        </c:if>
                        <c:if test="${data.ZhuanRangType=='2'}">
                            <td align="center">${union.ShouRangGufen }</td>
                        </c:if>
                    </tr>
                    <input type="hidden" value="${union.RowGuid}">
                </c:forEach>
                </tbody>
            </table>
            </td>
        </tr>
        <tr>
            <td class="title" >相关附件</td>
            <td colspan="5">
                <table border="1px" width="100%">
                    <tbody>
                    <tr>
                        <td class="title" align="center">电子件名称</td>
                        <td class="title" align="center">电子件列表(点击查看)</td>
                    </tr>
                    <c:forEach items="${filelist}" var="file">
                    <tr>
                        <td align="center">${file.FileName}</td>
                        <td align="center" id="${file.FileCode}" need="${file.IsMustNeed}"></td>
                    </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </td>
        </tr>
        </thead>
    </table>

</form>
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
    <c:if test="${auditStatus.AuditStatus=='3' }">
    <a href="javascript:printHZ('${params.RowGuid }','gq')" class="weui-btn weui-btn_mini weui-btn_primary">打印回执</a>
    </c:if>


</body>
</html>
