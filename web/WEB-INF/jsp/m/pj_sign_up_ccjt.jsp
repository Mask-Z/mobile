<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">

<head>
<jsp:include page="mate.jsp"></jsp:include>

    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    <link rel="stylesheet" href="m/css/index.css">
    
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="js/bm.js"></script>
    <script type="text/javascript" src="m/js/DateOp.js"></script>
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

    $(function () {
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

        var $tooltips = $('.js_tooltips');

        $("#btn_save").click(function () {
            if ($tooltips.css('display') != 'none') return;
            var flag = true;
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

            var lxtel = $("#lxdh").val();
            var lxr = $("#lxr").val();
            if ($.trim(lxtel) === "") {
                $tooltips.html("联系电话不能为空!");
                flag = false;
            } else if ($.trim(lxr) === "") {
                $tooltips.html("联系人不能为空!");
                flag = false;
            } else if (!isPhoneNo(lxtel)) {
                $tooltips.html("联系电话格式不正确!");
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
                success: function (msg) {
                    if(msg){
                        if(msg.code == 0){
                            $("#toast_div").text("报名成功");
                            $('#loadingToast').fadeIn(100);
//                            window.location.href = "pj_list_cqjy";
                            window.location.href = "pj_sign_up_view?infoid=${ProjectGuid}&type=CCJT&bmguid=${data.RowGuid }";
                        }else{
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

        newimg();
        function newimg() {
            $("#authimg").attr("src", "authimg?" + new Date().getTime());
        }

        $("#authimg").click(function () {
            newimg();
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
    var task_code = "CQJY_NetBaoMing";
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
//                                    var html = "<span><a href=\"javascript:openfj('"+list[j].RowGuid+"')\">"+list[j].AttachFileName+"</a></span><a href=\"javascript:del('"+list[j].RowGuid+"');\" class=\"weui-btn weui-btn_mini weui-btn_warn\" name=\"file_del\">删除</a>";
//                                    $("#"+code).append(html);
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

<header class="h43">
    <div class="index-header">
        <a href="pj_list_cqjy" class="back"></a>
        <div class="title">项目报名</div>
    </div>
</header>

<form id="user_reg_1_form">
        <input type="hidden" name="bmguid" value="${bmguid}"><!-- 修改时,被修改的报名guid,新增时该只为空 -->
        <input type="hidden" name="info['type']" value="CCJT"><!-- 系统类别-->
        <input type="hidden" name="info['BelongXiaQuCode']" value="${data.BelongXiaQuCode }"><!-- 所属地区 -->
        <input type="hidden" name="info['DisplayName']" value="${user.displayName }"><!-- 用户名称 -->


        <input type="hidden" name="info['RowGuid']" value="${data.RowGuid }"><!-- 报名唯一标识 -->
        <input type="hidden" name="info['UserGuid']" value="${data.UserGuid }"><!-- 竞买人guid -->
        <input type="hidden" name="info['DanWeiGuid']" value="${data.DanWeiGuid }"><!-- 单位guid -->
        <input type="hidden" name="info['ProjectGuid']" value="${ProjectGuid}"><!-- 项目guid -->
        <input type="hidden" name="info['DanWeiName']" value="${data.DanWeiName }"><!-- 单位名称 -->
        <input type="hidden" name="info['BelongXiaQuCode']" value="${data.BelongXiaQuCode }"><!-- 所属地区 -->
        <input type="hidden" name="info['FaRen_3008']" value="${data.FaRen_3008 }"><!-- 法定代表人 -->

        
        <input type="hidden" name="info['UnitOrgNum']" value="${data.UnitOrgNum }"><!-- 企业组织机构代码 -->
        
        <input type="hidden" name="info['JiaoNaBZJ']"<c:if test="${empty data.JiaoNaBZJ}"> value="0.0"</c:if><c:if test="${not empty data.JiaoNaBZJ}"> value="${data.JiaoNaBZJ}" </c:if> ><!-- 保证金金额 -->

        <input type="hidden" name="info['DanWeiXingZhi']" value="${data.DanWeiXingZhi}"><!-- 单位性质 -->
        <input type="hidden" name="info['BaoMingType']" value="${data.BaoMingType}"><!-- 报名方式 -->
        <input type="hidden" name="info['BZJIsjiaoNa']" value="${data.BZJIsjiaoNa}"><!-- 保证金是否缴纳 -->
        <input type="hidden" name="info['YingYeZhiZhaoNo']" value="${data.YingYeZhiZhaoNo}"><!-- 营业执照号码 -->
        <input type="hidden" name="info['IsBaoMingEnSure']" value="${data.IsBaoMingEnSure}"><!-- 报名是否确认 -->
        <input type="hidden" name="info['GongGaoGuid']" value="${data.GongGaoGuid}"><!-- 公告guid -->
        <input type="hidden" name="info['ProjectNo']" value="${data.ProjectNo}"><!-- 项目编号 -->
        <input type="hidden" name="info['ProjectName']" value="${data.ProjectName}"><!-- 项目名称 -->
        <input type="hidden" name="info['IpAddress']" value="${data.IpAddress}"><!-- Ip地址 -->

<div class="weui-toptips weui-toptips_warn js_tooltips"  id="js_tooltips"></div>
<div class="weui-cells__title">项目报名</div>
    <div class="weui-cells weui-cells_form ">
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">标的编号</label></div>
            <div class="weui-cell__bd">${data.ProjectNo_3001}
            </div>
        </div>

        <div class="weui-cell ">
            <div class="weui-cell__hd"><label class="weui-label">标的名称</label></div>
            <div class="weui-cell__bd">${data.ProjectName_3001}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">产权类型</label></div>
            <div class="weui-cell__bd">${data.ProjectType_3006_name}
            </div>
        </div>

        <div class="weui-cell">
            <%--<div class="weui-cell__hd"><label class="weui-label">业务类型</label></div>--%>
            <div class="weui-cell__hd"><label class="weui-label">交易方式</label></div>
            <div class="weui-cell__bd">
                <c:choose>
                    <c:when test="${data.JiaoYiFangShi_3006 eq '2'}">
                                                                         竞价
                    </c:when>
                    <c:otherwise>
                        ${data.JiaoYiFangShi_3006}
                    </c:otherwise>
                </c:choose>
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
        <!-- 个人会员信息 end -->
        <c:if test="${user_type==1 }">
            <!-- 个人会员信息 begin -->
            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">竞买人</label></div>
                <%--<div class="weui-cell__bd">${user.displayName }--%>
                <div class="weui-cell__bd">${data.lblDanWeiName }
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
                <div class="weui-cell__bd">${data.lblUnitOrgNum }
                </div>
            </div>


            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">企业性质</label></div>
                <div class="weui-cell__bd">
                    <c:if test="${data.lblDanWeiXingZhi eq '1'}">企业</c:if>
                    <c:if test="${data.lblDanWeiXingZhi eq '2'}">行政事业单位</c:if>
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">证件号</label></div>
                <div class="weui-cell__bd">${data.ZhengNo }
                </div>
            </div>

            <!-- 个人会员信息 end -->
        </c:if>

        <c:if test="${user_type==0 }">
            <!-- 单位信息 begin -->
            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">竞买人<font color="red">(*)</font></label></div>
                <div class="weui-cell__bd">${data.lblDanWeiName }
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
                <div class="weui-cell__bd">${data.lblUnitOrgNum }
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">企业性质</label></div>
                <div class="weui-cell__bd">
                    <c:if test="${data.lblDanWeiXingZhi eq '1'}">企业</c:if>
                    <c:if test="${data.lblDanWeiXingZhi eq '2'}">行政事业单位</c:if>
                </div>
            </div>


            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">证件号</label></div>
                <div class="weui-cell__bd">${data.lblYingYeZhiZhaoNo }
                </div>
            </div>
            <!-- 单位信息 end -->
        </c:if>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">联系人<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" name="info['LianXiUser']" placeholder="请输入联系人" id="lxr">
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">联系电话<font color="red">(*)</font></label></div>
            <div class="weui-cell__bd">
                <input class="weui-input" type="number" name="info['LianXiTel']" value="${data.LianXiTel }" placeholder="请输入联系电话" id="lxdh">
            </div>
        </div>


        <div class="weui-cells__title">相关附件</div>

        <c:forEach items="${filelist}" var="file">

            <div class="weui-cell weui-cell_vcode">
                <div class="weui-cell__hd">
                    <label class="weui-label">${file.FileName}  <c:if test="${file.IsMustNeed eq '1' and data.IsBMNeedFile eq '1'}"><font color="red">(*)</font></c:if></label>
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
