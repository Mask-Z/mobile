<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">

<head>

<jsp:include page="mate.jsp"></jsp:include>
    <link rel="stylesheet" type="text/css" href="css/jquery-weui.css">
    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    <link rel="stylesheet" href="m/css/index.css">
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="js/bm.js"></script>

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

    $(function () {

<%--console.log(${data.RowGuid });--%>
//        $("#area").cityPicker({
//            title: "所在地区",
//            onChange: function(picker,values,displayValues){
//                areaCode = values[2];
//                areaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2];
//                $("#area_code").val(areaCode);
//                $("#area_name").val(areaName);
//            }
//        });


        newimg();
        function newimg() {
            $("#authimg").attr("src", "authimg?" + new Date().getTime());
        }

        $("#authimg").click(function () {
            newimg();
        })

        var $tooltips = $('.js_tooltips');
        $("#pj_sign_hyjg").on("click", function () {
            $("#jmrlx_select_div").fadeIn(200);
        });

        $("input:radio[name='sshyjg']").change(function () {
            $("#BelongDLJGName").val($(this).attr("hyname"));
            $("#sshyjh_value_div").text($(this).attr("hyname"));

            $("#BelongDLJGGuid").val($(this).val());
        });

        $("#hyjg_sel_ok").on("click", function () {
            $("#jmrlx_select_div").fadeOut(200);
        });

        $("#hyjg_sel_cancel").on("click", function () {
            $("#jmrlx_select_div").fadeOut(200);
        });

        /**
                           报名保存
         **/
        $("#btn_save").click(function () {
            if ($tooltips.css('display') != 'none') return;
            var flag = true;
            var lxtel = $("#lxdh").val();
            var lxr = $("#lxr").val();
            var diqu=$("#area_code").val();
            var type='${user_type }';

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
                        flag = false;
                    }
                }
            }

            if (!isPhoneNo(lxtel)) {
                $tooltips.html("联系电话格式不正确!");
                flag = false;
            }
            if ($.trim(lxtel) === "") {
                $tooltips.html("联系电话不能为空!");
                flag = false;
            }

            if ($.trim(lxr) === "") {
                $tooltips.html("联系人不能为空!");
                flag = false;
            }
            if (type === 0 &&( diqu === ''||diqu === '请选择')) {
                $tooltips.html("所在地区必填");
                flag = false;
            }


            if(!flag){
                $tooltips.css('display', 'block');
                setTimeout(function(){
                    $tooltips.css('display', 'none');
                }, 2000);
                return;
            }
            var param = $("#user_reg_1_form").serialize();
            $.ajax({
                type: "POST",
                url: "pj_sign_up_submit",
                dataType: "json",
                data: param,
                success: function (msg){
                    if(msg){
                        if (msg.code == 0){
                            $("#toast_div").text("报名成功");
                            $('#loadingToast').fadeIn(100);
                            window.location.href = "pj_sign_up_view?infoid=${ProjectGuid}&type=ZT&bmguid=${data.RowGuid }";
                        }else {
                            $("#toast_div").text(msg.msg);
                            $('#loadingToast').fadeIn(100);
                        }
                        $('#loadingToast').fadeOut(100);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
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
     * 附件加载
     */
    var task_code = "CQJY_BaoMingZT";
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
                        $("div[name='init_files']").each(function(){
                            $(this).html("");
                        });
                        for(var i=0;i<files.length;i++){
                            var code = files[i].type;
                            var list = files[i].fileList;
                            $("#"+code).html("");
                            for(var j=0;j<list.length;j++){
//                                var html = "<p><span><a href=\"javascript:openfj('"+list[j].RowGuid+"')\">"+list[j].AttachFileName+"</a></span><a href=\"javascript:del('"+list[j].RowGuid+"');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a></p>";
//                                $("#"+code).append(html);
                                var html = "<p><span><a target='_blank' href=\""+list[j].url+"\">"+list[j].AttachFileName+"</a></span><a href=\"javascript:del('"+list[j].RowGuid+"');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a></p>";
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

    /**
                附件下载
     **/
    function openfj(guid){
        window.location.href = "${bm_file_download}"+guid;
    }
    
    var r = 0;
    function reinitIframe() {
        var iframe_1 = document.getElementById("myiframe");

        try {
            var bHeight = iframe_1.contentWindow.document.body.scrollHeight;
            var dHeight = iframe_1.contentWindow.document.documentElement.scrollHeight;
            var height = Math.max(bHeight, dHeight);
            if (height - r > 10) {
                r = height;
                iframe_1.height = height;
            }

        } catch (ex) {
        }
    }

    window.setInterval("reinitIframe()", 1000);
</script>
<script type="text/javascript" src="js/city-picker.js"></script>
<header class="h43">
    <div class="index-header">
        <a href="pj_list_cqjy?table=ztbm" class="back"></a>
        <div class="title">项目报名</div>
    </div>
</header>

<form id="user_reg_1_form">
        <input type="hidden" name="bmguid" value="${bmguid}"><!-- 修改时,被修改的报名guid,新增时该只为空 -->
        <input type="hidden" name="info['type']" value="ZT"><!-- 请求接口类型-->
        <input type="hidden" name="info['systemType']" value="ZT"><!-- 业务类型 -->
        <input type="hidden" name="info['OprationType']" value="add"><!-- 操作类型 -->
        <input type="hidden" name="info['RowGuid']" value="${data.RowGuid }"><!-- 报名唯一标识 -->
        <input type="hidden" name="info['UserGuid']" value="${data.UserGuid }"><!-- 竞买人guid -->
        <input type="hidden" name="info['DanWeiGuid']" value="${data.DanWeiGuid }"><!-- 单位guid -->
        <input type="hidden" name="info['ZhuanTingGuid']" value="${ZhuanTingGuid }"><!-- 专厅guid -->
        <input type="hidden" name="info['DisplayName']" value="${data.DisplayName }"><!-- 显示名称 -->
        <input type="hidden" name="info['IsBMNeedFile']" value="${data.IsBMNeedFile }"><!-- 是否必须上传电子件 -->
        <input type="hidden" name="info['BelongXiaQuCode']" value="${data.BelongXiaQuCode }"><!-- 所属地区 -->
        <input type="hidden" name="info['XiaQuCode']" value="${data.XiaQuCode }"><!-- 机构代码 -->
        <input type="hidden" name="info['DanWeiName']" value="${data.DanWeiName }"><!-- 单位名称 -->
        <input type="hidden" name="info['IsGuoZi']" value="${data.IsGuoZi }"><!-- 是否国资 -->
        <input type="hidden" name="info['FaRenType']" value="${data.FaRenType }"><!-- 法人类型 -->
        <input type="hidden" name="info['GuoZiJianGuanType']" value="${data.GuoZiJianGuanType }"><!-- 国资监管类型 -->
        <input type="hidden" name="info['YQGuoZiJG']" value="${data.YQGuoZiJG }"><!-- 央企国资机构 -->
        <input type="hidden" name="info['FYQGuoZiJG']" value="${data.FYQGuoZiJG }"><!-- 非央企国资机构 -->
        <input type="hidden" name="info['ZhuGuanJiTuan']" value="${data.ZhuGuanJiTuan }"><!-- 主管集团 -->
        <input type="hidden" name="info['ZhuGuanJiTuanCode']" value="${data.ZhuGuanJiTuanCode }"><!-- 主管集团代码 -->
        <input type="hidden" name="info['AreaName']" value="${data.AreaName }" id="area_name" ><!-- 地区名称 -->
        <input type="hidden" name="info['AreaCode']" value="${data.AreaCode }" id="area_code" ><!-- 地区代码 -->
        <input type="hidden" name="info['ZhuCeDi']" value="${data.ZhuCeDi }"><!-- 注册地 -->
        <input type="hidden" name="info['FaRen_13003']" value="${data.FaRen_13003 }"><!-- 法人 -->
        <input type="hidden" name="info['HangYeType']" value="${data.HangYeType }"><!-- 所属行业 -->
        <input type="hidden" name="info['HangYeTypeCode']" value="${data.HangYeTypeCode }"><!-- 所属行业代码 -->
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
        <input type="hidden" name="info['ZhuCeZiBen']" value="${data.ZhuCeZiBen }"><!-- 注册资本 -->
        <input type="hidden" name="info['UnitOrgNum']" value="${data.UnitOrgNum }"><!-- 组织机构代码 -->
        <input type="hidden" name="info['DanWeiXingZhi']" value="${data.DanWeiXingZhi }"><!-- 单位性质 -->
        <input type="hidden" name="info['YingYeZhiZhaoNo']" value="${data.YingYeZhiZhaoNo }"><!-- 营业执照号码 -->
        <input type="hidden" name="info['BZJIsjiaoNa']" value="${data.BZJIsjiaoNa }"><!-- 保证金是否缴纳 -->
        <input type="hidden" name="info['JiaoNaEndDate']" value="${data.JiaoNaEndDate }"><!-- 保证金缴纳截至日期 -->
        <input type="hidden" name="info['ZhuanTingName']" value="${data.ZhuanTingName }"><!-- 专厅名称 -->
        <input type="hidden" name="info['FaRen_3008']" value="${data.FaRen_3008 }"><!-- 法定代表人 -->
        <input type="hidden" name="info['UserID']" value="${data.UserID }"><!-- 法人身份证号码 -->
        <input type="hidden" name="info['IpAddress']" value="${data.IpAddress }"><!-- Ip地址 -->

<div class="weui-toptips weui-toptips_warn js_tooltips" id="js_tooltips"></div>
    <div class="weui-cells weui-cells_form no-mt">
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">专厅名称</label></div>
            <div class="weui-cell__bd">${data.lblZhuanTingName}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">竞买人</label></div>
            <div class="weui-cell__bd">${data.lblDanWeiName}
            </div>
        </div>
        <%--<div class="weui-btn-area">--%>
            <%--<a class="weui-btn weui-btn_primary" href="infodetail?infoid=${ProjectGuid}" >查看网站公告原文</a>--%>
        <%--</div>--%>
        <c:if test="${user_type==1 }">
        <!-- 个人会员信息 begin -->

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">会员类型</label></div>
            <div class="weui-cell__bd">
                <c:if test="${data.FaRenType eq '1'}">企事业单位</c:if>
                <c:if test="${data.FaRenType eq '2'}">自然人</c:if>
            </div>
        </div>
        <div class="weui-cells__title">基本情况</div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">证件名称</label></div>
            <div class="weui-cell__bd">${data.ZhengName}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">证件号码</label></div>
            <div class="weui-cell__bd">${data.ZhengNo}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">工作单位</label></div>
            <div class="weui-cell__bd">${data.GongZuoDanWei}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">职务</label></div>
            <div class="weui-cell__bd">${data.ZhiWu}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label" >资金来源<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <c:if test="${data.ZiJinLaiYuan==0}">自有</c:if>
                <c:if test="${data.ZiJinLaiYuan==1}">融资</c:if>
                <c:if test="${data.ZiJinLaiYuan==2}">其他</c:if>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">个人资产申报<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">${data.GeRenZiChan}
            </div>
        </div>
        <!-- 个人会员信息 end -->
        </c:if>


        <c:if test="${user_type==0 }">
        <!-- 单位信息 begin -->


        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">企业性质</label></div>
            <div class="weui-cell__bd">${data.lblDanWeiXingZhi}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
            <div class="weui-cell__bd">${data.lblUnitOrgNum}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">国资类型<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <c:if test="${data.IsGuoZi eq 'T'}">国资</c:if>
                <c:if test="${data.IsGuoZi eq 'F'}">非国资</c:if>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">法人类型<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <c:if test="${data.FaRenType eq '1'}">企事业单位</c:if>
                <c:if test="${data.FaRenType eq '2'}">自然人</c:if>
            </div>
        </div>

        <div class="weui-cells__title">基本情况</div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">所在地区<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">${data.AreaName}
            </div>
            <%--<div class="weui-cell__bd">--%>
                <%--<input class="weui-input" id="area" type="text" value="${data.AreaName.replace("·"," ")}" >--%>
            <%--</div>--%>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">注册地<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">${data.ZhuCeDi}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">注册资本(万元)</label></div>
            <div class="weui-cell__bd">${data.ZhuCeZiBen}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">公司类型(经济性质)<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">${data.gsType_name}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">经济类型<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">${data.JingJiType_name}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">法定代表人<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">${data.FaRen_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">所属行业<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">${data.HangYeType}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">经济规模<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">${data.GuiMo_name}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">工商注册号</label></div>
            <div class="weui-cell__bd">${data.GongShangHao}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">经营范围</label></div>
            <div class="weui-cell__bd">${data.JingYingFanWei}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">受让资格陈述</label></div>
            <div class="weui-cell__bd">${data.ShouRangZiGe}
            </div>
        </div>

        <!-- 单位信息 end -->
        </c:if>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">联系人<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['LianXiUser']" value="${data.LianXiUser }" placeholder="请输入联系人" id="lxr">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">联系电话<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['LianXiTel']" value="${data.LianXiTel }" placeholder="请输入联系电话" id="lxdh" type="number">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">电子邮箱</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['Email']" value="${data.Email }" placeholder="请输入电子邮箱" id="dzyx">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">传真号码</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['ChuanZhen']" value="${data.ChuanZhen }" placeholder="请输入传真号码">
            </div>
        </div>

        <div class="weui-cells__title">相关附件</div>

        <c:forEach items="${filelist}" var="file">

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

        </c:forEach>


</div>
</form>

<div class="weui-cells__title">标的列表</div>


<div class="weui-cell bgff">
    <iframe src='iframeData?ZhuanTingGuid=${ZhuanTingGuid}' width="100%"  id="myiframe" scrolling="no" frameborder="0" ></iframe>
</div>


<div class="weui-btn-area">
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_save">确定</a>
</div>

<div class="js_dialog" id="jmrlx_select_div" style="display: none;height: 400px;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
        <div class="weui-dialog__hd" style="height: 30px"><strong class="weui-dialog__title">所属会员机构</strong></div>
        <div class="weui-dialog__bd" style="height: 330px;overflow-y:scroll;">
            <div class="weui-cells weui-cells_radio">
                <c:forEach items="${sshyjg }" var="hyjg" varStatus="jg">
                    <label class="weui-cell weui-check__label" for="x${jg.index }"
                           style="text-align: left;font-size: 14px">
                        <div class="weui-cell__bd">
                            <p>${hyjg.name }</p>
                        </div>
                        <div class="weui-cell__ft">
                            <input type="radio" class="weui-check" hyname="${hyjg.name }" value="${hyjg.guid }"
                                   name="sshyjg" name="info['Email']"
                                   id="x${jg.index }">
                            <span class="weui-icon-checked"></span>
                        </div>
                    </label>
                </c:forEach>
            </div>
        </div>
        <div class="weui-dialog__ft">
            <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_default" id="hyjg_sel_cancel">取消</a>
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
