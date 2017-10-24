<script type="text/javascript">
var consult_url_prefix = 'http://www.zcool.com.cn/special/ask';
var index_zx_hd = 1;
var index_jx_hd = 1;
var index_zx_tw = 1;
var index_zz_tw = 1;
var dashenUid = 0;

/*ajax 获取精选回答*/
function ajaxJXHD(page){
  $.ajax({
    type: 'POST',
    url: consult_url_prefix+'/answer.do',
    data:{"tab":"selection","p":page,"dashenuid":dashenUid},
    dataType: 'json',
    success: function(data){
      if(data.total > 0){

        var listhtml = "";
        listhtml = fillData_ZXHD(data);

        $("#section-hd").html(listhtml);
        if($("#page-1").children().length < 1){
          var totalPage = 1;
          if(data.size && data.size>0){
            totalPage = Math.ceil(data.total/data.size);
          }
          laypage({
            cont: 'page-1', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：&lt;div id="page1">&lt;/div>
            pages: totalPage, //通过后台拿到的总页数
            curr: data.p, //初始化当前页
            jump: function(e){//触发分页后的回调
              if(index_jx_hd > 1){
                ajaxJXHD(e.curr);
              }
            }
          });
        }
      }else{
          $("#section-hd").html('');
      }

      index_jx_hd ++;
      zc.moveTo("#fl02");
    },
    error:function(data) {
      console.log(data.msg);
    },
  });
}

/*ajax 获取最新回答*/
function ajaxZXHD(page){
  $.ajax({
    type: 'POST',
    url: consult_url_prefix+'/answer.do',
    data:{"p":page},
    dataType: 'json',
    success: function(data){
      if(data.total > 0){

        var listhtml = "";
        listhtml = fillData_ZXHD(data);

        $("#section-hd").html(listhtml);

        if($("#page-1").children().length < 1){
          var totalPage = 1;
          if(data.size && data.size>0){
            totalPage = Math.ceil(data.total/data.size);
          }
          laypage({
            cont: 'page-1', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：&lt;div id="page1">&lt;/div>
            pages: totalPage, //通过后台拿到的总页数
            curr: data.p, //初始化当前页
            jump: function(e){//触发分页后的回调
              if(index_zx_hd > 1){
                ajaxZXHD(e.curr);
              }
            }
          });
        }
      }else{
              $("#section-hd").html('');
            }

      index_zx_hd ++;
    },
    error:function(data) {
      console.log(data.msg);
    },
  });
}

function fillData_ZXHD(data){
  var listhtml = "";
  for(var i=0;i<data.records.length;i++){
    listhtml +=
            '<ul  class="feedbacklist">'+
              '<li class="layout">'+
                '<div class="fltableTh">'+
                  '<div class="headBox">'+
                    '<a href="http://www.zcool.com.cn/u/'+data.records[i].question.memberId+'" target="_blank"><img height="48" width="48"  src="'+data.records[i].question.headUrl+'" alt="" /></a>'+
                    '<div class="headBoxName"><a href="http://www.zcool.com.cn/u/'+data.records[i].question.memberId+'" target="_blank">'+data.records[i].question.name+'</a></div>'+
                                '<span>&nbsp;</span>'+
                  '</div>'+
                '</div>'+
                '<div class="fltableTd">'+
                    '<div class="fdate">'+data.records[i].answer.publishTime+'</div>'+
                  '<div class="nboxt">'+
                    '<div class="ncontent">'+data.records[i].question.question+'</div>'+
                  '</div>'+
                '</div>'+
              '</li>'+
              '<li class="layout fbright">'+
                '<div class="fltableTd">'+
                  '<div class="nboxs">'+
                    '<div class="ncontent">'+data.records[i].answer.question+'</div>'+
                  '</div>'+
                '</div>'+
                '<div class="fltableTh">'+
                  '<div class="headBox">';
            if(data.records[i].answer.iszan){
              listhtml += '<span class="likespan active"><span>'+data.records[i].answer.recommendCount+'</span><div><img src="assets/img/star.png" alt="" /></div></span>';
            }else{
                listhtml += '<span class="likespan"  onClick="ajaxzan(this,\''+data.records[i].answer.id+'\')"><span>'+data.records[i].answer.recommendCount+'</span><div><img src="assets/img/star.png" alt="" /></div></span>';
            }
              listhtml += '<a href="http://www.zcool.com.cn/u/'+data.records[i].answer.memberId+'" target="_blank"><img height="48" width="48"  src="'+data.records[i].answer.headUrl+'" alt="" /></a>'+
                    '<div class="headBoxName"><a href="http://www.zcool.com.cn/u/'+data.records[i].answer.memberId+'" target="_blank">'+data.records[i].answer.name+'</a><br />'+
                      data.records[i].answer.profession+
                    '</div>'+
                  '</div>'+
                '</div>'+
              '</li>'+
            '</ul>'
  }
  return listhtml;
}

