<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">

<head>

    <jsp:include page="mate.jsp"></jsp:include>
    <link rel="stylesheet" href="m/css/index.css">
    <link rel="stylesheet" type="text/css" href="css/jquery-weui.css">
    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">

    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="js/bm.js"></script>
    <script type="text/javascript" src="js/jquery-weui.js"></script>
    <script type="text/javascript" src="m/js/DateOp.js"></script>
</head>

<body>

<script type="text/javascript">
    +function (a) {
        a.rawCitiesData = ${citys};
    }($);

    $(function () {


        //根据国资监管类型显示不同内容
        var jianGuan_type = $("#jianGuan_type").val();
        if (jianGuan_type == '0') {
            $("#yq_guoZiRegulator_div").show();
            $("#belongArea_province_div").hide();
            $("#belongArea_city_div").hide();
            $("#belongArea_district_div").hide();
            $("#fyq_regulator_div").hide();
        } else {
            $("#yq_guoZiRegulator_div").hide();
            $("#belongArea_province_div").show();
            $("#belongArea_city_div").show();
            $("#belongArea_district_div").show();
            $("#fyq_regulator_div").show();
        }

        //根据是否国资显示不同内容
        var guoZi_type = $("#guoZi_type").val();
        console.log("guoZi_type: "+guoZi_type);
        if (guoZi_type == 'F') {
            $("#jianGuan_type_div").hide();
            $("#yq_guoZiRegulator_div").hide();
            $("#belongArea_province_div").hide();
            $("#belongArea_city_div").hide();
            $("#belongArea_district_div").hide();
            $("#fyq_regulator_div").hide();
            $("#bu_menName_div").hide();
            $("#ji_gouCode_div").hide();
        } else {
            $("#jianGuan_type_div").show();
            $("#bu_menName_div").show();
            $("#ji_gouCode_div").show();
            var jianGuan_type = $("#jianGuan_type").val();
            if (jianGuan_type == '0') {
                $("#yq_guoZiRegulator_div").show();
                $("#belongArea_province_div").hide();
                $("#belongArea_city_div").hide();
                $("#belongArea_district_div").hide();
                $("#fyq_regulator_div").hide();
            } else {
                $("#yq_guoZiRegulator_div").hide();
                $("#belongArea_province_div").show();
                $("#belongArea_city_div").show();
                $("#belongArea_district_div").show();
                $("#fyq_regulator_div").show();
            }
        }
        $("#danWei_guid").val('${loginAccount.danWeiGuid}');
        $("#user_guid").val('${loginAccount.userGuid}');
        /**
         * 成立时间格式化
         * @type {string}
         */
        var FoundDate='${userInfo.FoundDate}';
        $('#foundDate').val(DateOp.strToDate2(FoundDate));


//        $("#belongArea_province_div").hide();
        $("#belongArea_city_div").hide();
        $("#belongArea_district_div").hide();
//        $("#fyq_regulator_div").hide();

        var $tooltips = $('.js_tooltips');
        var $danWei_name = $('#danWei_name');
        var $danWei_name2 = $('#danWei_name2');
        var $unitOrgNum = $('.unitOrgNum');
        var $unitOrgNum2 = $('#unitOrgNum2');
        var $registerZiBen = $('.registerZiBen');
        var $foundDate = $('.foundDate');
        var $registerNum = $('.registerNum');
        var $jingYingRange = $('.jingYingRange');
        var $local_mobile = $('#local_mobile');
        var $address = $('.address');
        var $jinMaiRenValue = $('#jinMai_ren_value');

        //开户账号名称随姓名一起变化
        $danWei_name.on('change',function () {
            $("#kaiHu_name").val($danWei_name.val());
        });

        $('#btn_save').on('click', function () {

            var guoZi_type = $("#guoZi_type").val();//是否国资

            if ($tooltips.css('display') != 'none') return;//防止多次提交

            var flag = true;

            if ($.trim($("#bank_area_code").val()) == '') {//开户行所在地
                $tooltips.html('开户行所在地不能为空');
                flag = false;
            }

            if ($('#kaiHu_bank').val() == '') {
                $tooltips.html('开户行不能为空');
                flag = false;
            }

            if ($('#kaiHu_account').val() == '') {
                $tooltips.html('开户账号不能为空');
                flag = false;
            }

            if ($.trim($jinMaiRenValue.val()) == '') {
                $tooltips.html('竞买方类别不能为空');
                flag = false;
            }

            if ($.trim($address.val()) == '') {
                $tooltips.html('详细地址不能为空');
                flag = false;
            }

            if (!isPhoneNo($.trim($local_mobile.val()))) {
                $tooltips.html('手机号码格式不正确');
                flag = false;
            }

            if ($.trim($local_mobile.val()) == '') {
                $tooltips.html('手机号不能为空');
                flag = false;
            }

            if ($.trim($jingYingRange.val()) == '') {
                $tooltips.html('经营范围不能为空');
                flag = false;
            }
            if ($.trim($registerNum.val()) == '') {
                $tooltips.html('工商注册号不能为空');
                flag = false;
            }

            if ($.trim($("#faDingDaiBiao").val()) == '') {
                $tooltips.html('法定代表人不能为空');
                flag = false;
            }

            <%--console.log("date: " + $.trim($foundDate.val()));--%>
            <%--console.log("接收短信提醒", ${userInfo.IsReceiveMessage});--%>
            <%--console.log("竞买人类别",${userInfo.JinMaiRenValue});--%>
            <%--alert(${userInfo.JinMaiRenValue});--%>
            if ($.trim($foundDate.val()) == '') {
                $tooltips.html('成立时间不能为空');
                flag = false;
            }

            if ($.trim($registerZiBen.val()) == '') {
                $tooltips.html('注册资本不能为空');
                flag = false;
            }

            if ($.trim($("#suoZai_area_code").val()) == '') {//所在地区
                $tooltips.html('所在地区不能为空');
                flag = false;
            }

            if (guoZi_type === "T") {//国资需要验证

                var jianGuan_type = $("#jianGuan_type").val();

                if (jianGuan_type === "0") {//央企需要验证

                    if ($.trim($("#zgdwmc").val()) == '') {
                        $tooltips.html('主管单位名称不能为空');
                        flag = false;
                    }

                } else if (jianGuan_type === "1") {//非央企需要验证

                    if ($.trim($("#belong_area_name").val()) == '') {
                        $tooltips.html('国资监管机构地区不能为空!');
                        flag = false;
                    }
                }
            }


            var unitOrgNum = $.trim($unitOrgNum.val());
            var unitOrgNum2 = $.trim($unitOrgNum2.val());

            if (unitOrgNum !=unitOrgNum2){
                $tooltips.html('组织机构代码和组织机构代码不一致');
                flag = false;
            }

            if (unitOrgNum2 == '') {
                $tooltips.html('组织机构代码确认不能为空');
                flag = false;
            }
            if (unitOrgNum.length !== 9 && unitOrgNum.length !== 18) {

                $tooltips.html('组织机构代码只能为9位或者18位');
                flag = false;
            }

            if (unitOrgNum == '') {
                $tooltips.html('组织机构代码不能为空');
                flag = false;
            }

            if ($.trim($danWei_name2.val()) != $.trim($danWei_name.val())){
                $tooltips.html('单位名称和单位名称确认不一致');
                flag = false;
            }

            if ($.trim($danWei_name2.val()) == '') {
                $tooltips.html('单位名称确认不能为空');
                flag = false;
            }

            if ($.trim($danWei_name.val()) == '') {
                $tooltips.html('单位名称不能为空');
                flag = false;
            }


            if (!flag) {
                $tooltips.css('display', 'block');
                setTimeout(function () {
                    $tooltips.css('display', 'none');
                }, 2000);
                return;
            }

            $('#register_loading_toast').fadeIn(100);

            //注册资本如果未整数,需要加.00,改成小数
            if ($.trim($registerZiBen.val()) != '') {
                var money = $.trim($registerZiBen.val());
                if (money.indexOf('.') == -1) {
                    $(".registerZiBen").val(money + ".00");
                }
            }

            if ($("#accept_message").is(':checked')) {
                $("#is_receive_message").val("0");
            } else {
                $("#is_receive_message").val("1");
            }

            $("#belong_industry").val($("#belong_industry_code").find("option:selected").text());

            var bankAreaCode = '';
            var bankAreaName = '';
            var belongAreaCode = '';
            var belongAreaName = '';
            var areaCode = '';
            var areaName = '';
            var suoZaiAreaCode = '';
            var suoZaiAreaName = '';

            var data = $("#unit_reg_2_form").serialize();

            $.ajax({
                type: "POST",
                url: "unit_info_update",
                dataType: "json",
                data: data,
                success: function (result) {
                    if (result.msg == "") {
                        $("#toast_div").text("信息修改成功");
                        setTimeout(function () {
                            $('#register_loading_toast').fadeOut(100);
                            location.href = "getUserInfo";
                        }, 1000);
                    } else {
                        $('#register_loading_toast').fadeOut(100);
                        $tooltips.html(result.msg);
                        $tooltips.css('display', 'block');
                        setTimeout(function () {
                            $tooltips.css('display', 'none');
                        }, 5000);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }
            });
        });

        $("#guoZi_type").on("change", function (e) {
            var guoZi_type = $("#guoZi_type").val();
            console.log(guoZi_type);
            if (guoZi_type == 'F') {
                $("#jianGuan_type_div").hide();
                $("#yq_guoZiRegulator_div").hide();
                $("#belongArea_province_div").hide();
                $("#belongArea_city_div").hide();
                $("#belongArea_district_div").hide();
                $("#fyq_regulator_div").hide();
                $("#bu_menName_div").hide();
                $("#ji_gouCode_div").hide();
            } else {
                $("#jianGuan_type_div").show();
                $("#bu_menName_div").show();
                $("#ji_gouCode_div").show();
                var jianGuan_type = $("#jianGuan_type").val();
                if (jianGuan_type == '0') {
                    $("#yq_guoZiRegulator_div").show();
                    $("#belongArea_province_div").hide();
                    $("#belongArea_city_div").hide();
                    $("#belongArea_district_div").hide();
                    $("#fyq_regulator_div").hide();
                } else {
                    $("#yq_guoZiRegulator_div").hide();
                    $("#belongArea_province_div").show();
                    $("#belongArea_city_div").show();
                    $("#belongArea_district_div").show();
                    $("#fyq_regulator_div").show();
                }
            }
        });

        $("#jianGuan_type").on("change", function (e) {
            var jianGuan_type = $("#jianGuan_type").val();
            if (jianGuan_type == '0') {
                $("#yq_guoZiRegulator_div").show();
                $("#belongArea_province_div").hide();
                $("#belongArea_city_div").hide();
                $("#belongArea_district_div").hide();
                $("#fyq_regulator_div").hide();
            } else {
                $("#yq_guoZiRegulator_div").hide();
                $("#belongArea_province_div").show();
                $("#belongArea_city_div").show();
                $("#belongArea_district_div").show();
                $("#fyq_regulator_div").show();
            }
        });

        $("#unit_reg_jmr_select").on("click", function () {
            $("#jmr_select_div").fadeIn(200);
        });


        /**
         * 获取竞买人类型 start
         * @type {string}
         */
        var jinMaiRen = "";
        var jinMaiRenValue = "";
        $(".jmr_type").each(function () {
            if ($(this).is(':checked')) {
                jinMaiRenValue = jinMaiRenValue + $(this).val() + ";";
                jinMaiRen = jinMaiRen + $.trim($(this).parent().next().children().text()) + ";";
            }
        });
        $("#jinMai_ren").val(jinMaiRen);
        $("#jinMai_ren_value").val(jinMaiRenValue);
        $("#unit_reg_jmr_text").text(jinMaiRen);
        /**
         * 获取竞买人类型 end
         */

        $("#jmr_sel_ok").on("click", function () {
            var jinMaiRen = "";
            var jinMaiRenValue = "";
            $(".jmr_type").each(function () {
                if ($(this).is(':checked')) {
                    jinMaiRenValue = jinMaiRenValue + $(this).val() + ";";
                    jinMaiRen = jinMaiRen + $.trim($(this).parent().next().children().text()) + ";";
                }
            });
            $("#jinMai_ren").val(jinMaiRen);
            $("#jinMai_ren_value").val(jinMaiRenValue);
            $("#unit_reg_jmr_text").text(jinMaiRen);
            $("#jmr_select_div").fadeOut(200);

        });

        $(".jmr_type_label").on("click", function () {
            var $object = $(this).find(".jmr_type");
            var code = $object.val();
            $(".jmr_type").each(function () {
                if ($object.is(':checked')) {
                    if ($(this).val().indexOf(code) >= 0) {
                        $(this).prop("checked", true);
                    }
                } else {
                    if ($(this).val().indexOf(code) >= 0) {
                        $(this).removeAttr("checked");
                    }
                }
            });
        });

        $("#kaiHuBank_area").cityPicker({
            title: "开户行所在地",
            onChange: function (picker, values, displayValues) {
                bankAreaCode = values[2];
                bankAreaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2];
                $("#bank_area_code").val(bankAreaCode);
                $("#bank_area_name").val(bankAreaName);
            }
        });

        $("#belong_area").cityPicker({
            title: "国资监管机构地区",
            onChange: function (picker, values, displayValues) {
                belongAreaCode = values[2];
                belongAreaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2];
                $("#belong_area_code").val(belongAreaCode);
                $("#belong_area_name").val(belongAreaName);
            }
        });

        $("#area").cityPicker({
            title: "注册地",
            onChange: function (picker, values, displayValues) {
                areaCode = values[2];
                areaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2];
                $("#area_code").val(areaCode);
                $("#area_name").val(areaName);
            }
        });

        $("#suoZai_area").cityPicker({
            title: "所在地区",
            onChange: function (picker, values, displayValues) {
                suoZaiAreaCode = values[2];
                suoZaiAreaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2];
                $("#suoZai_area_code").val(suoZaiAreaCode);
                $("#suoZai_area_name").val(suoZaiAreaName);
            }
        });
    });
