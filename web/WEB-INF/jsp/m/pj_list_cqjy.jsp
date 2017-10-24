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
    <title>E交易</title>
    <link rel="stylesheet" href="m/css/bootstrap.min.css">
    <link rel="stylesheet" href="m/css/iconfont.css">
    <link rel="stylesheet" href="m/css/index.css">
    <link rel="stylesheet" href="m/css/dropload.css">
    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    <script src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
    <script src="m/js/dropload.min.js"></script>
    <script src="js/pj_baoming.js"></script>
    <script src="m/js/index.js"></script>
    <%--<script type="text/javascript" src="m/js/DateOp.js"></script>--%>
</head>

<body>
<script type="text/javascript">
var msg = '${msg}';
if(msg!=''){
	alert(msg);
}
</script>
<%--竞买人条款--%>
<div class="js_dialog" id="dytk" style="display: none;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
        <div class="weui_dialog_hd"><strong class="weui_dialog_title">报名须知</strong></div>
        <div class="weui-dialog__bd" style="height: 350px;overflow-y:scroll;"></div>
        <div class="weui-dialog__ft" id="agree">
            <a onclick="disagree()" class="weui-dialog__btn weui-dialog__btn_primary">不同意</a>
            <input type="submit" value="同意" id="btnAgree" class="weui-dialog__btn weui-dialog__btn_primary">
        </div>
    </div>
</div>

<!-- 错误消息 -->
<div class="js_dialog" id="loadingToast" style="display: none;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
        <div class="weui-dialog__bd" id="toast_div"></div>
        <div class="weui-dialog__ft">
            <a class="weui-dialog__btn weui-dialog__btn_primary" onclick="disagree()">确定</a>
        </div>
    </div>
</div>

<header class="h43">
    <div class="index-header">
        <%--<a href="login" class="baoming"></a>--%>
            <a href="" class="back" onclick="window.history.back(-1);return false;"></a>
        <div class="title">项目报名</div>
        <a href="javascript:showRule1();" class="h-r"><i class="glyphicon glyphicon-filter"></i></a>
    </div>
</header>
<div class="container ">
    <%--<div class="h40"></div>--%>
    <%--<div class="base-bidding-head">--%>
        <%--<span class="curr item">普通报名</span>--%>
        <%--<span class="item">专厅报名</span>--%>
    <%--</div>--%>

    <div class="base-bidding-box bgff" style="display: block;">
        <div class="new-list index-news ptbm">
            <ul class="clearfix ptbm">
            </ul>
        </div>
    </div>
    <%--<div class="base-bidding-box bgff" style="display: none;">--%>
        <%--<div class="new-list index-news ztbm">--%>
            <%--<ul class="clearfix ztbm">--%>
            <%--</ul>--%>
        <%--</div>--%>
    <%--</div>--%>

</div>
<div class="visit-type js-visit-recommend">
    <div class="box">
        <div class="recharge-cz">
            <h3 class="bd_b f16 pb10 mb10 clearfix lh24"><a href="javascript:closeRule1();" class="fr "><i
                    class="fc99 f24 iconfont icon-error"></i></a>筛选</h3>
            <form id="zbcg_search" class="zbcg_search">

                <dl>
                    <dd>
                        <span class="mb5 dsb">项目名称</span>
                        <input class="form-control input input-sm" id="title" name="title" value="${title}"
                               type="text">
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">项目编号</span>
                        <input class="form-control input input-sm" id="pronum" name="pronum" value="${pronum}"
                               type="text">
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">交易机构</span>
                        <select name="jyjg" id="jyjg" class="form-control input input-sm">
                            <option value="">全部</option>
                            <c:forEach items="${organizeList}" var="org">
                                <option value="${org.orgid}">${org.name}</option>
                            </c:forEach>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">项目状态</span>
                        <select class="form-control input input-sm " name="status" id="status">
                            <%--<option value="">全部</option>--%>
                            <option value="3">已报名</option>
                            <option value="0">未开始</option>
                            <option value="1" selected>报名中</option>
                            <option value="2">报名结束</option>


                        </select>
                    </dd>
                </dl>
            </form>
        </div>
        <div class="pd10 bd_t recharge-btn ">
            <button type="button" class="btn btn-success  w100">确定</button>
        </div>
    </div>
</div>

<footer class="base-footer-index">
    <div class="box">
        <a href="index" ><span class=" iconfont ">&#xe885;</span><br>首页</a>
        <a href="pj_list_cqjy" class="active"><span class=" iconfont ">&#xe679;</span><br>普通报名</a>
        <a href="pj_list_cqjy?table=ztbm"><span class=" iconfont ">&#xe67a;</span><br>专厅报名</a>
        <a href="getUserInfo"><span class=" iconfont ">&#xe7eb;</span><br>个人信息</a>
    </div>
