<%@ page import="com.ccjt.ejy.web.vo.GongGao" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"   %>
<!DOCTYPE html>
<html lang="en">
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    int sz = 0;
    String size = "";
    Object obj = request.getAttribute("his");if(obj!=null){List s = (List)obj; sz = s.size(); }
    obj = request.getAttribute("his_erci");if(obj!=null){List s = (List)obj;sz += s.size(); }
    size = String.valueOf(sz);

    Object oo = request.getAttribute("allcount");
    if(oo!=null){
        size = (oo).toString();
    }
%>
<head>
<jsp:include page="mate.jsp"></jsp:include>
    <title>E交易</title>
    <link rel="stylesheet" href="m/css/bootstrap.min.css">
    <link rel="stylesheet" href="m/css/iconfont.css">
    <link rel="stylesheet" href="m/css/index.css">
    <script src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="m/js/iconfont.js"></script>
    <script src="m/js/bootstrap.min.js"></script>
    <script src="m/js/index.js"></script>


</head>
<script>
    $(function () {

        /**
         * 根据<li>标签的个数设置宽度
         * @type {jQuery}
         */
        var len=$(".deatil-tabs li").length;
        var wid=100/len;
        $(".deatil-tabs li").width(wid+'%');


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

        function long_to_date(l_second) {
            if (l_second > 0) {
                l_second = l_second / 1000;
                var second = 0, minute = 0, hour = 0, day = 0;
                minute = parseInt(l_second / 60); //算出一共有多少分钟
                second = parseInt(l_second % 60);//算出有多少秒
                if (minute > 60) { //如果分钟大于60，计算出小时和分钟
                    hour = parseInt(minute / 60);
                    minute %= 60;//算出有多分钟
                }
                if (hour > 24) {//如果小时大于24，计算出天和小时
                    day = parseInt(hour / 24);
                    hour %= 24;//算出有多分钟
                }
            }
            var ts = "<span class=\"big-time\">" + day + "</span><span>天</span><span class=\"big-time\">" + hour + "</span><span>时</span>";
            ts += "<span class=\"big-time\">" + minute + "</span><span>分</span><span class=\"big-time\">" + second + "</span><span>秒</span>";
            return ts;
        }

        var bms = '${news.gonggaofromdate.time}';
        var bme = '${news.gonggaotodate.time}';

        function update_time() {
            var now = new Date().getTime();
            var t_value = "";
            if (now > bms) {//报名未开始
                t_value = "<i class='glyphicon glyphicon-time mr10 f16'></i><span style=\"width: 70px;\">距报名开始</span>";
                t_value += long_to_date(now - bms);
            }
            if (bms < now && now < bme) {//报名中
                t_value = "<i class='glyphicon glyphicon-time mr10 f16'></i><span style=\"width: 70px;\">距报名结束</span>";
                t_value += long_to_date(bme - now);
            }
            if (now > bme) {//报名已经结束
                t_value = "<span style=\"width: 70px;\">${news.status_name}</span>";
            }
            if ('${news.status}' == '6') {
                t_value = "<span style=\"width: 70px;\">已成交</span>";
            }
            if ('${news.status}' == '0') {
                t_value = "<span style=\"width: 70px;\">未开始</span>";
            }
            $(".detail-head-time").html(t_value);
        }

        setInterval(update_time, 1000);
        $("#share-pop_a").click(function(){
            $("#share-pop").toggle();
        });
        $("#share-pop_close").click(function(){
            $("#share-pop").hide();
        });

        $("#download").click(function(){
            var title='${news.title}';
            var content='';
            <%--var d3='${mediainfo.d3}';--%>
//            if (typeof d3 !=='undefined' && d3 !='' ){
//                content=d3;
//            }else{
            var basepath='<%=basePath%>';
            var infoid='${news.infoid}';
            content=basepath+'infodetail?infoid='+infoid;
//            }

            var form=$("<form></form>");//定义一个form表单
            form.attr("style","display:none");
            form.attr("target","");
            form.attr("method","post");
            form.attr("action","<%=basePath%>DownloadQRCode");
            var contentinput=$("<input type='hidden' name='content'/>");
            contentinput.attr("value",content);
            var titleinput=$("<input type='hidden' name='title'/>");
            titleinput.attr("value",title);
            var infoidinput=$("<input type='hidden' name='infoid'/>");
            infoidinput.attr("value",'${news.infoid}');

            $("body").append(form);//将表单放置在web中
            form.append(contentinput);
            form.append(titleinput);
            form.append(infoidinput);
            form.submit();//表单提交
            form.remove();
        });
    })
    function back() {
        window.location.href = document.referrer;
    }
</script>
<body>

