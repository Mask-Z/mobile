<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<head>
<jsp:include page="mate.jsp"></jsp:include>
    <title>E交易</title>
    <link rel="stylesheet" href="<%=basePath%>m/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%=basePath%>m/css/iconfont.css">
    <link rel="stylesheet" href="<%=basePath%>m/css/index.css">
    <script src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="<%=basePath%>m/js/iconfont.js"></script>
    <script src="<%=basePath%>m/js/bootstrap.min.js"></script>
    <script src="<%=basePath%>m/js/index.js"></script>
</head>

<body>
<header class="h43">
    <div class="index-header">
        <a href="" class="back" onclick="window.history.back(-1);return false;"></a>
        <div class="title">融资贷款</div>
    </div>
</header>
<div class="h40"></div>
<div class="base-bidding-head list-4">
    <span class="curr">信用担保</span>
    <span>应收贷</span>
    <span>产权贷</span>
    <span>交E融</span>
</div>
<div class="base-bidding-box bgff" style="display: block;">
    <div class="new-list-info">
        ${xydb}
    </div>
</div>
<div class="base-bidding-box bgff" style="display: none;">
    <div class="new-list-info">
        ${ysd}
    </div>
</div>
<div class="base-bidding-box bgff" style="display: none;">
    <div class="new-list-info">
        ${cqd}
    </div>
</div>
<div class="base-bidding-box bgff" style="display: none;">
    <div class="new-list-info">
        ${jer}
    </div>
</div>
</body>

</html>
