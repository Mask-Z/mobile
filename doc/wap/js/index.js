

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



 $(function() {
            var myElement = document.getElementById('carousel-example-generic')
            var hm = new Hammer(myElement);
            hm.on("swipeleft", function() {
                $('#carousel-example-generic').carousel('next')
            })
            hm.on("swiperight", function() {
                $('#carousel-example-generic').carousel('prev')
            });
           $('#carousel-example-generic').carousel({interval:3000});//每隔5秒自动轮播 
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
        //获取导航距离页面顶部的距离  
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
}); 
