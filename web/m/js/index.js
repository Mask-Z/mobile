

// 修改业务员人选 B
function showRule1() {
    $(".js-visit-recommend").animate({ right: '0px' }, 300);
}

function closeRule1() {
    $(".js-visit-recommend").animate({ right: '-100%' }, 300);
};

 $(document).ready(function() {
        //时间切换
        $(".base-bidding-head span").click(function() {
            $(this).addClass("curr").siblings().removeClass("curr")
            $(this).parent().siblings(".base-bidding-box").hide().eq($(this).index()).show()
        })
    });




 $(document).ready(function(){
    //时间切换
    $(".deatil-tabs  li").click(function(){
      $(this).addClass("cur").siblings().removeClass("cur")
      $(this).parent().siblings(".tab_con").hide().eq($(this).index()).show()
    })
  });



  $(document).ready(function(){
    //时间切换
    $(".deatil-tabs  li").click(function(){
      $(this).addClass("cur").siblings().removeClass("cur")
      $(this).parent().siblings(".tab_con").hide().eq($(this).index()).show()
    })
  });

  $(function(){
	  if($(".deatil-tabs").lebght > 0){
		  var onexFix = $(".deatil-tabs").offset().top; 
	        //监听页面滚动  
	        $(window).scroll(function() {  
	            //onex 
	            if($(document).scrollTop() > onexFix ){   
	                $(".deatil-tabs").addClass("fixed");
	                $(".deatil-tabs-height").show();  
	            }else{
	                $(".deatil-tabs").removeClass("fixed"); 
	                $(".deatil-tabs-height").hide();  
	            };
	        });
	  }
});
