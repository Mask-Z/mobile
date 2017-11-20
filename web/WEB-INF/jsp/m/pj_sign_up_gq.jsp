<%@page import="org.apache.commons.lang3.StringUtils" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">

<head>

    <jsp:include page="mate.jsp"></jsp:include>

    <%--<link rel="stylesheet" type="text/css" href="css/jquery-weui.css">--%>
    <%--<link rel="stylesheet" type="text/css" href="m/weui/weui.css">--%>
    <link rel="stylesheet" href="m/css/index.css">
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js"></script>
    <%--<script type="text/javascript" src="js/jquery-weui.js"></script>--%>
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
<%
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
<style>
    .weui-cells .weui-cell-srf:nth-child(2n+2) {
        background-color: #f5f5f5;
    }
</style>
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
                $("#bmjzsj").html("报名已结束");
            } else {
                $("#bmjzsj").html("距离报名截止时间还有:" + DateOp.formatMsToStr2(endTime - nowTime));
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
                $("#td_gf1").hide();
                $("#td_gf2").hide();
                $("#input_gf").textbox({required:false});
            } else {
                $("#td_bl1").hide();
                $("#td_bl2").hide();
                $("#input_bl").textbox({required:false});
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
            if ($("#srf_js_tooltips").css('display') != 'none') return false;


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
                $("#srf_js_tooltips").css('display', 'block');
                setTimeout(function () {
                    $("#srf_js_tooltips").css('display', 'none');
                }, 3000);
                alert( $("#srf_js_tooltips").text());
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
            $("#union_select_div").fadeIn(200);
            $("#pj_gq_submit").hide();
        });

        $("#is_managerLayer").change(function () {
            var is_managerLayer = $(this).val();
            if (is_managerLayer == 1) {
                $("#zhiwu_div").show();
                $("#shenji").show();
            } else {
                $("#zhiwu_div").hide();
                $("#shenji").hide();
            }
        });


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
//            }else{
//                $("#shouRang_name").val('');
                }
            });
