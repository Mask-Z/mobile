﻿<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

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

<body>
<header class="h43">
    <div class="index-header">
        <a href="" class="back" onclick="window.history.back(-1);return false;"></a>
        <div class="title">  <c:if test="${empty result}">交易公告</c:if>
            <c:if test="${not empty result}">交易结果公示</c:if>
        </div>
    </div>
</header>
<div class="base-bidding-box bgff" style="display: block;">
    <div class="new-list-info">
        <h1>${news.title }</h1>
        <c:if test="${empty result}">
            <div class="remarks clearfix ta-c"><span class=" fc99 f12">发布时间&nbsp;${news.fabudate }&nbsp;&nbsp;&nbsp;&nbsp;${news.click }次阅读</span></div>
        </c:if>
        <c:if test="${not empty result}">
            <div class="remarks clearfix ta-c"><span class=" fc99 f12">发布时间&nbsp;${news.chengjiaodate }&nbsp;&nbsp;&nbsp;&nbsp;${news.click }次阅读</span></div>
        </c:if>

        <div class="info">
        <div style="overflow-x: auto;">
            ${con}
        </div>
        </div>
    </div>
</div>

</body>

</html>
