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
</head>

<body>
<header class="h43">
    <div class="index-header">
        <a href="index" class="back"></a>
        <div class="title">竞价大厅</div>
        <a href="javascript:showRule1();" class="h-r"><i class="glyphicon glyphicon-filter"></i></a>
    </div>
</header>
<div class="container ">
    <script type="text/javascript" src="m/ext/jjdt_more.js"></script>

    <div class="h40"></div>
    <div class="base-bidding-head">
        <span class="curr item">产权交易</span>
        <span class="item">招标采购</span>
    </div>
    <div class="base-bidding-box bgff" style="display: block;">
        <div class="table-view cqjy">
            <ul class="cart-table-view clearfix favorite">
            </ul>
        </div>
    </div>
    <div class="base-bidding-box bgff" style="display: none;">
        <div class="new-list index-news">
            <ul class="clearfix zbcg">
            </ul>
        </div>
    </div>
</div>
<div class="visit-type js-visit-recommend">
    <div class="box">
        <div class="recharge-cz">
            <h3 class="bd_b f16 pb10 mb10 clearfix lh24"><a href="javascript:closeRule1();" class="fr "><i
                    class="fc99 f24 iconfont icon-error"></i></a>筛选</h3>
            <form id="jjdt_search" class="jjdt_search">
                <%--<input type="hidden" name="sheng" id="jjdt_sheng" value=""/>--%>
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
                            <option value="">全部</option>
                            <c:forEach items="${orglist}" var="org">
                                <option value="${org.orgid}"/>
                                ${org.name}
                                </option>
                            </c:forEach>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">标的所在地</span>
                        <select class="form-control input input-sm " name="sheng" id="sheng">
                            <option value=""
                            <%--<c:if test="${empty sheng}">selected</c:if> >全部--%>
                                    selected>全部
                            </option>
                            <c:forEach items="${cityinfo}" var="city">
                                <option value="${city.code}"
                                    <%--<c:if test="${sheng==city.name}">selected</c:if>>${city.name}</option>--%>
                                >${city.name}</option>
                            </c:forEach>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">项目类型</span>
                        <select class="form-control input input-sm " name="type" id="type">
                            <option value="">全部</option>
                            <c:forEach items="${typelist}" var="obj">
                                <option value="<c:out value="${obj.type}"/>">
                                    <c:out value="${obj.typeName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <span class="mb5 dsb">项目状态</span>
                        <select class="form-control input input-sm " name="status" id="status">
                            <option selected="selected" value="">全部</option>
                            <option value="2">未开始</option>
                            <option value="0">报价中</option>
                            <option value="3">已结束</option>
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
        var itemIndex = 0;
        var tab1LoadEnd = false;
        var tab2LoadEnd = false;
        // tab
        $('.base-bidding-head .item,.btn.btn-success').on('click', function () {
            closeRule1();
            var ele = $(this).attr("class");//获取触发事件的元素
            var $this = $(this);
            itemIndex = $this.index();
            if (ele === "btn btn-success  w100") {
                $(".favorite li").remove();
//                itemIndex == '0';
                // 解锁
                tab1LoadEnd = false;
            }
            // 如果选中菜单一
            if (itemIndex == '0') {
                // 如果数据没有加载完
                if (!tab1LoadEnd) {
                    // 解锁
                    dropload.unlock();
                    dropload.noData(false);
                } else {
                    // 锁定
                    dropload.lock('down');
                    dropload.noData();
                }
                // 如果选中菜单二
            } else if (itemIndex == '1') {
                if (!tab2LoadEnd) {
                    // 解锁
                    dropload.unlock();
                    dropload.noData(false);
                } else {
                    // 锁定
                    dropload.lock('down');
                    dropload.noData();
                }
            }
            // 重置
            dropload.resetload();
        });

        var flag = 1;//第一次小于行数可以显示
        // 每页展示10个
        var rows = 15;
        var selector;
        if (itemIndex == '0') {
            selector = '.table-view.cqjy';
        } else {
            selector = '.index-news';
        }
        // dropload
        var dropload = $(selector).dropload({
            scrollArea: window,
            loadDownFn: function (me) {
                // 加载菜单一的数据
                if (itemIndex == '0') {
                    //获取form表单的查询条件
                    var params = $("form.jjdt_search").serialize();
                    var currentPage = Math.ceil($(".clearfix.favorite li").length / rows) + 1;
                    $.ajax({
                        type: 'POST',
                        url: 'jjdt_more_data',
                        data: "page=" + currentPage + "&rows=" + rows + "&" + params,
                        dataType: 'json',
                        success: function (datas) {
                            var data = datas.jjdt_more;
                            var html = '';
                            var arrLen = data.length;
                            if (arrLen > 0 && flag == 1) {
                                if (arrLen < 15) {
                                    flag = 2;
                                }
                                for (var i = 0; i < arrLen; i++) {

            		                var subject = data[i];
            		                var format ="yyyy-MM-dd HH:mm:ss";
            		                var infoguid =subject.infoguid;
            		                var price =subject.price;//标的底价
            		                var endtime =new Date(subject.endtime).format(format);//延时报价时间
            		                var biaodino =subject.biaodino;
            		                var project_url =subject.project_url;
            		                var projectcontroltype =subject.projectcontroltype ==null 
            		   						? -1 
            								:($.trim(subject.projectcontroltype) =="" 
            										? -1
            									 	:$.trim(subject.projectcontroltype));
            		                var object =subject.object;//项目名称
            						var hasbid =subject.hasbid =="1";
            		                if(object !=null && object.length >35){
            		                	object =object.substring(0,35)+"...";
            		                }
            		                //需要动态刷新的值
            		                var startMs =subject.start;
            		                
            		                var obj_start;//开始时间
            		                var obj_endTime;//剩余时间
            		                var obj_bmbtn;//操作按钮
            		                var maxprice;//当前价格
            		                
            		                var status = subject.status;//0 竞价中  1 未开始  2 已结束
            		              	
            		                //刷新最高价
            		                maxprice =subject.maxprice;
            		                //刷新开始时间：已开始直接显示开始时间；未开始显示多久开始
            		                var cur = subject.current;//当前时间
            		                if(cur > startMs){
            		                	obj_start =new Date(startMs).format(format);
            		                }else{
            		                	obj_start =DateOp.formatMsToStr(startMs - cur);
            		                }
            		                
            		                
            		                //刷新操作按钮：
            		                var show_span1 =false;//是否显示span1
            		                switch(projectcontroltype){
            		                	case 2:
            		                		show_span1 =true;
            		                		obj_bmbtn ="中止";
            		               		break;
            		                	case 1:
            		                		show_span1 =true;
            		                		obj_bmbtn ="终结";
            		            		break;
            		                	default:
            		                		
            		                		obj_bmbtn = subject.statusCN;
            		                    	
            		                    	if(obj_bmbtn==="竞价中"){
            		                    		obj_endTime = (DateOp.formatMsToStr(subject.last_times));//剩余时间
            		                		} else if(obj_bmbtn==="已结束"){
            		                			obj_endTime = ("0秒");
            		                		} else if (obj_bmbtn==="未开始"){
            		                			obj_endTime = obj_start;
            		                		}
            		                		else {
            		                			obj_endTime = (obj_bmbtn);
            		                		}
            		                		
            		               		break;
            		                }

            						var obj_price;
                                    // if (maxprice==="-"){
            						

                                    if((obj_bmbtn=="竞价中"  || obj_bmbtn=="已结束") && !hasbid){
                                        obj_price='<span class="price" style="color:#333" id="price_'+biaodino+'"><span class="fc66" >挂牌价：</span>￥' + price + '元</span>';
                                    } else {
                                        obj_price='<span class="price"><span class="fl" id="price_'+biaodino+'"><span class="fc66" >当前价：</span>￥<b id="maxPrice_'+biaodino+'">' + maxprice + '</b>元 </span></span>';
                                    }

                                    html+='<li> <div class="right_text"> <p class="sub_tit"><a href="'+subject.project_url+'">' +object+
            						'</a> </p><input type="hidden" name="biaoDiNOs" value="'+biaodino+'">' +obj_price+
            						// ' <p class="price">￥<b>'+maxprice+'</b>元 <del class="f12 fc99 ml10">￥'+price+'元</del> </p> ' +
            						'<div class="clearfix"></div><span class="type" id="endTime_'+biaodino+'" >'+obj_endTime+'</span> <div id="state_'+biaodino+'" >'+obj_bmbtn+'</div>' +
            						'</div> </li>';
                                    }    
                            } else {
                                flag = 1;
//                                 数据加载完
                                tab1LoadEnd = true;
                                // 锁定
                                me.lock();
                                // 无数据
                                me.noData();
                            }
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $('.clearfix.favorite').append(html);
                                // 每次数据加载完，必须重置
                                me.resetload();
                            }, 100);
                        },
                        error: function (xhr, type) {
                            // 即使加载出错，也得重置
                            me.resetload();
                        }
                    });
                    // 加载菜单二的数据
                } else if (itemIndex == '1') {
                    //跳转页面
                    window.location.href = "zbcg_jjdt";
                }
            }
        });
    });

</script>
<%--<script>--%>
    <%--var ss = '<tr class="bd-green"><td title="一批织带设备资产" style="text-align:left;font-size:14px; padding: 5px 10px;"><input type="hidden" name="biaoDiNOs" value="24WZ20170027"><a class="bdh-btn" target="_blank" href="infodetail?infoid=a059c44d-9248-4b40-a1f3-4880c4a8494d" style="color: #333">一批织带设备资产</a></td><td title="2017-06-19 00:00:00" id="start_24WZ20170027">2017-06-19 00:00:00</td><td title="9分29秒" id="endTime_24WZ20170027">9分29秒</td><td title="2017-06-26 10:00:00">2017-06-26 10:00:00</td><td title="311900.00 元">311900.00 元</td><td title="- 元" id="maxPrice_24WZ20170027">- 元</td><td title="24WZ20170027" id="bmbtn_24WZ20170027"><font id="bmbtn_span1_24WZ20170027" class="button" style="background-color:#ccc;color:#fff;display: none;">竞价中</font><font id="bmbtn_span2_24WZ20170027" class="button" style=""><a id="24WZ20170027" class="ejy_huiyuan_bm">竞价中</a></font></td></tr>';--%>
<%--</script>--%>
</html>
