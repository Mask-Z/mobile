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
    <script type="text/javascript" src="m/js/DateOp.js"></script>
    <script type="text/javascript" src="m/ext/jjdt_more.js"></script>
</head>

<body>
<header class="h43">
    <div class="index-header">
        <a href="index" class="back" ></a>
        <div class="title">竞价大厅</div>
        <a href="javascript:showRule1();" class="h-r"><i class="glyphicon glyphicon-filter"></i></a>
    </div>
</header>
<div class="container ">
    <div class="h40"></div>
    <div class="base-bidding-head">
        <span class="item cqjy" >产权交易</span>
        <span class="curr item">招标采购</span>
    </div>
    <div class="base-bidding-box bgff" style="display: none;">
        <div class="table-view cqjy">
            <ul class="cart-table-view clearfix favorite">
            </ul>
        </div>
    </div>
    <div class="base-bidding-box bgff" style="display: block;">
        <div class="table-view index-news">
            <ul class="cart-table-view clearfix zbcg">
            </ul>
        </div>
    </div>
</div>
<div class="visit-type js-visit-recommend">
    <div class="box">
        <div class="recharge-cz">
            <h3 class="bd_b f16 pb10 mb10 clearfix lh24"><a href="javascript:closeRule1();" class="fr "><i
                    class="fc99 f24 iconfont icon-error"></i></a>筛选</h3>
            <form id="jjdt_search" class="jjdt_search" action="zbcg_jjdt" method="get">
                <dl>
                    <dd>
                        <span class="mb5 dsb">标的名称</span>
                        <input class="form-control input input-sm" id="keytext" name="biaodiname" value="${biaodiname}"
                               type="text">
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">机构名称</span>
                        <select name="orgid" class="form-control input input-sm">
                            <option value="" <c:if test="${empty orgid}">selected</c:if>>全部</option>
                            <c:forEach items="${cityinfo}" var="org">
                                <option value="${org.code}"
                                        <c:if test="${orgid==org.code}">selected</c:if> />
                                ${org.name}
                                </option>
                            </c:forEach>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">项目类型</span>
                        <select class="form-control input input-sm " name="type" id="pro_type">
                            <option value=""
                                    <c:if test="${empty type}">selected</c:if> >全部
                            </option>
                            <option value="B"
                                    <c:if test="${type=='B'}">selected</c:if> />
                            工程</option>
                            <option value="A"
                                    <c:if test="${type=='A'}">selected</c:if> />
                            货物</option>
                            <option value="C"
                                    <c:if test="${type=='C'}">selected</c:if> />
                            服务</option>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">项目状态</span>
                        <select class="form-control input input-sm " name="status" id="status">
                            <option selected="selected" value=""
                                    <c:if test="${empty status}">selected</c:if> >全部
                            </option>
                            <option value="未开始"
                                    <c:if test="${status=='未开始'}">selected</c:if> >未开始
                            </option>
                            <option value="报价中"
                                    <c:if test="${status=='报价中'}">selected</c:if> >报价中
                            </option>
                            <option value="已结束"
                                    <c:if test="${status=='已结束'}">selected</c:if> >已结束
                            </option>
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
</body>
<script>
    $(function () {

        var currentPage = 0;
        // 每页展示5个
        var rows = 15;
        // dropload
        $('.index-news').dropload({
            scrollArea: window,
            loadDownFn: function (me) {
                currentPage++;
                var params = $("form.jjdt_search").serialize();
                // 拼接HTML
                var result = '';
                $.ajax({
                    type: 'GET',
                    url: '<%=basePath%>jjdt_zbcg_more_data?currentPage=' + currentPage + '&rows=' + rows + '&' + params,
                    dataType: 'json',
                    success: function (data) {
                        var arrLen = data.length;
                        if (arrLen > 0) {
                            for (var i = 0; i < arrLen; i++) {
//                                result += '<li><a href="newsinfo?infoid=' + data[i].infoid + '">' + data[i].title + '</a></li>';

                                var nowMs = Date.parse(new Date());
                                var endTimeMs = data[i].jingjia_end;
                                var obj_endTime;
                                //刷新剩余时间：
                                if (endTimeMs < nowMs) {
                                    obj_endTime = "已结束";
                                }else if (typeof(endTimeMs)=="undefined"){
                                    obj_endTime = "报价中";
                                } else {
                                    obj_endTime = '<i class="glyphicon glyphicon-time"></i>&nbsp;'+DateOp.formatMsToStr(endTimeMs - nowMs);
                                }


                                var  obj_price;
                                if (data[i].zgj==="-"){
                                    obj_price='<span>￥<b>' + data[i].zgj + '</b>元</span>';
                                }else{
                                    obj_price='<span class="price">￥<b>' + data[i].zgj + '</b>元 </span>';
                                }

                                result += '<li><input type="hidden" name="biaoDiNOs" value="' + data[i].projectnum + '" /><div class="right_text">' +
                                    '<p class="sub_tit"><a href="newsinfo?infoid=' + data[i].infoid + '">' + data[i].title + '</a></p>' +obj_price+
                                    '<span class="type" id="endTime_' + data[i].jingjia_end + '">' + obj_endTime + '</span> </div></li>';
//                                       '+<span  id="bmbtn_'+subject.biaodino+'"><font id="bmbtn_span1_'+subject.biaodino+'" class="button" style="background-color:#ccc;color:#fff;display: none;"></font>'+
//                                       '<span  id="bmbtn_'+subject.biaodino+'">'+
//                                        '<font id="bmbtn_span2_'+subject.biaodino+'" class="button" style="background-color:#ccc;color:#fff;"><a id="'+subject.biaodino+'" class="ejy_huiyuan_bm"></a></font></span>';
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
                            $('.clearfix.zbcg').append(result);
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

    $('.btn.btn-success').on('click', function () {
        closeRule1();
        $('form.jjdt_search').submit();
    });

    $('.item.cqjy').on('click',function () {
        //跳转页面
        window.location.href="jjdt_more";
    })


</script>
</html>
