<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
        <div class="title">会员中心</div>
    </div>
</header>
<div class="container ">
    <div class="h40"></div>
    <div class="base-bidding-head list-3">
        <span class="curr item" >会员公告</span>
        <span  class="item" >制度规则</span>
        <span  class="item" >会员帮助</span>
    </div>
    <div class="base-bidding-box bgff" style="display: block;">
        <div class="new-list index-news  hygg">
            <ul class="clearfix  hygg">
            </ul>
        </div>
    </div>
    <div class="base-bidding-box bgff" style="display: none;">
        <div class="new-list index-news  zdgz">
            <ul class="clearfix  zdgz">
            </ul>
        </div>
    </div>
    <div class="base-bidding-box bgff" style="display: none;">
        <div class="new-list index-news hybz">
            <ul class="clearfix  hybz">
            </ul>
        </div>
    </div>
</div>
<div class="visit-type js-visit-recommend">
    <div class="box">
        <div class="recharge-cz">
            <h3 class="bd_b f16 pb10 mb10 clearfix lh24"><a href="javascript:closeRule1();" class="fr "><i class="fc99 f24 iconfont icon-error"></i></a>筛选</h3>
            <dl>
                <dd>
                    <span class="mb5 dsb">标的类型</span>
                    <select class="form-control input input-sm ">
                        <option value="股权">股权</option>
                        <option value="债权">债权</option>
                        <option value="增资扩股">增资扩股</option>
                        <option value="房地产">房地产</option>
                        <option value="二手车">二手车</option>
                    </select>
                </dd>
            </dl>
            <dl>
                <dd>
                    <span class="mb5 dsb">标的所在地</span>
                    <select class="form-control input input-sm ">
                        <option value="股权">股权</option>
                        <option value="债权">债权</option>
                        <option value="增资扩股">增资扩股</option>
                        <option value="房地产">房地产</option>
                        <option value="二手车">二手车</option>
                    </select>
                </dd>
            </dl>
            <dl>
                <dd>
                    <span class="mb5 dsb">产权业务类型</span>
                    <select class="form-control input input-sm ">
                        <option value="股权">股权</option>
                        <option value="债权">债权</option>
                        <option value="增资扩股">增资扩股</option>
                        <option value="房地产">房地产</option>
                        <option value="二手车">二手车</option>
                    </select>
                </dd>
            </dl>
            <dl>
                <dd>
                    <span class="mb5 dsb">项目状态</span>
                    <select class="form-control input input-sm ">
                        <option value="股权">股权</option>
                        <option value="债权">债权</option>
                        <option value="增资扩股">增资扩股</option>
                        <option value="房地产">房地产</option>
                        <option value="二手车">二手车</option>
                    </select>
                </dd>
            </dl>
        </div>
        <div class="pd10 bd_t recharge-btn ">
            <button type="button" class="btn btn-success  w100" onclick="javascript:closeRule1();">确定</button>
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
            }
            // 重置
            dropload.resetload();
        });
//        alert(itemIndex);

        // 每页展示10个
        var rows = 15;
        var selector;
        if (itemIndex == '0') {
            selector = '.index-news.hygg';
        } else if (itemIndex == '1') {
            selector = '.index-news.zdgz';
        } else if (itemIndex == '2') {
            selector = '.index-news.hybz';
        }
        // dropload
        var dropload = $(selector).dropload({
            scrollArea: window,
            loadDownFn: function (me) {
                // 加载菜单一的数据
                if (itemIndex == '0') {
                    var currentPage = Math.ceil($(".clearfix.hygg li").length / rows)+1;
//                    if (currentPage==0)
                    $.ajax({
                        type: 'GET',
                        url: '<%=basePath%>hyzx_data?currentPage=' + currentPage + '&rows=' + rows + '&flag=hygg',
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
//                                $('.new-list.hygg').append('<div class="dropload-down"><div class="dropload-noData">暂无数据</div></div>');
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.hygg').append(result);
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
                    var currentPage = Math.ceil($(".clearfix.zdgz li").length / rows)+1;
                    $.ajax({
                        type: 'GET',
                        url: '<%=basePath%>hyzx_data?currentPage=' + currentPage + '&rows=' + rows + '&flag=zdgz',
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
                                $('.new-list.zdgz').append('<div class="dropload-down"><div class="dropload-noData">暂无数据</div></div>');
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.zdgz').append(result);
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
                    var currentPage = Math.ceil($(".clearfix.hybz li").length / rows)+1;
                    $.ajax({
                        type: 'GET',
                        url: '<%=basePath%>hyzx_data?currentPage=' + currentPage + '&rows=' + rows + '&flag=hybz',
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
                                $('.new-list.hybz').append('<div class="dropload-down"><div class="dropload-noData">暂无数据</div></div>');
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.hybz').append(result);
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
