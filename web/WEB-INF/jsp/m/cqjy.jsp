﻿<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <div class="title">产权交易</div>
        <a href="javascript:showRule1();" class="h-r"><i class="glyphicon glyphicon-filter"></i></a>
    </div>
</header>
<div class="container ">
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
            <form id="jygg_more_form" action="jygg_more" method="get" >
                <dl>
                    <dd>
                        <span class="mb5 dsb">标的名称</span>
                        <input class="form-control input input-sm" id="title" name="title" type="text" value="${title}">
                    </dd>
                </dl>
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
                            <option value="矿权" <c:if test="${type=='矿权'}">selected</c:if>>矿权</option>
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
                                <option value="${city.name}"
                                        <c:if test="${area==city.name}">selected</c:if>>${city.name}</option>
                            </c:forEach>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">产权业务类型</span>
                        <select class="form-control input input-sm " name="cqywtype" id="cqywtype">
                            <option value=""
                                    <c:if test="${empty cqywtype}">selected</c:if> >全部
                            </option>
                            <option value="国有企业资产"
                                    <c:if test="${cqywtype=='国有企业资产'}">selected</c:if> >国有企业资产
                            </option>
                            <option value="金融企业资产"
                                    <c:if test="${cqywtype=='金融企业资产'}">selected</c:if> >金融企业资产
                            </option>
                            <option value="行政事业单位资产"
                                    <c:if test="${cqywtype=='行政事业单位资产'}">selected</c:if> >行政事业单位资产
                            </option>
                            <option value="涉诉资产"
                                    <c:if test="${cqywtype=='涉诉资产'}">selected</c:if> >涉诉资产
                            </option>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">项目状态</span>
                        <select class="form-control input input-sm " name="status" id="status">
                            <option value=""
                                    <c:if test="${empty status}">selected</c:if> >全部
                            </option>
                            <option value="未开始"
                                    <c:if test="${status=='未开始'}">selected</c:if> >未开始
                            </option>
                            <option value="正在报名"
                                    <c:if test="${status=='正在报名'}">selected</c:if> >正在报名
                            </option>
                            <option value="报名已截止"
                                    <c:if test="${status=='报名已截止'}">selected</c:if> >报名已截止
                            </option>
                            <option value="竞价中"
                                    <c:if test="${status=='竞价中'}">selected</c:if> >竞价中
                            </option>
                            <option value="竞价已截止"
                                    <c:if test="${status=='竞价已截止'}">selected</c:if> >竞价已截止
                            </option>
                            <option value="已成交"
                                    <c:if test="${status=='已成交'}">selected</c:if> >已成交
                            </option>
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
<footer class="base-footer-index">
    <div class="box">
        <a href="index" ><span class=" iconfont ">&#xe885;</span><br>首页</a>
        <a href="jygg_more" class="active"><span class=" iconfont ">&#xe679;</span><br>产权交易</a>
        <a href="zbcg_more"><span class=" iconfont ">&#xe67a;</span><br>招标采购</a>
        <a href="getUserInfo"><span class=" iconfont ">&#xe7eb;</span><br>个人信息</a>
    </div>
</footer>
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

        var title=$('#title').val();
        var cqywtype=$('#cqywtype').val();
        var type=$('#type').val();
        var status=$('#status').val();
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
                    url: '<%=basePath%>cqjy_data?currentPage=' + currentPage + '&rows=' + rows + '&categorynum=&cqywtype=' + cqywtype + '&order=&type=' + type + '&area=' + area + '&status=' + status + '&title='+title+'&xiaqu=',
                    dataType: 'json',
                    success: function (data) {
                        var arrLen = data.length;
                        if (arrLen > 0) {
                            for (var i = 0; i < arrLen; i++) {
                                var obj_status_name;
                                if (data[i].status_name==="报名中"||data[i].status_name==="竞价中"){
                                    obj_status_name='  <span class="Label" style="background-color: #f60">' + data[i].status_name + '</span>';
                                }else if (data[i].status_name==="已成交"){
                                    obj_status_name='  <span class="Label" style="background-color: #13a547">' + data[i].status_name + '</span>';
                                }else {
                                    obj_status_name='  <span class="Label" style="background-color: rgba(0, 0, 0, 0.4)">' + data[i].status_name + '</span>';
                                }
                                result += '  <li class="mask">' +
                                    '  <a href="infodetail?infoid=' + data[i].jygg_guid + '&categoryNum=' + data[i].categorynum + '" class="item-list">' +
                                    '  <img class="img" style=\"height: 125px\" src="http://www.e-jy.com.cn/' + data[i].titlepic + '">' +
                                    '  <div class="media-body">' +obj_status_name+
                                    '  <p class="tit"><b class="item">' + data[i].categoryname + '</b>' + data[i].title +
                                    '   </p> <p class="other-info">￥<b>';
                                if (data[i].projectnum != null && data[i].projectnum != "" && data[i].projectnum.startWith("CQJY")) {
                                    result += "详见交易公告</b></p> </div> </a> </li>";
                                } else if (data[i].systemtype == 'ZZKG') {
                                	result += "详见交易公告</b></p> </div> </a> </li>";
                                } else {
                                    result += data[i].guapaiprice + '元 </b></p> </div> </a> </li>';
                                }

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
        $('#jygg_more_form').submit();
    }
</script>
</html>
