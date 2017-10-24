<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.ccjt.ejy.web.vo.GongGao" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<head>

<jsp:include page="mate.jsp"></jsp:include>
    <title>E交易</title>
    <link rel="stylesheet" href="<%=basePath %>m/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%=basePath %>m/css/iconfont.css">
    <link rel="stylesheet" href="<%=basePath %>m/css/index.css">
    <script src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="<%=basePath %>m/js/iconfont.js"></script>
    <script src="<%=basePath %>m/js/bootstrap.min.js"></script>
    <script src="<%=basePath %>m/js/m_index.js"></script>
    <script type="text/javascript" src="m/js/DateOp.js"></script>
    <script type="text/javascript" src="m/js/divselect.js"></script>
    <script type="text/javascript" src="m/ext/jjdt_more.js"></script>
</head>
<script type="text/javascript">
    $(function () {
        load_jjdt();
        if (Hammer) {
            var myElement = document.getElementById('carousel-example-generic')
            var hm = new Hammer(myElement);
            hm.on("swipeleft", function () {
                $('#carousel-example-generic').carousel('next')
            })
            hm.on("swiperight", function () {
                $('#carousel-example-generic').carousel('prev')
            });
            $('#carousel-example-generic').carousel({interval: 3000});//每隔5秒自动轮播
        }

//
//        function long_to_date(l_second) {
//            if (l_second > 0) {
//                l_second = l_second / 1000;
//                var second = 0, minute = 0, hour = 0, day = 0;
//                minute = parseInt(l_second / 60); //算出一共有多少分钟
//                second = parseInt(l_second % 60);//算出有多少秒
//                if (minute > 60) { //如果分钟大于60，计算出小时和分钟
//                    hour = parseInt(minute / 60);
//                    minute %= 60;//算出有多分钟
//                }
//                if (hour > 24) {//如果小时大于24，计算出天和小时
//                    day = parseInt(hour / 24);
//                    hour %= 24;//算出有多分钟
//                }
//            }
//            var ts = "<span class=\"big-time\">" + day + "</span><span>天</span><span class=\"big-time\">" + hour + "</span><span>时</span>";
//            ts += "<span class=\"big-time\">" + minute + "</span><span>分</span><span class=\"big-time\">" + second + "</span><span>秒</span>";
//            return ts;
//        }

//
//        function date2TimeStamp(str) {
//            str=str.replace(/-/g,'/');
//            var date=new Date(str);
//            var bme = date.getTime();
//            update_time(bme);
//        }

//        function update_time(bme) {
//
//            var now = new Date().getTime();
//            var t_value = "";
//            if (now < bme) {//报名中
//                t_value = "<i class='glyphicon glyphicon-time mr10 f16'></i><span style=\"width: 70px;\">距报名结束</span>";
//                t_value += long_to_date(bme - now);
//            }
//            if (now > bme) {//报名已经结束
//                t_value = "<span style=\"width: 70px;\">已结束</span>";
//            }
//            $(".timestamp").html(t_value);
//            setInterval(update_time(bme-1000), 1000);
//        }

//        window.setInterval(load_jjdt,1500);
    });



</script>
<style>
    .index-header .search .city_name .city_list{
        background-color: #FFffff;
    }
</style>
<body>

<form action="jygg_more" id="index_search_form" method="get">
    <input type="hidden" name="title" id="index_search_title" value="${title }">
</form>

<header class="h43">
    <div class="index-header">
        <div class="header_w">
            <div class="header-logo">
                <h1></h1>
                <div class="search">
                    <select id="selectType" class="city_name">
                        <option value="产权交易" selected>产权交易</option>
                        <option value="招标采购">招标采购</option>
                    </select>
                 
                    <div class="search-box">
                        <input name="title" type="text" placeholder="搜索你要搜索的关键字" id="index_search_text">
                        <a href="#" class="search-btn"><i class="iconfont icon-icon1"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>
