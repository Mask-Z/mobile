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
	<link rel="stylesheet" type="text/css" href="css/jquery-weui.css">
	<link rel="stylesheet" type="text/css" href="m/weui/weui.css">
	<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/1.11.3/jquery.min.js"></script>
	<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js"></script>    
    
    <script type="text/javascript" src="js/jquery-weui.js"></script>

  </head>
  
  <body>
    
<script type="text/javascript">
$(function(){    
    $("#pj_sign_srf").on("click",function(){    	
    	$("#srf_select_div").fadeIn(200);    	
    });
    
    $("#srf_sel_ok").on("click",function(){
        $(".weui-srf").each(function(){ 
            if($(this).is(':checked')){
                $("#shouRang_name").val($(this).next().next().next().val());
                $("#shouRang_guid").val($(this).next().next().val());
            }
        });
    	$("#srf_select_div").fadeOut(200);
    });
    
    $("#srf_sel_cancel").on("click",function(){
    	$("#srf_select_div").fadeOut(200);
    });
    
    $("#btn_ok").click(function(){    	
    	var param = $("#pj_gq_addUnion").serialize();    	
    	$.ajax({
       	   type: "POST",
       	   url: "pj_gq_addUnion_submit",
       	   dataType:"json",
       	   data: param,
       	   success: function(msg){
       	       if(msg){
       	           if(msg.code==0){
       	    		   alert(msg.msg);
       	    	   }else{
       	    		   alert(msg.msg);
       	    	   }
       	       }
       	   },
       	   error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   		alert(errorThrown);
       	   }
       	});    	
    });
    
    $("#btn_cancel").on("click",function(){    	
    	window.history.back(-1);
    });
    
    var $searchBar = $('#searchBar'),
        $searchResult = $('#searchResult'),
        $searchText = $('#searchText'),
        $searchInput = $('#searchInput');

        function hideSearchResult(){
            $searchResult.hide();
            $searchInput.val('');
        }
        
        function cancelSearch(){
            hideSearchResult();
            $searchBar.removeClass('weui-search-bar_focusing');
            $searchText.show();
        }

        $searchText.on('click', function(){
            $searchBar.addClass('weui-search-bar_focusing');
            $searchInput.focus();
        });
        
        $searchInput.on('blur', function(){
            if(!this.value.length) cancelSearch();
        }).on('input', function(){
            if(this.value.length){
                $.ajax({
                   type: "POST",
       	           url: "get_srf_list",
       	           dataType: "json",
       	           data: "srfNameOrUnitCode="+$("#searchInput").val()+"&projectGuid="+$("#project_guid").val()
       	               +"&rowGuid="+$("#baoMing_guid").val()+"&type="+$("#choose_srf").val(),
       	           success: function(result){
       	               $searchResult.empty();
       	               $.each(result,function(i,data){
       	                   var innerHtml = "<label class='weui-cell-srf weui-check__label' for='i" + i +"' style='text-align: left;font-size: 14px'>"
			                         + "<div class='weui-cell__bd'>"
			                         + "<div class='weui-cell-srf'>"
        	                         + "<div class='weui-cell__hd'>"
        	                         + "<span class='weui-label'>" + data.UnitOrgNum + "</span>"
        	                         + "</div>"
                                     + "<div class='weui-cell__bd'>"
                                     + "<span class='weui-input'>" + data.DanWeiName + "</span>"
                                     + "</div>"
                                     + "</div>"
			                         + "</div>"
			                         + "<div class='weui-cell__ft'>"
			                         + "<input type='radio' class='weui-check weui-srf' name='radio1234' id='i" + i +"'>"
			                         + "<span class='weui-icon-checked'></span>"
			                         + "<input type='hidden' value='" + data.DanWeiGuid + "'>"
			                         + "<input type='hidden' value='" + data.DanWeiName + "'>"
			                         + "</div>"
			                         + "</label>";
       	                   $searchResult.append(innerHtml);
       	               });
       	               
       	               $searchResult.show();       	           
       	           },
       	           error:function (XMLHttpRequest, textStatus, errorThrown) {
       	   		       alert(errorThrown);
       	           }
       	        });                  
            }else{
                $searchResult.hide();
            }
        });
        
    $("#choose_srf").on("change",function(){
        $searchResult.hide();
        $searchResult.empty();
        $searchInput.val('');	
    	if($(this).val() == 0){  
    	    $("#searchInput").attr("placeholder","输入竞买方搜索");    	    
    	}else{
    	    $("#searchInput").attr("placeholder","输入组织机构代码搜索");    	 
    	}
    });    
});
</script>
<script type="text/javascript" src="js/city-picker.js"></script>
<form id="pj_gq_addUnion">
<input type="hidden" id="baoMing_guid" value="${rowGuid }"><!-- 报名唯一标识 -->
<input type="hidden" id="project_guid" value="${projectGuid}"><!-- 项目guid -->
<input type="hidden" id="shouRang_guid" name="info['shouRangGuid']" value="">

