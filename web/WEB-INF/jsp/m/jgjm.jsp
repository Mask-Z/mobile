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
        <div class="title">机构加盟</div>
    </div>
</header>
<div class="h40"></div>
<div class="base-bidding-head list-3">
    <span class="curr">加盟流程</span>
    <span>加盟优势</span>
    <span>加盟条件</span>
</div>
<div class="base-bidding-box bgff" style="display: block;">
    <div class="new-list-info">
        <div class=" lh30">
            ${con1}
        </div>
    </div>
</div>
<div class="base-bidding-box bgff" style="display: none;">
    <div class="new-list-info">
        <div class=" lh30">
            ${con2}
        </div>
    </div>
</div>
<div class="base-bidding-box bgff" style="display: none;">
    <div class="new-list-info ">
        <div class="lh30">
            ${con3}
        </div>
    </div>
</div>

</body>

</html>
