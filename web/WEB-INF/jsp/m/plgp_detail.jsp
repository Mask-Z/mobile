<%@ page import="com.ccjt.ejy.web.vo.GongGao" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Date" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
<jsp:include page="mate.jsp"></jsp:include>
    <title>E交易</title>
    <link rel="stylesheet" href="m/css/bootstrap.min.css">
    <link rel="stylesheet" href="m/css/iconfont.css">
    <link rel="stylesheet" href="m/css/index.css">
    <link rel="stylesheet" type="text/css" href="m/weui/weui.css">
    <script src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="m/js/iconfont.js"></script>
    <script src="m/js/bootstrap.min.js"></script>
    <script src="m/js/index.js"></script>
    <script src="js/pj_baoming.js"></script>


</head>
<script>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
        Date nowDate = new Date();
        request.setAttribute("nowDate", nowDate);
        List<GongGao> zzList=(List<GongGao>) request.getAttribute("zzList");
        List<GongGao> cxgpList = (List<GongGao>) request.getAttribute("cxgpList");
        List<GongGao> zjList = (List<GongGao>) request.getAttribute("zjList");
        GongGao zzgg=null;
        GongGao cxgpgg=null;
        GongGao zjgg=null;
        if (null!=zzList && zzList.size()>0){
            zzgg=zzList.get(0);
        }
        if (null!=cxgpList && cxgpList.size()>0){
            cxgpgg=cxgpList.get(0);
        }
        if (null!=zjList && zjList.size()>0){
            zjgg=zjList.get(0);
        }
        request.setAttribute("zzgg",zzgg);
        request.setAttribute("cxgpgg",cxgpgg);
        request.setAttribute("zjgg",zjgg);

        //标的列表显示的数量
        int size=0;
        Object obj = request.getAttribute("projectList");
        if(obj!=null){
        List list = (List)obj;
        size = list.size();
    }
    %>
    $(function () {


        /**
         * 获取批量挂牌的各个项目的状态
         */
        var projectList='${projectListJson}';
        var projectListJson = JSON.parse(projectList);
//        console.log("projectListJson: "+projectListJson+"  length: "+projectListJson.length);
//        console.log("projectList: "+projectList);
        for (var i=0;i<projectListJson.length;i++){
            var projectGuid=projectListJson[i].ProjectGuid;
            $.ajax({
                url: 'getPLGPStatus?projectguid='+projectGuid,
                async:false,
                type: 'get',
                success: function (data) {
                    var e=data.code;
//                    console.log("projectGuid: "+projectGuid+"  code: "+e);
                    if (e == 1) {
                        $("#"+projectGuid).html("<a href='jyggcontent?infoid="+data.infoid+"' class='fc2a'>终结公告</a>");
                    }
                    if (e == 2) {
                        $("#"+projectGuid).html("<a href='jyggcontent?infoid="+data.infoid+"' class='fc2a'>中止公告</a>");
                    }
                    if (e == 3) {
                        $("#"+projectGuid).html("<a href='jyggcontent?infoid="+data.infoid+"' class='fc2a'>重新挂牌公告</a>");
                    }
                    if (e == 5) {

                        $("#"+projectGuid).html("已成交");
                    }
                    if (e == 7) {

                        $("#"+projectGuid).html("竞价中");
                    }
                    if (e == 8) {

                        $("#"+projectGuid).html("${news.status_name}");
                    }
                    if (e == 9) {

                        $("#"+projectGuid).html("竞价已截止");
                    }
                }
            })
        }
        <%--<%--%>
            <%--List<Map<String,Object>> projectList=(List<Map<String,Object>>) request.getAttribute("projectList");--%>
             <%--for (int i=0;i<projectList.size();i++){--%>
             <%--Map project=projectList.get(i);--%>
             <%--String projectGuid=(String) project.get("projectGuid");--%>
             <%--%>--%>
        <%--$.ajax({--%>
            <%--url: 'getPLGPStatus?projectguid=<%=projectGuid%>',--%>
            <%--type: 'get',--%>
            <%--success: function (data) {--%>
                <%--var projectGuid='<%=projectGuid%>';--%>
                <%--var e=data.code;--%>

                <%--if (e == 1) {--%>
                    <%--$("#"+projectGuid).html("<a href='jyggcontent?infoid="+data.infoid+"' class='fc2a'>终结公告</a>");--%>
                <%--}--%>
                <%--if (e == 2) {--%>
                    <%--$("#"+projectGuid).html("<a href='jyggcontent?infoid="+data.infoid+"' class='fc2a'>中止公告</a>");--%>
                <%--}--%>
                <%--if (e == 3) {--%>
                    <%--$("#"+projectGuid).html("<a href='jyggcontent?infoid="+data.infoid+"' class='fc2a'>重新挂牌公告</a>");--%>
                <%--}--%>
                <%--if (e == 5) {--%>

                    <%--$("#"+projectGuid).html("已成交");--%>
                <%--}--%>
                <%--if (e == 7) {--%>

                    <%--$("#"+projectGuid).html("竞价中");--%>
                <%--}--%>
                <%--if (e == 8) {--%>

                    <%--$("#"+projectGuid).html("${news.status_name}");--%>
                <%--}--%>
                <%--if (e == 9) {--%>

                    <%--$("#"+projectGuid).html("竞价已截止");--%>
                <%--}--%>
            <%--}--%>
        <%--})--%>
        <%--<%   }--%>
        <%--%>--%>


        /**
         * 根据<li>标签的个数设置宽度
         * @type {jQuery}
         */
        var len = $(".deatil-tabs li").length;
        var wid = 100 / len;
        $(".deatil-tabs li").width(wid + '%');

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
        console.log("本页面是: plgp_detail.jsp");
        console.log("gonggaostatue的值是: ${gonggaostatue }");
        console.log("couldSign的值是: ${empty BaoMingGuid and couldSign eq 'true'}");
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
            if (${news.status eq 6}) {
                t_value = "<span style=\"width: 70px;\">已成交</span>";
            }
            if (${news.status eq 0}) {
                t_value = "<span style=\"width: 70px;\">未开始</span>";
            }
            if (${news.status eq 5}) {
                t_value = "<span style=\"width: 70px;\">竞价已截止</span>";
            }
            if (${gonggaostatue==1 }) {
                t_value = "<span style=\"width: 70px;\">此项目已终结</span>" +
                    "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<a href='newsinfo?infoid=${zjgg.infoid}' class='fc2a' target='_blank'>[点击查看终结公告]</a>";
            }
            if (${gonggaostatue==2 }) {
                t_value = "<span style=\"width: 70px;\">此项目已中止</span>" +
                    "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<a href='newsinfo?infoid=${zzgg.infoid}' class='fc2a' target='_blank'>[点击查看中止公告]</a>";
            }
            <%--if (${news.status eq 9}) {--%>
                <%--t_value = "<span style=\"width: 70px;\">竞价暂停</span>";--%>
            <%--}--%>

            $(".detail-head-time").html(t_value);
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
        }

        setInterval(update_time, 1000);
    })
    function back() {
        window.location.href = document.referrer;
    }
