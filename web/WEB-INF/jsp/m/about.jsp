<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
            <div class="title">关于我们</div>
        </div>
    </header>
    <div class="base-bidding-box bgff">
        <div class="new-list-info">
            ${gonggao.content }
        </div>
    </div>

</body>

</html>
