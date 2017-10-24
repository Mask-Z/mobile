﻿<%@ page import="com.ccjt.ejy.web.vo.GongGao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
    <script src="js/pj_baoming.js"></script>
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
        %>
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
<%
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
    <%--<c:when test="${news.status_name eq('报名中')&&(empty gonggaostatue or gonggaostatue == 0)}">--%>
    <%--<c:when test="${news.gonggaotodate.after(nowDate) and (empty gonggaostatue or (gonggaostatue != 1 and gonggaostatue !=2)) }">--%>
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
                <c:if test="${news.ispllr!='1'}">
                   <c:if test="${news.systemtype != 'ZZKG' }">￥${news.guapaiprice}元</c:if> 
                   <c:if test="${news.systemtype == 'ZZKG' }">￥${news.zzkg_guapaiprice }</c:if>
                </c:if>
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
                                <%--<c:when test="${mediainfo.d3 != null && mediainfo.d3 != ''}"><!--全景不为空,二维码中写入全景地址-->--%>
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
            <c:if test="${news.systemtype eq 'GQ'}">
                <li class="cur">标的企业信息</li>
            </c:if>
            <c:if test="${news.systemtype eq 'ZZKG'}">
                <li class="cur">增资企业信息</li>
            </c:if>
            <li class="">重要披露事项</li>
            <li class="">竞买记录<% if(size!="") out.println("(<span style=\"color: #C00;\">"+size+"</span>)"); %></li>

        </ul>
        <div class="deatil-tabs-height" style="display:none ;"></div>

        <div class="tab_con clearfix" style="display: block;">
            <div class="p" style="width:100%;margin:0px auto;">
                <style>
                    .base-detail-table {
                        border: solid 1px #add9c0;
                        width: 100%;
                        border-left: 1px #e5e5e5 solid;
                        border-top: 1px #e5e5e5 solid;
                        font-size: 14px;
                    }

                    .base-detail-table tr td {
                        border-right: 1px #e5e5e5 solid;
                        border-bottom: 1px #e5e5e5 solid;
                        padding: 10px;
                    }

                    .base-detail-table tr td.title {
                        background: #f1f1f1;
                        text-align: center;
                        width: 150px;
                    }
                </style>
                <c:if test="${news.systemtype eq 'ZZKG'}">
                    <table class="base-detail-table" border="0" bordercolor="black" cellspacing="0" cellpadding="0">
                        <%--<tr>--%>
                            <%--<td colspan="6" class="title" align="center"><h3>--%>
                                <%--增资企业信息--%>
                            <%--</h3></td>--%>
                        <%--</tr>--%>
                        <tr>
                            <td width="120" class="title">增资企业名称</td>
                            <td colspan="5">${qyxxlist.objectName}</td>
                        </tr>
                        <tr>
                            <td class="title">监管机构（部门）</td>
                            <td>${qyxxlist.monitorName_name}</td>
                        </tr>
                        <tr>
                            <td class="title" width="120">监管机构（部门）地区代码</td>
                            <td>${qyxxlist.monitorZone_name}</td>
                        </tr>
                        <tr>
                            <td class="title" width="120">批准单位</td>
                            <td>${qyxxlist.authorizeUnit}</td>
                        </tr>
                        <tr>
                            <td class="title">批准文件类型</td>
                            <td>${qyxxlist.authorizeFileType_name}</td>
                        </tr>
                        <tr>
                            <td class="title">批准文件名称</td>
                            <td>${qyxxlist.authorizeFileName}</td>
                        </tr>
                        <tr>
                            <td class="title">国家出资企业统一社会信用代码</td>
                            <td>${qyxxlist.HQCode}</td>
                        </tr>
                        <tr>
                            <td width="120" class="title">国家出资企业</td>
                            <td colspan="5">${qyxxlist.HQName}</td>
                        </tr>
                        <tr>
                            <td class="title">增资企业统一社会信用代码</td>
                            <td>${qyxxlist.objectCode}</td>
                        </tr>
                        <tr>
                            <td class="title">增资企业经营规模</td>
                            <td>${qyxxlist.managerScale_name}</td>
                        </tr>
                        <tr>
                            <td class="title">增资企业所在地区</td>
                            <td>${qyxxlist.zone_name}</td>
                        </tr>
                        <tr>
                            <td class="title">增资企业所属行业</td>
                            <td>${qyxxlist.industryCode_name}</td>
                        </tr>
                        <tr>
                            <td class="title">增资企业经济类型</td>
                            <td>${qyxxlist.economyType_name}</td>
                        </tr>
                        <tr>
                            <td class="title">增资企业企业类型</td>
                            <td>${qyxxlist.economyNature_name}</td>
                        </tr>
                        <tr>
                            <td class="title">增资企业职工人数</td>
                            <td>${qyxxlist.employeeQuantity}</td>
                        </tr>
                        <tr>
                            <td class="title">注册资本</td>
                            <td colspan="3">${qyxxlist.registeredCapital}</td>
                        </tr>
                        <tr>
                            <td class="title">主要业务、经营范围</td>
                            <td colspan="5">${qyxxlist.businessScope}</td>
                        </tr>
                    </table>
                </c:if>
                <c:if test="${news.systemtype eq 'GQ'}">
                    <table class="base-detail-table" border="0" bordercolor="black" cellspacing="0" cellpadding="0">
                        
                        <tr>
                            <td width="120" class="title">标的企业名称</td>
                            <td colspan="5">${qyxxlist.objectName}</td>
                        </tr>
                        <tr>
                            <td class="title">标的企业统一社会信用代码</td>
                            <td>${qyxxlist.objectCode}</td>
                        </tr>
                        <tr>
                            <td class="title" width="120">标的企业经营规模</td>
                            <td>${qyxxlist.managerScale}</td>
                        </tr>
                        <tr>
                            <td class="title" width="120">标的企业所在地区</td>
                            <td>${qyxxlist.Zone_name}</td>
                        </tr>
                        <tr>
                            <td class="title">标的企业所属行业</td>
                            <td>${qyxxlist.industryCode_name}</td>
                        </tr>
                        <tr>
                            <td class="title">标的企业经济类型</td>
                            <td>${qyxxlist.economyType_name}</td>
                        </tr>
                        <tr>
                            <td class="title">标的企业企业类型</td>
                            <td>${qyxxlist.economyNature_name}</td>
                        </tr>

                        <tr>
                            <td class="title">标的企业职工人数</td>
                            <td>${qyxxlist.employeeQuantity}</td>
                        </tr>
                        <tr>
                            <td class="title">注册资本</td>
                            <td>${qyxxlist.registeredCapital}</td>
                        </tr>
                        <tr>
                            <td width="120" class="title">主要业务、经营范围</td>
                            <td colspan="5">${qyxxlist.businessScope}</td>
                        </tr>
                        <tr>
                            <td class="title">本次拟转让产(股)权比例</td>
                            <td>${qyxxlist.sellPercent}</td>
                        </tr>
                        <tr>
                            <td class="title">本次拟转让股份数</td>
                            <td><c:if test="${qyxxlist.gf!='0'}">${qyxxlist.gf}</c:if></td>
                        </tr>
                        <tr>
                            <td class="title">决策文件类型</td>
                            <td>${qyxxlist.decisionFileType}</td>
                        </tr>
                    </table>
                </c:if>
            </div>
        </div>
        <div class="recharge-cz detail-customer tab_con" style="display: none;">
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

            <c:if test="${news.systemtype eq 'GQ'}">
                <dl>
                    <dt><span class="fc66">企业管理层是否参与受让</span></dt>
                    <dd><span class="fc99">      <c:choose>
                        <c:when test="${news.hasBuyIntent eq'1'}">
                            是
                        </c:when>
                        <c:otherwise>
                            否
                        </c:otherwise>
                    </c:choose></span></dd>
                </dl>
            </c:if>

            <c:if test="${news.systemtype eq 'ZZKG'}">
                <dl>
                    <dt><span class="fc66">企业管理层或员工是否有参与融资意向</span></dt>
                    <dd><span class="fc99">      <c:choose>
                        <c:when test="${news.hasInvestIntent eq'1'}">
                            是
                        </c:when>
                        <c:otherwise>
                            否
                        </c:otherwise>
                    </c:choose></span></dd>
                </dl>
            </c:if>


        </div>

        <div class="clearfix tab_con" style="display: none;">
            <!-- 竞价历史 -->
            <c:if test="${news.allowMoreJqxt=='1' }">
                <h3 class="clearfix pt10 pb10 ta-c">第一次竞价</h3>
            </c:if>
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

                                    <c:choose>
                                        <c:when test="${jinjia_1=='3' }"><!-- 竞价结束 -->

                                            <td width="100px" class="tr-end orange">${obj.code }</td>
                                            <td width="100px" class="tr-end orange">${obj.price }</td>

                                        </c:when>
                                        <c:otherwise><!-- 竞价未结束 -->

                                            <c:choose>
                                                <c:when test="${news.jingjiafangshi=='3'}"><!-- 密封式 -->
                                                    <td width="100px" class="tr-end orange">*****</td>
                                                    <td width="100px" class="tr-end orange">*****</td>
                                                </c:when>
                                                <c:otherwise><!-- 正常报价 -->
                                                    <td width="100px" class="tr-end orange">*****</td>
                                                    <td width="100px" class="tr-end orange">${obj.price }</td>
                                                </c:otherwise>
                                            </c:choose>

                                        </c:otherwise>
                                    </c:choose>

                                    <td class="tr-end orange">${obj.bj_time}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <%--二次竞价历史--%>
            <c:if test="${news.allowMoreJqxt=='1' }">
                <h3 class="clearfix pt10 pb10 ta-c">第二次竞价</h3>
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
                        <c:when test="${his_erci ==null || fn:length(his_erci) ==0}">
                            <tr>
                                <td colspan="3" style="color: red;text-align: left;">暂无竞价</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${his_erci }" var="obj" varStatus="jh">
                                <tr style="font-size: 11px;">

                                    <c:choose>
                                        <c:when test="${jinjia_2=='3' }"><!-- 竞价结束 -->

                                            <td width="100px" class="tr-end orange">${obj.code }</td>
                                            <td width="100px" class="tr-end orange">${obj.price }</td>
                                        </c:when>
                                        <c:otherwise><!-- 竞价未结束 -->
                                            <c:choose>
                                                <c:when test="${news.jingjiafangshi_1=='3'}"><!-- 密封式 -->
                                                    <td width="100px" class="tr-end orange">*****</td>
                                                    <td width="100px" class="tr-end orange">*****</td>
                                                </c:when>
                                                <c:otherwise><!-- 正常报价 -->
                                                    <td width="100px" class="tr-end orange">*****</td>
                                                    <td width="100px" class="tr-end orange">${obj.price }</td>
                                                </c:otherwise>
                                            </c:choose>

                                        </c:otherwise>
                                    </c:choose>

                                    <td class="tr-end orange">${obj.bj_time}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
            </c:if>
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

                            <c:if test="${empty gonggaostatue or (gonggaostatue != 1 and gonggaostatue !=2)}">
                                <c:choose>
                                    <%--<c:when test="${news.status==1 }">--%>
                                    <%--<c:when test="${news.gonggaotodate.after(nowDate) and news.status ne 0}">--%>
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
                                                    查看报名情况<br><i>保证金:<c:if test="${news.ispllr=='1'}">详见交易公告</c:if>
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
