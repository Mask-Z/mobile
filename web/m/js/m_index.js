function load_jjdt() {

	$.ajax({
				url : 'jjdt_more_data',
				type : 'post',
				data : "page=1&rows=8",
				dataType : 'json',
				success : function(datas) {
					var data = datas.jjdt_more;
					var pageObj = datas.pageObj;
					current_page = pageObj.currentPage;
					var totalPage = 1;
					var pageSize = 10;
					var count = pageObj.total;
					if (data == null || data.length == 0) {
						// 没有符合的数据
						$("#newHallList").html("<font color=red>&nbsp;&nbsp;&nbsp;&nbsp;暂时没有符合条件的数据</font>");
						$("#curr_page").html("当前页" + current_page + "/" + totalPage);
						return;
					}
					if (count < pageSize || pageSize == 0) {
						totalPage = 1;
					} else {
						totalPage = count % pageSize == 0 ? Math.floor(count
								/ pageSize) : Math.floor(count / pageSize) + 1;
					}
					// 更新数据
					var html = "";
					for ( var i = 0; i < data.length; i++) {
		                var subject =data[i];
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
						var hasbid = (subject.hasbid =="1");
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
		                		} else if (obj_bmbtn==="未开始"){
		                			obj_endTime = obj_start;
		                		} else if(obj_bmbtn==="已结束"){
		                			obj_endTime = ("0秒");
		                		} else {
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
						'<div class="clearfix"></div><span class="type" id="endTime_'+biaodino+'" >'+obj_endTime+'</span> <div id="state_'+biaodino+'">'+obj_bmbtn+'</div>' +
						'</div> </li>';
					}

					if (html != "") {

						$(".clearfix.favorite").html(html);

					}
				}
			})

}