<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
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
        a.rawCitiesData = '${citysWithEmpty}';
    }($);

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

        //设置搜索结果高度
        var dHeight=document.documentElement?document.documentElement.clientHeight:document.body.clientHeight;//浏览器高度
        $("#searchResult").height(dHeight-120);

        var zhuanRangType = "${data.ZhuanRangType }";
        var faRenType = "${data.FaRenType }";

        function init(){
            if($("#zhuanRang_type").val() == '1'){
                $("#shouRang_gufen_div").hide();
                $("#shou_RangGuFen").hide();
            }else{
                $("#shouRang_percent_div").hide();
                $("#shou_RangPercent").hide();
            }

            if($("#lbl_isManagerLayer").val() == '1'){
                $("#zhiwu_div").show();
                $("#shenji").show();
            }

            if($("#jinQi_ziChan").val() == '0;1;'){
                $("#s90").attr("checked", true);
                $("#s100").attr("checked", true);
            }else if($("#jinQi_ziChan").val() == '0;'){
                $("#s90").attr("checked", true);
            }else if($("#jinQi_ziChan").val() == '1;'){
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

        $("#pj_sign_hyjg").on("click",function(){
            $("#hyjg_select_div").fadeIn(200);
        });

        $("input:radio[name='sshyjg']").change(function (){
            $("#belong_DLJGName").val($(this).attr("hyname"));
            $("#sshyjh_value_div").text($(this).attr("hyname"));
            $("#belong_DLJGGuid").val($(this).val());
        });

        $("#hyjg_sel_ok").on("click",function(){
            $("#hyjg_select_div").fadeOut(200);
        });

        //保存报名信息
        $("#btn_save").click(function(){
            if($("#srf_js_tooltips").css('display')!='none') return false;


            var flag = true;
            var zhuanRangValue = "";
            var zhuanRang_value = 0;

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

            if($("#zhuanRang_type").val() == '2' && $("#srf_srgf").val()==''){
                $("#srf_js_tooltips").html("拟受让股份必填");
                flag = false;
            }

            if(!isPhoneNo($("#lianxidianhua").val())){
                $("#srf_js_tooltips").html("联系电话格式错误");
                flag = false;
            }

            if($("#lianxidianhua").val()==''){
                $("#srf_js_tooltips").html("联系电话必填");
                flag = false;
            }

            if($("#lianxiren").val()==''){
                $("#srf_js_tooltips").html("联系人必填");
                flag = false;
            }
            $(".zhuanRang_value").each(function(){
                zhuanRang_value = zhuanRang_value + parseFloat($(this).text());
            });
            if(zhuanRangType == "1"){
                zhuanRangValue = "${zhuanRangInfo.sellPercent }";
                if(!isNaN($("#srf_srp").val()) && $("#srf_srp").val()!=""){
                    zhuanRang_value = zhuanRang_value + parseFloat($("#srf_srp").val());
                }

            }else if(zhuanRangType == "2"){
                zhuanRangValue = "${zhuanRangInfo.sellAmount }";
                if(!isNaN($("#srf_srgf").val()) && $("#srf_srgf").val()!=""){
                    zhuanRang_value = zhuanRang_value + parseFloat($("#srf_srgf").val());
                }

            }

            //if(!isNan(zhuanRang_value)){
            //	zhuanRang_value = 0;
            //}
            if(parseFloat(zhuanRangValue) != zhuanRang_value){
                if(zhuanRangType == "1"){
                    $("#srf_js_tooltips").html("受让方受让（联合受让）的比例(" + zhuanRang_value.toFixed(4) + "%)应该等于转让方转让（联合转让）的比例(" + zhuanRangValue +"%)");
                }else if(zhuanRangType == "2"){
                    $("#srf_js_tooltips").html("受让方受让（联合受让）的股份数(" + zhuanRang_value + "股)应该等于转让方转让（联合转让）的股份数(" + zhuanRangValue +"股)");
                }
                flag = false;
            }



            if($("#zhuanRang_type").val() == '1' && $("#srf_srp").val()==''){
                $("#srf_js_tooltips").html("拟受让比例必填");
                flag = false;
            }

            if($("#shourangdijia").val()==''){
                $("#srf_js_tooltips").html("受让底价必填");
                flag = false;
            }

            if(faRenType=='1'){
                if($.trim($("#jingyingfanwei").val())==''){
                    $("#srf_js_tooltips").html("经营范围必填");
                    flag = false;
                }

                if($("#hangYeType_code").val().indexOf('J')>=0 && $.trim($("#industryC_code").val())==''){
                    $("#srf_js_tooltips").html("金融类所属行业必填");
                    flag = false;
                }
                if($("#zhuCe_ziBen").val()==''){
                    $("#srf_js_tooltips").html("注册资本必填");
                    flag = false;
                }
                if($("#zhuCe_di").val()==''){
                    $("#srf_js_tooltips").html("注册地必填");
                    flag = false;
                }
            }
            if(faRenType=='2'&&$.trim($("#zheng_No").val())==''){
                $("#srf_js_tooltips").html("证件号码必填");
                flag = false;
            }
            if(faRenType=='2'&&!isCardNo($.trim($("#zheng_No").val()))){
                $("#srf_js_tooltips").html("身份证号码格式错误");
                flag = false;
            }
            if($("#is_managerLayer").val()=='1'&&$.trim($("#zhi_wu").val())==''){
                $("#srf_js_tooltips").html("职务必填");
                flag = false;
            }
            if($("#area_code").val()==''||$("#area_code").val()=='请选择'){
                $("#srf_js_tooltips").html("所在地区必填");
                flag = false;
            }




            if($("#s90").is(':checked') && $("#s100").is(':checked')){
                $("#jinQi_ziChan").val("0;1;");
            }else if($("#s90").is(':checked')){
                $("#jinQi_ziChan").val("0;");
            }else if($("#s100").is(':checked')){
                $("#jinQi_ziChan").val("1;");
            }else{
                $("#jinQi_ziChan").val("");
            }





            if(!flag){
                $("#srf_js_tooltips").css('display', 'block');
                setTimeout(function(){
                    $("#srf_js_tooltips").css('display', 'none');
                }, 3000);
                return false;
            }

            var param = $("#pj_gq_submit").serialize();

            $.ajax({
                type: "POST",
                url: "pj_sign_up_submit",
                dataType:"json",
                data: param,
                success: function(result){
                    if(result){
                        if(result.code==0){
                            $("#toast_div").text("数据提交中");
                            $('#loadingToast').fadeIn(100);
                            location.href = "pj_sign_up_view?infoid=${ProjectGuid}&type=GQ&bmguid=${data.RowGuid }&zhuanRangType="+zhuanRangType;
                        } else if(result.code=-2){
                            $("#srf_js_tooltips").html(result.msg);
//       	    		    $("#toast_div").text(result.msg);
                            $("#srf_js_tooltips").css('display', 'block');
                            setTimeout(function(){
                                $("#srf_js_tooltips").css('display', 'none');
                            }, 3000);
//       	    		    $('#loadingToast').fadeIn(100);
                        }
                        $('#loadingToast').fadeOut(100);
                    }
                },
                error:function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        });

        //新增联合受让方
        $("#btn_add").on("click",function(){
            //重置表单数据
            document.getElementById("pj_gq_addUnion").reset();
            //新增时启用所有输入并显示确定按钮
            $("#union_select_div").find("*").each(function(){
                $(this).removeAttr("disabled");
            });
            $("#btn_ok").show();
            $("#union_type").val("union_add");
            $("#union_select_div").fadeIn(200);
            $("#pj_gq_submit").hide();
        });

        $("#is_managerLayer").change(function(){
            var is_managerLayer = $(this).val();
            if(is_managerLayer == 1){
                $("#zhiwu_div").show();
                $("#shenji").show();
            }else{
                $("#zhiwu_div").hide();
                $("#shenji").hide();
            }
        });



        $("#pj_sign_srf").on("click",function(){
            if($(this).attr("disabled") == "disabled"){
                return;
            }
            $("#shouRang_name").val('');
            $("#srf_select_div").fadeIn(200);
            $("#pj_gq_submit").hide();

        });

        $("#srf_sel_ok").on("click",function(){
            $(".weui-srf").each(function(){
                if($(this).is(':checked')){
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

        $("#srf_sel_cancel").on("click",function(){
            $("#srf_select_div").fadeOut(200);
            $("#pj_gq_submit").show();
        });

        //新增/修改联合受让方保存
        $("#btn_ok").click(function(){
            var flag = true;

            if(zhuanRangType=="1"&&$("#shouRang_percent").val()>100){
                $("#union_js_tooltips").html("受让比例请输入不大于100的值");
                flag = false;
            }

            if(zhuanRangType=="1"&&$("#shouRang_percent").val()==""){
                $("#union_js_tooltips").html("受让比例必填");
                flag = false;
            }
            if(zhuanRangType=="2"&&$("#shouRang_gufen").val()==""){
                $("#union_js_tooltips").html("受让股份必填");
                flag = false;
            }
            if($.trim($("#shouRang_name").val())==""){
                $("#union_js_tooltips").html("受让方名称必填");
                flag = false;
            }
            if(!flag){
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
                        }else{
                            $("#toast_div").text("操作失败");
                            $('#loadingToast').fadeIn(100);
                        }
                        $('#loadingToast').fadeOut(100);
                    }
                },
                error:function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
            $("#union_select_div").fadeOut(200);
            $("#pj_gq_submit").show();
        });

        //新增/修改联合受让方取消
        $("#btn_cancel").on("click",function(){
            $("#union_select_div").fadeOut(200);
            $("#pj_gq_submit").show();
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
                        innerHtml += ' <table class="table" width="100%"> <tbody> <tr>'+
                            '<td height="50" width="70" align="center">序号</td> <td>联合受让方名称</td>';

                        if(zhuanRangType == "1"){
                            innerHtml +=  ' <td align="center"  width="120">拟受让比例（%）</td></tr>';

                        }else if(zhuanRangType == "2"){
                            innerHtml += ' <td align="center"  width="120">拟受让股份（股）</td></tr>';

                        }
//       	            $("#union_div").append(innerHead);
                        $.each(result,function(i,data){
//       	                var innerHtml = "";
                            if(zhuanRangType == "1"){
                                innerHtml += ' <tr class="ios_menu"> <td height="30" align="center" >'+(i+1) +'</td>'+
                                    '<td>'+ data.ShouRangName+'</td>'+
                                    '<td class="zhuanRang_value" align="center">'+ data.ShouRangPercent+'</td></tr>'+
                                    "<input type='hidden' value='" + data.RowGuid + "'>";
                            }else if(zhuanRangType == "2"){
                                innerHtml += ' <tr class="ios_menu"> <td height="30" align="center" >'+(i+1) +'</td>'+
                                    '<td>'+ data.ShouRangName+'</td>'+
                                    '<td class="zhuanRang_value" align="center">'+ data.ShouRangGufen+'</td></tr>'+
                                    "<input type='hidden' value='" + data.RowGuid + "'> ";
                            }
//       	                $("#union_div").append(innerHtml);
                        } );
                        $("#union_div").append(innerHtml+"</tbody> </table>");

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
                    data: "srfNameOrUnitCode="+$("#searchInput").val()+"&projectGuid=${ProjectGuid}&rowGuid="+$("#union_baoMing_guid").val()+"&type="+$("#choose_srf").val(),
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

        $("#choose_srf").on("change",function(){
            $searchResult.hide();
            $searchResult.empty();
            $searchInput.val('');
            if($(this).val() == 0){
                $("#searchInput").attr("placeholder","输入竞买方搜索");
            }else{
                $("#searchInput").attr("placeholder","输入组织机构代码搜索");
            }
        });

        $("#hangYeType_code").on("change",function(){
            $(this).next().val($(this).find("option:selected").text());
        });

        $("#industryC_code").on("change",function(){
            $(this).next().val($(this).find("option:selected").text());
        });

        /**
         修改时附件加载
         **/
        if('${bmguid}'!=''){
            loadFile();
        }
    });

    var task_code = "CQJY_GQBaoMing";
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
//									var html = "<p><span><a href=\"javascript:openfj('"+list[j].RowGuid+"')\">"+list[j].AttachFileName+"</a></span><a href=\"javascript:del('"+list[j].RowGuid+"');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a></p>";
//									$("#"+code).append(html);
                                    var html = "<p><span><a target='_blank' target='_blank' href=\""+list[j].url+"\">"+list[j].AttachFileName+"</a></span><a href=\"javascript:del('"+list[j].RowGuid+"');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a></p>";
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
        <a href="javascript:showRule1();" class="h-r"><i class="glyphicon glyphicon-filter"></i></a>
    </div>
</header>
<style type="text/css">
    <!--
    .title{
        background: skyblue;
    }
    table.myform{
        line-height: 24px;
    }
    table.myform td{
        padding: 2px;
    }
    -->
</style>
<h4>报名详情</h4>
<div style="margin:5px 0;"></div>
<table class="myform" title="报名详情" style="width:100%;height:250px" border="1">
    <thead>
    <tr>
        <td class="title">标的编号</td>
        <td colspan="4">${data.ProjectNo_3001 }</td>
    </tr>
    <tr>
        <td class="title">标的名称</td>
        <td colspan="4">${data.ProjectName_3001 } </td>
    </tr>
    <tr>
        <td class="title">标的类型</td>
        <td colspan="4"><c:if test="${data.BiaoDiType_3001==1}">股权</c:if>
            <c:if test="${data.BiaoDiType_3001==2}">股权+债权</c:if></td>
    </tr>
    <tr>
        <td class="title" colspan="5">报名信息：如有基本信息未填写，请先到会员库中完善基本信息 </td>
    </tr>
    <tr>
        <td class="title" rowspan="3">委托会员</td>
        <td class="title">机构名称</td>
        <td>
            <input class="easyui-textbox" type="text"/>
        </td>
        <td class="title">工位号</td>
        <td>
            <input class="easyui-textbox" type="text"/>
        </td>
    </tr>
    <tr>
        <td class="title">经纪</td>
        <td>
            <input class="easyui-textbox" type="text"/>
        </td>
        <td class="title">经纪人编码</td>
        <td>
            <input class="easyui-textbox" type="text"/>
        </td>
    </tr>
    <tr>
        <td class="title">联系人</td>
        <td>
            <input class="easyui-textbox" type="text"/>
        </td>
        <td class="title">联系电话</td>
        <td>
            <input class="easyui-textbox" type="text"/>
        </td>
    </tr>
    </thead>
</table>

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
            }catch(Exception e){
                e.printStackTrace();
            }
        }
    %>
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
    <input type="hidden" name="info['BelongDLJGGuid']" id="belong_DLJGGuid" value="${data.BelongDLJGGuid }"><!-- 机构guid(委托会员) -->
    <input type="hidden" name="info['BelongDLJGName']" id="belong_DLJGName" value="${data.BelongDLJGName }"><!-- 机构名称(委托会员) -->
    <input type="hidden" name="info['ZhuanRangType']" id="zhuanRang_type" value="${data.ZhuanRangType }"><!-- 转让方式 -->
    <input type="hidden" name="info['IsUnionShouRang']" id="is_unionShouRang" value="${data.IsUnionShouRang }"><!-- 是否联合受让 -->
    <input type="hidden" name="info['FaRen_3008']" value="${data.FaRen_3008 }"><!--  -->
    <input type="hidden" name="info['UserID']" value="${data.UserID }"><!--  -->
    <input type="hidden" name="info['OprationType']" value="${data.OprationType }"><!--  -->
    <input type="hidden" id="lbl_isManagerLayer" value="${data.IsManagerLayer}">
    <input type="hidden" name="info['JinQiZiChan']" id="jinQi_ziChan" value="${data.JinQiZiChan}">

    <div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="srf_js_tooltips"></div>
    <div class="weui-toptips weui-toptips_warn js_tooltips" style="top: 43px" id="js_tooltips"></div>
    <div class="weui-cells weui-cells_form no-mt">
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
            <div class="weui-cell__bd"><c:if test="${data.BiaoDiType_3001==1}">股权</c:if>
                <c:if test="${data.BiaoDiType_3001==2}">股权+债权</c:if>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">挂牌价</label></div>
            <div class="weui-cell__bd" style="color: red">
                <fmt:formatNumber type="number" value="${data.GuaPaiPrice }" pattern="0.000000" maxFractionDigits="6"/> 万元
                <%--${data.GuaPaiPrice }万元--%>
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

        <div class="weui-btn-area">
            <%--<a class="weui-btn weui-btn_primary" href="infodetail?infoid=${ProjectGuid}" >查看网站公告原文</a>--%>
            <a class="weui-btn weui-btn_primary" href="infodetail?${fn:split(data.GongGaoUrl,'?')[1]}" >查看网站公告原文</a>
        </div>
        <div class="weui-cells__title">报名信息</div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd"><label class="weui-label">是否国资</label></div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="info['IsGuoZi']">
                    <option value="T" <c:if test="${data.IsGuoZi=='T'}">selected</c:if>>国资</option>
                    <option value="F" <c:if test="${data.IsGuoZi=='F'}">selected</c:if>>非国资</option>
                </select>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">法人类型<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd"><c:if test="${data.FaRenType==2}">自然人</c:if><c:if test="${data.FaRenType==1}">企事业单位</c:if>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">受让方名称</label></div>
            <div class="weui-cell__bd">${data.DanWeiName }
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd"><label class="weui-label">是否标的企业管理层直接或间接出资</label></div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="info['IsManagerLayer']" id="is_managerLayer">
                    <option value="0" <c:if test="${data.IsManagerLayer=='0'}">selected</c:if>>否</option>
                    <option value="1" <c:if test="${data.IsManagerLayer=='1'}">selected</c:if>>是</option>
                </select>
            </div>
        </div>

        <div class="weui-cell" id="zhiwu_div" style="display: none;">
            <div class="weui-cell__hd"><label class="weui-label">职务<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['ZhiWu']" type="text" id="zhi_wu" value="${data.ZhiWu }" placeholder="请输入职务"/>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after" id="shenji" style="display:none">
            <div class="weui-cell__hd"><label class="weui-label">是否进行了经济责任审计<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="info['hasAudit']">
                    <option value="1" <c:if test="${data.hasAudit=='1'}">selected</c:if>>是</option>
                    <option value="0" <c:if test="${data.hasAudit=='0'}">selected</c:if>>否</option>
                </select>
            </div>
        </div>

        <div class="weui-cell weui-cell_select">
            <div class="weui-cell__hd">
                <label for="" class="weui-label">所在地区<font color="red">(*)</font></label>
            </div>
            <div class="weui-cell__bd">
                <input class="weui-select" id="area" type="text" value="${data.AreaName.replace("·"," ")}">
            </div>
        </div>

        <c:if test="${user_type==1 }">
            <!-- 个人会员信息  begin -->
            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">证件名称</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" name="info['ZhengName']" type="text" value="${data.ZhengName }" placeholder="请输入证件名称"/>
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">证件号码<font color="red">(*)</font></label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" name="info['ZhengNo']" type="text" id="zheng_No" value="${data.ZhengNo }" placeholder="请输入证件号码"/>
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">工作单位</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" name="info['GongZuoDanWei']" type="text" value="${data.GongZuoDanWei }" placeholder="请输入工作单位"/>
                </div>
            </div>

            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd"><label class="weui-label">资金来源</label></div>
                <div class="weui-cell__bd">
                    <select class="weui-select" name="info['ZiJinLaiYuan']">
                        <option value="0" <c:if test="${data.ZiJinLaiYuan=='0'}">selected</c:if>>自有</option>
                        <option value="1" <c:if test="${data.ZiJinLaiYuan=='1'}">selected</c:if>>融资</option>
                        <option value="2" <c:if test="${data.ZiJinLaiYuan=='2'}">selected</c:if>>其他</option>
                    </select>
                </div>
            </div>

            <div class="weui-cells__tips">个人资产申报</div>
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <textarea class="weui-textarea" name="info['GeRenZiChan']" rows="3">${data.GeRenZiChan }</textarea>
                </div>
            </div>
            <!-- 个人会员信息 end -->
        </c:if>

        <c:if test="${user_type==0 }">
            <!-- 单位信息  begin -->
            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">注册地<font color="red">(*)</font></label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" name="info['ZhuCeDi']" type="text" id="zhuCe_di" value="${data.ZhuCeDi }" placeholder="请输入注册地"/>
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">注册资本（万元）<font color="red">(*)</font></label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" name="info['ZhuCeZiBen']" type="zb" id="zhuCe_ziBen" value="${data.ZhuCeZiBen }"/>
                </div>
            </div>

            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
                <div class="weui-cell__bd">
                    <select class="weui-select" name="info['BiZhong']">
                        <c:forEach items="${biZhongs}" var="biZhong">
                            <option value="${biZhong.code}" <c:if test ="${biZhong.code eq data.BiZhong}">selected</c:if>>${biZhong.value}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label for="" class="weui-label">成立时间</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" type="date" name="info['ChengLiDate']" value="<%=cldate %>">
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label for="" class="weui-label">法定代表人</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" type="text" name="info['FaRen_13003']" value="${data.FaRen_13003 }">
                </div>
            </div>

            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd"><label class="weui-label">所属行业<font color="red">(*)</font></label></div>
                <div class="weui-cell__bd">
                    <select class="weui-select" name="info['HangYeTypeCode']" id="hangYeType_code">
                        <c:forEach items="${hangYeTypes}" var="hangYeType">
                            <option value="${hangYeType.code}" <c:if test ="${hangYeType.code eq data.HangYeTypeCode}">selected</c:if>>${hangYeType.value}</option>
                        </c:forEach>
                    </select>
                    <input type="hidden" name="info['HangYeType']" value="${data.HangYeType}">
                </div>
            </div>

            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd"><label class="weui-label">金融类所属行业</label></div>
                <div class="weui-cell__bd">
                    <select class="weui-select" name="info['IndustryCCode']" id="industryC_code">
                        <option value=""></option>
                        <c:forEach items="${industryCs}" var="industryC">
                            <option value="${industryC.code}" <c:if test ="${industryC.code eq data.IndustryCCode}">selected</c:if>>${industryC.value}</option>
                        </c:forEach>
                    </select>
                    <input type="hidden" name="info['IndustryCName']" value="${data.IndustryCName}">
                </div>
            </div>

            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">公司类型（经济性质）<font color="red">(*)</font></label>
                </div>
                <div class="weui-cell__bd">
                    <select class="weui-select" name="info['CompanyLeiXing']">
                        <c:forEach items="${companyLeiXings}" var="companyLeiXing">
                            <option value="${companyLeiXing.code}" <c:if test ="${companyLeiXing.code eq data.CompanyLeiXing}">selected</c:if>>${companyLeiXing.value}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">企业性质（经济类型）<font color="red">(*)</font></label>
                </div>
                <div class="weui-cell__bd">
                    <select class="weui-select" name="info['CompanyXingZhi']">
                        <c:forEach items="${companyXingZhis}" var="companyXingZhi">
                            <option value="${companyXingZhi.code}" <c:if test ="${companyXingZhi.code eq data.CompanyXingZhi}">selected</c:if>>${companyXingZhi.value}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">经济规模<font color="red">(*)</font></label>
                </div>
                <div class="weui-cell__bd">
                    <select class="weui-select" name="info['GuiMo']">
                        <option value="0" <c:if test ="${data.GuiMo==0}">selected</c:if>>大型</option>
                        <option value="1" <c:if test ="${data.GuiMo==1}">selected</c:if>>中型</option>
                        <option value="2" <c:if test ="${data.GuiMo==2}">selected</c:if>>小型</option>
                        <option value="3" <c:if test ="${data.GuiMo==3}">selected</c:if>>微型</option>
                    </select>
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
                <div class="weui-cell__bd">${data.UnitOrgNum }
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">经营范围<font color="red">(*)</font></label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" name="info['JingYingFanWei']" type="text" id="jingyingfanwei" value="${data.JingYingFanWei }" placeholder="请输入经营范围">
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">受让资格陈述</label></div>
                <div class="weui-cell__bd">
                    <textarea class="weui-textarea" name="info['ShouRangZiGe']" rows="3">${data.ShouRangZiGe}</textarea>
                </div>
            </div>

            <div class="weui-cells__tips">近期资产情况</div>
            <div class="weui-cells__title">数据来源</div>
            <div class="weui-cells weui-cells_checkbox">
                <label class="weui-cell weui-check__label" for="s90">
                    <div class="weui-cell__hd">
                        <input type="checkbox" name="checkbox1" class="weui-check jinqi_zichan" id="s90">
                        <i class="weui-icon-checked"></i>
                    </div>
                    <div class="weui-cell__bd">
                        <p>审计报告</p>
                    </div>
                </label>
                <label class="weui-cell weui-check__label" for="s100">
                    <div class="weui-cell__hd">
                        <input type="checkbox" name="checkbox1" class="weui-check jinqi_zichan" id="s100">
                        <i class="weui-icon-checked"></i>
                    </div>
                    <div class="weui-cell__bd">
                        <p>财务报表</p>
                    </div>
                </label>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label for="" class="weui-label">报表日期</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" type="date" name="info['BaoBiaoDate']" value="<%=bbdate%>">
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">资产总计（万元）</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" name="info['ZiChanTotal']" type="number" value="${data.ZiChanTotal}"/>
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">负债总计（万元）</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" name="info['FuZhaiTotal']" type="number" value="${data.FuZhaiTotal}"/>
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">净资产（万元）</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" name="info['JingZiChan']" type="number" value="${data.JingZiChan}"/>
                </div>
            </div>

            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
                <div class="weui-cell__bd">
                    <select class="weui-select" name="info['MoneyType']">
                        <c:forEach items="${biZhongs}" var="moneyType">
                            <option value="${moneyType.code}" <c:if test ="${moneyType.code eq data.MoneyType}">selected</c:if>>${moneyType.value}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <!-- 单位信息 end -->
        </c:if>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd"><label class="weui-label">是否标的公司原股东<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="info['hasPriority']">
                    <option value="0" <c:if test ="${data.hasPriority=='0'}">selected</c:if>>否</option>
                    <option value="1" <c:if test ="${data.hasPriority=='1'}">selected</c:if>>是</option>
                </select>
            </div>
        </div>

        <div class="weui-cells__title">受让意愿</div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">受让底价(万元)<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['ShouRangDiJia']" type="zb" id="shourangdijia" value="${data.ShouRangDiJia }" placeholder="请输入受让底价"/>
            </div>
        </div>

        <div class="weui-cell weui-cell_select weui-cell_select-after">
            <div class="weui-cell__hd"><label class="weui-label">币种</label></div>
            <div class="weui-cell__bd">
                <select class="weui-select" name="info['ShouRangBiZhong']">
                    <c:forEach items="${biZhongs}" var="shouRangBiZhong">
                        <option value="${shouRangBiZhong.code}" <c:if test ="${shouRangBiZhong.code eq data.ShouRangBiZhong}">selected</c:if>>${shouRangBiZhong.value}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="weui-cell" id="shou_RangPercent">
            <div class="weui-cell__hd"><label class="weui-label">拟受让比例(%)<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['ShouRangPercent']" type="zb" id="srf_srp" value="${data.ShouRangPercent }" placeholder="请输入拟受让比例"/>
            </div>
        </div>

        <div class="weui-cell" id="shou_RangGuFen">
            <div class="weui-cell__hd"><label class="weui-label">拟受让股份(股)<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['ShouRangGuFen']" type="zb" id="srf_srgf" value="${data.ShouRangGuFen }"/>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">联系人<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['LianXiUser']" id="lianxiren" value="${data.LianXiUser }" placeholder="请输入联系人">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">联系电话<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" type="number" name="info['LianXiTel']" id="lianxidianhua" value="${data.LianXiTel }" placeholder="请输入联系电话">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">电子邮箱</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['Email']" value="${data.Email }" placeholder="请输入电子邮箱">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">传真号码</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['ChuanZhen']" value="${data.ChuanZhen }" placeholder="请输入传真号码">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">资信证明</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['ZiXinZhengMing']" value="${data.ZiXinZhengMing }" readonly="readonly">
            </div>
        </div>


        <div class="weui-cells__tips">委托会员</div>
        <div class="weui-cell weui-cell_access" id="pj_sign_hyjg">
            <div class="weui-cell__hd"><label class="weui-label">机构名称</label></div>
            <div class="weui-cell__bd">
                <p id="sshyjh_value_div" align="left">${data.BelongDLJGName }</p>
            </div>
            <div class="weui-cell__ft" style="font-size: 0">
                <span></span>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">工位号</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['GongWeiNo']" value="${data.GongWeiNo }" placeholder="请输入工位号">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">经纪人</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['JingJiRen']" value="${data.JingJiRen }" placeholder="请输入经纪人">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">经纪人编码</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['JingJiRenCode']" value="${data.JingJiRenCode }" placeholder="请输入经纪人编码">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">联系人</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['LianXiRen']" value="${data.LianXiRen }" placeholder="请输入联系人">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">联系电话</label></div>
            <div class="weui-cell__bd">
                <input class="weui-input"  type="number" name="info['JGLianXiTel']" value="${data.JGLianXiTel }" placeholder="请输入联系电话">
            </div>
        </div>

        <div class="weui-cells__tips">联合受让方</div>
        <div class="weui-cells weui-cells_form" id="union_div">
            <table class="table" width="100%">
                <tbody>
                <tr>
                    <td height="50" width="70" align="center">序号</td>
                    <td>联合受让方名称</td>
                    <c:if test="${data.ZhuanRangType=='1'}">
                        <td align="center"  width="120">拟受让比例（%）</td>
                    </c:if>
                    <c:if test="${data.ZhuanRangType=='2'}">
                        <td align="center"  width="120">拟受让股份（股）</td>
                    </c:if>
                </tr>
                <c:forEach items="${data.unionList}" var="union" varStatus="vs">
                    <tr class="ios_menu">
                        <td height="30" height="30" align="center">${vs.index+1 }</td>
                        <td>${union.ShouRangName}</td>
                        <c:if test="${data.ZhuanRangType=='1'}">
                            <td class="zhuanRang_value" align="center">${union.ShouRangPercent }</td>
                        </c:if>
                        <c:if test="${data.ZhuanRangType=='2'}">
                            <td class="zhuanRang_value" align="center">${union.ShouRangGufen }</td>
                        </c:if>
                    </tr>
                    <input type="hidden" value="${union.RowGuid}">
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="weui-btn-area">
            <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_add">新增联合受让方</a>
        </div>

        <input type="hidden" id="union_waiting_handle" value="">
        <div class="weui-cells__title">相关附件</div>

        <c:forEach items="${filelist}" var="file">

            <div class="weui-cell weui-cell_vcode">
                <div class="weui-cell__hd">
                    <label class="weui-label">${file.FileName}  <c:if test="${file.IsMustNeed eq '1' and data.IsBMNeedFile eq '1' }"><font color="red">(*)</font></c:if></label>
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
<div class="weui-btn-area">
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_save">确定</a>
</div>

<!--新增联合受让方dialog start-->
<div class="js_dialog" id="union_select_div" style="display: none;">
    <div class="weui-mask"></div>
    <div class="weui-dialog_srf" style="height:100%;overflow-y:scroll;">
        <div class="weui-dialog__hd_srf" style="height: 30px;      padding: 10px;  background: #f5f5f5;line-height: 30px;border-bottom: 1px #ddd solid;"><strong class="weui-dialog__title">新增联合受让方</strong></div>
        <div class="weui-dialog__bd_srf">
            <form id="pj_gq_addUnion">

                <input type="hidden" id="union_baoMing_guid" name="info['baoMingGuid']" value="${data.RowGuid }"><!-- 联合受让方报名统一标识 -->
                <input type="hidden" id="shouRang_guid" name="info['shouRangGuid']" value="">
                <input type="hidden" id="union_row_guid" name="info['rowGuid']" value=""><!-- 联合受让方唯一标识 -->
                <input type="hidden" name="info['zhuanRangType']" value="${data.ZhuanRangType }"><!-- 转让方式 -->
                <input type="hidden" name="info['unionType']" id="union_type" value=""><!-- 转让方式 -->


                <div class="weui-toptips weui-toptips_warn js_tooltips" id="union_js_tooltips"></div>
                <div class="weui-cells weui-cells_form" style="margin:0px;">

                    <div class="weui-cell weui-cell_access" id="pj_sign_srf">
                        <div class="weui-cell__hd"><label class="weui-label">受让方名称<font color="red">(*)</font></label></div>
                        <div class="weui-cell__bd">
                            <input class="weui-input" name="info['shouRangName']" type="text" id="shouRang_name" value="" onfocus="this.blur()"/>
                        </div>
                        <div class="weui-cell__ft" style="font-size: 0">
                            <span></span>
                        </div>
                    </div>

                    <div class="weui-cell weui-cell_select weui-cell_select-after">
                        <div class="weui-cell__hd"><label class="weui-label">受让方类型</label></div>
                        <div class="weui-cell__bd">
                            <select class="weui-select" name="info['shouRangRenType']" id="shouRangRen_type">
                                <option value="1">法人</option>
                                <option value="2">自然人</option>
                            </select>
                        </div>
                    </div>

                    <div class="weui-cell" id="shouRang_percent_div">
                        <div class="weui-cell__hd"><label class="weui-label">受让比例(%)<font color="red">(*)</font></label></div>
                        <div class="weui-cell__bd">
                            <input class="weui-input" name="info['shouRangPercent']" type="zb" id="shouRang_percent" value=""/>
                        </div>
                    </div>

                    <div class="weui-cell" id="shouRang_gufen_div">
                        <div class="weui-cell__hd"><label class="weui-label">受让股份(股)<font color="red">(*)</font></label></div>
                        <div class="weui-cell__bd">
                            <input class="weui-input" name="info['shouRangGuFen']" type="zb" id="shouRang_gufen" value=""/>
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
<!--新增联合受让方dialog end-->

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
                        <input type="search" class="weui-search-bar__input" id="searchInput" placeholder="输入竞买方名称搜索" required="">
                    </div>
                    <label class="weui-search-bar__label" id="searchText" style="transform-origin: 0px 0px 0px; opacity: 1; transform: scale(1, 1);line-height:25px;">
                        <i class="weui-icon-search"></i>
                        <span>搜索</span>
                    </label>
                </form>
            </div>
            <div class="weui-cells searchbar-result weui-cells_radio" id="searchResult" style="transform-origin: 0px 0px 0px; opacity: 1; transform: scale(1, 1); display: none;overflow-y: scroll">

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
