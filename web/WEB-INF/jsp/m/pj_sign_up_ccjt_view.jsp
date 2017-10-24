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

    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    <link rel="stylesheet" href="m/css/bootstrap.min.css">
    <link rel="stylesheet" href="m/css/iconfont.css">
    <link rel="stylesheet" href="m/css/index.css">
    
    <script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
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

    $(function () {

        //设置高度
        function initHeight() {
            var $button=$(".fixed-btn-area");
            var $form=$(".fixed-weui-cells_form");
            var $buttonHeight=$button.height();
            var $formHeight=$form.height();
            $form.height($formHeight+$buttonHeight+10);
        }
        initHeight()

        $("#to_submit").click(function () {
            var param = $("#pj_sw_audit").serialize();
            $.ajax({
                type: "POST",
                url: "pj_sign_up_audit",
                dataType: "json",
                data: param,
                success: function (msg) {
                    if (msg) {
                        if (msg.code == 0) {
                            $("#toast_div").text("报名成功");
                            $('#loadingToast').fadeIn(100);
                            window.location.href = "pj_list_cqjy";
                        }else{
                            $("#toast_div").text(msg.msg);
                            $('#loadingToast').fadeIn(100);
                        }
                        $('#loadingToast').fadeOut(3000);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        });

        /**
         * 加载附件
         **/
        loadFile();
    })

    var task_code = "CQJY_NetBaoMing";
    function loadFile() {
        $("#toast_div").text("加载中");
        $('#loadingToast').fadeIn(100);
        var data = {};
        data.bmguid = "${params.RowGuid }";
        data.taskCode = task_code;
        $.ajax({
            url: "getFileList",
            type: "POST",
            data: data,
            success: function (res, status, xhr) {
                try {
                    if (res && res.code == 0) {
                        var files = (res.data);
                        for (var i = 0; i < files.length; i++) {
                            var code = files[i].type;
                            var list = files[i].fileList;

                            for (var j = 0; j < list.length; j++) {
//                                var html = "<span><a href=\"javascript:openfj('" + list[j].RowGuid + "')\">" + list[j].AttachFileName + "</a></span>";
                                var html = "<p><span><a target='_blank' href=\""+list[j].url+"\">"+list[j].AttachFileName+"</a></span></p>";
                                $("#" + code).append(html);
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

    function openfj(guid) {
        window.location.href = "${bm_file_download}" + guid;
    }
</script>


<header class="h43" style="height: 3px">
    <div class="index-header">
        <a href="pj_list_cqjy" class="back"></a>
        <div class="title">报名查看</div>
    </div>
</header>

<form id="pj_sw_audit" action="pj_sign_up_submit" method="post">
    <input type="hidden" name="projectName" value="${data.ProjectName_3001}">
    <input type="hidden" name="projectGuid" value="${params.ProjectGuid }">
    <input type="hidden" name="bmid" value="${params.RowGuid }">
    <input type="hidden" name="type" value="CCJT">

</form>


<div class="weui-toptips weui-toptips_warn js_tooltips"></div>
<div class="weui-cells__title">查看报名信息</div>
<div class="weui-cells weui-cells_form fixed-weui-cells_form">
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
        <div class="weui-cell__hd"><label class="weui-label">产权类型</label></div>
        <div class="weui-cell__bd">${data.ProjectType_3006_name}
        </div>
    </div>

    <div class="weui-cell">
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


    <div class="weui-cells__title">报名信息</div>
    <c:if test="${user_type==1 }">
        <!-- 个人会员信息 begin -->
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">竞买人</label></div>
            <div class="weui-cell__bd">${data.DanWeiName_3003 }
            </div>
        </div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
            <div class="weui-cell__bd">${data.UnitOrgNum_3003 }
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">企业性质</label></div>
            <div class="weui-cell__bd">
                <c:if test="${data.DanWeiXingZhi_3003 eq '1'}">企业</c:if>
                <c:if test="${data.DanWeiXingZhi_3003 eq '2'}">行政事业单位</c:if>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">证件号</label></div>
            <div class="weui-cell__bd">${data.YingYeZhiZhaoNo_3003 }
            </div>
        </div>


        <!-- 个人会员信息 end -->
    </c:if>


    <c:if test="${user_type==0 }">
        <!-- 单位信息 begin -->
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">竞买人</label></div>
            <div class="weui-cell__bd">${data.DanWeiName_3003 }
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
            <div class="weui-cell__bd">${data.UnitOrgNum_3003 }
            </div>
        </div>


        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">企业性质</label></div>
            <div class="weui-cell__bd">
                <c:if test="${data.DanWeiXingZhi_3003 eq '1'}">企业</c:if>
                <c:if test="${data.DanWeiXingZhi_3003 eq '2'}">行政事业单位</c:if>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">证件号</label></div>
            <div class="weui-cell__bd">${data.YingYeZhiZhaoNo_3003 }
            </div>
        </div>
        <!-- 单位信息 end -->
    </c:if>


    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人</label></div>
        <div class="weui-cell__bd">${data.LianXiUser_3003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系电话</label></div>
        <div class="weui-cell__bd">${data.LianXiTel_3003 }
        </div>
    </div>

<!-- 
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">电子竞价登录账号</label></div>
        <div class="weui-cell__bd">${data.lblLoginID }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">电子竞价登陆密码</label></div>
        <div class="weui-cell__bd">${data.lblPassWord }
        </div>
    </div>
 -->
    <!-- file start -->
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

    <!-- file end -->
</div>

<div class="weui-btn-area fixed-btn-area" style="position: fixed;bottom: 0px;z-index:9;background-color: #FFFFFF;">
    <a href="javascript:printHZ('${RowGuid} ','ccjt')" class="weui-btn weui-btn_primary" id="showIOSDialog">打印回执</a>
</div>


<!-- 报名回执 -->
<div class="js_dialog" id="iosDialog" style="display: none;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
        <div class="weui-dialog__hd"><strong class="weui-dialog__title">产权交易报名确认单</strong></div>
        <div class="weui-dialog__bd"></div>
        <div class="weui-dialog__ft">
            <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary zdl" id="zdl_btn">知道了</a>
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