</script>
<script type="text/javascript" src="js/city-picker.js"></script>

<header class="h43" style="height: 27px">
    <div class="index-header">
        <a href="" class="back" onclick="window.history.back(-1);return false;"></a>
        <div class="title">单位会员详细信息完善   <a href="loginOut" style="float: right;color: #F2F2F2;padding-right: 30px">退出</a></div>
    </div>
</header>

<div class="weui-toptips weui-toptips_warn js_tooltips"></div>
<div class="weui-cells weui-cells_form">
    <form id="unit_reg_2_form">
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">会员类型</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" type="text" placeholder="单位" disabled/>
            </div>
        </div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">单位名称<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input danWeiName" name="danWeiName" id="danWei_name" type="text"
                       placeholder="请输入单位全称" value="${userInfo.DanWeiName}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">单位名称确认<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input danWeiName"  id="danWei_name2" type="text"
                       placeholder="请再次输入单位全称"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">组织机构代码<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input unitOrgNum" name="unitOrgNum" type="text" placeholder="请输入组织机构代码"
                       value="${userInfo.UnitOrgNum}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">组织机构代码确认<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input unitOrgNum"  type="text" placeholder="请再次输入组织机构代码" id="unitOrgNum2"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">法人类型</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" type="text" placeholder="企事业单位" disabled/>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">是否国资<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="guoZiType" id="guoZi_type">
                    <c:forEach items="${guoZiTypes}" var="guoZiType">
                        <option value="${guoZiType.code}" <c:if
                                test="${userInfo.rdoGuoZiType eq guoZiType.code}"> selected </c:if>>${guoZiType.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after" id="jianGuan_type_div">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">国资监管类型<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="jianGuanType" id="jianGuan_type">
                    <c:forEach items="${jianGuanTypes}" var="jianGuanType">
                        <option value="${jianGuanType.code}"<c:if
                                test="${userInfo.rdoJianGuanType  eq jianGuanType.code}"> selected </c:if> >${jianGuanType.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after" id="yq_guoZiRegulator_div">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">国资监管机构</label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="yqGuoZiRegulator">
                    <option value=""></option>
                    <c:forEach items="${yqGuoZiRegulators}" var="yqGuoZiRegulator">
                        <option value="${yqGuoZiRegulator.code}"<c:if
                                test="${userInfo.rdoYQGuoZiRegulator  eq yqGuoZiRegulator.code}"> selected </c:if> >${yqGuoZiRegulator.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cell" id="belongArea_province_div" style="display: none">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">国资监管机构地区代码<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <input class="weui-input" id="belong_area" type="text" value=" ${userInfo.belongAreaName }">
            </div>
        </div>
        <%--<script> console.log("国资监管机构地区代码: ${userInfo.belongAreaCode    }");</script>--%>
        <div class="weui-cell weui-cell_select weui-cell_select-after" id="fyq_regulator_div" style="display: none">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">国资监管机构</label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="fyqRegulator">
                    <option value=""></option>
                    <c:forEach items="${fyqRegulators}" var="fyqRegulator">
                        <option value="${fyqRegulator.code}" <c:if
                                test="${userInfo.rdoFYQRegulator  eq fyqRegulator.code}"> selected </c:if> >${fyqRegulator.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cell" id="bu_menName_div">
            <div class="weui-cell__hd"><label class="weui-label">主管单位名称<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input buMenName" name="buMenName" id="zgdwmc" type="text" placeholder="请输入主管单位名称"
                       value="${userInfo.BuMenName  }"/>
            </div>
        </div>

        <div class="weui-cell" id="ji_gouCode_div">
            <div class="weui-cell__hd"><label class="weui-label">主管单位组织机构代码</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input jiGouCode" name="jiGouCode" type="text" placeholder="请输入主管单位组织机构代码"
                       value="${userInfo.JiGouCode }"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">所在地区<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <input class="weui-input" id="suoZai_area" type="text" value="${userInfo.SuoZaiAreaName}">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">注册地</label>
            </div>
            <div class="weui-cell__bd">
                <input class="weui-input" id="area" type="text" value="${userInfo.RegisterCity}">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">注册资本（万元）<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input registerZiBen" name="registerZiBen" value="${userInfo.RegisterZiBen}"
                       type="zb" placeholder="请输入注册资本（万元）"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label for="" class="weui-label">成立时间<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <%--value="${userInfo.FoundDate}"--%>

                <%--<input class="weui-input foundDate" type="date" name="foundDate"  <fmt:parseDate value="${userInfo.FoundDate}" pattern="yyyy-MM-dd" var="masterDate"/> >--%>
                <input class="weui-input foundDate" type="date" name="foundDate" id="foundDate">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">法定代表人<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input faDingDaiBiao" id="faDingDaiBiao" name="faDingDaiBiao" type="text"
                       placeholder="请输入法定代表人" value="${userInfo.FaDingDaiBiao}"/>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">所属行业<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="belongIndustryCode" id="belong_industry_code">
                    <c:forEach items="${belongIndustrys}" var="belongIndustry">
                        <option value="${belongIndustry.code}" <c:if
                                test="${userInfo.BelongIndustry eq belongIndustry.value}"> selected </c:if> >${belongIndustry.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">公司类型（经济性质）<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="companyType">
                    <c:forEach items="${companyTypes}" var="companyType">
                        <option value="${companyType.code}"
                                <c:if test="${userInfo.CompanyType eq companyType.code}">selected</c:if>  >${companyType.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">经济类型<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="economicType">
                    <c:forEach items="${economicTypes}" var="economicType">
                        <option value="${economicType.code}"
                                <c:if test="${userInfo.EconomicType eq economicType.code}">selected</c:if> >${economicType.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">经济规模<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="economicSize">
                    <c:forEach items="${economicSizes}" var="economicSize">
                        <option value="${economicSize.code}"
                                <c:if test="${userInfo.EconomicSize eq economicSize.code}">selected</c:if>  >${economicSize.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">工商注册号<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input registerNum" name="registerNum" type="text" placeholder="请输入工商注册号"
                       value="${userInfo.RegisterNum}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">经营范围<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input jingYingRange" name="jingYingRange" type="text" placeholder="请输入经营范围"
                       value="${userInfo.JingYingRange}"/>
            </div>
        </div>

        <%--<div class="weui-cell">受让资格陈述</div>--%>
        <%--<div class="weui-cell">--%>
            <%--<div class="weui-cell__bd">--%>
                <%--<textarea class="weui-textarea" name="shouRangZiGe" rows="3"></textarea>--%>
            <%--</div>--%>
        <%--</div>--%>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">国税登记证编号</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="guoShuiNo" type="text" placeholder="请输入国税登记证编号"
                       value="${userInfo.GuoShuiNo}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">地税登记证编号</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="diShuiNO" type="text" placeholder="请输入地税登记证编号"
                       value="${userInfo.DiShuiNO}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">手机号<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input localMobile" name="localMobile" id="local_mobile" type="number"
                       placeholder="请输入手机号" value="${userInfo.LocalMobile}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">单位电话</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="localTel" type="text" placeholder="请输入单位电话"
                       value="${userInfo.LocalTel}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">电子邮箱</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="localEmail" placeholder="请输入电子邮箱" value="${userInfo.LocalEmail}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">传真</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="localFax" placeholder="请输入传真" value="${userInfo.LocalFax}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">网址</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="webAddress" placeholder="请输入网址" value="${userInfo.WebAddress}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">详细地址<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input address" name="address" placeholder="请输入详细地址" value="${userInfo.Address}"/>
            </div>
        </div>

        <div class="weui-cell weui-cell_switch">
            <div class="weui-cell__bd">接受短信提醒</div>
            <div class="weui-cell__ft">
                <input class="weui-switch" type="checkbox" id="accept_message"
                <c:if test="${userInfo.IsReceiveMessage eq '0'}"> checked</c:if> >
            </div>
        </div>
        <div class="weui-cells__tips">选择接受，则发送相关类别公告时会发送短信提醒</div>

        <div class="weui-cell weui-cell_access" id="unit_reg_jmr_select">
            <div class="weui-cell__hd">竞买方类别<font color="red">(*)</font></div>
            <div class="weui-cell__bd">
                <p id="unit_reg_jmr_text" align="left"></p>
            </div>
            <div class="weui-cell__ft" style="font-size: 0">
                <span></span>
            </div>
        </div>

        <div class="weui-cells__tips">单位简介</div>
        <div class="weui-cell">
            <div class="weui-cell__bd">
                <textarea class="weui-textarea" name="companyDes" rows="3" >${userInfo.CompanyDes}</textarea>
            </div>
        </div>

        <div class="weui-cells__tips" style="color: red;">银行账号信息[退款转账用]：必填</div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">开户账号名称</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" id="kaiHu_name" placeholder="" value="${userInfo.KaiHuName}" disabled/>
            </div>
        </div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">开户账号<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" type="khzh" name="kaiHuAccount" id="kaiHu_account" placeholder="请输入开户账号" value="${userInfo.KaiHuAccount}"/>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">开户行<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="kaiHuBank" id="kaiHu_bank">
                    <c:forEach items="${kaiHuBanks}" var="bank">
                        <option value="${bank.code}" <c:if test="${userInfo.KaiHuBank eq bank.code}">selected</c:if>   >${bank.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="weui-cell">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">开户行所在地<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <input class="weui-input" id="kaiHuBank_area" type="text" value="${userInfo.BankAreaName}">
            </div>
        </div>

        <input type="hidden" name="bankAreaName" id="bank_area_name" value="${userInfo.BankAreaName}">
        <input type="hidden" name="bankAreaCode" id="bank_area_code" value="${userInfo.BankAreaCode}">
        <input type="hidden" name="belongAreaName" id="belong_area_name" value=""><!-- 国资监管机构地区代码 -->
        <input type="hidden" name="belongAreaCode" id="belong_area_code" value="">
        <input type="hidden" name="areaName" id="area_name" value="">
        <input type="hidden" name="areaCode" id="area_code" value="">
        <input type="hidden" name="suoZaiAreaName" id="suoZai_area_name" value="${userInfo.SuoZaiAreaName}">
        <input type="hidden" name="suoZaiAreaCode" id="suoZai_area_code" value="${userInfo.SuoZaiAreaCode}">
        <input type="hidden" name="danWeiGuid" id="danWei_guid" value="">
        <input type="hidden" name="userGuid" id="user_guid" value="">
        <input type="hidden" name="isReceiveMessage" id="is_receive_message" value="">
        <input type="hidden" name="belongIndustry" id="belong_industry" value="">
        <input type="hidden" name="jinMaiRen" id="jinMai_ren" value="">
        <input type="hidden" name="jinMaiRenValue" id="jinMai_ren_value" value="">
    </form>

</div>


<div class="weui-btn-area">
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_save">保存信息</a>
</div>

<!-- 竞买方类别-->
<%int index = 0; %>
<div id="jmr_select_div" style="display:none;">
    <div class="weui-mask"></div>
    <div class="weui-dialog" style="width: 100%;height: 500px;overflow-y: scroll;">
        <div class="weui-dialog__bd" style="padding-top: 5px">
            <div class="weui-cells weui-cells_checkbox">
                <c:set var="temp1" value="${fn:split(userInfo.JinMaiRenValue,';')}"/>
                <c:forEach items="${jmrlist}" var="itm_1" varStatus="vs_1">
                    <label class="weui-cell weui-check__label jmr_type_label" for="s<%=++index %>">
                        <div class="weui-cell__hd">
                            <input type="checkbox" class="weui-check jmr_type" value="${itm_1.code }"
                                   name="jmr_checkbox" id="s<%=index %>"
                            <c:forEach items="${temp1}" var="temp2">
                            <c:if test="${temp2 eq itm_1.code}">
                                   checked
                            </c:if>
                            </c:forEach>
                            >
                            <i class="weui-icon-checked"></i>
                        </div>
                        <div class="weui-cell__bd">
                            <p align="left">${itm_1.value } </p>
                        </div>
                    </label>
                    <c:if test="${itm_1.dictList!=null && fn:length(itm_1.dictList) > 0 }">
                        <c:forEach items="${itm_1.dictList}" var="itm_2" varStatus="vs_2">
                            <label class="weui-cell weui-check__label jmr_type_label" style="padding-left: 40px"
                                   for="s<%=++index %>"">
                            <div class="weui-cell__hd">
                                <input type="checkbox" class="weui-check jmr_type" value="${itm_2.code }"
                                       name="jmr_checkbox" id="s<%=index %>"
                                <c:forEach items="${temp1}" var="temp2">
                                <c:if test="${temp2 eq itm_2.code}">
                                       checked
                                </c:if>
                                </c:forEach>
                                >
                                <i class="weui-icon-checked"></i>
                            </div>
                            <div class="weui-cell__bd">
                                <p align="left">${itm_2.value }</p>
                            </div>
                            </label>
                            <c:forEach items="${itm_2.dictList}" var="itm_3" varStatus="vs_3">
                                <label class="weui-cell weui-check__label jmr_type_label" style="padding-left: 70px"
                                       for="s<%=++index %>">
                                    <div class="weui-cell__hd">
                                        <input type="checkbox" class="weui-check jmr_type" value="${itm_3.code }"
                                               name="jmr_checkbox" id="s<%=index %>"
                                        <c:forEach items="${temp1}" var="temp2">
                                        <c:if test="${temp2 eq itm_3.code}">
                                               checked
                                        </c:if>
                                        </c:forEach>
                                        >
                                        <i class="weui-icon-checked"></i>
                                    </div>
                                    <div class="weui-cell__bd">
                                        <p align="left">${itm_3.value }</p>
                                    </div>
                                </label>
                            </c:forEach>
                        </c:forEach>
                    </c:if>
                </c:forEach>
            </div>
        </div>
        <div class="weui-dialog__ft">
            <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary" id="jmr_sel_ok">确定</a>
        </div>
    </div>
</div>

<div id="register_loading_toast" style="display:none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
        <i class="weui-loading weui-icon_toast"></i>
        <p class="weui-toast__content" id="toast_div">数据提交中</p>
    </div>
</div>

</body>
</html>
