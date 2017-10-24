<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
        <div class="title">${type.name}</div>
    </div>
</header>
<div class="base-bidding-box bgff" style="display: block;">
    <div class="new-list-info">
        <h1>${news.title }</h1>
        <div class="remarks clearfix ta-c"><span class=" fc99 f12">发布时间&nbsp;${news.gonggaofromdate_str }&nbsp;&nbsp;&nbsp;&nbsp;${news.click }次阅读</span></div>
        <div class="info">
            ${con}
        </div>
    </div>
</div>

</body>

</html>