<div class="weui-toptips weui-toptips_warn js_tooltips"></div>
<div class="weui-cells__title">新增联合受让方</div>
<div class="weui-cells weui-cells_form">    
    <div class="weui-cell weui-cell_access" id="pj_sign_srf">
        <div class="weui-cell__hd"><label class="weui-label">受让方名称</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['shouRangName']" type="text" id="shouRang_name" value=""/>
        </div>
        <div class="weui-cell__ft" style="font-size: 0">
			<span></span>
        </div>
    </div>
    
    <div class="weui-cell weui-cell_select weui-cell_select-after">
        <div class="weui-cell__hd"><label class="weui-label">受让方类型</label></div>
        <div class="weui-cell__bd">
            <select class="weui-select" name="info['shouRangRenType']">
                 <c:forEach items="${shouRangRenTypes}" var="shouRangRenType">
                    <option value="${shouRangRenType.code}">${shouRangRenType.value}</option>
                </c:forEach>
            </select>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">受让比例（%）</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['shouRangPercent']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人姓名</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['lianXiName']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人电话</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['lianXiTel']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人邮件</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['lianXiEmail']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">联系人传真</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['lianXiFax']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员单位名称</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoDWName']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员联系人电话</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoDWLianXiTel']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cells__tips">委托会员核实意见</div>
    <div class="weui-cell">
        <div class="weui-cell__bd">
            <textarea class="weui-textarea" name="info['weiTuoHYHeShi']" rows="3"></textarea>
        </div>
    </div>   
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员工位号</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoHYNo']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员经纪人</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoHYName']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员经纪人编码</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoHYCode']" type="text" value=""/>
        </div>
    </div>
    
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">委托会员联系人</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input" name="info['weiTuoHYLianXiName']" type="text" value=""/>
        </div>
    </div>
    
</div>
</form>
<div class="weui-btn-area">
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_ok">确定</a>    
    <a class="weui-btn weui-btn_primary" href="javascript:" id="btn_cancel">取消</a>    
</div>

<div class="js_dialog" id="srf_select_div" style="display: none;height: 400px;">
    <div class="weui-mask"></div>
    <div class="weui-dialog">
        <div class="weui-dialog__hd" style="height: 30px"><strong class="weui-dialog__title">新增联合受让方</strong></div>
        <div class="weui-dialog__bd" style="height: 330px;overflow-y:scroll;">            
            <div class="weui-search-bar" id="searchBar">
                <select id="choose_srf" class="form-control input input-sm">
                    <option value="0">竞买方</option>
                    <option value="1">组织机构代码</option>
                </select>
                <form class="weui-search-bar__form">
                    <div class="weui-search-bar__box">
                        <input type="search" class="weui-search-bar__input" id="searchInput" placeholder="输入竞买方名称搜索" required="">
                    </div>
                    <label class="weui-search-bar__label" id="searchText" style="transform-origin: 0px 0px 0px; opacity: 1; transform: scale(1, 1);">
                        <i class="weui-icon-search"></i>
                        <span>搜索</span>
                    </label>
                </form>
            </div>
            <div class="weui-cells searchbar-result weui-cells_radio" id="searchResult" style="transform-origin: 0px 0px 0px; opacity: 1; transform: scale(1, 1); display: none;">
                
            </div>
        </div>
        <div class="weui-dialog__ft">
            <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary" id="srf_sel_ok">确定</a>
            <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary" id="srf_sel_cancel">取消</a>
        </div>
    </div>
</div>
    
    
  </body>
</html>