<div class="detail-head ">
    <a href="javascript:void(0);" class="detail-ico-back left" onclick="window.history.back(-1);return false;"><i
            class="iconfont icon-xiayibu"></i></a>
    <%--<div class="detail-head-time"><i class="glyphicon glyphicon-time mr10 f16"></i>距报名结束6天22时33分30秒</div>--%>
    <div class="detail-head-time active"></div>
    <!-- 轮播效果 B -->

    <script src="m/js/jquery.hammer.min.js"></script>
    <div class="container ">
        <div id="carousel-example-generic" class="carousel slide">
            <!-- 轮播（Carousel）指标 -->
            <!-- 轮播（Carousel）项目 -->
            <div class="carousel-inner swipeleft">
                <c:if test="${news.picList.size()!=0}">
                <c:forEach items="${news.picList}" var="pic" varStatus="zt">
                <c:if test="${zt.count==1}">
                <div class="item active">
                    </c:if>
                    <c:if test="${zt.count!=1}">
                    <div class="item ">
                        </c:if>
                        <img src="http://www.e-jy.com.cn/${pic.path}" width="100%"></div>
                    </c:forEach>
                    </c:if>
                    <c:if test="${news.picList.size()==0 || empty news.picList.size()}">
                        <div class="item active ">
                            <img src="http://www.e-jy.com.cn/${news.titlepic}" width="100%">
                        </div>
                        <%--<div class="item ">--%>
                        <%--<img src="http://www.e-jy.com.cn/${news.titlepic}" width="100%">--%>
                        <%--</div>--%>
                    </c:if>
                </div>
                <!-- 轮播（Carousel）导航 -->
            </div>
        </div>
    </div>
    <!-- 轮播效果 E -->
    <div class="bgff clearfix">
        <div class="pd10">
            <div class="detail-title">${news.title}</div>
            <div class="detail-jg ovh">
              <span>挂牌价:
                <b style="color: #dd352c; font-size: 20px;">
                <c:if test="${news.ispllr=='1'}">详见交易公告</c:if>
                <c:if test="${news.ispllr!='1'}">￥${news.guapaiprice}元</c:if>
                </b>
                </span><br/>
                <span>保证金:
                <b style="color: #dd352c; font-size: 20px;">
                <c:if test="${news.ispllr=='1'}">详见交易公告</c:if>
                <c:if test="${news.ispllr!='1'}">￥${news.baozhengjprice}元</c:if>
                </b>
                </span>
                <span class="fr f14 fc99 mt15"><i class="glyphicon glyphicon-eye-open"></i>&nbsp;${news.click}人</span>
            </div>
            <div class="recharge-cz detail-customer">
                <c:choose>
                    <c:when test="${news.xiaQuCode == '101023' || news.xiaQuCode == '101024'}">
                        <dl>
                            <dt><span class="fc66">报名开始时间：</span></dt>
                            <dd><span class="fc99"><fmt:formatDate value="${news.gonggaofromdate }" type="date" dateStyle="medium" pattern="yyyy-MM-dd"/></span></dd>
                        </dl>
                        <dl>
                            <dt><span class="fc66">报名结束时间：</span></dt>
                            <dd><span class="fc99"><fmt:formatDate value="${news.gonggaotodate }" type="date" dateStyle="medium" pattern="yyyy-MM-dd"/>	</span></dd>
                        </dl>
                    </c:when>
                    <c:otherwise>
                        <dl>
                            <dt><span class="fc66">报名开始时间：</span></dt>
                            <dd><span class="fc99">${news.gonggaofromdate_str}</span></dd>
                        </dl>
                        <dl>
                            <dt><span class="fc66">报名结束时间：</span></dt>
                            <dd><span class="fc99">${news.gonggaotodate_str}</span></dd>
                        </dl>
                    </c:otherwise>
                </c:choose>
                <dl>
                    <dt><span class="fc66">项目编号：</span></dt>
                    <dd><span class="fc99">${news.project_no}</span></dd>
                </dl>
                <dl>
                    <dt><span class="fc66">竞买公告：</span></dt>
                    <dd><a href="jyggcontent?infoid=${news.infoid}" class="fc2a" target="_blank">[点击查看竞买公告]</a></dd>
                </dl>
                <dl>
                    <dt><span class="fc66">交易结果公示：</span></dt>
                    <dd><a href="jyggcontent?infoid=${cjgg_guid}&result=1" class="fc2a" target="_blank">[点击查看交易结果公示]</a></dd>
                </dl>
                <dl>
                    <dt><span class="fc66"  style="cursor: pointer">分享二维码：</span></dt>
                    <dd><span class="fc2a" id="share-pop_a">[点击查看分享]</span></dd>
                </dl>
                <div class="share-pop" id="share-pop" style="display: none">
                    <div class="box clearfix">
                        <div class="smc clearfix">
                            <div class="qr-code">
                                <%--<c:choose>--%>
                                <%--<c:when testWebService="${mediainfo.d3 != null && mediainfo.d3 != ''}"><!--全景不为空,二维码中写入全景地址-->--%>
                                <%--<img src="http://qr.topscan.com/api.php?text=${mediainfo.d3}&w=120&m=5" width="120" height="120" class="dsb"/>--%>
                                <%--</c:when>--%>
                                <%--<c:otherwise>--%>
                                <img src="http://qr.topscan.com/api.php?text=<%=basePath%>infodetail?infoid=${news.infoid}&w=120&m=5" width="120" height="120" class="dsb"/>
                                <%--</c:otherwise>--%>
                                <%--</c:choose>--%>
                            </div>
                            <div class="text">${news.title}</div>
                        </div>
                        <div class="smb clearfix">
                            <!-- JiaThis Button BEGIN -->
                            <div class="jiathis_style_32x32 ">
                                <a class="jiathis_button_weixin fx-btn" style="background:url(m/images/fx-ico-1.png) no-repeat center top;"></a>
                                <a class="jiathis_button_cqq fx-btn" style="background:url(m/images/fx-ico-3.png) no-repeat center top;"></a>
                                <a class="jiathis_button_tsina fx-btn" style="background:url(m/images/fx-ico-2.png) no-repeat center top;"></a>
                                <a class=" fx-btn" style="background:url(m/images/fx-ico-4.png) no-repeat center top;cursor: pointer" id="download" ></a>
                            </div>
                            <script type="text/javascript" >
                                var jiathis_config={
                                    sm:"weixin,cqq,tsina",
                                    summary:"",
                                    shortUrl:false,
                                    hideMore:false
                                }
                            </script>
                            <script type="text/javascript" src="http://v3.jiathis.com/code_mini/jia.js" charset="utf-8"></script>
                            <!-- JiaThis Button END -->

                        </div>
                        <div class="ta-c"><img src="m/images/erweima-tg.png" alt="" /></div>
                    </div>
                    <b id="share-pop_close">X</b>

                </div>
            </div>
        </div>
    </div>
    <div class="mt10 bgff">

        <ul class="deatil-tabs clearfix">
            <li class="cur">重要披露事项</li>


            <li class="">竞买记录<% if(size!="") out.println("(<span style=\"color: #C00;\">"+size+"</span>)"); %></li>
        </ul>
        <div class="deatil-tabs-height" style="display: none;"></div>


        <div class="recharge-cz detail-customer tab_con" style="display: block;width: 100%">
        <%--<div class="clearfix tab_con pd10" style="display: block;width: 100%">--%>
            <dl>
                <dt><span class="fc66">受让方资格条件</span></dt>
                <dd><span class="fc99">${news.zgtj}(以公告内容为准)</span></dd>
            </dl>
            <c:if test="${news.systemtype ne 'ZZKG'}">
            <dl>
                <dt><span class="fc66">与转让相关其他条件</span></dt>
                <dd><span class="fc99">${news.zhuanrangftj}(以公告内容为准)</span></dd>
            </dl>
            </c:if>
            <dl>
                <dt><span class="fc66">重大事项披露</span></dt>
                <dd><span class="fc99">${news.zhongdcontent}(以公告内容为准)</span></dd>
            </dl>
            <dl>
                <dt><span class="fc66">权利人是否行使优先购买权</span></dt>
                <dd><span class="fc99">      <c:choose>
                    <c:when test="${news.haspriority eq'1'}">
                        是
                    </c:when>
                    <c:otherwise>
                        否
                    </c:otherwise>
                </c:choose></span></dd>
            </dl>
        </div>

        <div class="clearfix tab_con" style="display: none;">
            <div class="pd10 f12 lh24 ta-c">
                <table class="table ">
                    <thead>
                    <tr>
                        <th class="ta-c">竞买人编号</th>
                        <c:if test="${news.currencyunit ne '2'}">
                            <th class="ta-c">价格(元)</th>
                        </c:if>
                        <c:if test="${news.currencyunit eq '2'}">
                            <th class="ta-c">价格(万元)</th>
                        </c:if>
                        <th class="ta-c">时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${his ==null || fn:length(his) ==0}">
                            <tr>
                                <td colspan="3" style="color: red;text-align: left;">暂无竞价</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${his }" var="obj" varStatus="jh">
                                <tr style="font-size: 11px;">
                                    <%--已成交的编号和价格都显示--%>

                                        <td width="100px" class="tr-end orange">${obj.code }</td>
                                        <td width="100px" class="tr-end orange">${obj.price }</td>
                                        <td class="tr-end orange">${obj.bj_time }</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="h50 mt10">
        <div class="base-footer">
            <div class="detail-enroll" style="margin-left: 0px;">
                <div class="c5-1">
                    <a style="color: #fff;" id='${news.project_no }'
                       class='ejy_huiyuan_bm active'>${news.status_name}<br>
                        成交价:${ChengJiaoPrice}元
                        <%--<c:choose>--%>
                            <%--&lt;%&ndash;只有股权才有二次竞价&ndash;%&gt;--%>
                            <%--<c:when testWebService="${not empty his}">--%>
                                <%--${his.get(0).price}元--%>
                            <%--</c:when>--%>
                            <%--<c:otherwise>--%>
                                <%--${news.currentprice}元--%>
                            <%--</c:otherwise>--%>
                        <%--</c:choose>--%>

                    </a>

                </div>
            </div>
        </div>
    </div>
</body>

</html>
