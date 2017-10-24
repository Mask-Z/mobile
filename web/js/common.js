
//弹出窗体初始属性
var win = {
	iconCls : "icon-save",
	modal : true,
	shadow : false,
	collapsible : false,
	minimizable : false,
	minimized : false,
	maximizable : true,
	maximized : false,
	closed : true
};

$(function() {

});

/**
 * 提示框
 * @param {提示内容} message
 * @param {对话框围标} icon(error,question,info,warning.)
 * @param {对话框标题} title
 * @param {关闭对话框后的处理方法} fn
 */
function alertMsg(message, icon, title, fn) {
	if (!icon)
		icon = "info";
	if (!title)
		title = "提示";
	if (!fn)
		$.messager.alert(title, message, icon);
	else
		$.messager.alert(title, message, icon, fn);
}

/**
 * 调用弹出窗体
 * @param {窗体名:#w1} elem 
 * @param {窗体参数设置json格式{title: '修改',
 cache: false,
 href: 'getBaseNodeInfo.action',
 width: 100,
 height: 100}} parameter
 */
function showWindow(elem, parameter) {
	//记录body打开弹出窗体前的最后个元素
	$(elem).window($.extend({
		//页面加载后相关处理(表单美化,布局等)
		//onLoad: loadFilter ? loadFilter : function(){

		//},
		onClose : function() {
			//初始化弹出窗体
			//$(elem).window("body").html("");

			//alert($(elem).window().html());
			$(elem).html('');
			//关闭后删除打开窗体添加的easyui插件的面板
		},
		onBeforeOpen : function() {
			//记录打开前最后个元素
			//panel = $("body").children("div").last();
		}
	}, {
		modal : true,
		minimizable : false,
		draggable : true,
		collapsible : false,
		shadow : false,
		cache:false,
		closed : true,
		border : false
	}, parameter, 'move', {
		left : ($(document).width() - parameter.width) / 2,
		top : ($(document).height() - parameter.height) / 2
	}));
	$(elem).window("open");
}
/**
 * 关闭弹出窗体
 * @param {窗体名:#w1} elem
 */
function closeWindow(elem) {
	$(elem).window("close");
}

/**
 * 设置列表数据样式
 * @param {列表名:#date} elem
 * @param {参数设置} options
 */
function getDatagrid(elem, options) {
	if (!(elem instanceof jQuery))
		elem = $(elem);
	elem.datagrid($.extend({
		fitColumns : true,
		nowrap : false,
		striped : true,
		fit : true,
		border : false,
		pageSize : 14,
		pageList : [ 12, 14, 16, 18, 20 ],
		pagination : true,
		rownumbers : true,
		onLoadError : function(jqXHR, textStatus, errorThrown) {
			code = jqXHR.status;
			if (code == 404)
				alert("请求页未找到!");
			else if (code == 0)
				alert("远程链接已断开!");
			else if (code == 500)
				alert("服务器内部错误!");
			else
				alert(jqXHR.responseText);
		}
	}, options));
}

/**
 * 删除信息
 * @param {url:'请求', 
 * 		data:'传参json格式,默认:{}',
 * 		message:'删除前的提示信息,默认:是否删除所选信息?', 
 *		success:'返回成功成功的处理方法'
 */
function delInfo(options) {
	$.messager.confirm('提示', !options.message ? '是否删除所选信息?' : options.message,
			function(r) {
				if (r) {
					var uri = options.url.split("?");
					if (uri && uri[0])
						options.url = uri[0];
					if (uri && uri[1])
						if (options.data)
							options.data += "&" + uri[1];
						else
							options.data = "&" + uri[1];
					$.ajax({
						type : "post",
						url : options.url,
						data : !options.data ? {} : options.data,
						success : options.success,
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							alert("出错啦,请刷新后重试!");
						},
						onLoadError : function(jqXHR, textStatus, errorThrown) {
							alert(jqXHR.responseText);
						}
					});
				}
			});
}

/**
 * 文件大小
 * @param {Object} bytes
 * @return {TypeName} 
 */
function formatFileSize(bytes) {
	if (typeof bytes !== 'number') {
		return '';
	}
	if (bytes >= 1000000000) {
		return (bytes / 1000000000).toFixed(2) + ' GB';
	}
	if (bytes >= 1000000) {
		return (bytes / 1000000).toFixed(2) + ' MB';
	}
	return (bytes / 1000).toFixed(2) + ' KB';
}

//全局异步请求
$.ajaxSetup({
	error : function(XMLHttpRequest, textStatus, errorThrown) {
		if (XMLHttpRequest.status == 403) {
			alert('您没有权限访问此资源或进行此操作');
			return false;
		}
	},
	complete : function(XMLHttpRequest, textStatus) {
		var sessionstatus = XMLHttpRequest.getResponseHeader("sessionstatus"); //通过XMLHttpRequest取得响应头,sessionstatus， 
		if (sessionstatus == 'timeout') {
			//如果超时就处理 ，指定要跳转的页面  
			var top = getTopWinow(); //获取当前页面的顶层窗口对象 
			top.location.href = "login"; //跳转到登陆页面
		}
	}
});

/** 
 * 在页面中任何嵌套层次的窗口中获取顶层窗口 
 * @return 当前页面的顶层窗口对象 
 */
function getTopWinow() {
	var p = window;
	while (p != p.parent) {
		p = p.parent;
	}
	return p;
}