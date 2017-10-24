//刷新
function refresh(){
    var biaoDiNOs="";
    $("input[name=biaoDiNOs]").each(function(i,k){
        var projectcontroltype = $(this).next().val();
        if(projectcontroltype != 1&&projectcontroltype != 2){
            if(biaoDiNOs===""){
                biaoDiNOs += $(this).val();
            }else{
                biaoDiNOs +="," +$(this).val();
            }
        }
    });
    
    if(biaoDiNOs===""){
    	return; 
    }
    
    $.ajax({
        type: "POST",
        url: "refresh",
        dataType: "json", //json数据方式
        data: {"biaoDiNOs" : biaoDiNOs}, //json参数
        success: function (json) {
            if(json !=null){
            	var html = "";
                for(var i =0;i <json.length;i++){
                	
	                var subject =json[i];
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
	                    	
	                		if(obj_bmbtn==="竞价中" || obj_bmbtn==="延时竞价"){
	                    		obj_endTime = (DateOp.formatMsToStr(subject.last_times));//剩余时间
	                		} else if(obj_bmbtn==="已结束"){
	                			obj_endTime = ("0秒");
	                		} else if (obj_bmbtn==="未开始"){
	                			obj_endTime = obj_start;
	                		} else {
	                			obj_endTime = (obj_bmbtn);
	                		}
	                		
	               		break;
	                }

					var obj_price = "";
					
                    if((obj_bmbtn=="竞价中"  || obj_bmbtn=="已结束") && !hasbid){
                        obj_price='<span class="fc66">挂牌价：</span>￥' + price + '元';
                    } else {
                        obj_price='<span class="fc66">当前价：</span>￥<b id="maxPrice_'+biaodino+'">' + maxprice + '</b>元 </span>';
                    }
                    
                    $("#price_" + biaodino).html(obj_price);
                    $("#endTime_" + biaodino).html(obj_endTime);
                    $("#state_" + biaodino).html(obj_bmbtn);
                	
                }
                
            }
        }, error: function (XMLHttpRequest, textStatus, errorThrown) {
            //异步错误，Http错误状态码
            //console.log("ajax error：" + XMLHttpRequest.status + "," + XMLHttpRequest.readyState);
        }
    });
    
}
$(function () {
	setInterval("refresh()",1000)
});