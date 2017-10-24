var explorer;var explorer_version;

/**
 * 获取浏览器类型
 * 
 * @returns {undefined}
 */
	function getExplorer() {
	    var explorer = window.navigator.userAgent;
	    if (explorer.indexOf("MSIE") >= 0) {
	        return "IE";
	    } else if(explorer.indexOf("Edge") >= 0){
	    	return "IE";
	    } else if (explorer.indexOf("Firefox") >= 0) {
	        return "Firefox";
	    } else if (explorer.indexOf("Chrome") >= 0) {
	        return "Chrome";
	    } else if (explorer.indexOf("Opera") >= 0) {
	        return "Opera";
	    } else if (explorer.indexOf("Safari") >= 0) {
	        return "Safari";
	    } else {
	        return  "IE";
	    }
	}

	/** 获取浏览器版本号 */
	function getExplorerVersion(){
		var userAgent = navigator.userAgent;
		var browser;
		var version;
		var browserMatch = _uaMatch(userAgent);
		if (browserMatch.browser) {
			browser = browserMatch.browser;
			version = browserMatch.version;
		}
		return version;
	}
	function _uaMatch(userAgent) {
		var rMsie = /(msie\s|trident.*rv:)([\w.]+)/;
		var rFirefox = /(firefox)\/([\w.]+)/;
		var rOpera = /(opera).+version\/([\w.]+)/;
		var rChrome = /(chrome)\/([\w.]+)/;
		var rSafari = /version\/([\w.]+).*(safari)/;
		var ua = userAgent.toLowerCase();
		var match = rMsie.exec(ua);
		if (match != null) {
			return {
				browser : "IE",
				version : match[2] || "0"
			};
		}
		var match = rFirefox.exec(ua);
		if (match != null) {
			return {
				browser : match[1] || "",
				version : match[2] || "0"
			};
		}
		var match = rOpera.exec(ua);
		if (match != null) {
			return {
				browser : match[1] || "",
				version : match[2] || "0"
			};
		}
		var match = rChrome.exec(ua);
		if (match != null) {
			return {
				browser : match[1] || "",
				version : match[2] || "0"
			};
		}
		var match = rSafari.exec(ua);
		if (match != null) {
			return {
				browser : match[2] || "",
				version : match[1] || "0"
			};
		}
		if (match != null) {
			return {
				browser : "",
				version : "0"
			};
		}
	}
	
	//获取值
	explorer =getExplorer();
	explorer_version =getExplorerVersion();