<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
        <div class="title">预披露</div>
        <a href="javascript:showRule1();" class="h-r"><i class="glyphicon glyphicon-filter"></i></a>
    </div>
</header>
<div class="container  ">
    <div class="bgff ">
        <div class="table-view">
            <ul class="row">
            </ul>
        </div>
    </div>
</div>
<div class="visit-type js-visit-recommend">
    <div class="box">
        <div class="recharge-cz">
            <h3 class="bd_b f16 pb10 mb10 clearfix lh24"><a href="javascript:closeRule1();" class="fr "><i
                    class="fc99 f24 iconfont icon-error"></i></a>筛选</h3>
            <form id="ypl_more_form" action="ypl_more" method="get" >
                <dl>
                    <dd>
                        <span class="mb5 dsb">标的类型</span>
                        <select class="form-control input input-sm " name="type" id="type">
                            <option value=""
                                    <c:if test="${empty type}">selected</c:if> >全部
                            </option>
                            <option value="股权" <c:if test="${type=='股权'}">selected</c:if>>股权</option>
                            <option value="债权" <c:if test="${type=='债权'}">selected</c:if>>债权</option>
                            <option value="增资扩股" <c:if test="${type=='增资扩股'}">selected</c:if>>增资扩股</option>
                            <option value="房地产" <c:if test="${type=='房地产'}">selected</c:if>>房地产</option>
                            <option value="二手车" <c:if test="${type=='二手车'}">selected</c:if>>二手车</option>
                            <option value="房产招租" <c:if test="${type=='房产招租'}">selected</c:if>>房产招租</option>
                            <option value="废旧物资" <c:if test="${type=='废旧物资'}">selected</c:if>>废旧物资</option>
                            <option value="土地" <c:if test="${type=='土地'}">selected</c:if>>土地</option>
                            <option value="粮食" <c:if test="${type=='粮食'}">selected</c:if>>粮食</option>
                            <option value="工美藏品" <c:if test="${type=='工美藏品'}">selected</c:if>>工美藏品</option>
                            <option value="花木交易" <c:if test="${type=='花木交易'}">selected</c:if>>花木交易</option>
                            <option value="其他" <c:if test="${type=='其他'}">selected</c:if>>其他</option>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">标的所在地</span>
                        <select class="form-control input input-sm " name="area" id="area">
                            <option value=""
                                    <c:if test="${empty area}">selected</c:if> >全部
                            </option>
                            <c:forEach items="${cityinfo}" var="city">
                                <option value="${city.code}"
                                        <c:if test="${area==city.code}">selected</c:if>>${city.name}</option>
                            </c:forEach>
                        </select>
                    </dd>
                </dl>
            </form>
        </div>
        <div class="pd10 bd_t recharge-btn ">
            <button type="button" class="btn btn-success  w100" onclick="submmitForm();">确定</button>
        </div>

    </div>
</div>
</body>
<script>



    String.prototype.startWith = function (str) {
        var reg = new RegExp("^" + str);
        return reg.test(this);
    };

    $(function () {
        // 页数
        var currentPage = 0;
        // 每页展示5个
        var rows = 16;

        var type=$('#type').val();
        var area=$('#area').val();

        // dropload
        $('.table-view').dropload({
            scrollArea: window,
            loadDownFn: function (me) {
                currentPage++;
                // 拼接HTML
                var result = '';
                $.ajax({
                    type: 'GET',
                    url: '<%=basePath%>ypl_data?currentPage=' + currentPage + '&rows=' + rows + '&categorynum=&type=' + type + '&area=' + area,
                    dataType: 'json',
                    success: function (data) {
                        var arrLen = data.length;
                        if (arrLen > 0) {
                            for (var i = 0; i < arrLen; i++) {
                                result+='<li class="mask"> <a href="newsinfo?infoid='+data[i].infoid+'" class="item-list"> ' +
                                    '<img class="img" src="'+data[i].titlepic+'"> <div class="media-body"> <p class="tit">' +
                                    '<b class="item">'+data[i].projectstyle+'</b>'+data[i].title+'</p> </p> </div> </a> </li>';
                            }
                            // 如果没有数据
                        } else {
                            // 锁定
                            me.lock();
                            // 无数据
                            me.noData();
                        }
                        // 为了测试，延迟1秒加载
                        setTimeout(function () {
                            // 插入数据到页面，放到最后面
                            $('.row').append(result);
                            // 每次数据插入，必须重置
                            me.resetload();
                        }, 100);
                    },
                    error: function (xhr, type) {


                        // 即使加载出错，也得重置
                        me.resetload();
                    }
                });
            }
        });
    });


    function submmitForm() {
        closeRule1();
        $('#ypl_more_form').submit();
    }
</script>
</html>