<div class="container ">
    <!-- 轮播效果 B -->
    <!-- 轮播效果 B -->
    <script src="<%=basePath %>m/js/jquery.hammer.min.js"></script>
    <div id="carousel-example-generic" class="carousel slide">
        <!-- 轮播（Carousel）指标 -->
        <ol class="carousel-indicators">
            <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
            <li data-target="#carousel-example-generic" data-slide-to="1"></li>
            <li data-target="#carousel-example-generic" data-slide-to="2"></li>
            <li data-target="#carousel-example-generic" data-slide-to="3"></li>
            <li data-target="#carousel-example-generic" data-slide-to="4"></li>
        </ol>
        <!-- 轮播（Carousel）项目 -->
        <div class="carousel-inner swipeleft">
            <%--<div class="item active">--%>
                <%--<img src="<%=basePath %>m/images/shangxian.jpg" width="100%" alt="First slide">--%>
            <%--</div>--%>
            
            <div class="item active">
                <img src="<%=basePath %>m/images/hlj.jpg" height="300px" width="100%" alt=" slide">
            </div>
            
            <div class="item">
                <img src="<%=basePath %>m/images/elhsk.jpg" width="100%" alt="First slide">
            </div>
            <div class="item">
                <img src="<%=basePath %>m/images/ntzh.jpg" width="100%" alt="Second slide">
            </div>
            <div class="item">
                <img src="<%=basePath %>m/images/shangxian.jpg" width="100%" alt="Second slide">
            </div>
            <div class="item">
                <img src="<%=basePath %>m/images/xj.jpg" width="100%" alt="Second slide">
            </div>
            
        </div>
        <!-- 轮播（Carousel）导航 -->
    </div>
    <!-- 轮播效果 E -->
    <div class="pd10 bgff">
        <ul class="sorts_img_box clearfix">
            <li>
                <div class="sorts_img">
                    <a href="jygg_more">
                        <img src="<%=basePath %>m/images/index-menu-1.png">
                        <span>产权交易</span>
                    </a>
                </div>
            </li>
            <li>
                <div class="sorts_img">
                    <a href="zbcg_more">
                        <img src="<%=basePath %>m/images/index-menu-2.png">
                        <span>招标采购</span>
                    </a>
                </div>
            </li>
            <li>
                <div class="sorts_img">
                    <a href="jjdt_more">
                        <img src="<%=basePath %>m/images/index-menu-3.png">
                        <span>竞价大厅</span>
                    </a>
                </div>
            </li><%--
            
            <li>
                <div class="sorts_img">
                    <a href="http://www.e-nsh.com.cn/">
                        <img src="<%=basePath %>m/images/index-menu-4.png">
                        <span>股权托管</span>
                    </a>
                </div>
            </li>
            <li>
                <div class="sorts_img">
                    <a href="http://www.e-dt.com.cn/">
                        <img src="<%=basePath %>m/images/index-menu-5.png">
                        <span>金融交易</span>
                    </a>
                </div>
            </li>
            
            --%><li>
                <div class="sorts_img">
                    <a href="tzjr/038001">
                        <img src="<%=basePath %>m/images/index-menu-6.png">
                        <span>融资贷款</span>
                    </a>
                </div>
            </li>
            <li>
                <div class="sorts_img">
                    <a href="hyzx">
                        <img src="<%=basePath %>m/images/index-menu-7.png">
                        <span>会员中心</span>
                    </a>
                </div>
            </li>
            <li>
                <div class="sorts_img">
                    <%--<a href="gggs.html">--%>
                    <a href="news_more">
                        <img src="<%=basePath %>m/images/index-menu-8.png">
                        <span>公告公示</span>
                    </a>
                </div>
            </li>
            <li>
                <div class="sorts_img">
                    <%--<a href="<%=basePath %>doc/wap/jgjm.html">--%>
                    <a href="wyjm/014001">
                        <img src="<%=basePath %>m/images/index-menu-9.png">
                        <span>机构加盟</span>
                    </a>
                </div>
            </li>
            <li>
                <div class="sorts_img">
                    <a href="about">
                        <img src="<%=basePath %>m/images/index-menu-10.png">
                        <span>关于我们</span>
                    </a>
                </div>
            </li>
        </ul>
    </div>
    <div class="bgff mt10">
        <div class="table-view">
            <h3><a href="jygg_more">产权交易</a></h3>
            <ul class="row">
                <!-- 产权交易-->
                <c:forEach items="${cqjy_jygg_all}" var="gq" varStatus="status">
                    <li class="mask">
                        <a href="infodetail?infoid=${gq.infoid}&categoryNum=${gq.categorynum}" class="item-list">
                            <img class="img" src="http://www.e-jy.com.cn/${gq.titlepic}" style="height: 125px">
                            <div class="media-body">
                                <span class="Label"
                                      <c:choose>
                                          <c:when test="${gq.status_name.equals('竞价中')||gq.status_name.equals('报名中')}">
                                              style="background-color: #f60"
                                          </c:when>
                                          <c:when test="${gq.status_name.equals('已成交')}">
                                              style="background-color:#13a547"
                                          </c:when>
                                          
                                      </c:choose>
                                        >${gq.status_name}</span>
                                <p class="tit"><b class="item">${gq.projectstyle}</b>${gq.title}</p>
                                <p class="other-info">￥<b>${gq.guapaiprice}元</b>
                                </p>
                            </div>
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
    <div class="bgff mt10">
        <div class="table-view">
            <h3 class="bor-red"><a href="ypl_more">预披露</a></h3>
            <ul class="row">
                <c:forEach items="${ypl_gq}" var="gq" varStatus="status">
                    <li class="mask">
                        <a href="newsinfo?infoid=${gq.infoid}&categoryNum=${gq.categorynum}" class="item-list">
                            <img class="img" src="${gq.titlepic}">
                            <div class="media-body">
                                <p class="tit"><b class="item">${gq.categoryname}</b>${gq.title}
                                </p>
                                </p>
                            </div>
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
    <div class="bgff mt10">
        <div class="table-view">
            <h3 class="bor-green bd_b"><a href="jjdt_more">竞价大厅</a></h3>
            <ul class="cart-table-view clearfix favorite">
            </ul>
        </div>
    </div>
    <div class="bgff mt10">
        <div class="table-view">
            <h3 class="inde-base-title"><a href="zbcg_more">招标采购</a></h3>
            <div class="new-list index-news">
                <ul class="clearfix">
                    <c:forEach items="${zbcg_zbgg_gc}" var="gq" varStatus="status"><!-- 招标采购-工程 -->
                    <li><a href="newsinfo?infoid=${gq.infoid}&categoryNum=${gq.categorynum}">
                        <span class="fr fc99 pl10">
                                ${gq.enddate }
                        </span>
                        <span class="">
                                ${gq.title}
                        </span>
                    </a></li>

                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
