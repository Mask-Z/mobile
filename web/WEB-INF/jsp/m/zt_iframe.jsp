<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<jsp:include page="mate.jsp"></jsp:include>

</head>
<script>
    function queryData(page){
        var url='iframeData?ZhuanTingGuid=${ZhuanTingGuid}';
        if(page!=null){
            url+='&page='+page;
        }
        window.open(url,"_self");
    }
    function gotoPage(){
        var page=document.getElementById('kkpager_btn_go_input').value;
        page=parseInt(page);
        var tPage=parseInt('${totalPage}');
        if(page<=0){
            queryData(1);
        }else if(page>tPage){
            queryData(tPage);
        }else{
            queryData(page);
        }
    }
</script>
<style>
    .kkpager{
        clear:both;
        height:50px;
        line-height:30px;
        margin:0px auto 10px;
        text-align: center;
        font-size:14px;
    }
    .kkpager a{
        padding:6px 12px;
        margin:10px 3px;
        font-size:14px;
        border:1px solid #e6e6e6;
        background-color:#FFF;
        text-decoration:none;
        outline: none;
    }
    .kkpager span{
        font-size:14px;
    }
    .kkpager span.disabled{
        padding:6px 12px;
        margin:10px 3px;
        font-size:14px;
        border:1px solid #e6e6e6;
        background-color:#FFF;
    }
    .kkpager span.curr{
        padding:6px 12px;
        margin:10px 3px;
        font-size:14px;
        border:1px solid #dd342c;
        background-color:#dd342c;
        color:#FFF;
    }
    .kkpager a:hover{
        border:1px solid #dd342c;
    }
    .kkpager span.normalsize{
        font-size:14px;
    }
    #kkpager_gopage_wrap{
        display:inline-block;
        width:40px;
        height:31px;
        border:1px solid #e6e6e6;
        margin:0px 1px;
        padding:0px;
        position:relative;
        left:0px;
        top:13px;
    }
    #kkpager_btn_go {
        width:40px;
        height:31px;
        line-height:31px;
        padding:0px;
        font-family:"Microsoft Yahei",arial,sans-serif;
        text-align:center;
        border:0px;
        background-color:#bbb;
        color:#FFF;
        position:absolute;
        left:61px;
        top:0px;
        display:block;
    }
    #kkpager_btn_go:hover{background:#dd342c;cursor: pointer;}
    #kkpager_btn_go_input{
        width:40px;
        height:31px;
        text-align:center;
        border:0px;
        position:absolute;
        left:0px;
        top:0px;
        outline:none;
    }
</style>
<body>
<%--<div class="weui-cells" >--%>
    <style>

        .base-table-001{border-left:1px #e6e6e6 solid;border-top:1px #e6e6e6 solid;}
        .base-table-001 tr td{border-right:1px #e6e6e6 solid;border-bottom:1px #e6e6e6 solid; padding:5px 8px;text-align: center;}
    </style>
    <div style="overflow-x: auto;">
        <table class="table base-table-001" width="100%" style="white-space:nowrap; ">
            <tbody>
            <tr>
                <td height="30">序号</td>
                <td>标的编号</td>
                <td>标的名称</td>
                <td>竞价会开始时间</td>
                <td>竞价会结束时间</td>
                <td>保证金(元)</td>
                <td>挂牌价(元)</td>
                <td>公告</td>
            </tr>
            <c:forEach items="${data.BiaoDiList}" var="BiaoDiList" >
                <tr class="ios_menu" >
                    <td height="30">${BiaoDiList.RowNo }</td>
                    <td>${BiaoDiList.ProjectNo}</td>
                    <td>${BiaoDiList.ProjectName}</td>
                    <td>${BiaoDiList.JJBeginTime }</td>
                    <td>${BiaoDiList.JJEndTime }</td>
                    <td>${BiaoDiList.BZJPrice }</td>
                    <td>${BiaoDiList.GuaPaiPrice }</td>
                    <td> <a href="infodetail?infoid=${BiaoDiList.infoId }" target="_blank">查看公告</a> </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<div id="kkpager" class="kkpager" style="display: block;">
    <div class="clearfix mt15">
      <span class="pageBtnWrap">
	      <c:if test="${page>1}">
              <a href="javascript:;" onclick="queryData(${page-1})" title="上一页">上一页</a>
          </c:if>
		  <c:if test="${page-3 gt 0}">
              <a href="javascript:;" onclick="queryData(${page-3})">${page-3}</a>
          </c:if>
		  <c:if test="${page-2 gt 0}">
              <a href="javascript:;" onclick="queryData(${page-2})">${page-2}</a>
          </c:if>
		  <c:if test="${page-1 gt 0}">
              <a href="javascript:;" onclick="queryData(${page-1})">${page-1}</a>
          </c:if>
		  <span class="curr">${page}</span>
		  <c:if test="${page+1 lt totalPage}">
              <a href="javascript:;" onclick="queryData(${page+1})">${page+1}</a>
          </c:if>
		  <c:if test="${page+2 lt totalPage}">
              <a href="javascript:;" onclick="queryData(${page+2})">${page+2}</a>
          </c:if>
		  <c:if test="${page+3 lt totalPage}">
              <a href="javascript:;" onclick="queryData(${page+3})">${page+3}</a>
          </c:if>
        <c:if test="${page<totalPage}">
	      	 <a href="javascript:;" onclick="queryData(${page+1})" title="下一页">下一页</a></span>
        </c:if>
        <span class="infoTextAndGoPageBtnWrap">
        <span class="totalText">
            共<span class="totalPageNum">${totalPage }</span>页<span class="totalInfoSplitStr">/</span>共<span class="totalRecordNum">${total }</span>条数据</span>
        
           </span>
    </div>
<%--</div>--%>
</body>
</html>