/*ajax 获取最赞提问*/
function ajaxZZTW(page){
  $.ajax({
    type: 'POST',
    url: consult_url_prefix+'/question.do',
    data:{"tab":"selection","p":page},
    dataType: 'json',
    success: function(data){
      if(data.total > 0){
        var listhtml = "";
        listhtml = fillData_ZXTW(data);
        $("#section-tw").html(listhtml);
        if($("#page-2").children().length < 1){
          var totalPage = 1;
          if(data.size && data.size>0){
            totalPage = Math.ceil(data.total/data.size);
          }
          laypage({
            cont: 'page-2', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：&lt;div id="page1">&lt;/div>
            pages: totalPage, //通过后台拿到的总页数
            curr: data.p, //初始化当前页
            jump: function(e){//触发分页后的回调
              if(index_zz_tw > 1){
                ajaxZZTW(e.curr);
              }

            }
          });
        }
      }else{
              $("#section-tw").html('');
            }
      index_zz_tw ++;
    },
    error:function(data) {
      console.log(data.msg);
    },
  });
}


/*ajax 获取最新提问*/
function ajaxZXTW(page){
  $.ajax({
    type: 'POST',
    url: consult_url_prefix+'/question.do',
    data:{"p":page},
    dataType: 'json',
    success: function(data){
      if(data.total > 0){
        var listhtml = "";
        listhtml = fillData_ZXTW(data);
        $("#section-tw").html(listhtml);
                if($("#page-2").children().length < 1){
          var totalPage = 1;
          if(data.size && data.size>0){
            totalPage = Math.ceil(data.total/data.size);
          }
          laypage({
            cont: 'page-2', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：&lt;div id="page1">&lt;/div>
            pages: totalPage, //通过后台拿到的总页数
            curr: data.p, //初始化当前页
            jump: function(e){//触发分页后的回调
              if(index_zx_tw > 1){
                ajaxZXTW(e.curr);
              }
            }
          });
        }

        index_zx_tw ++;
      }else{
          $("#section-tw").html('');
      }
    },
    error:function(data) {
      console.log(data.msg);
    },
  });
}

function fillData_ZXTW(data){
  var listhtml = "";
  for(var i=0;i<data.records.length;i++){
    listhtml +=
                '<li class="layout">'+
                '<div class="fltableTh">'+
                  '<div class="headBox">'+
                    '<a href="http://www.zcool.com.cn/u/'+data.records[i].memberId+'" target="_blank"><img height="48" width="48"  src="'+data.records[i].headUrl+'" alt="" /></a>'+
                    '<div class="headBoxName"><a href="http://www.zcool.com.cn/u/'+data.records[i].memberId+'" target="_blank">'+data.records[i].name+'</a></div>'+
                    '<span>'+data.records[i].publishTime+'</span>'+
                  '</div>'+
                '</div>'+
                '<div class="fltableTd">';
          if(data.records[i].iszan){
            listhtml += '<span class="likespan special active"><div><img src="assets/img/star.png" alt="" /></div><span>'+data.records[i].recommendCount+'</span></span>';
          }else{
              listhtml += '<span class="likespan special" onClick="ajaxzan(this,\''+data.records[i].id+'\')"><div><img src="assets/img/star.png" alt="" /></div><span>'+data.records[i].recommendCount+'</span></span>';
          }
            listhtml +='<div class="nbox">'+
                    '<div class="ncontent">'+data.records[i].question+' <span class="atcolor">'+data.records[i].recommendDesigner+'</span>  </div>'+
                  '</div>'+
                '</div>'+
              '</li>'
  }
  return listhtml;
}

