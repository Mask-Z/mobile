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
        <div class="title">招标采购</div>
    </div>
</header>
<div class="container ">
    <div class="h40"></div>
    <div class="base-bidding-head">
        <span class="curr" onclick="getData('zbgg')">招标公告</span>
        <span onclick="getData('cjgg')">成交公告</span>
    </div>
    <div class="base-bidding-box bgff" style="display: block;">
        <div class="new-list index-news zbgg">
            <ul class="clearfix zbgg">
            </ul>
        </div>
    </div>
    <div class="base-bidding-box bgff" style="display: none;">
        <div class="new-list index-news cjgg">
            <ul class="clearfix cjgg">
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
    $(function(){
        // 页数
        var currentPage = 0;
        // 每页展示5个
        var rows = 8;
        var flag='zbgg';
        // dropload
        $('.new-list.'+flag).dropload({
            scrollArea : window,
            loadDownFn : function(me){
                currentPage++;
                // 拼接HTML
                var result = '';
                $.ajax({
                    type: 'GET',
                    url: '<%=basePath%>zbcg_data?currentPage='+currentPage+'&rows='+rows+'&flag='+flag,
                    dataType: 'json',
                    success: function(data){
                        var arrLen = data.length;
                        if(arrLen > 0){
                            for(var i=0; i<arrLen; i++){
                                result +=   '<li><a  href="newsinfo?infoid='+data[i].infoid+' " target="_blank"><span class="fr fc99 pl10">'
                                    +data[i].infodate+'</span><span class="">'+data[i].title
                                    +'</span></a></li>';
                            }
                            // 如果没有数据
                        }else{
                            // 锁定
                            me.lock();
                            // 无数据
                            me.noData();
                        }
                        // 为了测试，延迟1秒加载
                        setTimeout(function(){
                            // 插入数据到页面，放到最后面
                            $('.clearfix.'+flag).append(result);
                            // 每次数据插入，必须重置
                            me.resetload();
                        },100);
                    },
                    error: function(xhr, type){
                        // 即使加载出错，也得重置
                        me.resetload();
                    }
                });
            }
        });
    });
    function getData(data) {
        var flag=data;
        $(".dropload-down").remove();
        var p=$(".clearfix."+flag+" li").length;
        // 页数
        var currentPage = p;
        // 每页展示5个
        var rows = 8;
        // dropload
        $('.new-list.'+flag).dropload({
            scrollArea : window,
            loadDownFn : function(me){
                currentPage++;
                // 拼接HTML
                var result = '';
                $.ajax({
                    type: 'GET',
                    url: '<%=basePath%>zbcg_data?currentPage='+currentPage+'&rows='+rows+'&flag='+flag,
                    dataType: 'json',
                    success: function(data){
                        var arrLen = data.length;
                        if(arrLen > 0){
                            for(var i=0; i<arrLen; i++){
                                result +=   '<li><a  href=" newsinfo?infoid='+data[i].infoid+' " target="_blank"><span class="fr fc99 pl10">'
                                    +data[i].infodate+'</span><span class="">'+data[i].title
                                    +'</span></a></li>';
                            }
                            // 如果没有数据
                        }else{
                            $(".dropload-down").remove();
                            $('.new-list.'+flag).append('<div class="dropload-down"><div class="dropload-noData">暂无数据</div></div>');
                            // 锁定
                            me.lock();
                            // 无数据
                            me.noData();
                        }
                        // 为了测试，延迟1秒加载
                        setTimeout(function(){
                            // 插入数据到页面，放到最后面
                            $('.clearfix.'+flag).append(result);
                            // 每次数据插入，必须重置
                            me.resetload();
                        },100);
                    },
                    error: function(xhr, type){


                        // 即使加载出错，也得重置
                        me.resetload();
                    }
                });
            }
        });
    };
</script>
</html>