//        if ($.trim($("#shouRang_name").val()) == ''){
//            $("#shouRang_name").val($("#searchInput").val());
//        }
            $("#srf_select_div").fadeOut(200);
            $("#pj_gq_submit").show();
        });

        $("#srf_sel_cancel").on("click", function () {
            $("#srf_select_div").fadeOut(200);
            $("#pj_gq_submit").show();
        });

        //新增/修改联合受让方保存
        $("#editsave").click(function () {
            if($("#addLHSR").form('validate')) {
//                $("#addLHSR").submit();
                var param = $("#addLHSR").serialize();
                $.ajax({
                    type: "POST",
                    url: "pj_gq_addUnion_submit",
                    dataType: "json",
                    data: param,
                    success: function (result) {
                        if (result) {
                            if (result.code == 0) {
                                alert(result.msg);
                                setUnionDiv($("#union_baoMing_guid").val());
                            } else {
                                alert(result.msg);
                            }
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("error: "+errorThrown);
                    }
                });
                $("#dlg_lhsr").dialog('close');
            }
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
                        $("#union_table").empty();
                        var innerHtml = "";
                        innerHtml += ' <tbody> <tr>' +
                            '<td  width="10%" align="center" class="title">序号</td> <td class="title" width="30%" align="center">联合受让方名称</td>';

                        if (zhuanRangType == "1") {
                            innerHtml += ' <td align="center"  width="30%" class="title">拟受让比例（%）</td>';

                        } else if (zhuanRangType == "2") {
                            innerHtml += ' <td align="center"  width="30%" class="title">拟受让股份（股）</td>';

                        }
                        innerHtml +='<td class="title" width="10%" align="center">查看</td><td class="title" width="10%" align="center">修改</td><td class="title" width="10%" align="center">删除</td></tr>';
                        $.each(result, function (i, data) {
//       	                var innerHtml = "";
                            if (zhuanRangType == "1") {
                                innerHtml += ' <tr> <td  align="center" >' + (i + 1) + '</td>' +
                                    '<td align="center">' + data.ShouRangName + '</td>' +
                                    '<td align="center">' + data.ShouRangPercent + '</td>' +
                                    '<td align="center"> <a href="javascript:void(0)" class="easyui-linkbutton" >查看</a></td><td align="center"> <a href="javascript:void(0)" class="easyui-linkbutton" >修改</a></td><td align="center"> <a href="javascript:void(0)" class="easyui-linkbutton" >删除</a></td>' +
                                    '</tr>' +
                                    "<input type='hidden' value='" + data.RowGuid + "'>";
                            } else if (zhuanRangType == "2") {
                                innerHtml += ' <tr> <td align="center" >' + (i + 1) + '</td>' +
                                    '<td align="center">' + data.ShouRangName + '</td>' +
                                    '<td align="center">' + data.ShouRangGufen + '</td>' +
                                    '<td align="center"> <a href="javascript:void(0)" class="easyui-linkbutton" >查看</a></td><td align="center"> <a href="javascript:void(0)" class="easyui-linkbutton" >修改</a></td><td align="center"> <a href="javascript:void(0)" class="easyui-linkbutton" >删除</a></td>' +
                                    '</tr>' +
                                    "<input type='hidden' value='" + data.RowGuid + "'> ";
                            }
                        });
                        $("#union_table").append(innerHtml + "</tbody>");

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
<script>
    $(function () {
        $('input:radio[name=""]').change(function () {

        })
    })

    $(function(){
//        if ($.browser.msie) {
//            $('input:checkbox').click(function () {
//                this.blur();
//                this.focus();
//            });
//        };
        var ml="${data.IsManagerLayer}";
        var usertype="${user_type }";
        if (ml =='1'){
            if (usertype==0) {//单位
                $("#row_danwei").attr("rowspan","12");
                $("#zhiwu_div").show();
            }
            if (usertype==1){//个人
                $("#row_geren").attr("rowspan", "7");
                $("#zhiwu_div").show();
            }
        }
        $("#managerLayer_geren").change(function() {
            if($("#managerLayer_geren").is(':checked')){
                    $("#row_geren").attr("rowspan","7");
                    $("#zhiwu_div").show();
            }else{
                $("#row_geren").attr("rowspan","6");
                $("#zhiwu_div").hide();
            }
        });
        $("#managerLayer_danwei").change(function() {
            if($("#managerLayer_danwei").is(':checked')){
                $("#row_danwei").attr("rowspan","12");
                $("#zhiwu_div").show();
            }else{
                $("#row_danwei").attr("rowspan","11");
                $("#zhiwu_div").hide();
            }
        });
    });
</script>
<header class="h43">
    <div class="index-header">
        <a href="pj_list_cqjy" class="back"></a>
        <div class="title">
            <a id="btn_save" class="easyui-linkbutton c1" style="width:80px" >下一步</a>
            <%--<a  class="easyui-linkbutton c2" style="width:120px">新增联合受让方</a>--%>
            <%--<a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#dlg_lhsr').dialog('open')">新增联合受让方</a>--%>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="addUnion()">新增联合受让方</a>
            项目报名</div>
        <a href="javascript:showRule1();" class="h-r"><i class="glyphicon glyphicon-filter"></i></a>
    </div>
</header>
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
<div style="margin:5px 0;"></div>

<div id="dlg_lhsr" class="easyui-dialog" title="新增联合受让方" data-options="iconCls:'icon-save',closed:true" style="width:800px;height:600px;padding:10px">
    <div>
        <a href="javascript:void(0)" class="easyui-linkbutton" id="editsave" >修改保存</a>
        <span style="float: right"><font color="red">注意:信息录入完成后,请务必要点击左侧的[修改保存]按钮!</font></span>
    </div>
    <form id="addLHSR">

                <input type="hidden" id="union_baoMing_guid" name="info['baoMingGuid']" value="${data.RowGuid }">
                <!-- 联合受让方报名统一标识 -->
                <input type="hidden" id="shouRang_guid" name="info['shouRangGuid']" value="">
                <input type="hidden" id="union_row_guid" name="info['rowGuid']" value=""><!-- 联合受让方唯一标识 -->
                <input type="hidden" name="info['zhuanRangType']" value="${data.ZhuanRangType }"><!-- 转让方式 -->
                <input type="hidden" name="info['unionType']" id="union_type" value=""><!-- 转让方式 -->

                <table class="myform" title="报名详情" style="width:100%;height:250px" border="1">
                    <thead>
                    <tr>
                        <td class="title">受让方名称<font color="red">(*)</font></td>
                        <td colspan="2">
                            <input class="easyui-textbox" type="text" style="width: 80%" id="srfmc" name="info['shouRangName']"  data-options="required:true" readonly/>
                            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#dlg_js').dialog('open')">检索</a>
                        </td>
                        <td class="title">受让方类型</td>
                        <td colspan="2">
                            <input type="radio" value="1" name="info['shouRangRenType']" checked>法人
                            <input type="radio" value="2" name="info['shouRangRenType']" >自然人
                        </td>
                    </tr>
                    <tr>
                        <td class="title"  id="td_bl1">受让比例(%)<font color="red">(*)</font></td>
                        <td colspan="2" id="td_bl2"> <input class="easyui-textbox" type="text" id="input_bl" name="info['shouRangPercent']" style="width: 90%" data-options="required:true"/>%</td>
                        <td class="title"  id="td_gf1">受让股份(股)<font color="red">(*)</font></td>
                        <td colspan="2"  id="td_gf2"> <input class="easyui-textbox" style="width: 100%" id="input_gf" type="text" name="info['shouRangGuFen']" data-options="required:true"/></td>
                        <td class="title"></td>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td class="title">联系人姓名</td>
                        <td colspan="2"> <input class="easyui-textbox" type="text" name="info['lianXiName']" style="width: 100%"/></td>
                        <td class="title">联系人电话</td>
                        <td colspan="2"><input class="easyui-textbox" type="text" name="info['lianXiTel']" style="width: 100%"/></td>
                    </tr>
                    <tr>
                        <td class="title">联系人邮件</td>
                        <td colspan="2"><input class="easyui-textbox" type="text" name="info['lianXiEmail']" style="width: 100%"/></td>
                        <td class="title">联系人传真</td>
                        <td colspan="2"><input class="easyui-textbox" type="text" name="info['lianXiFax']" style="width: 100%"/></td>
                    </tr>
                    <tr>
                        <td class="title">委托会员单位名称</td>
                        <td colspan="2"><input class="easyui-textbox" type="text" name="info['weiTuoDWName']" style="width: 100%"/></td>
                        <td class="title">委托会员联系人电话</td>
                        <td colspan="2"><input class="easyui-textbox" type="text" name="info['weiTuoDWLianXiTel']" style="width: 100%"/></td>
                    </tr>
                    <tr>
                        <td class="title">委托会员核实意见</td>
                        <td colspan="4">
                            <input class="easyui-textbox" style="height:80px;width: 100%" data-options="multiline:true"
                                   name="info['weiTuoHYHeShi']" >
                        </td>
                    </tr>
                    <tr>
                        <td class="title">委托会员工位号</td>
                        <td colspan="2"><input class="easyui-textbox" type="text" name="info['weiTuoHYNo']" style="width: 100%"/></td>
                        <td class="title">委托会员经纪人</td>
                        <td colspan="2"><input class="easyui-textbox" type="text" name="info['weiTuoHYName']" style="width: 100%"/></td>
                    </tr>
                    <tr>
                        <td class="title">委托会员经纪人编码</td>
                        <td colspan="2"><input class="easyui-textbox" type="text" name="info['weiTuoHYCode']" style="width: 100%"/></td>
                        <td class="title">委托会员联系人</td>
                        <td colspan="2"><input class="easyui-textbox" type="text" name="info['weiTuoHYLianXiName']" style="width: 100%"/></td>
                    </tr>
                    </thead>
                </table>

            </form>
</div>
<div id="dlg_js" class="easyui-dialog" title="竞买方列表" data-options="iconCls:'icon-save',closed:true" style="width:600px;height:400px;padding:10px">
    <table class="myform">
        <tr>
            <td class="title">竞买方</td>
            <td  colspan="2"><input class="easyui-textbox" type="text"  style="width: 95%" id="jmf"/></td>
            <td class="title">组织机构代码</td>
            <td  colspan="2"><input class="easyui-textbox" type="text"  style="width: 95%" id="zzjgdm"/></td>
        </tr>
    </table>
    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="getjmfList()">搜索</a>
    <table id="jmfList_table"  >
    </table>
</div>
<script>
        var projectGuid='${ProjectGuid}';
        var rowGuid='${data.RowGuid}';
        var type='0';
        function getjmfList() {
            var  jmf=$('#jmf').val();
            var  zzjgdm=$('#zzjgdm').val();
             $('#jmfList_table').datagrid({
            url:"get_srf_list",
            queryParams: { 'projectGuid': projectGuid ,'rowGuid':rowGuid,'srfNameOrUnitCode':jmf,'type':type },
            pageList:[15,20,30,40,50],
            columns:[[
                {field:'id',title:'全选',checkbox:true},
                {field:'xuhao',title:'序号',width:80,align:'left'},
                {field:'DanWeiName',title:'竞买方',width:80,align:'left'},
                {field:'UnitOrgNum',title:'组织机构代码',width:80,align:'left'},
                {field:'operation',title:'操作',width:80,align:'center',
                    formatter: function(value,row,index){
                        var str = "";
                        str += '<a href="javascript:;" style="color: green" onClick = "jmfSelect(\''+row.DanWeiName+'\')">选择</a>';
                        return str;
                    }
                }
            ]]
        });
    };

    function jmfSelect(DanWeiName) {
        if (DanWeiName!=''){
            $("#srfmc").textbox({required:false});
        }
        $('#srfmc').textbox('setValue',DanWeiName);
        $("#dlg_js").dialog('close');
    }

    function addUnion() {
        $("#union_type").val("union_add");
        $("#dlg_lhsr").dialog('open');
    }

</script>
<!--
<table id="table" style="height:100%;width: 100%;" data-options="">
    <thead>
    <tr>
        <th colspan="9">
            <div style="padding: 2px;background: white;">
                <div style="line-height: 32px;">
                    <input class="easyui-searchbox" data-options="prompt:'请输入',menu:'#tool_search_select',searcher:doSearch2" style="width:300px"></input>
                    开始: <input class="easyui-datebox" style="width:110px">
                    结束: <input class="easyui-datebox" style="width:110px">
                    部门:
                    <input class="easyui-combobox" style="height:26px;" data-options="
		                    showItemIcon: true,
		                    editable :false,
		                    groupField:'group',
		                    panelHeight:'auto',
		                    data: [
		                        {value:'add',text:'技术支持部',iconCls:'icon-add','group':'常州部'},
		                        {value:'del',text:'测试部',iconCls:'icon-remove','group':'常州部'},
		                        {value:'save',text:'运维部',iconCls:'icon-save','group':'常州部',selected:true},
		                        {value:'cancel',text:'产品研发部',iconCls:'icon-cancel','group':'常州部'},
		                        {value:'undo',text:'业务开发部',iconCls:'icon-undo','group':'常州部'},
		                        {value:'redo',text:'销售部',iconCls:'icon-redo','group':'上海部'},
		                        {value:'undo',text:'财务部',iconCls:'icon-undo','group':'上海部'},
		                        {value:'redo',text:'风控部',iconCls:'icon-redo','group':'上海部'},
		                        {value:'undo',text:'业务部',iconCls:'icon-undo','group':'上海部'},
		                        {value:'redo',text:'人力资源部',iconCls:'icon-redo','group':'上海部'},
		                        {value:'undo',text:'行政部',iconCls:'icon-undo','group':'上海部'},
		                    ]
		                    ">
                </div>
                <div style="line-height: 32px;">
                    性别：
                    <label><input type="radio" name="sex" value="" checked><span>全部</span></label>
                    <label><input type="radio" name="sex" value="m"><span>男</span></label>
                    <label><input type="radio" name="sex" value="w"><span>女</span></label>

                    兴趣：
                    <input class="easyui-combobox" style="height:26px" data-options="
							valueField: 'label',
							textField: 'value',
							multiple:true,
							data: [{
								label: '1',
								value: 'Java'
							},{
								label: '2',
								value: 'Perl'
							},{
								label: '3',
								value: 'Ruby'
							}],
							value:[1,3]" />

                    技能：
                    <input class="easyui-combobox" name="language" style="height:26px" data-options="
	                    editable:false,
	                    url:'example/combobox/combobox_data1.json',
	                    method:'get',
	                    valueField:'id',
	                    textField:'text',
	                    value:[1,3],
	                    multiple:true,
	                    panelHeight:'auto'
	                    ">
                </div>

                <div>
                    <a href="#" style="height: 26px;" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'">搜索</a>
                    <a href="#" style="height: 26px;" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">添加</a>
                    <a href="#" style="height: 26px;" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove'">删除</a>
                    <a href="#" style="height: 26px;" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit',disabled:true">编辑</a>
                </div>
            </div>
        </th>
    </tr>
    <tr>
        <th data-options="field:'ck',checkbox:true"></th>
        <th data-options="field:'itemid',width:80,formatter:text"
            sortable="true"><span class="easyui-tooltip" title="唯一ID">ID</span></th>
        <th data-options="field:'productid',width:100" sortable="true"><span class="easyui-tooltip" title="登陆的账号名">账号</span></th>
        <th data-options="field:'listprice',width:80,formatter:listprice,align:'center'" sortable="true">List Price</th>
        <th data-options="field:'unitcost',width:160,formatter:unitcost,align:'center'">Unit Cost</th>
        <th data-options="field:'status',width:80,formatter:status,align:'center'">Attribute</th>
        <th data-options="field:'attr1',width:120,align:'center'">Status</th>
        <th data-options="field:'operate',align:'center',formatter:operate">Operate</th>
        <th data-options="field:'button',width:120,align:'center',formatter:button">Button</th>
    </tr>
    </thead>
</table>
<div id="tool_search_select">
    <div data-options="name:'all',iconCls:'icon-ok'">账号</div>
    <div data-options="name:'sports',iconCls:'icon-man'">用户</div>
</div>
<script>
    function doSearch2(value,name){
        alert('You input: ' + value+'('+name+')');
    }
</script>
<script>
    function listprice(value,row,index){
        return "<span class='block-success span-badge'>"+value+"</span>";
    }
    function unitcost(value,row,index){
        var progressbar;
        if(value<10){
            progressbar="<div class='progressbar progressbar-green' data-options='value:"+value+"'>"+value+"</div>";
        }else if(value>10&&value<30){
            progressbar="<div class='progressbar progressbar-blue' data-options='value:"+value+"'>"+value+"</div>";
        }else if(value>30&&value<50){
            progressbar="<div class='progressbar' data-options='value:"+value+"'>"+value+"</div>";
        }else if(value>50&&value<80){
            progressbar="<div class='progressbar progressbar-yellow' data-options='value:"+value+"'>"+value+"</div>";
        }else{
            progressbar="<div class='progressbar progressbar-red' data-options='value:"+value+"'>"+value+"</div>";
        }

        return progressbar;
    }
    function operate(value,row,index){
        return "<a href='javascript:void(0)' class='operate' data-options='value:"+value+",iconCls:\"icon-set\"'></a>";
    }
    function status(value,row,index){
        return "<input class='switchbutton'>";
    }
    function button(value,row,index){
        return "<a href='javascript:confirm_delete();' class='button-delete button-danger'>删除</a> <a href='javascript:confirm_edit();' class='button-edit button-default'>编辑</a>";
    }
    function text(value,row,index){
        return "<input class='text' value='"+value+"'>";
    }
    function confirm_delete(){
        $.messager.confirm('提示', '确认删除?', function(r){
            if (r){
                $.messager.alert('提示','删除成功','success');
            }
        });
    }
    function confirm_edit(){
        $.messager.confirm('提示', '确认编辑?', function(r){
            if (r){
                $.messager.alert('提示','编辑界面打开','success');
            }
        });
    }
    $(function(){
        $("#table").datagrid({
            cls:"theme-datagrid",
            title:"账号管理",
            iconCls :"icon-search",
            toolbar: "#tool_search",
            singleSelect:true,
            //默认排序字段itemid升序
            sortName:"itemid",
            sortOrder:"asc",
            //showFooter:true,
            cache:false,
            //是否开启分页
            pagination:true,
            pageSize:10,
            //rownumbers:true,//显示序号
            collapsible:true,
            url:"example/application/datagrid_data4.json",
            onLoadSuccess:function(){
                $(".operate").menubutton({
                    plain:false,
                    menu: "#operate_menu"
                });
                $("#operate_menu").menu({
                    onClick:function(item){
                        var a=$(".operate").menubutton("options");
                        switch (item.name)
                        {
                            case "undo":
                                alert("undo "+a.value);
                                break;
                            case "redo":
                                alert("redo "+a.value);
                                break;
                            case "cut":
                                alert("cut "+a.value);
                                break;
                            case "copy":
                                alert("copy "+a.value);
                                break;
                            case "paste":
                                alert("paste "+a.value);
                                break;
                            case "delete":
                                alert("delete "+a.value);
                                break;
                        }
                    }
                });

                $(".progressbar").progressbar({});

                $(".switchbutton").switchbutton({
                    height:23
                });

                $(".button-delete").linkbutton({
                });
                $(".button-edit").linkbutton({
                });

                $(".text").textbox({
                    width:70,
                    height:30
                })

                $(".operate-append,.operate-edit,.operate-delete").linkbutton({});
                $(".operate-append").on('click', function(){
                    var a=$(this).linkbutton("options");
                    alert("append "+a.value);
                });
                $(".operate-edit").on('click', function(){
                    var a=$(this).linkbutton("options");
                    alert("edit "+a.value);
                });
                $(".operate-delete").on('click', function(){
                    var a=$(this).linkbutton("options");
                    alert("delete "+a.value);
                });
            }
        });
    })
</script>
<div id="operate_menu" style="width:150px;">
    <div data-options="name:'undo'">Undo</div>
    <div data-options="name:'redo'">Redo</div>
    <div class="menu-sep"></div>
    <div data-options="name:'cut'">Cut</div>
    <div data-options="name:'copy'">Copy</div>
    <div data-options="name:'paste'">Paste</div>
    <div class="menu-sep"></div>
    <div data-options="name:'delete'">Delete</div>
    <div>Select All</div>
</div>
-->
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


    <table class="myform" title="报名详情" style="width:100%;height:250px" border="1">
        <thead>
        <tr>
            <td class="title">标的编号</td>
            <td colspan="3">${data.ProjectNo_3001 }</td>
            <td class="title">标的名称</td>
            <td colspan="2">${data.ProjectName_3001 }</td>
        </tr>
        <tr>
            <td class="title">标的类型</td>
            <td colspan="5"><c:if test="${data.BiaoDiType_3001==1}">股权</c:if>
                <c:if test="${data.BiaoDiType_3001==2}">股权+债权</c:if></td>
        </tr>
        <tr>
            <td class="title">挂牌价</td>
            <td colspan="5"><fmt:formatNumber type="number" value="${data.GuaPaiPrice }" pattern="0.000000"
                                              maxFractionDigits="6"/> 万元
            </td>
        </tr>
        <tr>
            <td class="title">报名截止时间</td>
            <td colspan="5">${data.GongGaoToDate}&nbsp;&nbsp;<span id="bmjzsj"></span>&nbsp;&nbsp;<a
                    class="weui-btn weui-btn_primary" href="infodetail?${fn:split(data.GongGaoUrl,'?')[1]}">查看网站公告原文</a>
            </td>
        </tr>
        <tr>
            <td class="title" colspan="6">报名信息：如有基本信息未填写，请先到会员库中完善基本信息</td>
        </tr>
        <tr>
            <td class="title">是否国资<font color="red">(*)</font></td>
            <td colspan="3">
                <input type="radio" name="info['IsGuoZi']" value="T"
                       <c:if test="${data.IsGuoZi=='T'}">checked="true"</c:if>>国资</input>
                <input type="radio" name="info['IsGuoZi']" value="F"
                       <c:if test="${data.IsGuoZi=='F'}">checked="true"</c:if>>非国资</input>
            </td>
            <td class="title">法人类型<font color="red">(*)</font></td>
            <td colspan="2">
                <input type="radio" name="frlx"
                       <c:if test="${data.FaRenType==2}">checked="true"</c:if> disabled>自然人</input>
                <input type="radio" name="frlx"
                       <c:if test="${data.FaRenType==1}">checked="true"</c:if> disabled>企事业单位</input>
            </td>
        </tr>

        <c:if test="${user_type==0 }">
            <!-- 单位信息 begin -->
            <tr>
                <td class="title" rowspan="11" id="row_danwei">基本情况</td>
                <td class="title">受让方名称</td>
                <td colspan="2">${data.DanWeiName }</td>
                <td class="title">所在地区<font color="red">(*)</font></td>
                <td colspan="1" id="area">${data.AreaName }</td>
            </tr>
            <tr>
                <td colspan="5"><input name="info['IsManagerLayer']" type="checkbox" id="managerLayer_danwei"
                                       <c:if test="${data.IsManagerLayer=='1'}">checked</c:if>>标的企业管理层直接或间接出资
                </td>
            </tr>
            <tr id="zhiwu_div" style="display: none;">
                <td class="title">职务<font color="red">(*)</font></td>
                <td colspan="2">
                    <input class="easyui-textbox" name="info['ZhiWu']" type="text" id="zhi_wu" value="${data.ZhiWu }" placeholder="请输入职务" data-options="required:true"/>
                </td>
                <td class="title">是否进行了经济责任审计<font color="red">(*)</font></td>
                <td colspan="1" >
                    <input type="radio" value="1" name="info['hasAudit']" <c:if test="${empty data.hasAudit or data.hasAudit=='1'}">checked="true"</c:if>>是
                    <input type="radio" value="0" name="info['hasAudit']" <c:if test="${data.hasAudit=='0'}">checked="true"</c:if>>否
                </td>
            </tr>
            <tr>
                <td class="title">注册地<font color="red">(*)</font></td>
                <td colspan="2">
                    <input class="easyui-textbox" type="text" name="info['ZhuCeDi']" value="${data.ZhuCeDi }"
                           data-options="required:true"/>
                </td>
                <td class="title">注册资本<font color="red">(*)</font></td>
                <td colspan="1">
                    <input class="easyui-textbox" type="text" name="info['ZhuCeZiBen']" value="${data.ZhuCeZiBen }"
                           data-options="required:true"/>
                </td>
            </tr>
            <tr>
                <td class="title">成立时间</td>
                <td colspan="2">
                    <input class="easyui-datebox" type="text" name="info['ChengLiDate']" value="<%=cldate %>"/>
                </td>
                <td class="title">法定代表人</td>
                <td colspan="1">
                    <input class="easyui-textbox" type="text" name="info['FaRen_13003']" value="${data.FaRen_13003 }"/>
                </td>
            </tr>
            <tr>
                <td class="title">所属行业<font color="red">(*)</font></td>
                <td colspan="4">
                    <select class="easyui-combobox" name="info['HangYeTypeCode']" style="width:50%;" id="hangYeType_code" data-options="required:true">
                        <c:forEach items="${hangYeTypes}" var="hangYeType">
                            <option value="${hangYeType.code}"
                                    <c:if test="${hangYeType.code eq data.HangYeTypeCode}">selected</c:if>>${hangYeType.value}</option>
                        </c:forEach>
                    </select>
                    <input type="hidden" name="info['HangYeType']" value="${data.HangYeType}">
                </td>
            </tr>
            <tr>
                <td class="title">金融类所属行业</td>
                <td colspan="4">
                    <select class="easyui-combobox" name="info['IndustryCCode']" style="width:50%;" id="industryC_code">
                        <option value=""></option>
                        <c:forEach items="${industryCs}" var="industryC">
                            <option value="${industryC.code}"
                                    <c:if test="${industryC.code eq data.IndustryCCode}">selected</c:if>>${industryC.value}</option>
                        </c:forEach>
                    </select>
                    <input type="hidden" name="info['IndustryCName']" value="${data.IndustryCName}">
                </td>
            </tr>
            <tr>
                <td class="title">公司类型(经济性质)<font color="red">(*)</font></td>
                <td colspan="2">
                    <select class="easyui-combobox" style="width: 50%" name="info['CompanyLeiXing']" data-options="required:true">
                        <c:forEach items="${companyLeiXings}" var="companyLeiXing">
                            <option value="${companyLeiXing.code}"
                                    <c:if test="${companyLeiXing.code eq data.CompanyLeiXing}">selected</c:if>>${companyLeiXing.value}</option>
                        </c:forEach>
                    </select>
                </td>
                <td class="title">企业性质(经济类型)<font color="red">(*)</font></td>
                <td colspan="1">
                    <select class="easyui-combobox" style="width: 50%" name="info['CompanyXingZhi']" data-options="required:true">
                        <c:forEach items="${companyXingZhis}" var="companyXingZhi">
                            <option value="${companyXingZhi.code}"
                                    <c:if test="${companyXingZhi.code eq data.CompanyXingZhi}">selected</c:if>>${companyXingZhi.value}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="title">企业组织机构代码</td>
                <td colspan="2">${data.UnitOrgNum }</td>
                <td class="title">经营规模<font color="red">(*)</font></td>
                <td colspan="1">
                    <input
                            <c:if test="${data.GuiMo==0}">checked</c:if> type="radio" name="info['GuiMo']" value="0"/>大型
                    <input
                            <c:if test="${data.GuiMo==1}">checked</c:if> type="radio" name="info['GuiMo']" value="1"/>中型
                    <input
                            <c:if test="${data.GuiMo==2}">checked</c:if> type="radio" name="info['GuiMo']" value="2"/>小型
                    <input
                            <c:if test="${data.GuiMo==3}">checked</c:if> type="radio" name="info['GuiMo']" value="3"/>微型
                </td>
            </tr>
            <tr>
                <td class="title">经营范围<font color="red">(*)</font></td>
                <td colspan="4">
                    <input class="easyui-textbox" style="height:80px;width: 100%" data-options="multiline:true,required:true"
                           name="info['JingYingFanWei']" id="jingyingfanwei" value="${data.JingYingFanWei }">
                </td>
            </tr>
            <tr>
                <td class="title">受让资格陈述</td>
                <td colspan="4">
                    <input class="easyui-textbox" style=" height:80px;width: 100%" data-options="multiline:true"
                           name="info['ShouRangZiGe']" value="${data.ShouRangZiGe}">
                </td>
            </tr>
            <tr>
                <td class="title">近期资产情况</td>
                <td colspan="5">
                    <table border="1" width="100%">
                        <thead>
                        <tr>
                            <td class="title">数据来源</td>
                            <td><input id="s90" type="checkbox" name="checkbox1">审计报告<input id="s100" type="checkbox"
                                                                                            name="checkbox1">财务报表
                            </td>
                        </tr>
                        <tr>
                            <td class="title">报表日期</td>
                            <td><input class="easyui-datebox" type="text" name="info['BaoBiaoDate']" value="<%=bbdate %>"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="title">币种</td>
                            <td>
                                <select class="easyui-combobox" style="width: 50%" name="info['MoneyType']">
                                    <c:forEach items="${biZhongs}" var="moneyType">
                                        <option value="${moneyType.code}"
                                                <c:if test="${moneyType.code eq data.MoneyType}">selected</c:if>>${moneyType.value}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="title">资产情况</td>
                            <td> 资产总计:<input type="easyui-textbox" name="info['ZiChanTotal']" value="${data.ZiChanTotal}">(万元);
                                负债总计:<input type="easyui-textbox" name="info['FuZhaiTotal']" value="${data.FuZhaiTotal}">(万元);
                                净资产:<input type="easyui-textbox" name="info['JingZiChan']" value="${data.JingZiChan}">(万元)
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
                <td class="title">所在地区<font color="red">(*)</font></td>
                <td colspan="1" id="area">${data.AreaName }</td>
            </tr>

            <tr>
                <td colspan="5"><input name="info['IsManagerLayer']" type="checkbox" id="managerLayer_geren"
                                       <c:if test="${data.IsManagerLayer=='1'}">checked</c:if>>标的企业管理层直接或间接出资
                </td>
            </tr>
            <tr id="zhiwu_div" style="display: none;">
                <td class="title">职务<font color="red">(*)</font></td>
                <td colspan="2">
                    <input class="easyui-textbox" name="info['ZhiWu']" type="text" id="zhi_wu" value="${data.ZhiWu }" placeholder="请输入职务" data-options="required:true"/>
                </td>
                <td class="title">是否进行了经济责任审计<font color="red">(*)</font></td>
                <td colspan="1" >
                    <input type="radio" value="1" name="info['hasAudit']" <c:if test="${empty data.hasAudit or data.hasAudit=='1'}">checked="true"</c:if>>是
                    <input type="radio" value="0" name="info['hasAudit']" <c:if test="${data.hasAudit=='0'}">checked="true"</c:if>>否
                </td>
            </tr>
            <tr>
                <td class="title">证件名称</td>
                <td colspan="2"><input class="easyui-textbox" name="info['ZhengName']" type="text"
                                       value="${data.ZhengName }"/></td>
                <td class="title">证件号码<font color="red">(*)</font></td>
                <td colspan="1"><input class="easyui-textbox" name="info['ZhengNo']" type="text" id="zheng_No"
                                       value="${data.ZhengNo }" data-options="required:true"/></td>
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
            <td class="title">是否标的公司原股东<font color="red">(*)</font></td>
            <td colspan="5">
                <input
                        <c:if test="${empty data.hasPriority or data.hasPriority=='1'}">checked</c:if> type="radio" name="info['hasPriority']"
                        value="1"/>是
                <input
                        <c:if test="${data.hasPriority=='0'}">checked</c:if> type="radio" name="info['hasPriority']"
                        value="0"/>否${data.hasPriority}
            </td>
        </tr>
        <tr>
            <td class="title">受让意愿<font color="red">(*)</font></td>
            <td colspan="5">
                受让底价(万元)<input type="easyui-textbox" name="info['ShouRangDiJia']" id="shourangdijia" data-options="required:true"
                               value="${data.ShouRangDiJia}">
                <select class="" name="info['ShouRangBiZhong']">
                    <c:forEach items="${biZhongs}" var="shouRangBiZhong">
                        <option value="${shouRangBiZhong.code}"
                                <c:if test="${shouRangBiZhong.code eq data.ShouRangBiZhong}">selected</c:if>>${shouRangBiZhong.value}</option>
                    </c:forEach></select>
                ;<span id="shou_RangPercent">拟受让比例<input type="easyui-textbox" name="info['ShouRangPercent']" id="srf_srp" data-options="required:true"
                                                         value="${data.ShouRangPercent }">%</span>
                <span id="shou_RangGuFen">拟受让比例<input type="easyui-textbox" name="info['ShouRangGuFen']" id="srf_srgf" data-options="required:true"
                                                      value="${data.ShouRangGuFen }"></span>
            </td>
        </tr>
        <tr>
            <td class="title">联系人<font color="red">(*)</font></td>
            <td colspan="3"><input type="easyui-textbox" name="info['LianXiUser']" id="lianxiren"
                                   value="${data.LianXiUser }" data-options="required:true"></td>
            <td class="title">联系电话<font color="red">(*)</font></td>
            <td colspan="2"><input type="easyui-textbox" name="info['LianXiTel']" id="lianxidianhua"
                                   value="${data.LianXiTel }" data-options="required:true"></td>
        </tr>
        <tr>
            <td class="title">电子邮箱</td>
            <td colspan="3">
                <input class="easyui-textbox" name="info['Email']" value="${data.Email }">
            </td>
            <td class="title">传真号码</td>
            <td colspan="2"><input class="easyui-textbox" name="info['ChuanZhen']" value="${data.ChuanZhen }">
            </td>
        </tr>
        <tr>
            <td class="title">资信证明</td>
            <td colspan="5"><input style="width: 100%" class="easyui-textbox" name="info['ZiXinZhengMing']"
                                   value="${data.ZiXinZhengMing }" readonly="readonly">
            </td>
        </tr>
        <tr>
            <td class="title" rowspan="3">委托会员</td>
            <td class="title">机构名称</td>
            <td colspan="2">
                ${data.BelongDLJGName }
            </td>
            <td class="title">工位号</td>
            <td colspan="1">
                <input class="easyui-textbox" name="info['GongWeiNo']" value="${data.GongWeiNo }">
            </td>
        </tr>
        <tr>
            <td class="title">经纪人</td>
            <td colspan="2">
                <input class="weui-textbox" name="info['JingJiRen']" value="${data.JingJiRen }"/>
            </td>
            <td class="title">经纪人编码</td>
            <td colspan="1">
                <input class="weui-textbox" name="info['JingJiRenCode']" value="${data.JingJiRenCode }"/>
            </td>
        </tr>
        <tr>
            <td class="title">联系人</td>
            <td colspan="2">
                <input class="weui-textbox" name="info['LianXiRen']" value="${data.LianXiRen }"/>
            </td>
            <td class="title">联系电话</td>
            <td colspan="1">
                <input class="weui-textbox" name="info['JGLianXiTel']" value="${data.JGLianXiTel }"/>
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
                        <td class="title" align="center">管理</td>
                    </tr>
                    <c:forEach items="${filelist}" var="file">
                        <tr>
                            <td align="center">${file.FileName}</td>
                            <td align="center"></td>
                            <td align="center" id="${file.FileCode}" need="${file.IsMustNeed}"><a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#dlg').dialog('open')">文件管理</a></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </td>
        </tr>
        </thead>
    </table>
    <div id="dlg" class="easyui-dialog" title="请选择上传文件" data-options="iconCls:'icon-save',closed:true" style="width:400px;height:200px;padding:10px">
        <form id="upform">
            <input name="fileCode" id="fileCode" type="hidden">
            <input name="rowGuid" type="hidden" value="${data.RowGuid }">
            <input id="uploaderInput" name="file" class="weui-uploader__input" type="file" accept="*" multiple/>
        </form>
    </div>
    <br>
    <table  width="100%" border="1px" id="union_table">
        <tbody>
        <tr>
            <td  width="10%" align="center" class="title">序号</td>
            <td class="title" width="30%" align="center">联合受让方名称</td>
            <c:if test="${data.ZhuanRangType=='1'}">
                <td align="center"  width="30%" class="title">拟受让比例（%）</td>
            </c:if>
            <c:if test="${data.ZhuanRangType=='2'}">
                <td align="center"  width="30%" class="title">拟受让股份（股）</td>
            </c:if>
            <td class="title" width="10%" align="center">查看</td>
            <td class="title" width="10%" align="center">修改</td>
            <td class="title" width="10%" align="center">删除</td>
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

                <td align="center"> <a href="javascript:void(0)" class="easyui-linkbutton" >查看</a></td>
                <td align="center"> <a href="javascript:void(0)" class="easyui-linkbutton" >修改</a></td>
                <td align="center"> <a href="javascript:void(0)" class="easyui-linkbutton" >删除</a></td>
            </tr>
            <input type="hidden" value="${union.RowGuid}">
        </c:forEach>
        </tbody>
    </table>
    <div style="height: 80px"></div>
</form>


<!--竞买人查询dialog start-->
<div class="js_dialog" id="srf_select_div" style="display: none;">
    <div class="weui-dialog_srf" id="autodiv">
        <div class="weui-dialog__bd" style="padding:0px;">
            <div class="weui-search-bar" id="searchBar">
                <select id="choose_srf" class="form-control input input-sm">
                    <option value="0">竞买方</option>
                    <option value="1">组织机构代码</option>
                </select>
                <form class="weui-search-bar__form">
                    <div class="weui-search-bar__box">
                        <input type="search" class="weui-search-bar__input" id="searchInput" placeholder="输入竞买方名称搜索"
                               required="">
                    </div>
                    <label class="weui-search-bar__label" id="searchText"
                           style="transform-origin: 0px 0px 0px; opacity: 1; transform: scale(1, 1);line-height:25px;">
                        <i class="weui-icon-search"></i>
                        <span>搜索</span>
                    </label>
                </form>
            </div>
            <div class="weui-cells searchbar-result weui-cells_radio" id="searchResult"
                 style="transform-origin: 0px 0px 0px; opacity: 1; transform: scale(1, 1); display: none;overflow-y: scroll">

            </div>
        </div>
        <div class="weui-btn-area">
            <a class="weui-btn weui-btn_default" href="javascript:" id="srf_sel_cancel">取消</a>
            <a class="weui-btn weui-btn_primary" href="javascript:" id="srf_sel_ok">确定</a>
        </div>
    </div>
</div>
<!--竞买人查询dialog end-->

<div class="js_dialog" id="hyjg_select_div" style="display: none;height: 400px;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
        <div class="weui-dialog__hd" style="height: 30px"><strong class="weui-dialog__title">机构名称</strong></div>
        <div class="weui-dialog__bd" style="height: 400px;overflow-y:scroll;">
            <div class="weui-cells weui-cells_radio">
                <c:forEach items="${sshyjg }" var="hyjg" varStatus="jg">
                    <label class="weui-cell weui-check__label" for="x${jg.index }"
                           style="text-align: left;font-size: 14px">
                        <div class="weui-cell__bd">
                            <p>${hyjg.name }</p>
                        </div>
                        <div class="weui-cell__ft">
                            <input type="radio" class="weui-check" hyname="${hyjg.name }" value="${hyjg.guid }"
                                   name="sshyjg" id="x${jg.index }">
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



<%--<div>--%>
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
<div id="loadingToast" style="display:none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
        <i class="weui-loading weui-icon_toast"></i>
        <p class="weui-toast__content" id="toast_div">数据加载中</p>
    </div>
</div>

</body>
</html>
