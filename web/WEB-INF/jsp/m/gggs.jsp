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
        <a href="" class="back" onclick="window.history.back(-1);return false;"></a>
        <div class="title">公告公示</div>
    </div>
</header>
<div class="container ">
    <div class="h40"></div>
    <div class="base-bidding-head list-4">
        <span class="curr item">平台公告</span>
        <span class="item">政策法规</span>
        <span class="item">业界资讯</span>
        <span class="item">交易规则</span>
    </div>
    <div class="base-bidding-box bgff" style="display: block;">
        <div class="new-list index-news  ptgg">
            <ul class="clearfix  ptgg">
            </ul>
        </div>
    </div>
    <div class="base-bidding-box bgff" style="display: none;">
        <div class="new-list index-news  zcfg">
            <ul class="clearfix   zcfg">

            </ul>
        </div>
    </div>
    <div class="base-bidding-box bgff" style="display: none;">
        <div class="new-list index-news  yjzx">
            <ul class="clearfix  yjzx">

            </ul>
        </div>
    </div>
    <div class="base-bidding-box bgff" style="display: none;">
        <div class="new-list index-news  jygz">
            <ul class="clearfix  jygz">

            </ul>
        </div>
    </div>
</div>

</body>
<script>
    $(function () {
        var itemIndex = 0;
        var tab1LoadEnd = false;
        var tab2LoadEnd = false;
        var tab3LoadEnd = false;
        var tab4LoadEnd = false;
        // tab
        $('.base-bidding-head .item').on('click', function () {
            var $this = $(this);
            itemIndex = $this.index();
//            alert("item"+itemIndex);
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
            } else if (itemIndex == '2') {
                if (!tab3LoadEnd) {
                    // 解锁
                    dropload.unlock();
                    dropload.noData(false);
                } else {
                    // 锁定
                    dropload.lock('down');
                    dropload.noData();
                }
            } else if (itemIndex == '3') {
                if (!tab4LoadEnd) {
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
            selector = '.index-news.ptgg';
        } else if (itemIndex == '1') {
            selector = '.index-news.zcfg';
        } else if (itemIndex == '2') {
            selector = '.index-news.yjzx';
        } else if(itemIndex == '3'){
            selector = '.index-news.jygz';
        }
        // dropload
        var dropload = $(selector).dropload({
            scrollArea: window,
            loadDownFn: function (me) {
                // 加载菜单一的数据
                if (itemIndex == '0') {
                    var currentPage = Math.ceil($(".clearfix.ptgg li").length / rows)+1;
                    $.ajax({
                        type: 'GET',
                        url: '<%=basePath%>gggs_data?currentPage=' + currentPage + '&rows=' + rows + '&flag=ptgg',
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
                                tab1LoadEnd = true;
                                // 锁定
                                me.lock();
                                // 无数据
                                me.noData();
//                                $('.new-list.ptgg').append('<div class="dropload-down"><div class="dropload-noData">暂无数据</div></div>');
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.ptgg').append(result);
                                // 每次数据加载完，必须重置
                                me.resetload();
                            }, 100);
                        },
                        error: function (xhr, type) {

                            // 即使加载出错，也得重置
                            me.resetload();
                        }
                    });
                    // 加载菜单二的数据
                } else if (itemIndex == '1') {
                    var currentPage = Math.ceil($(".clearfix.zcfg li").length / rows)+1;
                    $.ajax({
                        type: 'GET',
                        url: '<%=basePath%>gggs_data?currentPage=' + currentPage + '&rows=' + rows + '&flag=zcfg',
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
                                $('.new-list.zcfg').append('<div class="dropload-down"><div class="dropload-noData">暂无数据</div></div>');
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.zcfg').append(result);
                                // 每次数据加载完，必须重置
                                me.resetload();
                            }, 100);
                        },
                        error: function (xhr, type) {

                            // 即使加载出错，也得重置
                            me.resetload();
                        }
                    });
                } else if (itemIndex == '2') {
                    var currentPage = Math.ceil($(".clearfix.yjzx li").length / rows)+1;
                    $.ajax({
                        type: 'GET',
                        url: '<%=basePath%>gggs_data?currentPage=' + currentPage + '&rows=' + rows + '&flag=yjzx',
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
                                tab3LoadEnd = true;
                                // 锁定
                                me.lock();
                                // 无数据
                                me.noData();
                                $('.new-list.yjzx').append('<div class="dropload-down"><div class="dropload-noData">暂无数据</div></div>');
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.yjzx').append(result);
                                // 每次数据加载完，必须重置
                                me.resetload();
                            }, 100);
                        },
                        error: function (xhr, type) {

                            // 即使加载出错，也得重置
                            me.resetload();
                        }
                    });
                }else if(itemIndex == '3'){
                    var currentPage = Math.ceil($(".clearfix.jygz li").length / rows)+1;
                    $.ajax({
                        type: 'GET',
                        url: '<%=basePath%>gggs_data?currentPage=' + currentPage + '&rows=' + rows + '&flag=jygz',
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
                                tab4LoadEnd = true;
                                // 锁定
                                me.lock();
                                // 无数据
                                me.noData();
                                $('.new-list.jygz').append('<div class="dropload-down"><div class="dropload-noData">暂无数据</div></div>');
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.jygz').append(result);
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