/*tab切换-最新回答*/
function tabzxhd(obj){
    $("#page-1").html('');
  $(obj).addClass("active");
    ajaxZXHD(1);
}

/*tab切换-最赞提问*/
function tabzztw(obj){
    $("#page-2").html('');
  $(obj).parents(".tinatitle").find("i").removeClass("active");
  $(obj).addClass("active");
  ajaxZZTW(1);
}
/*tab切换-最新提问*/
function tabzxtw(obj){
    $("#page-2").html('');
  $(obj).parents(".tinatitle").find("i").removeClass("active");
    $(obj).addClass("active");
    ajaxZXTW(1);
}

/*字数限制*/
!function($) {
  $.Huitextarealength = function(obj, maxlength) {
    var v = $(obj).val();
    var l = v.length;
    if (l > maxlength) {
      v = v.substring(0, maxlength);
      $(obj).val(v);
    }
    $(obj).parent().find(".textarea-length").text(v.length);
  }
} (window.jQuery);

/*弹出菜单*/
!function($) {
  $.Huimodalalert = function(info, speed) {
    alert(info);
  }

} (window.jQuery);

/*点赞*/
function ajaxzan(obj,id){
  if(isLogon()){//判断用户是否登录
        if(!$(obj).hasClass("active")){
          CommentsUtil.recommend(407,id,function(data){
            if (data.success) {
            var cookie_q_zan = $.cookie('special_ask_job_recommend_q_id');
            if(cookie_q_zan==null || cookie_q_zan==''){
              cookie_q_zan = id;
            }else{
              cookie_q_zan +=','+id;
            }
            $.cookie('special_ask_job_recommend_q_id',cookie_q_zan,{expires:60,path: '/',domain:'.zcool.com.cn'});
                    $(obj).addClass("active");
                    var number = parseInt($(obj).children('span').html()) + 1;
                    $(obj).children('span').html(number);
                }else{
                    alert(data.errormsg);
                }
          });
        }else{
      $.Huimodalalert('你已赞过',2000);
        }
    }else{
    $.Huimodalalert('请先登录',2000);
  }
}

/*发送评论*/
function ajaxSendSubmit(){
  var _name = $("#godName").val();
  var _id = $("#godName").attr("data-id");
  var _textarea =  $("#questioncontent").val();

  if(_name.length<=0){
    $.Huimodalalert('必须@一个人',2000);
    return false;
  }
  if(_textarea.length<=0){
    $.Huimodalalert('问题不能为空',2000);
    return false;
  }
  if(_textarea.length > 140){
    $.Huimodalalert('亲，最多只能输入140个字哦~~',2000);
    return false;
  }
  $.ajax({
    type: 'POST',
    data:{"recommendUid":_id,"question":_textarea},
    url: consult_url_prefix+'/submit.do',
    dataType: 'json',
    success:function(data){
      if('success' == data.status){

        zc.moveTo("#fl03")
          tabzxtw($("#zxtw"));
          $("#questioncontent").val('');
        //$("#modal-send-sueecss").modal("show");
      }else if('nocomment' == data.status){
        $.Huimodalalert('亲，最多只能输入140个字哦~~',2000);
      }else if('errordata' == data.status){
        $.Huimodalalert('亲，还不能向这个大神咨询哦~~',2000);
      }else if('nologin' == data.status){
        $.Huimodalalert('请先登录',2000);
      }
    },
    error:function(data) {
      console.log(data.msg);
    },
  });
}



$(function(){
    var uids = new Array(344197,92509,1045258,66510,19656,13533091,13876089,14138969,15245125,460999);
    $(".tag-godat").each(function(index,element){
        $(this).attr("data-id",uids[index]);
    });
    $(".tag-godlist").each(function(index,element){
        $(this).attr("data-id",uids[index]);
    });
    $(".tag-godreply").each(function(index,element){
        $(this).attr("data-id",uids[index]);
    });
    $(".tag-godreply").click(function(){
        $(this).parents(".tinatitle").find("i").removeClass("active");
      var name = $(this).text();
        $("#dashenzhuanqu").text(name);
        dashenUid = $(this).attr("data-id");
        $("#page-1").html('');
        ajaxJXHD(1);
    });

  ajaxZXHD(1);
  ajaxZXTW(1);
});
</script>