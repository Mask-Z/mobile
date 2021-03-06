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
        //initHeight();


        /**
         * 提交
         **/

         $("a[name='flow_submit']").click(function(){
     		var btn = $(this);
     		var t = btn.attr("operationType");
     		if(t){
     			if("Save"==t){//修改
     				window.location.href = "pj_sign_up?infoid=${params.ZhuanTingGuid }&type=ZT&bmguid=${params.RowGuid }";
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
        
        
        function next_step(btn){
        	var on = btn.attr("operationName");
        	var og = btn.attr("operationGuid");
        	var tg = btn.attr("transitionGuid");
        	var ot = btn.attr("operationType");
        	if(on=="" || og=="" || tg=="" || ot==""){
        		//alert("系统错误,无法提交");
        		//return;
        	}
            $("#operationName").val(on);
            $("#operationGuid").val(og);
            $("#transitionGuid").val(tg);
            $("#operationType").val(ot);
            var param = $("#pj_sw_audit").serialize();
            $.ajax({
                type: "POST",
                url: "pj_sign_up_audit",
                dataType: "json",
                data: param,
                success: function(msg){
                    if(msg){
                        if(msg.code == 0){
                            $("#toast_div").text("报名成功");
                            $('#loadingToast').fadeIn(100);
                            window.location.href = "pj_list_cqjy?table=ztbm";
                        }else{
                            $("#toast_div").text(msg.msg);
                            $('#loadingToast').fadeIn(100);
                        }
                        $('#loadingToast').fadeOut(3000);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown){
                    alert(errorThrown);
                }
            });
        };

        /**
         * 修改
         **/
        $("#btnEdit").click(function(){
            
        });
        
        var wfInfo = "${data.WorkFlowInfo.wfInfo}";
        if(wfInfo){
            $("#wfInfo").html(wfInfo);
            $("#wfInfo").css('display', 'block');
        }

        /**
         * 加载附件
         **/
        loadFile();
    })

    var task_code = "CQJY_BaoMingZT";
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
//                                var html = "<p><span><a href=\"javascript:openfj('"+list[j].RowGuid+"')\">"+list[j].AttachFileName+"</a></span></p>";
                                var html = "<p><span><a target='_blank' href=\""+list[j].url+"\">"+list[j].AttachFileName+"</a></span></p>";
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

<header class="h43">
    <div class="index-header">
        <a href="pj_list_cqjy?table=ztbm" class="back"></a>
        <div class="title">报名查看</div>
    </div>
</header>

<form id="pj_sw_audit" action="pj_sign_up_submit" method="post">
    <input type="hidden" name="info['projectName']" value="${data.lblZhuanTingName}">
    <input type="hidden" name="info['ProjectGuid']" value="${data.XiaQuCode }">
    <input type="hidden" name="info['RowGuid']" value="${params.RowGuid }">
    <input type="hidden" name="info['ZhuanTingGuid']" value="${ZhuanTingGuid }">
    <input type="hidden" name="info['type']" value="ZT">

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
<div class="weui-cells weui-cells_form no-mt fixed-weui-cells_form">
    <c:if test="${user_type==0 }">
        <!-- 单位信息 begin -->

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">专厅名称</label></div>
            <div class="weui-cell__bd">${data.lblZhuanTingName }
            </div>
        </div>

        <div class="weui-cell ">
            <div class="weui-cell__hd"><label class="weui-label">竞买人</label></div>
            <div class="weui-cell__bd">${data.lblDanWeiName }
            </div>
        </div>



        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">企业性质</label></div>
            <div class="weui-cell__bd">${data.lblDanWeiXingZhi}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">企业组织机构代码</label></div>
            <div class="weui-cell__bd">${data.lblUnitOrgNum }
            </div>
        </div>

        <div class="weui-cell">
            <%--<div class="weui-cell__hd"><label class="weui-label">是否国资</label></div>--%>
            <div class="weui-cell__hd"><label class="weui-label">国资类型</label></div>
            <div class="weui-cell__bd">${data.IsGuoZi_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">法人类型</label></div>
            <div class="weui-cell__bd">
                <c:if test="${data.FaRenType_13003 eq '1'}">企事业单位</c:if>
                <c:if test="${data.FaRenType_13003 eq '2'}">自然人</c:if>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">国资监管类型</label></div>
            <div class="weui-cell__bd">${data.GuoZiJianGuanType_13003}
            </div>
        </div>

        <div class="weui-cell">
            <%--<div class="weui-cell__hd"><label class="weui-label">央企国资机构</label></div>--%>
            <div class="weui-cell__hd"><label class="weui-label">国资监管机构</label></div>
            <div class="weui-cell__bd">${data.YQGuoZiJG_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">主管集团</label></div>
            <div class="weui-cell__bd">${data.ZhuGuanJiTuan_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">主管集团代码</label></div>
            <div class="weui-cell__bd">${data.ZhuGuanJiTuanCode_13003}
            </div>
        </div>

        <div class="weui-cells__title">基本情况</div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">所在地区</label></div>
            <div class="weui-cell__bd">${data.AreaName}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">注册地</label></div>
            <div class="weui-cell__bd">${data.ZhuCeDi_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">注册资本(万元)</label></div>
            <div class="weui-cell__bd">${data.ZhuCeZiBen_13003}
            </div>
        </div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">公司类型</label></div>
            <div class="weui-cell__bd">${data.gsType_name}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">经济类型</label></div>
            <div class="weui-cell__bd">${data.JingJiType_name}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">法定代表人</label></div>
            <div class="weui-cell__bd">${data.FaRen_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">所属行业</label></div>
            <div class="weui-cell__bd">${data.HangYeType_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">经济规模</label></div>
            <div class="weui-cell__bd">${data.GuiMo_name}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">工商注册号</label></div>
            <div class="weui-cell__bd">${data.GongShangHao_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">经营范围</label></div>
            <div class="weui-cell__bd">${data.JingYingFanWei_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">受让资格陈述</label></div>
            <div class="weui-cell__bd">${data.ShouRangZiGe_13003}
            </div>
        </div>
        <!-- 单位信息 end -->
    </c:if>

    <c:if test="${user_type==1 }">
        <!-- 个人会员信息 begin -->
        <div class="weui-cells__title">报名信息</div>
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">专厅名称</label></div>
            <div class="weui-cell__bd">${data.lblZhuanTingName }
            </div>
        </div>

        <div class="weui-cell ">
            <div class="weui-cell__hd"><label class="weui-label">竞买人</label></div>
            <div class="weui-cell__bd">${data.lblDanWeiName }
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">会员类型</label></div>
            <div class="weui-cell__bd">
                <c:if test="${data.FaRenType_13003 eq '1'}">企事业单位</c:if>
                <c:if test="${data.FaRenType_13003 eq '2'}">自然人</c:if>
            </div>
        </div>

        <div class="weui-cells__title">基本情况</div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">证件名称</label></div>
            <div class="weui-cell__bd">${data.ZhengName_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">证件号码</label></div>
            <div class="weui-cell__bd">${data.ZhengNo_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">工作单位</label></div>
            <div class="weui-cell__bd">${data.GongZuoDanWei_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">职务</label></div>
            <div class="weui-cell__bd">${data.ZhiWu_13003}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">资金来源</label></div>
            <div class="weui-cell__bd">${data.ZiJinLaiYuan_name}
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">个人资产申报</label></div>
            <div class="weui-cell__bd">${data.GeRenZiChan_13003}
            </div>
        </div>
        <!-- 个人会员信息 end -->
    </c:if>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人</label></div>
        <div class="weui-cell__bd">${data.LianXiUser_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系电话</label></div>
        <div class="weui-cell__bd">${data.LianXiTel_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">电子邮箱</label></div>
        <div class="weui-cell__bd">${data.Email_13003 }
        </div>
    </div>

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">传真</label></div>
        <div class="weui-cell__bd">${data.ChuanZhen_13003 }
        </div>
    </div>
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
    <div class="weui-cells__title">标的列表</div>
    <div class="weui-cells" >
        <iframe src='iframeData?ZhuanTingGuid=${ZhuanTingGuid}' width="100%"  id="myiframe" scrolling="no" frameborder="0"  ></iframe>
    </div>
</div>

<div style="height: 50px"></div>
<div class="weui-btn-area fixed-btn-area" style="position: fixed;bottom: 0px;z-index:9;background-color: #FFFFFF;">
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
    <a href="javascript:printHZ('${RowGuid} ','zt')" class="weui-btn weui-btn_mini weui-btn_warn" id="showIOSDialog">打印回执</a>
</div>



<!-- 报名回执 -->
<div class="js_dialog" id="iosDialog" style="display: none;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
    	<div class="weui-dialog__hd"><strong class="weui-dialog__title">产权交易报名回执单 </strong></div>
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
