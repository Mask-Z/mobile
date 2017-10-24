<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="js/bm.js"></script>
    <script type="text/javascript" src="js/jquery-weui.js"></script>
</head>

<body>

<script type="text/javascript">
    +function (a) {
        a.rawCitiesData = ${citys};
    }($);

    $(function () {
        console.log("userGuid: "+'${loginAccount.userGuid}');
        console.log("danWeiGuid: "+'${loginAccount.danWeiGuid}');
//    var danWeiGuid = $.cookie("danWeiGuid");
//    var userGuid = $.cookie("userGuid");
//    var userName = $.cookie("userName");
//    var phoneNum = $.cookie("phoneNum");
        <%--console.log("竞买方类别code: " + '${userInfo.JinMaiRenValue}' + "");--%>
        <%--console.log("竞买方类别name: " + '${userInfo.JinMaiRen}');--%>
//    $("#danWei_name").val(userName);
//    $("#gr_mobilePhone").val(phoneNum);
    $("#danWei_guid").val('${loginAccount.danWeiGuid}');
    $("#user_guid").val('${loginAccount.userGuid}');

        var $tooltips = $('.js_tooltips');
        var $danWei_name = $('#danWei_name');
        var $gr_mobilePhone = $('#gr_mobilePhone');
        var $grIDCard = $('.grIDCard');
        var $jinMaiRenValue = $('#jinMai_ren_value');

        //开户账号名称随姓名一起变化
        $danWei_name.on('change',function () {
            $("#kaiHu_name").val($danWei_name.val());
        })


        $('#btn_save').on('click', function () {
            if ($tooltips.css('display') != 'none') return;
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

            if (!isCardNo($.trim($grIDCard.val()))) {
                $tooltips.html('身份证号码格式不正确');
                flag = false;
            }

            if ($.trim($grIDCard.val()) == '') {
                $tooltips.html('身份证号码不能为空');
                flag = false;
            }

            if (!isPhoneNo($.trim($gr_mobilePhone.val()))) {
                $tooltips.html('手机号不能为空');
                flag = false;
            }

            if ($.trim($gr_mobilePhone.val()) == '') {
                $tooltips.html('手机号不能为空');
                flag = false;
            }
            if ($.trim($danWei_name.val()) == '') {
                $tooltips.html('姓名不能为空');
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

            if ($("#accept_message").is(':checked')) {
                $("#is_receive_message").val("0");
            } else {
                $("#is_receive_message").val("1");
            }

            var data = $("#user_reg_2_form").serialize();
            $.ajax({
                type: "POST",
                url: "user_info_update",
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
        $("#user_reg_jmr_text").text(jinMaiRen);
        /**
         * 获取竞买人类型 end
         */
        $("#user_reg_jmr_select").on("click", function () {
            $("#jmr_select_div").fadeIn(200);
        });

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
            $("#user_reg_jmr_text").text(jinMaiRen);
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

        var bankAreaCode = '';
        var bankAreaName = '';


        $("#kaiHuBank_area").cityPicker({
            title: "开户行所在地",
            onChange: function (picker, values, displayValues) {
                bankAreaCode = values[2];
                bankAreaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2];
                $("#bank_area_code").val(bankAreaCode);
                $("#bank_area_name").val(bankAreaName);
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
    <form id="user_reg_2_form">
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">会员类型</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" type="text" placeholder="个人" disabled/>
            </div>
        </div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">姓名<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input danWeiName" name="danWeiName" id="danWei_name" type="text"
                       placeholder="请输入真实姓名" value="${userInfo.DanWeiName}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">手机号<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input grMobilePhone" name="grMobilePhone" id="gr_mobilePhone" type="text"
                       placeholder="请输入真实手机号" value="${userInfo.GRMobilePhone}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">身份证号码<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input grIDCard" name="grIDCard" placeholder="请输入身份证号码" value="${userInfo.GRIDCard}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">住址</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="grAddress" placeholder="请输入住址" value="${userInfo.GRAddress}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">工作单位</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="workDanWei" type="text" placeholder="请输入工作单位"
                       value="${userInfo.WorkDanWei}"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">职务</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="zhiWu" placeholder="请输入职务" value="${userInfo.ZhiWu}"/>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">资金来源</label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="ziJinResource">
                    <c:forEach items="${ziJinResources}" var="ziJinResource">
                        <option value="${ziJinResource.code}" <c:if
                                test="${userInfo.ZiJinResource eq ziJinResource.code}"> selected</c:if> > ${ziJinResource.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cells__tips">个人资产申报</div>
        <div class="weui-cell">
            <div class="weui-cell__bd">
                <textarea class="weui-textarea" name="ziChanApply" rows="3">${userInfo.ZiChanApply}</textarea>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">电子邮箱</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="grEmail" placeholder="请输入电子邮箱" value="${userInfo.GREmail}"/>
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

        <div class="weui-cell weui-cell_access" id="user_reg_jmr_select">
            <div class="weui-cell__hd">竞买方类别<font color="red">(*)</font></div>
            <div class="weui-cell__bd">
                <p id="user_reg_jmr_text" align="left"></p>
            </div>
            <div class="weui-cell__ft" style="font-size: 0">
                <span></span>
            </div>
        </div>

        <div class="weui-cells__tips" style="color: red;">银行账号信息[退款转账用]：必填</div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">开户账号名称</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" id="kaiHu_name" placeholder="" disabled value="${userInfo.KaiHuName}"/>
            </div>
        </div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">开户账号<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="kaiHuAccount" id="kaiHu_account" placeholder="请输入开户账号" type="khzh"
                       value="${userInfo.KaiHuAccount}"/>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">开户行<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="kaiHuBank" id="kaiHu_bank">
                    <c:forEach items="${kaiHuBanks}" var="bank">
                        <option value="${bank.code}"
                                <c:if test="${userInfo.KaiHuBank eq bank.code}">selected</c:if>   >${bank.value}</option>
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

        <%--<input type="hidden" name="bankAreaName" id="bank_area_name" value="北京市·市辖区·东城区">--%>
        <%--<input type="hidden" name="bankAreaCode" id="bank_area_code" value="110101"> --%>
        <input type="hidden" name="bankAreaName" id="bank_area_name" value="${userInfo.BankAreaName}">
        <input type="hidden" name="bankAreaCode" id="bank_area_code" value="${userInfo.BankAreaCode}">
        <input type="hidden" name="danWeiGuid" id="danWei_guid" value="">
        <input type="hidden" name="userGuid" id="user_guid" value="">
        <input type="hidden" name="isReceiveMessage" id="is_receive_message" value="">
        <input type="hidden" name="jinMaiRen" id="jinMai_ren" value="">
        <input type="hidden" name="jinMaiRenValue" id="jinMai_ren_value" value="">
    </form>

</div>


<div class="weui-btn-area">
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_save">保存信息</a>
</div>

<!-- 竞买方类别 -->
<%int index = 0; %>
<div id="jmr_select_div" style="display:none;">
    <div class="weui-mask"></div>
    <div class="weui-dialog" style="width: 100%;">
        <div class="weui-dialog__bd">
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
                                   for="s<%=++index %>">
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
