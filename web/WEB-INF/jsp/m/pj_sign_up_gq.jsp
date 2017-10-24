<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";


    Object obj = request.getAttribute("data");
    String bbdate = "";
    String cldate = "";
    String areaName = "";
    if (obj != null) {
        Map map = (Map) obj;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        SimpleDateFormat sdf_ = new SimpleDateFormat("yyyy-MM-dd");
        try {
            if (map.containsKey("BaoBiaoDate")) {
                String bd = map.get("BaoBiaoDate").toString();
                if (StringUtils.isNotBlank(bd)) {
                    bbdate = sdf_.format(sdf.parse(bd));
                }
            }
            if (map.containsKey("ChengLiDate")) {
                String bd = map.get("ChengLiDate").toString();
                if (StringUtils.isNotBlank(bd)) {
                    cldate = sdf_.format(sdf.parse(bd));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--<meta charset="utf-8">--%>
    <base href="<%=basePath%>">
    <title>e交易-产权交易平台</title>
    <%--<jsp:include page="mate.jsp"></jsp:include>--%>

    <!-- easyui-start-->
    <link href="<%=basePath%>easyui/themes/insdep/easyui.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>easyui/themes/insdep/easyui_animation.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>easyui/themes/insdep/easyui_plus.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>easyui/themes/insdep/insdep_theme_default.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>easyui/themes/insdep/icon.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>easyui/jquery.easyui.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>easyui/themes/insdep/jquery.insdep-extend.min.js"
            charset="UTF-8"></script>
    <!-- easyui-end -->
    <script type="text/javascript" charset="utf-8" src="<%=basePath%>js/common.js"></script>
    <%--<script type="text/javascript" src="js/jquery-weui.js"></script>--%>
    <script type="text/javascript" src="js/bm.js"></script>
    <script type="text/javascript" src="m/js/DateOp.js"></script>
</head>
<script type="text/javascript">

    var code = '${result.code}';
    if (code === '-2') {
        alert("${result.msg}");
        window.location.href = "pj_list_cqjy";
    } else if (code != '0') {
        alert("系统错误,请联系管理员");
        window.location.href = "pj_list_cqjy";
    }

    +function (a) {
        a.rawCitiesData = '${citysWithEmpty}';
    }($);

    $(function () {

        var endTime = Date.parse(new Date('${data.GongGaoToDate }'));

        function addEndTime() {
            var nowTime = new Date().getTime();
            if (nowTime >= endTime) {
                $('#bmjzsj').textbox('setValue', "报名已结束");
            } else {
                $('#bmjzsj').textbox('setValue', DateOp.formatMsToStr2(endTime - nowTime));
            }
        }

        addEndTime();
        setInterval(addEndTime, 1000);

        //设置搜索结果高度
        var dHeight = document.documentElement ? document.documentElement.clientHeight : document.body.clientHeight;//浏览器高度
        $("#searchResult").height(dHeight - 120);

        var zhuanRangType = "${data.ZhuanRangType }";
        var faRenType = "${data.FaRenType }";

        function init() {
            if ($("#zhuanRang_type").val() == '1') {
                $("#shouRang_gufen_div").hide();
                $("#shou_RangGuFen").hide();
            } else {
                $("#shouRang_percent_div").hide();
                $("#shou_RangPercent").hide();
            }

            if ($("#lbl_isManagerLayer").val() == '1') {
                $("#zhiwu_div").show();
                $("#shenji").show();
            }

            if ($("#jinQi_ziChan").val() == '0;1;') {
                $("#s90").attr("checked", true);
                $("#s100").attr("checked", true);
            } else if ($("#jinQi_ziChan").val() == '0;') {
                $("#s90").attr("checked", true);
            } else if ($("#jinQi_ziChan").val() == '1;') {
                $("#s100").attr("checked", true);
            }
        }

        init();

        var $iosActionsheet = $('#iosActionsheet');
        var $iosMask = $('#iosMask');

        function hideActionSheet() {
            $iosActionsheet.removeClass('weui-actionsheet_toggle');
            $iosMask.fadeOut(200);
        }

        $iosMask.on('click', hideActionSheet);
        $('#iosActionsheetCancel').on('click', hideActionSheet);
        $("#union_div").on("click", ".ios_menu", function () {
            $("#union_waiting_handle").val($(this).next().val());
            $iosActionsheet.addClass('weui-actionsheet_toggle');
            $iosMask.fadeIn(200);
        });

        $("#union_delete").on("click", function () {
            hideActionSheet();
            var rowGuid = $("#union_waiting_handle").val();
            $.ajax({
                type: "POST",
                url: "pj_gq_delUnion",
                dataType: "json",
                data: "rowGuid=" + rowGuid,
                success: function (result) {
                    if (result) {
                        if (result.code == 0) {
                            $("#toast_div").text("删除成功");
                            $('#loadingToast').fadeIn(100);
                            setUnionDiv($("#union_baoMing_guid").val());
                        } else {
                            $("#toast_div").text("删除失败");
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

        $("#union_view").on("click", function () {
            initUnionDialog("union_view");
        });

        $("#union_edit").on("click", function () {
            initUnionDialog("union_edit");
        });

        function initUnionDialog(type) {
            hideActionSheet();
            var rowGuid = $("#union_waiting_handle").val();
            $.ajax({
                type: "POST",
                url: "pj_gq_getUnion",
                dataType: "json",
                data: "rowGuid=" + rowGuid,
                success: function (result) {
                    if (result) {
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
                        if (type == "union_view") {
                            //查看时禁用所有输入并隐藏确定按钮
                            $("#union_select_div").find("*").each(function () {
                                $(this).attr("disabled", "disabled");
                            });
                            $("#btn_ok").hide();
                        }
                        if (type == "union_edit") {
                            $("#union_row_guid").val(rowGuid);
                            //修改时启用所有输入并显示确定按钮
                            $("#union_select_div").find("*").each(function () {
                                $(this).removeAttr("disabled");
                            });
                            $("#btn_ok").show();
                            $("#union_type").val("union_edit");
                        }
                        $("#union_select_div").fadeIn(200);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        }

        $("#pj_sign_hyjg").on("click", function () {
            $("#hyjg_select_div").fadeIn(200);
        });

        $("input:radio[name='sshyjg']").change(function () {
            $("#belong_DLJGName").val($(this).attr("hyname"));
            $("#sshyjh_value_div").text($(this).attr("hyname"));
            $("#belong_DLJGGuid").val($(this).val());
        });

        $("#hyjg_sel_ok").on("click", function () {
            $("#hyjg_select_div").fadeOut(200);
        });

        //保存报名信息
        $("#btn_save").click(function () {
//            if ($("#srf_js_tooltips").css('display') != 'none') {
//                alert($("#srf_js_tooltips").css('display'));
//                return false;
//            }


            var flag = true;
            var zhuanRangValue = "";
            var zhuanRang_value = 0;

            /**
             * 文件必须上传时验证
             * */
            var IsBMNeedFile = '${data.IsBMNeedFile}';
            if (IsBMNeedFile === '1') {
                var filelist = '${filelist}';
                var json1 = JSON.parse(filelist);
                for (var i = 0; i < json1.length; i++) {
                    if (json1[i].IsMustNeed == "1" && $("#" + json1[i].FileCode).find("p").length == 0) {
                        $tooltips.html(json1[i].FileName + "必须选择上传文件!");
                        flag = false;
                    }
                }
            }

            if ($("#zhuanRang_type").val() == '2' && $("#srf_srgf").val() == '') {
                $("#srf_js_tooltips").html("拟受让股份必填");
                flag = false;
            }

            if (!isPhoneNo($("#lianxidianhua").val())) {
                $("#srf_js_tooltips").html("联系电话格式错误");
                flag = false;
            }

            if ($("#lianxidianhua").val() == '') {
                $("#srf_js_tooltips").html("联系电话必填");
                flag = false;
            }

            if ($("#lianxiren").val() == '') {
                $("#srf_js_tooltips").html("联系人必填");
                flag = false;
            }
            $(".zhuanRang_value").each(function () {
                zhuanRang_value = zhuanRang_value + parseFloat($(this).text());
            });
            if (zhuanRangType == "1") {
                zhuanRangValue = "${zhuanRangInfo.sellPercent }";
                if (!isNaN($("#srf_srp").val()) && $("#srf_srp").val() != "") {
                    zhuanRang_value = zhuanRang_value + parseFloat($("#srf_srp").val());
                }

            } else if (zhuanRangType == "2") {
                zhuanRangValue = "${zhuanRangInfo.sellAmount }";
                if (!isNaN($("#srf_srgf").val()) && $("#srf_srgf").val() != "") {
                    zhuanRang_value = zhuanRang_value + parseFloat($("#srf_srgf").val());
                }

            }

            //if(!isNan(zhuanRang_value)){
            //	zhuanRang_value = 0;
            //}
            if (parseFloat(zhuanRangValue) != zhuanRang_value) {
                if (zhuanRangType == "1") {
                    $("#srf_js_tooltips").html("受让方受让（联合受让）的比例(" + zhuanRang_value.toFixed(4) + "%)应该等于转让方转让（联合转让）的比例(" + zhuanRangValue + "%)");
                } else if (zhuanRangType == "2") {
                    $("#srf_js_tooltips").html("受让方受让（联合受让）的股份数(" + zhuanRang_value + "股)应该等于转让方转让（联合转让）的股份数(" + zhuanRangValue + "股)");
                }
                flag = false;
            }


            if ($("#zhuanRang_type").val() == '1' && $("#srf_srp").val() == '') {
                $("#srf_js_tooltips").html("拟受让比例必填");
                flag = false;
            }

            if ($("#shourangdijia").val() == '') {
                $("#srf_js_tooltips").html("受让底价必填");
                flag = false;
            }

            if (faRenType == '1') {
                if ($.trim($("#jingyingfanwei").val()) == '') {
                    $("#srf_js_tooltips").html("经营范围必填");
                    flag = false;
                }

                if ($("#hangYeType_code").val().indexOf('J') >= 0 && $.trim($("#industryC_code").val()) == '') {
                    $("#srf_js_tooltips").html("金融类所属行业必填");
                    flag = false;
                }
                if ($("#zhuCe_ziBen").val() == '') {
                    $("#srf_js_tooltips").html("注册资本必填");
                    flag = false;
                }
                if ($("#zhuCe_di").val() == '') {
                    $("#srf_js_tooltips").html("注册地必填");
                    flag = false;
                }
            }
            if (faRenType == '2' && $.trim($("#zheng_No").val()) == '') {
                $("#srf_js_tooltips").html("证件号码必填");
                flag = false;
            }
            if (faRenType == '2' && !isCardNo($.trim($("#zheng_No").val()))) {
                $("#srf_js_tooltips").html("身份证号码格式错误");
                flag = false;
            }
            if ($("#is_managerLayer").val() == '1' && $.trim($("#zhi_wu").val()) == '') {
                $("#srf_js_tooltips").html("职务必填");
                flag = false;
            }
            if ($("#area_code").val() == '' || $("#area_code").val() == '请选择') {
                $("#srf_js_tooltips").html("所在地区必填");
                flag = false;
            }


            if ($("#s90").is(':checked') && $("#s100").is(':checked')) {
                $("#jinQi_ziChan").val("0;1;");
            } else if ($("#s90").is(':checked')) {
                $("#jinQi_ziChan").val("0;");
            } else if ($("#s100").is(':checked')) {
                $("#jinQi_ziChan").val("1;");
            } else {
                $("#jinQi_ziChan").val("");
            }


            if (!flag) {
                alert($("#srf_js_tooltips").text());
//                $("#srf_js_tooltips").css('display', 'block');
                setTimeout(function () {
                    $("#srf_js_tooltips").css('display', 'none');
                }, 3000);
                return false;
            }

            var param = $("#pj_gq_submit").serialize();

            $.ajax({
                type: "POST",
                url: "pj_sign_up_submit",
                dataType: "json",
                data: param,
                success: function (result) {
                    if (result) {
                        if (result.code == 0) {
                            $("#toast_div").text("数据提交中");
                            $('#loadingToast').fadeIn(100);
                            location.href = "pj_sign_up_view?infoid=${ProjectGuid}&type=GQ&bmguid=${data.RowGuid }&zhuanRangType=" + zhuanRangType;
                        } else if (result.code = -2) {
                            $("#srf_js_tooltips").html(result.msg);
//       	    		    $("#toast_div").text(result.msg);
                            $("#srf_js_tooltips").css('display', 'block');
                            setTimeout(function () {
                                $("#srf_js_tooltips").css('display', 'none');
                            }, 3000);
//       	    		    $('#loadingToast').fadeIn(100);
                        }
                        $('#loadingToast').fadeOut(100);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        });

        //新增联合受让方
        $("#btn_add").on("click", function () {
            //重置表单数据
            document.getElementById("pj_gq_addUnion").reset();
            //新增时启用所有输入并显示确定按钮
            $("#union_select_div").find("*").each(function () {
                $(this).removeAttr("disabled");
            });
            $("#btn_ok").show();
            $("#union_type").val("union_add");
            $('#union_select_div').panel('open');
//            $("#union_select_div").attr("closed",'false');
//            $.parser.parse($("#union_select_div"));
//            $("#pj_gq_submit").hide();
        });

//        $("#is_managerLayer").change(function(){
//            var is_managerLayer = $(this).val();
//            if(is_managerLayer == 1){
//                $("#zhiwu_div").show();
//                $("#shenji").show();
//            }else{
//                $("#zhiwu_div").hide();
//                $("#shenji").hide();
//            }
//        });

        $("#is_managerLayer").combobox({
            onChange: function (n, o) {
                var is_managerLayer = $(this).val();
                if (is_managerLayer == 1) {
                    $("#zhiwu_div").show();
                    $("#shenji").show();
                    $.parser.parse($("#zhiwu_div"));
                    $.parser.parse($("#shenji"));
                } else {
                    $("#zhiwu_div").hide();
                    $("#shenji").hide();
                }
            }
        });

//        $("#area").cityPicker({
//            title: "所在地区",
//            onChange: function (picker, values, displayValues) {
//                areaCode = values[2];
//                areaName = displayValues[0] + "·" + displayValues[1] + "·" + displayValues[2];
//                $("#area_code").val(areaCode);
//                $("#area_name").val(areaName);
//            }
//        });

        $("#pj_sign_srf").on("click", function () {
            if ($(this).attr("disabled") == "disabled") {
                return;
            }
            $("#shouRang_name").val('');
            $("#srf_select_div").fadeIn(200);
            $("#pj_gq_submit").hide();

        });

        $("#srf_sel_ok").on("click", function () {
            $(".weui-srf").each(function () {
                if ($(this).is(':checked')) {
                    $("#shouRang_name").val($.trim($(this).next().next().next().val()));
                    $("#shouRang_guid").val($.trim($(this).next().next().val()));
                }
            });
            $("#srf_select_div").fadeOut(200);
            $("#pj_gq_submit").show();
        });

        $("#srf_sel_cancel").on("click", function () {
            $("#srf_select_div").fadeOut(200);
            $("#pj_gq_submit").show();
        });

        //新增/修改联合受让方保存
        $("#btn_ok").click(function () {
            var flag = true;
            var text = '';
            if (zhuanRangType == "1" && $("#shouRang_percent").val() > 100) {
                text = '受让比例请输入不大于100的值';
                flag = false;
            }

            if (zhuanRangType == "1" && $("#shouRang_percent").val() == "") {
                text = '受让比例必填';
                flag = false;
            }
            if (zhuanRangType == "2" && $("#shouRang_gufen").val() == "") {
                text = '受让股份必填';
                flag = false;
            }

            if($.trim($("#shouRangFang_name").combogrid('getValue')) == ""){
//            if ($.trim($("#shouRang_name").val()) == "") {
                text = '受让方名称必填';
                flag = false;
            }
            if (!flag) {
                alert(text);
                return false;
            }
            var param = $("#pj_gq_addUnion").serialize();
            $.ajax({
                type: "POST",
                url: "pj_gq_addUnion_submit",
                dataType: "json",
                data: param,
                success: function (result) {
                    if (result) {
                        if (result.code == 0) {
                            alert("操作成功");
                            $('#loadingToast').fadeIn(100);
                            setUnionDiv($("#union_baoMing_guid").val());
                        } else {
                            alert("操作失败");
                            $('#loadingToast').fadeIn(100);
                        }
                        $('#loadingToast').fadeOut(100);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
            $('#union_select_div').panel('close');
            $("#lhsrf").datagrid('reload');
            $("#pj_gq_submit").show();
        });

        //新增/修改联合受让方取消
        $("#btn_cancel").on("click", function () {
            $('#union_select_div').panel('close');
            $("#pj_gq_submit").show();
        });

        //动态展示当前报名的所有联合受让方
        function setUnionDiv(baoMingGuid) {
            if (baoMingGuid != '') {
                $.ajax({
                    type: "POST",
                    url: "pj_gq_getUnionList",
                    dataType: "json",
                    data: "baoMingGuid=" + baoMingGuid,
                    success: function (result) {
                        if (result.length > 0) {
                            $("#is_unionShouRang").val("1");
                        } else {
                            $("#is_unionShouRang").val("0");
                        }
                        $("#union_div").empty();
                        var innerHtml = "";
                        innerHtml += ' <table class="table" width="100%"> <tbody> <tr>' +
                            '<td height="50" width="70" align="center">序号</td> <td>联合受让方名称</td>';

                        if (zhuanRangType == "1") {
                            innerHtml += ' <td align="center"  width="120">拟受让比例（%）</td></tr>';

                        } else if (zhuanRangType == "2") {
                            innerHtml += ' <td align="center"  width="120">拟受让股份（股）</td></tr>';

                        }
//       	            $("#union_div").append(innerHead);
                        $.each(result, function (i, data) {
//       	                var innerHtml = "";
                            if (zhuanRangType == "1") {
                                innerHtml += ' <tr class="ios_menu"> <td height="30" align="center" >' + (i + 1) + '</td>' +
                                    '<td>' + data.ShouRangName + '</td>' +
                                    '<td class="zhuanRang_value" align="center">' + data.ShouRangPercent + '</td></tr>' +
                                    "<input type='hidden' value='" + data.RowGuid + "'>";
                            } else if (zhuanRangType == "2") {
                                innerHtml += ' <tr class="ios_menu"> <td height="30" align="center" >' + (i + 1) + '</td>' +
                                    '<td>' + data.ShouRangName + '</td>' +
                                    '<td class="zhuanRang_value" align="center">' + data.ShouRangGufen + '</td></tr>' +
                                    "<input type='hidden' value='" + data.RowGuid + "'> ";
                            }
//       	                $("#union_div").append(innerHtml);
                        });
                        $("#union_div").append(innerHtml + "</tbody> </table>");

                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert(errorThrown);
                    }
                });
            }
        }

        var $searchBar = $('#searchBar'),
            $searchResult = $('#searchResult'),
            $searchText = $('#searchText'),
            $searchInput = $('#searchInput');

        function hideSearchResult() {
            $searchResult.hide();
            $searchInput.val('');
        }

        function cancelSearch() {
            hideSearchResult();
            $searchBar.removeClass('weui-search-bar_focusing');
            $searchText.show();
        }

        $searchText.on('click', function () {
            $searchBar.addClass('weui-search-bar_focusing');
            $searchInput.focus();
        });

        $searchInput.on('blur', function () {
            if (!this.value.length) cancelSearch();
        }).on('input', function () {
            if (this.value.length) {
                $.ajax({
                    type: "POST",
                    url: "get_srf_list",
                    dataType: "json",
                    data: "srfNameOrUnitCode=" + $("#searchInput").val() + "&projectGuid=${ProjectGuid}&rowGuid=" + $("#union_baoMing_guid").val() + "&type=" + $("#choose_srf").val(),
                    success: function (result) {
                        $searchResult.empty();
                        $searchResult.append('<div class="weui-cell-srf weui-check__label"><div class="weui-cell-srf" style="    width: 100%;    padding: 3px 0px;"><div class="weui-cell__hd"><label class="weui-label" style="font-weight: bold;">序号</label></div><div class="weui-cell__hd"><label class="weui-label" style="font-weight: bold;">组织机构代码</label></div>'
                            + '<div class="weui-cell__bd"><label class="weui-label" style="color: #353535;font-weight: bold;">竞买方</label></div><!--<div class="weui-cell__bd"><label class="weui-label">选择</label></div> --></div></div>');
                        $.each(result, function (i, data) {
                            var j = i + 1;
                            var innerHtml = "<label class='weui-cell-srf weui-check__label' for='i" + i + "' style='text-align: left;font-size: 14px'>"
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
                                + "<input type='radio' class='weui-check weui-srf' name='radio1234' id='i" + i + "'>"
                                + "<span class='weui-icon-checked'></span>"
                                + "<input type='hidden' value='" + data.DanWeiGuid + "'>"
                                + "<input type='hidden' value='" + data.DanWeiName + "'>"
                                + "</div>"
                                + "</label>";
                            $searchResult.append(innerHtml);
                        });
                        $searchResult.show();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert(errorThrown);
                    }
                });
            } else {
                $searchResult.hide();
            }
        });

        $("#choose_srf").on("change", function () {
            $searchResult.hide();
            $searchResult.empty();
            $searchInput.val('');
            if ($(this).val() == 0) {
                $("#searchInput").attr("placeholder", "输入竞买方搜索");
            } else {
                $("#searchInput").attr("placeholder", "输入组织机构代码搜索");
            }
        });

        $("#hangYeType_code").on("change", function () {
            $(this).next().val($(this).find("option:selected").text());
        });

        $("#industryC_code").on("change", function () {
            $(this).next().val($(this).find("option:selected").text());
        });

        /**
         修改时附件加载
         **/
        if ('${bmguid}' != '') {
            loadFile();
        }
    });

    var task_code = "CQJY_GQBaoMing";

    function loadFile() {
        $("#toast_div").text("加载中");
        $('#loadingToast').fadeIn(100);
        var data = {};
        data.bmguid = "${data.RowGuid }";
        data.taskCode = task_code;
        $.ajax({
            url: "getFileList",
            type: "POST",
            data: data,
            success: function (res, status, xhr) {
                try {
                    if (res && res.code == 0) {
                        var files = (res.data);
                        if (files.length == 0) {
                            $("div[name='init_files']").each(function () {
                                $(this).html("");
                            })
                        } else {
                            $("div[name='init_files']").each(function () {
                                $(this).html("");
                            });
                            for (var i = 0; i < files.length; i++) {
                                var code = files[i].type;
                                var list = files[i].fileList;
                                $("#" + code).html("");
                                for (var j = 0; j < list.length; j++) {
//									var html = "<p><span><a href=\"javascript:openfj('"+list[j].RowGuid+"')\">"+list[j].AttachFileName+"</a></span><a href=\"javascript:del('"+list[j].RowGuid+"');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a></p>";
//									$("#"+code).append(html);
                                    var html = "<p><span><a target='_blank' target='_blank' href=\"" + list[j].url + "\">" + list[j].AttachFileName + "</a></span><a href=\"javascript:del('" + list[j].RowGuid + "');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a></p>";
                                    $("#" + code).append(html);
                                }
                            }
                        }
                    }
                    $('#loadingToast').fadeOut(100);
                } catch (e) {
                    alert(e.toLocaleString());
                }
            }
        });
    }

    /**
     附件下载
     **/
    function openfj(guid) {
        window.location.href = "${bm_file_download}" + guid;
    }
</script>
<script type="text/javascript" src="js/city-picker.js"></script>
<body>
<div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="srf_js_tooltips"></div>
<div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="js_tooltips"></div>
<form id="pj_gq_submit">

    <input type="hidden" name="bmguid" value="${bmguid}"><!-- 修改时,被修改的报名guid,新增时该值为空 -->
    <input type="hidden" name="info['type']" value="GQ"><!-- 系统类别-->
    <input type="hidden" name="info['RowGuid']" value="${data.RowGuid }"><!-- 报名唯一标识 -->
    <input type="hidden" name="info['ProjectGuid']" value="${ProjectGuid}"><!-- 项目guid -->
    <input type="hidden" name="info['DisplayName']"><!-- 显示名称 -->
    <input type="hidden" name="info['IpAddress']" value="${data.IpAddress }"><!-- Ip地址 -->
    <input type="hidden" name="info['BelongXiaQuCode']" value="${data.BelongXiaQuCode }"><!-- 所属地区 -->
    <input type="hidden" name="info['XiaQuCode']" value="${data.XiaQuCode }"><!-- 机构代码 -->
    <input type="hidden" name="info['DanWeiName']" value="${data.DanWeiName }"><!-- 单位名称 -->
    <input type="hidden" name="info['FaRenType']" value="${data.FaRenType }"><!-- 法人类型 -->
    <input type="hidden" name="info['AreaName']" id="area_name" value="${data.AreaName }"><!-- 地区名称 -->
    <input type="hidden" name="info['AreaCode']" id="area_code" value="${data.AreaCode }"><!-- 地区代码 -->
    <input type="hidden" name="info['BiaoDiName']" value="${data.ProjectName_3001 }"><!-- 标的名称 -->
    <input type="hidden" name="info['BiaoDiNo']" value="${data.ProjectNo_3001 }"><!-- 标的编号 -->
    <input type="hidden" name="info['UnitOrgNum']" value="${data.UnitOrgNum }"><!-- 组织机构代码 -->
    <input type="hidden" name="info['DanWeiXingZhi']" value="${data.DanWeiXingZhi }"><!-- 单位性质 -->
    <input type="hidden" name="info['YingYeZhiZhaoNo']" value="${data.YingYeZhiZhaoNo }"><!-- 营业执照号码 -->
    <input type="hidden" name="info['JiaoNaBZJ']" value="${data.JiaoNaBZJ }"><!-- 保证金金额 -->
    <input type="hidden" name="info['BZJIsjiaoNa']" value="${data.BZJIsjiaoNa }"><!-- 保证金是否缴纳 -->
    <input type="hidden" name="info['JiaoNaEndDate']" value="${data.JiaoNaEndDate }"><!-- 保证金缴纳截至日期 -->
    <input type="hidden" name="info['BelongDLJGGuid']" id="belong_DLJGGuid" value="${data.BelongDLJGGuid }">
    <!-- 机构guid(委托会员) -->
    <input type="hidden" name="info['BelongDLJGName']" id="belong_DLJGName" value="${data.BelongDLJGName }">
    <!-- 机构名称(委托会员) -->
    <input type="hidden" name="info['ZhuanRangType']" id="zhuanRang_type" value="${data.ZhuanRangType }"><!-- 转让方式 -->
    <input type="hidden" name="info['IsUnionShouRang']" id="is_unionShouRang" value="${data.IsUnionShouRang }">
    <!-- 是否联合受让 -->
    <input type="hidden" name="info['FaRen_3008']" value="${data.FaRen_3008 }"><!--  -->
    <input type="hidden" name="info['UserID']" value="${data.UserID }"><!--  -->
    <input type="hidden" name="info['OprationType']" value="${data.OprationType }"><!--  -->
    <input type="hidden" id="lbl_isManagerLayer" value="${data.IsManagerLayer}">
    <input type="hidden" name="info['JinQiZiChan']" id="jinQi_ziChan" value="${data.JinQiZiChan}">

    <style>.label-top {
        margin: 0 0 10px;
        display: block;
    }</style>
    <h4 class="easyui-panel" title="报名" style="width:90%;padding:30px 60px;">

        <!--报名表单Start-->
        <div style="margin-bottom:20px">
            <label class="label-top">标的编号:</label>
            <input class="easyui-textbox" style="width:50%;" value="${data.ProjectNo_3001 }"
                   data-options="readonly:true">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">标的名称:</label>
            <input class="easyui-textbox" style="width:50%;" value="${data.ProjectName_3001 }"
                   data-options="readonly:true">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">标的类型:</label>
            <c:if test="${data.BiaoDiType_3001==1}"> <input class="easyui-textbox" style="width:50%;" value="股权"
                                                            data-options="readonly:true"></c:if>
            <c:if test="${data.BiaoDiType_3001==2}"><input class="easyui-textbox" style="width:50%;" value="股权+债权"
                                                           data-options="readonly:true"></c:if>
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">挂牌价:</label>
            <input class="easyui-textbox" style="width:50%;" value="${data.GuaPaiPrice }万元"
                   data-options="readonly:true">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">报名截止时间:</label>
            <input class="easyui-textbox" style="width:50%;" value="${data.GongGaoToDate }"
                   data-options="readonly:true">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">距离报名截止时间:</label>
            <input id="bmjzsj" class="easyui-textbox" style="width:50%;" data-options="readonly:true" value="">
        </div>
        <div style="margin-bottom:20px">
            <a class="weui-btn weui-btn_primary" href="infodetail?${fn:split(data.GongGaoUrl,'?')[1]}">查看网站公告原文</a>
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top" style="width:100%; display:block;">是否国资:</label>
            <select class="easyui-combobox" name="info['IsGuoZi']" labelPosition="top" style="width:50%;">
                <option value="T" <c:if test="${data.IsGuoZi=='T'}">selected</c:if>>国资</option>
                <option value="F" <c:if test="${data.IsGuoZi=='F'}">selected</c:if>>非国资</option>
            </select>
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">法人类型<font color="red">(*)</font>:</label>
            <input class="easyui-textbox" style="width:50%;"
                   value='<c:if test="${data.FaRenType==2}">自然人</c:if><c:if test="${data.FaRenType==1}">企事业单位</c:if>'
                   data-options="readonly:true">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">受让方名称:</label>
            <input class="easyui-textbox" style="width:50%;" value="${data.DanWeiName }" data-options="readonly:true">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top" style="width:100%; display:block;">是否标的企业管理层直接或间接出资:</label>
            <select class="easyui-combobox" name="info['IsManagerLayer']" id="is_managerLayer" labelPosition="top"
                    style="width:50%;">
                <option value="0" <c:if test="${data.IsManagerLayer=='0'}">selected</c:if>>否</option>
                <option value="1" <c:if test="${data.IsManagerLayer=='1'}">selected</c:if>>是</option>
            </select>
        </div>
        <div style="margin-bottom:20px;display: none;" id="zhiwu_div">
            <label class="label-top">职务<font color="red">(*)</font>:</label>
            <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['ZhiWu']"
                   id="zhi_wu"
                   value="${data.ZhiWu }" placeholder="请输入职务">
        </div>
        <div style="margin-bottom:20px;display: none;" id="shenji">
            <label class="label-top" style="width:100%; display:block;">是否进行了经济责任审计<font color="red">(*)</font>:</label>
            <select class="easyui-combobox" name="info['hasAudit']" labelPosition="top" style="width:50%;">
                <option value="1" <c:if test="${data.hasAudit=='1'}">selected</c:if>>是</option>
                <option value="0" <c:if test="${data.hasAudit=='0'}">selected</c:if>>否</option>
            </select>
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">所在地区<font color="red">(*)</font>:</label>
            <input class="easyui-textbox" style="width:50%;" data-options="required:true" id="area"
                   value="${data.AreaName.replace("·"," ")}">
        </div>
        <c:if test="${user_type==1 }">
            <!-- 个人会员信息 begin -->
            <div style="margin-bottom:20px">
                <label class="label-top">证件名称:</label>
                <input class="easyui-textbox" style="width:50%;" name="info['ZhengName']" value="${data.ZhengName }"
                       placeholder="请输入证件名称">
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top">证件号码<font color="red">(*)</font>:</label>
                <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['ZhengNo']"
                       value="${data.ZhengNo }" placeholder="请输入证件号码">
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top">工作单位:</label>
                <input class="easyui-textbox" style="width:50%;" name="info['GongZuoDanWei']"
                       value="${data.GongZuoDanWei }" placeholder="请输入工作单位">
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">资金来源:</label>
                <select class="easyui-combobox" name="info['ZiJinLaiYuan']" labelPosition="top" style="width:50%;">
                    <option value="0" <c:if test="${data.ZiJinLaiYuan=='0'}">selected</c:if>>自有</option>
                    <option value="1" <c:if test="${data.ZiJinLaiYuan=='1'}">selected</c:if>>融资</option>
                    <option value="2" <c:if test="${data.ZiJinLaiYuan=='2'}">selected</c:if>>其他</option>
                </select>
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top">个人资产申报:</label>
                <input class="easyui-textbox" style="width:50%; height:80px;" data-options="multiline:true"
                       name="info['GeRenZiChan']" value="${data.GeRenZiChan}">
            </div>

            <!-- 个人会员信息 end -->
        </c:if>
        <c:if test="${user_type==0 }">
            <!-- 单位信息 begin -->
            <div style="margin-bottom:20px">
                <label class="label-top">注册地<font color="red">(*)</font>:</label>
                <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['ZhuCeDi']"
                       id="zhuCe_di" value="${data.ZhuCeDi }" placeholder="请输入注册地">
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top">注册资本（万元）<font color="red">(*)</font>:</label>
                <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['ZhuCeZiBen']"
                       type="zb" id="zhuCe_ziBen" value="${data.ZhuCeZiBen }">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">币种:</label>
                <select class="easyui-combobox" name="info['BiZhong']" labelPosition="top" style="width:50%;">
                    <c:forEach items="${biZhongs}" var="biZhong">
                        <option value="${biZhong.code}"
                                <c:if test="${biZhong.code eq data.BiZhong}">selected</c:if>>${biZhong.value}</option>
                    </c:forEach>
                </select>
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">成立时间:</label>
                    <%--<input type="date" class="easyui-datebox" name="info['ChengLiDate']" value="<%=cldate %>"></input>--%>
                <input type="text" class="easyui-datebox" name="info['ChengLiDate']" value="<%=cldate %>">
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top">法定代表人:</label>
                <input class="easyui-textbox" style="width:50%;" name="info['FaRen_13003']"
                       value="${data.FaRen_13003 }">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">所属行业<font color="red">(*)</font>:</label>
                <select class="easyui-combobox" name="info['HangYeTypeCode']" id="hangYeType_code" labelPosition="top"
                        style="width:50%;">
                    <c:forEach items="${hangYeTypes}" var="hangYeType">
                        <option value="${hangYeType.code}"
                                <c:if test="${hangYeType.code eq data.HangYeTypeCode}">selected</c:if>>${hangYeType.value}</option>
                    </c:forEach>
                </select>
                <input type="hidden" name="info['HangYeType']" value="${data.HangYeType}">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">金融类所属行业:</label>
                <select class="easyui-combobox" name="info['IndustryCCode']" id="industryC_code" labelPosition="top"
                        style="width:50%;">
                    <option value=""></option>
                    <c:forEach items="${industryCs}" var="industryC">
                        <option value="${industryC.code}"
                                <c:if test="${industryC.code eq data.IndustryCCode}">selected</c:if>>${industryC.value}</option>
                    </c:forEach>
                </select>
                <input type="hidden" name="info['IndustryCName']" value="${data.IndustryCName}">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">公司类型（经济性质）<font
                        color="red">(*)</font>:</label>
                <select class="easyui-combobox" name="info['CompanyLeiXing']" labelPosition="top" style="width:50%;">
                    <c:forEach items="${companyLeiXings}" var="companyLeiXing">
                        <option value="${companyLeiXing.code}"
                                <c:if test="${companyLeiXing.code eq data.CompanyLeiXing}">selected</c:if>>${companyLeiXing.value}</option>
                    </c:forEach>
                </select>
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">企业性质（经济类型）<font
                        color="red">(*)</font>:</label>
                <select class="easyui-combobox" name="info['CompanyXingZhi']" labelPosition="top" style="width:50%;">
                    <c:forEach items="${companyXingZhis}" var="companyXingZhi">
                        <option value="${companyXingZhi.code}"
                                <c:if test="${companyXingZhi.code eq data.CompanyXingZhi}">selected</c:if>>${companyXingZhi.value}</option>
                    </c:forEach>
                </select>
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">经济规模<font color="red">(*)</font>:</label>
                <select class="easyui-combobox" name="info['GuiMo']" labelPosition="top" style="width:50%;">
                    <option value="0" <c:if test="${data.GuiMo==0}">selected</c:if>>大型</option>
                    <option value="1" <c:if test="${data.GuiMo==1}">selected</c:if>>中型</option>
                    <option value="2" <c:if test="${data.GuiMo==2}">selected</c:if>>小型</option>
                    <option value="3" <c:if test="${data.GuiMo==3}">selected</c:if>>微型</option>
                </select>
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">企业组织机构代码:</label>
                <input class="easyui-textbox" style="width:50%;" value="${data.UnitOrgNum }"
                       data-options="readonly:true">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">经营范围<font color="red">(*)</font>:</label>
                <input class="easyui-textbox" style="width:50%;" data-options="required:true"
                       name="info['JingYingFanWei']"
                       type="text" id="jingyingfanwei" value="${data.JingYingFanWei }" placeholder="请输入经营范围">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">受让资格陈述:</label>
                <input class="easyui-textbox" style="width:50%; height:80px;" data-options="multiline:true"
                       name="info['ShouRangZiGe']" value="${data.ShouRangZiGe}">
            </div>
            <p>近期资产情况</p>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">数据来源:</label>
                <input class="easyui-combobox" name="language[]" style="width:50%;" data-options="
                    url:'example/application/combobox_data1.json',
                    method:'get',
                    valueField:'id',
                    textField:'text',

                    multiple:true,
                    panelHeight:'auto'
                    ">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">报表日期:</label>
                <input type="text" class="easyui-datebox" name="info['BaoBiaoDate']" value="<%=bbdate %>">
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top">资产总计（万元）:</label>
                <input class="easyui-textbox" style="width:50%;" value="${data.ZiChanTotal}" name="info['ZiChanTotal']"
                       type="number">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">负债总计（万元）:</label>
                <input class="easyui-textbox" style="width:50%;" value="${data.FuZhaiTotal}" name="info['FuZhaiTotal']"
                       type="number">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">净资产（万元）:</label>
                <input class="easyui-textbox" style="width:50%;" value="${data.JingZiChan}" name="info['JingZiChan']"
                       type="number">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">币种:</label>
                <select class="easyui-combobox" name="info['BiZhong']" labelPosition="top" style="width:50%;">
                    <c:forEach items="${biZhongs}" var="moneyType">
                        <option value="${moneyType.code}"
                                <c:if test="${moneyType.code eq data.MoneyType}">selected</c:if>>${moneyType.value}</option>
                    </c:forEach>
                </select>
            </div>
            <!-- 单位信息 end -->
        </c:if>
        <div style="margin-bottom:20px">
            <label class="label-top" style="width:100%; display:block;">是否标的公司原股东<font color="red">(*)</font>:</label>
            <select class="easyui-combobox" name="info['hasPriority']" labelPosition="top" style="width:50%;">
                <option value="0" <c:if test="${data.hasPriority=='0'}">selected</c:if>>否</option>
                <option value="1" <c:if test="${data.hasPriority=='1'}">selected</c:if>>是</option>
            </select>
        </div>
        <p>受让意愿</p>
        <div style="margin-bottom:20px">
            <label class="label-top">受让底价(万元)<font color="red">(*)</font>:</label>
            <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['ShouRangDiJia']"
                   type="zb" id="shourangdijia" value="${data.ShouRangDiJia }" placeholder="请输入受让底价">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top" style="width:100%; display:block;">币种:</label>
            <select class="easyui-combobox" name="info['ShouRangBiZhong']" labelPosition="top" style="width:50%;">
                <c:forEach items="${biZhongs}" var="shouRangBiZhong">
                    <option value="${shouRangBiZhong.code}"
                            <c:if test="${shouRangBiZhong.code eq data.ShouRangBiZhong}">selected</c:if>>${shouRangBiZhong.value}</option>
                </c:forEach>
            </select>
        </div>
        <div style="margin-bottom:20px" id="shou_RangPercent">
            <label class="label-top">拟受让比例(%)<font color="red">(*)</font>:</label>
            <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['ShouRangPercent']"
                   type="zb" id="srf_srp" value="${data.ShouRangPercent }" placeholder="请输入拟受让比例">
        </div>
        <div style="margin-bottom:20px" id="shou_RangGuFen">
            <label class="label-top">拟受让股份(股)<font color="red">(*)</font>:</label>
            <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['ShouRangGuFen']"
                   type="zb" id="srf_srgf" value="${data.ShouRangGuFen }" placeholder="请输入拟受让股份">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">联系人<font color="red">(*)</font>:</label>
            <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['LianXiUser']"
                   type="text" id="lianxiren" value="${data.LianXiUser }" placeholder="请输入联系人">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">联系电话<font color="red">(*)</font>:</label>
            <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['LianXiTel']"
                   type="text" id="lianxidianhua" value="${data.LianXiTel }" placeholder="请输入联系电话">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">电子邮箱:</label>
            <input class="easyui-textbox" style="width:50%;" name="info['Email']"
                   type="text" value="${data.Email }" placeholder="请输入电子邮箱">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">传真号码:</label>
            <input class="easyui-textbox" style="width:50%;" name="info['ChuanZhen']"
                   type="text" value="${data.ChuanZhen }" placeholder="请输入传真号码">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">资信证明:</label>
            <input class="easyui-textbox" style="width:50%;" name="info['ZiXinZhengMing']"
                   value="${data.ZiXinZhengMing }"
                   data-options="readonly:true">
        </div>
        <p>委托会员</p>
        <div style="margin-bottom:20px" id="pj_sign_hyjg">
            <label class="label-top" style="width:100%; display:block;">机构名称:</label>
            <select class="easyui-combobox" name="state" labelPosition="top" style="width:50%;">
                <c:forEach items="${sshyjg }" var="hyjg" varStatus="jg">
                    <option value="${hyjg.guid}" name="sshyjg" id="x${jg.index }"
                            hyname="${hyjg.name }">${hyjg.name}</option>
                </c:forEach>
            </select>
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">工位号:</label>
            <input class="easyui-textbox" style="width:50%;" name="info['GongWeiNo']"
                   type="text" value="${data.GongWeiNo }" placeholder="请输入工位号">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">经纪人:</label>
            <input class="easyui-textbox" style="width:50%;" name="info['JingJiRen']"
                   type="text" value="${data.JingJiRen }" placeholder="请输入经纪人">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">经纪人编码:</label>
            <input class="easyui-textbox" style="width:50%;" name="info['JingJiRenCode']"
                   type="text" value="${data.JingJiRenCode }" placeholder="请输入经纪人编码">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">联系人:</label>
            <input class="easyui-textbox" style="width:50%;" name="info['LianXiRen']"
                   type="text" value="${data.LianXiRen }" placeholder="请输入联系人">
        </div>
        <div style="margin-bottom:20px">
            <label class="label-top">联系电话:</label>
            <input class="easyui-textbox" style="width:50%;" name="info['JGLianXiTel']"
                   type="text" value="${data.JGLianXiTel }" placeholder="请输入联系电话">
        </div>

        <table class="easyui-datagrid" title="联合受让方" style="width:1000px;height:350px"
        <%--data-options="singleSelect:true,url:'example/datagrid/datagrid_data1.json',method:'get',toolbar:'#tb',footer:'#ft',pagination:true,--%>
               data-options="singleSelect:true,url:'pj_gq_getUnionListToEasyui?baoMingGuid=${data.RowGuid }',method:'get',toolbar:'#tb',footer:'#ft',pagination:true,
				pageSize:10" id="lhsrf">
            <thead>
            <tr>
                <th data-options="field:'id',width:100">序号</th>
                <th data-options="field:'shouRangName',width:500">联合受让方名称</th>
                <th data-options="field:'shouRangPercent',width:320">拟受让比例(%)</th>
            </tr>
            </thead>
        </table>
        <div id="ft" style="padding:2px 5px;">
            <a class="easyui-linkbutton" iconCls="icon-add" plain="true" id="btn_add">添加</a>
            <a class="easyui-linkbutton" iconCls="icon-edit" plain="true">编辑</a>
            <a class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
        </div>
        <br>
        <p>相关附件</p>
        <c:forEach items="${filelist}" var="file">
            <div class="weui-cell weui-cell_vcode">
                <div class="weui-cell__hd">
                    <label class="weui-label">${file.FileName} <c:if
                            test="${file.IsMustNeed eq '1' and data.IsBMNeedFile eq '1' }"><font
                            color="red">(*)</font></c:if></label>
                </div>
                <div class="weui-cell__bd" name="init_files" id="${file.FileCode}" need="${file.IsMustNeed}">
                </div>
                <div style="margin-bottom:20px">
                        <%--<label class="label-top" style="width:100%; display:block;">文件管理:</label>--%>


                    <form id="upform">
                        <input name="fileCode" id="fileCode" type="hidden">
                        <input name="rowGuid" type="hidden" value="${data.RowGuid }">
                        <input class="easyui-filebox" style="width:300px" id="uploaderInput" name="file"
                               data-options="buttonIcon:'icon-folder-search',buttonText:''" name="file_div">
                    </form>
                </div>
            </div>
        </c:forEach>

        <!--报名表单End-->

        <div>
            <a class="easyui-linkbutton" iconCls="icon-ok" style="width:100%;height:32px" id="btn_save">确定</a>
        </div>

        <div id="w1" style="background:url('<%=basePath%>images/bg-header.png?07a751e') repeat-x scroll 0 0 #FFFFFF;">
        </div>
    </h4>
</form>

<!--新增联合受让方dialog start-->
<style>
    .xzlhsrf {
        width: 100%;
        border-radius: 0px;
        top: 0px;
        left: 30%;
        -webkit-transform: translate(0, 0);
        transform: translate(0, 0);
        height: 100%;
        max-width: 500px;
        display: none;
        position: fixed;
        z-index: 99;
    }
</style>
<h4 class="easyui-panel xzlhsrf" title="新增联合受让方" id="union_select_div" closed='true'>
    <%--<div class="" id="union_select_div" style="display: none;">--%>
    <div class="weui-mask"></div>
    <div class="" style="height:100%;overflow-y:scroll;">
        <%--<div class="weui-dialog__hd_srf" style="height: 30px;      padding: 10px;  background: #f5f5f5;line-height: 30px;border-bottom: 1px #ddd solid;"><strong class="weui-dialog__title">新增联合受让方</strong></div>--%>
        <div class="weui-dialog__bd_srf">
            <form id="pj_gq_addUnion">

                <input type="hidden" id="union_baoMing_guid" name="info['baoMingGuid']" value="${data.RowGuid }">
                <!-- 联合受让方报名统一标识 -->
                <input type="hidden" id="shouRang_guid" name="info['shouRangGuid']" value="">
                <input type="hidden" id="union_row_guid" name="info['rowGuid']" value=""><!-- 联合受让方唯一标识 -->
                <input type="hidden" name="info['zhuanRangType']" value="${data.ZhuanRangType }"><!-- 转让方式 -->
                <input type="hidden" name="info['unionType']" id="union_type" value=""><!-- 转让方式 -->


             <!--   <div style="margin-bottom:20px" id="pj_sign_srf">
                    <div style="margin-bottom:20px">
                        <label class="label-top">受让方名称<font color="red">(*)</font>:</label>
                        <input class="easyui-textbox" style="width:50%;display: block;" data-options="required:true"
                               name="info['shouRangName']" id="shouRang_name"
                               type="text" value="">
                    </div>
                    <div class="weui-cell__ft" style="font-size: 0">
                        <span></span>
                    </div>
                </div> -->

                <div style="margin-bottom:20px">
                    <label class="label-top">受让方名称<font color="red">(*)</font>:</label>
                    <select class="easyui-combogrid" style="width:100%" data-options="
                    panelWidth: 600,
                    idField: 'danWeiName',
                    textField: 'danWeiName',
                    url: 'get_srf_listToEasyui',
                    method: 'get',
                    columns: [[
                        {field:'id',title:'序号',width:120},
                        {field:'unitOrgNum',title:'组织机构代码',width:160},
                        {field:'danWeiName',title:'竞买方',width:120,align:'right'}
                    ]],
                    fitColumns: true
                ,required:true"  name="info['shouRangName']" id="shouRangFang_name">
                    </select>
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top" style="width:100%; display:block;">受让方类型:</label>
                    <select class="easyui-combobox" labelPosition="top" style="width:50%;display: block;"
                            name="info['shouRangRenType']" id="shouRangRen_type">
                        <option value="1">法人</option>
                        <option value="2">自然人</option>
                    </select>
                </div>

                <div style="margin-bottom:20px" id="shouRang_percent_div">
                    <label class="label-top">受让比例(%)<font color="red">(*)</font>:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" data-options="required:true"
                           name="info['shouRangPercent']" id="shouRang_percent"
                           type="number" value="" placeholder="请输入受让比例">
                </div>

                <div style="margin-bottom:20px" id="shouRang_gufen_div">
                    <label class="label-top">受让股份(股)<font color="red">(*)</font>:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" data-options="required:true"
                           name="info['shouRangGuFen']" id="shouRang_gufen"
                           type="number" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">联系人姓名:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['lianXiName']"
                           id="lianXi_name" type="text" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">联系人电话:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['lianXiTel']" type="text"
                           id="lianXi_tel" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">联系人邮件:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['lianXiEmail']"
                           type="text" id="lianXi_email" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">联系人传真:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['lianXiFax']" type="text"
                           id="lianXi_fax" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">委托会员单位名称:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['weiTuoDWName']"
                           type="text" id="weiTuoDW_name" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">委托会员联系人电话:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['weiTuoDWLianXiTel']"
                           type="text" id="weiTuoDW_lianXiTel" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">委托会员核实意见:</label>
                    <input class="easyui-textbox" style="width:50%;display: block; height:80px;"
                           data-options="multiline:true" id="weiTuoHY_heShi"
                           name="info['weiTuoHYHeShi']">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">委托会员工位号:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['weiTuoHYNo']"
                           type="text" id="weiTuoHY_No" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">委托会员经纪人:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['weiTuoHYName']"
                           id="weiTuoHY_name" type="text" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">委托会员经纪人编码:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['weiTuoHYCode']"
                           type="text" id="weiTuoHY_code" value="">
                </div>

                <div style="margin-bottom:20px">
                    <label class="label-top">委托会员联系人:</label>
                    <input class="easyui-textbox" style="width:50%;display: block;" name="info['weiTuoHYLianXiName']"
                           id="weiTuoHY_lianXiName" type="text" value="">
                </div>
            </form>
        </div>
        <div class="weui-btn-area clearfix">
            <%--<div>--%>
            <%--<a  class="easyui-linkbutton" iconCls="icon-ok" style="width:20%;height:32px" id="btn_cancel">取消</a>--%>
            <%--<a  class="easyui-linkbutton" iconCls="icon-ok" style="width:20%;height:32px" id="btn_ok">确定</a>--%>
            <%--</div>--%>
            <a class="weui-btn weui-btn_default" href="javascript:" id="btn_cancel">取消</a>
            <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_ok">确定</a>
        </div>
    </div>
    <%--</div>--%>
</h4>
<!--新增联合受让方dialog end-->
</body>

</html>