</footer>

</body>
<script>
    $(function () {

        var itemIndex = 0;
        var tab1LoadEnd = false;
//        var tab2LoadEnd = false;
        var ProjectRegGuid='${ProjectRegGuid}';
        // tab
        $('.base-bidding-head .item,.btn.btn-success').on('click', function () {
            closeRule1();
            var ele = $(this).attr("class");//获取触发事件的元素
//            var $this = $(this);
//            itemIndex = $this.index();
            if (ele === "btn btn-success  w100") {
                $(".clearfix.ptbm li").remove();
                // 解锁
                tab1LoadEnd = false;
            }
            // 如果选中菜单一
//            if (itemIndex == '0') {
                // 如果数据没有加载完
                if (!tab1LoadEnd) {
                    // 解锁
                    dropload.unlock();
                    dropload.noData(false);
                } else {
                    // 锁定
                    dropload.lock('down');
                    dropload.noData();
                }
                // 如果选中菜单二
//            } else if (itemIndex == '1') {
//                if (!tab2LoadEnd) {
//                    // 解锁
//                    dropload.unlock();
//                    dropload.noData(false);
//                } else {
//                    // 锁定
//                    dropload.lock('down');
//                    dropload.noData();
//                }
//            }
            // 重置
            dropload.resetload();
        });

        // 每页展示10个
        var rows = 15;
        var selector;
//        if (itemIndex == '0') {
            selector = '.index-news.ptbm';
//        } else {
//            selector = '.index-news.ztbm';
//        }
        // dropload
        var dropload = $(selector).dropload({
            scrollArea: window,
            loadDownFn: function (me) {
                // 加载菜单一的数据
                if (itemIndex == '0') {
                    var currentPage = Math.ceil($(".clearfix.ptbm li").length / rows) + 1;
                    var params = $('form.zbcg_search').serialize();
                    $.ajax({
                        type: 'GET',
                        url: '<%=basePath%>pj_list_data?ProjectRegGuid='+ProjectRegGuid+'&currentPage=' + currentPage + '&rows=' + rows + '&flag=ptbm&' + params,
                        dataType: 'json',
                        success: function (e) {
                            var result = '';
                            var data = e.data;
                            var arrLen = data.length;
                            if (arrLen > 0) {
                                for (var i = 0; i < arrLen; i++) {
                                    result += "<li><a onclick=\"bm_sub('" + data[i].IsOpen + "','" + data[i].ProjectGuid + "','" + data[i].SystemType + "','" + data[i].BaoMingGuid + "','" + data[i].zhuanRangType + "','" + data[i].project_baoming_status + "')\"  href=\"javascript:;\" >"
                                        + "<span class=''>" + data[i].ProjectName + "&nbsp;&nbsp;&nbsp;&nbsp;" + data[i].ProjectType + "&nbsp;&nbsp;&nbsp;&nbsp;";
                                    if (data[i].project_baoming_status==0){
                                        result +="<span style='float:right;background: #ec8408;color: #fff; font-size: 12px; padding: 2px 7px;'>项目未开始报名</span>";
                                    }else if(data[i].project_baoming_status==2){
                                        result +="<span style='float:right;background: #999999;color: #fff; font-size: 12px; padding: 2px 7px;'>报名已结束</span>";
                                    }else{
                                        result +="<br><span class='time'>报名截止时间: "+data[i].GongGaoToDate+"</span>";
                                    }

                                    if (data[i].BaoMingGuid && data[i].BaoMingGuid != "" ) {
                                        result += "<span style='float:right;    background: #50b450;color: #fff; font-size: 12px; padding: 2px 7px;'>" + data[i].baoMingStatusText + "</span>";
                                    }
                                }
                            } else {
                                // 数据加载完
                                tab1LoadEnd = true;
                                // 锁定
                                me.lock();
                                // 无数据
                                me.noData();
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.ptbm').append(result);
                                // 每次数据加载完，必须重置
                                me.resetload();
                            }, 100);
                        },
                        error: function (xhr, type) {

                            // 即使加载出错，也得重置
                            me.resetload();
                            alert('您没有登录或登录已超时,请重新登录.');
                            window.location.href='login';
                        }
                    });
                    // 加载菜单二的数据
//                } else if (itemIndex == '1') {
//                    //跳转页面
//                    window.location.href = "pj_list_cqjy?table=ztbm";
                }
            }
        });
    });
</script>
</html>
