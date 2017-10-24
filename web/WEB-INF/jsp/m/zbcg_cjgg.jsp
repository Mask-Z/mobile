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
    <script src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
    <script src="m/js/iconfont.js"></script>
    <script src="m/js/bootstrap.min.js"></script>
    <script src="m/js/index.js"></script>
    <script src="m/js/dropload.min.js"></script>
</head>

<body>
<header class="h43">
    <div class="index-header">
        <a href="index" class="back" ></a>
        <div class="title">招标采购</div>
        <a href="javascript:showRule1();" class="h-r"><i class="glyphicon glyphicon-filter"></i></a>
    </div>
</header>
<div class="container ">
    <div class="h40"></div>
    <div class="base-bidding-head">
        <span class="item">招标公告</span>
        <span class="curr item">成交公告</span>
    </div>

    <div class="base-bidding-box bgff" style="display: none;">
        <div class="new-list index-news zbgg">
            <ul class="clearfix zbgg">
            </ul>
        </div>
    </div>
    <div class="base-bidding-box bgff" style="display: block;">
        <div class="new-list index-news cjgg">
            <ul class="clearfix cjgg">
            </ul>
        </div>
    </div>

</div>
<div class="visit-type js-visit-recommend">
    <div class="box">
        <div class="recharge-cz">
            <h3 class="bd_b f16 pb10 mb10 clearfix lh24"><a href="javascript:closeRule1();" class="fr "><i
                    class="fc99 f24 iconfont icon-error"></i></a>筛选</h3>
            <form id="zbcg_search" class="zbcg_search">
                <%--<input type="hidden" name="sheng" id="jjdt_sheng" value=""/>--%>
                <dl>
                    <dd>
                        <span class="mb5 dsb">公告的名称</span>
                        <input class="form-control input input-sm" id="keytext" name="title" value="${title}"
                               type="text">
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">项目类型</span>
                        <select name="type" class="form-control input input-sm">
                            <option value="">全部</option>
                            <option value="工程"/>工程</option>
                            <option value="货物"/>货物</option>
                            <option value="服务"/>服务</option>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">组织机构</span>
                        <select class="form-control input input-sm " name="ggtype" id="ggtype">
                            <option value="">全部</option>
                            <c:forEach items="${orglist}" var="obj">
                                <option value="${obj.orgid}"/>
                                    ${obj.name}
                                </option>
                            </c:forEach>
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
        <a href="jygg_more" ><span class=" iconfont ">&#xe679;</span><br>产权交易</a>
        <a href="zbcg_more" class="active"><span class=" iconfont ">&#xe67a;</span><br>招标采购</a>
        <a href=""><span class=" iconfont ">&#xe7eb;</span><br>我的</a>
    </div>
</footer>
</body>
<script>
    $(function () {
        var itemIndex = 1;
        var tab1LoadEnd = false;
        var tab2LoadEnd = false;
        // tab
        $('.base-bidding-head .item,.btn.btn-success').on('click', function () {
            closeRule1();
            var ele = $(this).attr("class");//获取触发事件的元素
            var $this = $(this);
            itemIndex = $this.index();
            if (ele === "btn btn-success  w100") {
                $(".clearfix.cjgg li").remove();
                itemIndex = 1;
                // 解锁
                tab2LoadEnd = false;
            }
//            var $this = $(this);
//            itemIndex = $this.index();
            // 如果选中菜单一
            if (itemIndex == '0') {
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
            } else if (itemIndex == '1') {
                if (!tab2LoadEnd) {
                    // 解锁
                    dropload.unlock();
                    dropload.noData(false);
                } else {
                    // 锁定
                    dropload.lock('down');
                    dropload.noData();
                }
            }
            // 重置
            dropload.resetload();
        });

        // 每页展示10个
        var rows = 15;
        var selector;
        if (itemIndex == '0') {
            selector = '.index-news.zbgg';
        } else {
            selector = '.index-news.cjgg';
        }
        // dropload
        var dropload = $(selector).dropload({
            scrollArea: window,
            loadDownFn: function (me) {
                // 加载菜单一的数据
                if (itemIndex == '0') {
                    //跳转页面
                    window.location.href="zbcg_more";
                    // 加载菜单二的数据
                } else if (itemIndex == '1') {
                    var currentPage = Math.ceil($(".clearfix.cjgg li").length / rows)+1;
                    var params=$('form.zbcg_search').serialize();
                    $.ajax({
                        type: 'GET',
                        url: '<%=basePath%>zbcg_data?currentPage=' + currentPage + '&rows=' + rows + '&flag=cjgg&'+params,
                        dataType: 'json',
                        success: function (data) {
                            var result = '';
                            var arrLen = data.length;
                            if (arrLen > 0) {
                                for (var i = 0; i < arrLen; i++) {
                                    result += '<li><a  href=" newsinfo?infoid=' + data[i].infoid + ' " ><span class="fr fc99 pl10">'
                                        + data[i].infodate + '</span><span class="">' + data[i].title
                                        + '</span></a></li>';
                                }
                            } else {
//                                 数据加载完
                                tab2LoadEnd = true;
                                // 锁定
                                me.lock();
                                // 无数据
                                me.noData();
//                                $('.new-list.cjgg').append('<div class="dropload-down"><div class="dropload-noData">暂无数据</div></div>');
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.cjgg').append(result);
                                // 每次数据加载完，必须重置
                                me.resetload();
                            }, 100);
                        },
                        error: function (xhr, type) {

                            // 即使加载出错，也得重置
                            me.resetload();
                        }
                    });
                }
            }
        });
    });
</script>
</html>