</script>
<body>
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

<div class="detail-head">
    <a href="" class="detail-ico-back left" onclick="window.history.back(-1);return false;"><i
            class="iconfont icon-xiayibu"></i></a>
    <%--根据状态名称显示不同颜色--%>
    <c:choose>
    <%--<c:when testWebService="${news.status_name eq('报名中') && (empty gonggaostatue or gonggaostatue == 0)}">--%>
    <%--<c:when testWebService="${news.gonggaotodate.after(nowDate) and (empty gonggaostatue or (gonggaostatue != 1 and gonggaostatue !=2)) }">--%>
    <c:when test="${news.gonggaotodate.after(nowDate) and (empty gonggaostatue or (gonggaostatue != 1 and gonggaostatue !=2) and news.status ne 0 and news.status ne 5) }">
    <div class="detail-head-time"></div>
    </c:when>
    <c:otherwise>
    <div class="detail-head-time none"></div>
    </c:otherwise>
    </c:choose>

    <!-- 轮播效果 B -->
    <script src="m/js/jquery.hammer.min.js"></script>
    <div id="carousel-example-generic" class="carousel slide">
        <!-- 轮播（Carousel）指标 -->
        <%--<ol class="carousel-indicators">--%>
        <%--<li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>--%>
        <%--<li data-target="#carousel-example-generic" data-slide-to="1"></li>--%>
        <%--&lt;%&ndash;<li data-target="#carousel-example-generic" data-slide-to="2"></li>&ndash;%&gt;--%>
        <%--</ol>--%>
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
                <span class="fr f14 fc99 mt5"><i class="glyphicon glyphicon-eye-open"></i>&nbsp;${news.click}人</span>
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
            <%--<li class="cur" style="width: 50%">拍品描述</li>--%>
            <li class="cur">重要披露事项</li>
            <li class="">标的列表(<span style="color: #C00;"><%=size%></span>)</li>

        </ul>
        <div class="deatil-tabs-height" style="display:none ;"></div>

        <div class="recharge-cz detail-customer tab_con" style="display: block;">
            <%--<dl>--%>
            <%--<dt><span class="fc66">标的物介绍：</span></dt>--%>
            <%--<dd><span class="fc99">${news.description}(以公告内容为准)</span></dd>--%>
            <%--</dl>--%>
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

        <!-- -----------------------------------------批量挂牌------------------------------- -->
        <div class="clearfix tab_con" style="display: none;">
            <div class="pd10 f12 lh24 ta-c">
                <script type="text/javascript">
                    //竞价大厅列表
                    function jjdt_projectList() {
                        var $bidinfo = $("#jygg_news_detail_bidinfo");
                        var $projectList = $("#jygg_news_detail_table");
                        var size = $bidinfo.find("tr").size();
                        $bidinfo.find("tr").each(function (i, k) {
                            if (i != 0) {
                                $(this).remove();
                            }
                        });
                        $bidinfo.hide();
                        $projectList.show();
                    }

                    //竞价大厅详情
                    function jjdt_detail(dom, projectGuid) {
                        //测试数据，正式需要注释
                        //projectGuid ="bffc1f92-23b8-4d4c-a542-43f054000490";
                        //debugger;
                        var $dom = $(dom);
                        var $bidinfo = $("#jygg_news_detail_bidinfo");
                        var $projectList = $("#jygg_news_detail_table");
                        var $bidinfo_inser = $("#jygg_news_detail_title");
                        $.ajax({
                            url: 'jjdt_baojiahis',
                            type: 'post',
                            data: {"projectGuid": projectGuid},
                            dataType: 'json',
                            success: function (datas) {
                                var his = datas.his;
                                var baojiaHis = datas.baojiaHis;
                                var fangshi = datas.fangshi;//3 密封式报价
                                var status = datas.status;//标的当前状态 3=竞价截止
                                //-----------------刷新竞价历史
                                var bidinfo_html = "";
                                if (his != null && his.length > 0) {
                                    var obj;
                                    len=his.length;
                                    for (var i = 0; i < his.length; i++) {
                                        obj = his [i];
                                        bidinfo_html += '<tr style="font-size: 11px;">';
                                        bidinfo_html +='<td class="tr-end orange">'+len--+'</td>';
                                        if("3"===status){
                                            bidinfo_html +='<td class="tr-end orange">'+obj.code+'</td>';
                                            bidinfo_html +='<td class="tr-end orange">'+obj.price+'</td>';

                                        }else {//未截止
                                            if("3"===fangshi){//密封式
                                                bidinfo_html +='<td class="tr-end orange">*****</td>';
                                                bidinfo_html +='<td class="tr-end orange">*****</td>';
                                            }else{
                                                bidinfo_html +='<td class="tr-end orange">*****</td>';
                                                bidinfo_html +='<td class="tr-end orange">'+obj.price+'</td>';
                                            }
                                        }

                                        bidinfo_html +='<td class="tr-end orange">'+obj.bj_time+'</td>';
                                        bidinfo_html +='</tr>';
                                    }
                                } else {
                                    bidinfo_html += '<tr><td colspan="3" style="color: red;text-align: left;">暂无竞价！</td></tr>';
                                }
                                $bidinfo_inser.after(bidinfo_html);
                                //-----------------刷新竞价历史
                                $bidinfo.show();
                                $projectList.hide();
                            },
                            error: function (XMLHttpRequest, textStatus, errorThrown) {
                                //console.log("ajax error：" + XMLHttpRequest.status + "," + XMLHttpRequest.readyState);
                            }
                        });
                    }
                </script>


                <!-- 批量挂牌：标的列表 -->
                <table id="jygg_news_detail_table" class="table" >
                    <caption>
                        <div style="height: 40px;">
                            标的名称：<input id="keywords" type="text"
                                        style="border:1px #ddd solid; height: 25px;"/>
                            <input type="button" value="搜索" onclick="search()"
                                   style="background: #ff8300;padding: 0px 10px; color: #fff; height: 25px;"/>
                            <script type="text/javascript">
                                //搜索
                                function search() {<!-- 批量挂牌：标的列表 -->
                                    var keywords = $("#keywords").val();
                                    var object;
                                    var c = 0;
                                    $(".jygg_news_detail_tr").each(function (i, k) {
                                        object = $(this).find("td:first").attr("title");
                                        if (keywords == '') {
                                            c++;
                                            $(this).show();
                                        } else {
                                            if (object.indexOf(keywords) != -1) {
                                                c++;
                                                $(this).show();
                                            } else {
                                                $(this).hide();
                                            }
                                        }
                                        //
                                        if (c == 0) {
                                            $("#jygg_news_detail_none").show();
                                        } else {
                                            $("#jygg_news_detail_none").hide();
                                        }
                                    });
                                }
                            </script>
                        </div>
                    </caption>

                    <tr>
                        <th class="ta-c">标的名称</th>
                        <th class="ta-c">挂牌价(元)</th>
                        <th class="ta-c">当前价(元)</th>
                        <%--<th class="ta-c">增值率</th>--%>
                        <th class="ta-c">操作</th>
                        <th class="ta-c">状态</th>
                    </tr>
                    <tr id="jygg_news_detail_none" style="display: none;">
                        <td colspan="3" style="color: red;text-align: left;">暂无竞价</td>
                    </tr>
                    <%
                        Object plist = request.getAttribute("projectList");
                        if(plist!=null){
                            List list = (List)plist;
                            for(Object o : list){
                                Map jjdt = (Map)o;
                                out.println("<tr class=\"jygg_news_detail_tr\" style=\"font-size: 11px;\">");
                                out.println("<td  class=\"tr-end orange\">" + jjdt.get("ProjectName") + "</td>");
                                out.println("<td  class=\"tr-end orange\">" + jjdt.get("guapaiprice") + "</td>");
//                                String zzlS = "0";
                                if("1".equals(jjdt.get("hasbid").toString())){
                                    out.println("<td>" + jjdt.get("maxPrice") + "</td>");
//                                    Double gpj = Double.valueOf(jjdt.get("guapaiprice").toString());
//                                    Double dqj = Double.valueOf(jjdt.get("maxPrice").toString());
//                                    double g = gpj.doubleValue();
//                                    double d = dqj.doubleValue();
//                                    double zzl = (d-g)/g*100;
//                                    DecimalFormat df = new DecimalFormat("0.00");
//                                    zzlS = df.format(zzl);
                                }else{
                                    out.println("<td> - </td>");
                                }


//                                out.println("<td>"+zzlS+"%</td>");
                                out.println("<td class=\"tr-end orange\"><button class=\"new-jygg-btn\" onclick=\"jjdt_detail(this ,'" + jjdt.get("projectGuid") + "')\">竞价详情</button></td>");
                                out.println("<td class=\"tr-end orange\" id="+jjdt.get("projectGuid")+"></td>");
                                out.println("</tr>");

                            }
                        }
                    %>
                </table>


                <!-- 批量挂牌：竞价记录详情start -->
                <div id="jygg_news_detail_bidinfo" style="display: none;" class="pd10 f12 lh24 ta-c">
                    <!-- 批量挂牌：竞价历史 -->
                    <table class="table ">
                        <caption style="font-size:18px;font-weight:bold;">
                            <button onclick="jjdt_projectList()"
                                    style="font-size: 11px;margin-bottom: 2px;">返回标的列表
                            </button>&nbsp;&nbsp;
                        </caption>
                        <tbody>
                        <tr id="jygg_news_detail_title" class="tr1">
                            <td class="tr-end orange">序号</td>
                            <td class="tr-end orange">竞买人编号</td>
                            <td class="tr-end orange" nowrap="nowrap">
                                价格(${news.systemtype =='CCJT' || news.systemtype =='NMG' || news.systemtype =='ZZKG' ?"元" : "万元" })
                            </td>
                            <td align="center" class="tr-end orange"> 时间</td>
                        </tr>
                        </tbody>
                    </table>

                </div>
                <!-- 竞价记录详情end -->

            </div>
        </div>

    </div>

    <div class="h50 mt10">
        <div class="base-footer">

            <div class="detail-enroll" style="margin-left: 0px;">
                <c:if test="${gonggaostatue==1}">
                <div class="c5-11"><a style="color: #fff;" id="" class="ejy_huiyuan_bm none">此项目已终结,无法报名<br/>终结时间:${fn:substring(zjList.get(0).gonggaofromdate,0,19)}</a>
                    </c:if>
                    <c:if test="${gonggaostatue==2}">
                    <div class="c5-11"><a style="color: #fff;" id="" class="ejy_huiyuan_bm none">此项目已中止,暂时无法报名<br/>中止时间:${fn:substring(zzList.get(0).gonggaofromdate,0,19)}</a>
                        </c:if>

                            <%--<c:if testWebService="${empty gonggaostatue or gonggaostatue == 0}">--%>
                        <c:if test="${empty gonggaostatue or (gonggaostatue != 1 and gonggaostatue !=2)}">
                                <c:choose>
                                    <%--<c:when testWebService="${news.status==1 }">--%>
                                    <%--<c:when testWebService="${news.gonggaotodate.after(nowDate) and news.status ne 0}">--%>
                                    <c:when test="${news.gonggaotodate.after(nowDate) and (news.status eq 1 or news.status eq 4)}">
                                        <div class="c5-11">
                                            <a style="color: #fff;" id='${news.project_no }' class='ejy_huiyuan_bm'
                                                <%--只有infoid和systemtype存在的情况下才可以点击--%>
                                                    <c:if test="${not empty news.infoid and not empty news.systemtype}">
                                                        <c:choose>
                                                            <c:when test="${not empty news.zt}">
                                                                <c:if test="${ empty BaoMingGuid or BaoMingGuid eq ''}">
                                                                    onclick="bm_sub('${news.isOpen}','${news.zt}','ZT','','','1')"
                                                                </c:if>
                                                                <c:if test="${not empty BaoMingGuid}">
                                                                    onclick="bm_sub('${news.isOpen}','${news.zt}','ZT','${BaoMingGuid}','','3')"
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:if test="${news.ispllr=='1' and empty BaoMingGuid}"> href="pj_list_cqjy?ProjectRegGuid=${news.infoid}"</c:if>
                                                                <c:if test="${news.ispllr!='1' and empty BaoMingGuid}"> onclick="bm_sub('${news.isOpen}','${news.projectguid}','${news.systemtype}','','','1')" </c:if>
                                                                <c:if test="${not empty BaoMingGuid}"> onclick="bm_sub('${news.isOpen}','${news.projectguid}','${news.systemtype}','${BaoMingGuid}','','3')" </c:if>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if> >

                                                <c:if test="${not empty BaoMingGuid}">
                                                    已报名<br><i>保证金:<c:if test="${news.ispllr=='1'}">详见交易公告</c:if>
                                                    <c:if test="${news.ispllr!='1'}">￥${news.baozhengjprice}元</c:if></i>
                                                </c:if>

                                                <c:if test="${empty BaoMingGuid  }">
                                                    <c:choose>
                                                        <c:when test="${couldSign}">
                                                            去报名<br>
                                                            <i>保证金:
                                                            <c:if test="${news.ispllr=='1'}">详见交易公告</c:if>
                                                            <c:if test="${news.ispllr!='1'}">￥${news.baozhengjprice}元</c:if></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            该项目尚未组建专厅
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>

                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="c5-1">
                                            <c:if test="${news.status_name eq ('未开始')}">
                                                <a style="color: #fff;" id='${news.project_no }'
                                                   class='ejy_huiyuan_bm none'>${news.status_name}<br>
                                                    开始时间:${news.gonggaofromdate_str}
                                                </a>
                                            </c:if>
                                            <c:if test="${news.status_name ne ('未开始')}">
                                                <a style="color: #fff;" id='${news.project_no }'
                                                   class='ejy_huiyuan_bm none'>${news.status_name}
                                                </a>
                                            </c:if>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </div>
                    </div>
                </div>
</body>

</html>
