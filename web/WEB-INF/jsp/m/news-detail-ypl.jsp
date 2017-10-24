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

<style>
    .liebiao .liebiao-neirong {
        background: #f6f6f6;
    }

    /*.ypl-detail-title{border-bottom:solid 1px #d6d6d6;;font-size: 14px;height: 40px;padding: 0px 15px;width: 1200px;margin:0px auto;margin-top:0px;}*/
    .ypl-detail-title {
        border-bottom: solid 1px #d6d6d6;;
        font-size: 14px;
        height: 40px;
        padding: 0px 15px;
        width: 100%;
        margin: 0px auto;
        margin-top: 0px;
    }

    .ypl-detail-title .item {
        float: left;
        height: 38px;
        line-height: 40px;
        padding: 0px 20px;
        cursor: pointer;
        border: solid 1px #f6f6f6;
    }

    .ypl-detail-title .item.curr {
        border: solid 1px #d6d6d6;
        border-bottom: 0px;
        background: #fff;
        color: #de332c;
        font-weight: bold;
        height: 40px;
    }

    .ypl-detail-box {
        padding: 15px;
        background: #fff;
        min-height: 330px;
    }

    /*2*/
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
<body>
<header class="h43">
    <div class="index-header">
        <a href="" class="back" onclick="window.history.back(-1);return false;"></a>
        <div class="title">${type.name}</div>
    </div>
</header>
<div class="base-bidding-box bgff" style="display: block;">

    <div class="liebiao-neirong">
        <div class="ypl-detail-title">
        	<c:if test="${qyxxlist!=null }">
            <span class="item curr">标的企业信息</span>
			</c:if>            
            <span class="item">预披露详情</span>
        </div>
        <c:if test="${qyxxlist!=null }">
        <div class="ypl-detail-box" style="display:block;">
            <table class="base-detail-table" border="0" bordercolor="black" cellspacing="0" cellpadding="0">
               
                <tr>
                    <td class="title">标的企业名称</td>
                    <td>${qyxxlist.objectName}</td>
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
                    <td class="title">标的企业所需行业</td>
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
                    <td class="title">主要业务、经营范围</td>
                    <td>${qyxxlist.businessScope}</td>
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
        </div>
		</c:if>
        <div class="ypl-detail-box" id ="dddddd" <c:if test="${qyxxlist!=null }">style="display:none;"</c:if> >
             
            <div class="new-list-info">
                <h1>${news.title }</h1>
                <div class="remarks clearfix ta-c"><span class=" fc99 f12">发布时间&nbsp;${news.infodate }&nbsp;&nbsp;&nbsp;&nbsp;${news.click }次阅读</span></div>
                <div class="info">
                    ${con }
                </div>
            </div>
        </div>

    </div>
</div>
<script>
    $(function () {
        $(".ypl-detail-title .item").click(function () {
            $(this).addClass("curr").siblings().removeClass("curr");
            $(".ypl-detail-box").hide().eq($(this).index()).show()
        });
        
        <c:if test="${qyxxlist==null }">
        $(".ypl-detail-title .item").click();
        </c:if>
    })
</script>
</body>

</html>