</div>
<div class="base-fot-item">版权信息：2014-2015 常州创业投资集团有限公司版权所有 苏ICP备14044398号-1</div>
<footer class="base-footer-index">
  <div class="box">
      <c:choose>
          <c:when test="${empty loginAccount}">
              <a href="" class="active"><span class=" iconfont ">&#xe885;</span><br>首页</a>
              <a href="jygg_more"><span class=" iconfont ">&#xe679;</span><br>产权交易</a>
              <a href="zbcg_more"><span class=" iconfont ">&#xe67a;</span><br>招标采购</a>
              <a href="getUserInfo"><span class=" iconfont ">&#xe7eb;</span><br>个人信息</a>
          </c:when>
          <c:otherwise>
              <a href="" class="active"><span class=" iconfont ">&#xe885;</span><br>首页</a>
              <a href="pj_list_cqjy"><span class=" iconfont ">&#xe679;</span><br>普通报名</a>
              <a href="pj_list_cqjy?table=ztbm"><span class=" iconfont ">&#xe67a;</span><br>专厅报名</a>
              <a href="getUserInfo"><span class=" iconfont ">&#xe7eb;</span><br>个人信息</a>
          </c:otherwise>
      </c:choose>
  </div>
</footer>

</body>
<script>
    $(function (){
//    $.divselect(".city_name","#inputselect");

    $(".iconfont.icon-icon1").click(function(){
        var href = window.location.href;
        var v = $("#index_search_text").val();
        $("#index_search_title").val(v);
        var type = $("#selectType").val();
        if("产权交易"==type){
            $("#index_search_form").attr("action","jygg_more");
        } else if("招标采购"==type){
            $("#index_search_form").attr("action","zbcg_more");
        }

        $("#index_search_form").submit();
    })
    })
</script>
</html>
