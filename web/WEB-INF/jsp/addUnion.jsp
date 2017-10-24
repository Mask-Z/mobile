<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<link rel="stylesheet" type="text/css" href="<%=basePath%>easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/style.css">
<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
<script type="text/javascript" src="<%=basePath%>easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=basePath%>easyui/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-validtype.js"></script>
<script type="text/javascript" src="<%=basePath%>js/common.js"></script>
<style>
    <!--
    tr {
        height: 30px;
    }
    td{
        text-align: left;
    }
    -->
</style>
<script type="text/javascript">
    var msg = "${msg}";
    if(msg == "success"){//保存成功的回传
        parent.$.messager.alert("提示", "保存成功");
        parent.$("#union_list_table").datagrid("reload");
        parent.closeWindow("#w1");
    }
</script>

<form id="ad_addform" style="margin: 5px 5px;" method="post" enctype="multipart/form-data" action="<%=basePath%>system/logo_save">
    <div class="sztab">
        <%--<table id="logo_addtable">--%>
            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">受让方名称<font color="red">(*)</font>:</label>
                <select class="easyui-combobox"  labelPosition="top" style="width:50%;" id="jgmc" name="jgmc" >
                    <c:forEach items="${orgList}" var="map">
                        <option value="${map.orgId}" <c:if test="${map.orgId eq ad.jgmc }">selected</c:if> >${map.orgName}</option>
                    </c:forEach>
                </select>
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top" style="width:100%; display:block;">受让方类型:</label>
                <select class="easyui-combobox"  labelPosition="top" style="width:50%;" name="info['shouRangRenType']" >
                    <c:forEach items="${shouRangRenTypes}" var="shouRangRenType">
                        <option value="${shouRangRenType.code}">${shouRangRenType.value}</option>
                    </c:forEach>
                </select>
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top">受让比例(%)<font color="red">(*)</font>:</label>
                <input class="easyui-textbox" style="width:50%;" data-options="required:true" name="info['shouRangPercent']"
                       type="text"  value="" placeholder="请输入受让比例">
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top">联系人姓名:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['lianXiName']" type="text"  value="" >
            </div>

            <div style="margin-bottom:20px">
                <label class="label-top">联系人电话:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['lianXiTel']" type="text"  value="" >
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">联系人邮件:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['lianXiEmail']" type="text"  value="" >
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">联系人传真:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['lianXiFax']" type="text"  value="" >
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">委托会员单位名称:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['weiTuoDWName']" type="text"  value="" >
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">委托会员联系人电话:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['weiTuoDWLianXiTel']" type="text"  value="" >
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">委托会员核实意见:</label>
                <input class="easyui-textbox" style="width:50%; height:80px;" data-options="multiline:true"
                       name="info['weiTuoHYHeShi']" value="${data.ShouRangZiGe}">
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">委托会员工位号:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['weiTuoHYNo']" type="text"  value="" >
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">委托会员经纪人:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['weiTuoHYName']" type="text"  value="" >
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">委托会员经纪人编码:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['weiTuoHYCode']" type="text"  value="" >
            </div>
            <div style="margin-bottom:20px">
                <label class="label-top">委托会员联系人:</label>
                <input class="easyui-textbox" style="width:50%;"  name="info['weiTuoHYLianXiName']" type="text"  value="" >
            </div>
        <%--</table>--%>
    </div>
    <a href="javascript:;" class="easyui-linkbutton" iconCls="icon-ok" id="ad_save">保存</a>
    <a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:parent.$('#w1').window('close');">取消</a>
</form>
<script type="text/javascript">
    var resroot = "<%=basePath%>";//用到UEDITOR的地方必须配置
</script>
<link rel="stylesheet" href="<%=basePath%>kindeditor-4.1.11/themes/default/default.css" />
<link rel="stylesheet" href="<%=basePath%>kindeditor-4.1.11/plugins/code/prettify.css" />
<script charset="utf-8" src="<%=basePath%>kindeditor-4.1.11/kindeditor-all.js"></script>
<script charset="utf-8" src="<%=basePath%>kindeditor-4.1.11/lang/zh-CN.js"></script>
<script charset="utf-8" src="<%=basePath%>kindeditor-4.1.11/plugins/code/prettify.js"></script>
<script>
    KindEditor.ready(function(K) {
        var editor1 = K.create('textarea[name="content"]', {
            cssPath : '<%=basePath%>kindeditor-4.1.11/plugins/code/prettify.css',
            uploadJson : '<%=basePath%>fileUpload',
            fileManagerJson : '<%=basePath%>fileManager',
            allowFileManager : true,
            afterCreate : function() {
            },
            afterBlur: function(){this.sync();}
        });
        prettyPrint();
    });
</script>