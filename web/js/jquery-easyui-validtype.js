$.extend($.fn.validatebox.defaults.rules, {
   	password: {//增加密码自定义验证
        validator: function(value, param){
			if(value == ""){
				return true;
			}else
				return value == $("#" + param).val();
        },
        message: '两次输入的密码必须一致!'
   	},
   	digist: {
   		validator: function(value, param){
		    return /^[0-9]*[1-9][0-9]*$/.test(value);
        },
        message: '请输入正整数!'
   	},
   	phone: {//增加角色自定义验证
        validator: function(value, param){
		   return /^((13[0-9]|15[0-35-9]|18[05-9])[0-9]{8})$/.test(value) || /^(0[0-9]{2,3})-([0-9]{7,8})$/.test(value);
        },
        message: '手机,座机(0519-12345678)号有误！'
   	},
   	mobilphone: {
   		 validator: function(value, param){
		    return /^((13[0-9]|15[0-35-9]|18[02-35-9])[0-9]{8})$/.test(value);
        },
        message: '手机号有误！'
   	},
   	url:{
		validator:function (value,param) {
			return /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(value);
		}, 
		message:"请输入正确的URL!"
	},
   	postcode:{
		validator:function (value,param) {
			return /^[1-9][0-9]{5}$/.test(value);
		}, 
		message:"请输入正确邮编"
	},
   	faxnum:{
		validator:function (value,param) {
			if(value == ""){
				return true;
			}else
				return /\d{3}-\d{8}|\d{4}-\d{7}/.test(value);
		}, 
		message:"请输入正确传真号码"
	},
   	email:{
		validator:function (value,param) {
				return /\w@\w*\.\w/.test(value);
		}, 
		message:"请输入正确邮箱"
	},
	keywords:{
		validator:function (value,param) {
			return 	 /^(([\u4e00-\u9fa5a-z0-9A-Z]+)(( (?!$))|$)){1,9}$/.test(value);				
		}, 
		message:"请输入正确的关键字!"
	},
	dateGeToday:{
		validator: function(value, param){ 
		  	var parser1 = $.fn.datebox.defaults.parser(value);
		  	var parser2 = $.fn.datebox.defaults.parser(param[0]);
            return parser1 >= parser2;  
        },  
        message: '请输入大于等于 {0} 的日期.'  
	},
	dateTimeGeTime:{
		validator: function(value, param){  
            var parser1 = $.fn.datetimebox.defaults.parser(value);
		  	var parser2 = $.fn.datetimebox.defaults.parser(param[0]);
            return parser1 >= parser2;  
        },  
        message: '请输入大于等于 {0} 的时间.'  
	},
	dateGeBetween:{
		validator: function(endDate, startDate){ 
			if(!startDate[0])
				return true;
          	var parser1 = $.fn.datebox.defaults.parser(endDate);
		  	var parser2 = $.fn.datebox.defaults.parser(startDate[0]);
            return parser1 > parser2;  
        },  
        message: '请输入大于 {0} 的结束日期.'  
	},
	dateLeBetween:{
		validator: function(endDate, startDate){  
			if(!startDate[0])
				return true;
          	var parser1 = $.fn.datebox.defaults.parser(endDate);
		  	var parser2 = $.fn.datebox.defaults.parser(startDate[0]);
            return parser1 < parser2;  
        },  
        message: '请输入小于 {0} 的结束日期.'  
	},
	dateTimeGeBetween:{
		validator: function(endDate, startDate){ 
			if(!startDate[0])
				return true;
            var parser1 = $.fn.datetimebox.defaults.parser(endDate);
		  	var parser2 = $.fn.datetimebox.defaults.parser(startDate[0]);
            return parser1 > parser2;  
        },  
        message: '请输入大于 {0} 的结束时间.'  
	},
	dateTimeLeBetween:{
		validator: function(endDate, startDate){ 
			if(!startDate[0])
				return true;
            var parser1 = $.fn.datetimebox.defaults.parser(endDate);
		  	var parser2 = $.fn.datetimebox.defaults.parser(startDate[0]);
            return parser1 < parser2;  
        },  
        message: '请输入小于 {0} 的结束时间.'  
	},
	ip:{
		validator: function(value, param){ 
			return /^((([01]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))[.]){3}(([0-1]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))$/.test(value);
        },  
        message: '无效的IP地址.'  
    },
    contrastIp:{
		validator: function(value, param){
    		if(!/^((([01]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))[.]){3}(([0-1]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))$/.test(value))
    			return false;
    		var start = $(param[0]).val();
   			var startArray = start.split(".");
   			var endArray = value.split(".");
   			var sa, ea, flag = false;
   			for(var i = 0; i < 4; i++){
   				sa = parseInt(startArray[i]);
   				ea = parseInt(endArray[i]);
   				if(sa < ea){
   					flag = true;
   					break;
   				}
   				else if(sa > ea)
   					break;
   			}
			return flag;
        },  
        message: '开始IP地址小于结束IP地址,请重新输入.'  
    },
    doubleNum:{
    	validator:function(value,p){
    		var a = /^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$/.test(value);
    		var b = /^[0-9]*[1-9][0-9]*$/.test(value);

    		return a||b;
    	},
    	message:"无效数字"
    }
});