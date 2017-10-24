/**
 * @param {type} dateStr    格式1：MM/dd/YYYY 或MM/dd/YYYY HH:mm:ss
 *                           格式2：MM-dd-YYYY 或MM-dd-YYYY HH:mm:ss
 *                           格式3：YYYY/MM/dd 或YYYY/MM/dd HH:mm:ss
 *                           格式4：YYYY-MM-dd 或YYYY-MM-dd HH:mm:ss
 */
var DateOp ={};
DateOp.strToDate = function(dateStr) {
    var myDate;
    //开头数字
    var starNum = new RegExp(/^\d+/).exec(dateStr);
    switch (starNum.toString().length) {
        case 2://月
            myDate = new Date(Date.parse(dateStr));
            break;
        case 4://年
            var array = dateStr.match(/\d+(\d+)?/g);
            var len = array.length;
            if (len < 3)
                return NaN;
            var hour = len > 3 ? array[3] : 0;
            var min = len > 4 ? array[4] : 0;
            var sec = len > 5 ? array[5] : 0;
            myDate = new Date(array[0], --array[1], array[2], hour, min, sec);
            break;
        default:
            return NaN;
    }
    return myDate;
};


/**
 * 转化为h5 type=date所需的日期格式
 * @param dateStr
 * @returns {*}
 */
DateOp.strToDate2 = function(dateStr) {
    var myDate;
    //开头数字
    var starNum = new RegExp(/^\d+/).exec(dateStr);
    switch (starNum.toString().length) {
        case 2://月
            myDate = new Date(Date.parse(dateStr));
            break;
        case 4://年
            var array = dateStr.match(/\d+(\d+)?/g);
            var len = array.length;
            if (len < 3)
                return NaN;
            myDate =array[0]+'-';//+ array[1]+'-'+array[2];
            if (array[1]<10){
                myDate+='0'+array[1]+'-';
            }else{
                myDate+=array[1]+'-';
            }
            if (array[2]<10){
                myDate+='0'+array[2];
            }else {
                myDate+=+array[2];
            }
            break;
        default:
            return NaN;
    }
    return myDate;
};

DateOp.formatMsToStr = function (seconds) {
    if (seconds === 0) {
        //return "0毫秒";
    }
    var year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0, minsec = seconds;
    if (seconds >= 1000) {
        second = Math.floor(seconds / 1000);
        //minsec = seconds % 1000;
    }
    if (second >= 60) {
        minute = Math.floor(second / 60);
        second = second % 60;
    }
    if (minute >= 60) {
        hour = Math.floor(minute / 60);
        minute = minute % 60;
    }
    if (hour >= 24) {
        day = Math.floor(hour / 24);
        hour = hour % 24;
    }
    //1年以365为基数计算
    if (day >= 365) {
        year = Math.floor(day / 365);
        day = day % 365;
        month = Math.floor(day / 30);
        day = day % 30;
    } else {
        //1个月以30为基数计算
        if (day >= 30) {
            month = Math.floor(day / 30);
            day = day % 30;
        }
    }
    return (year === 0 ? "" : year + "年")
            + (month === 0 ? "" : month + "个月")
            + (day === 0 ? "" : day + "日")
            + (hour === 0 ? "" : hour + "时")
            + (minute === 0 ? "" : minute + "分")
            + (second === 0 ? "" : second + "秒");
//            + (minsec === 0 ? "" : minsec + "毫秒");
}


/**
 * 精确到分
 * @param seconds
 * @returns {*}
 */
DateOp.formatMsToStr2 = function (seconds) {
    if (seconds === 0) {
        //return "0毫秒";
    }
    var  day = 0, hour = 0, minute = 0, second = 0;
    if (seconds >= 1000) {
        second = Math.floor(seconds / 1000);
    }
    if (second >= 60) {
        minute = Math.floor(second / 60);
        second = second % 60;
    }
    if (minute >= 60) {
        hour = Math.floor(minute / 60);
        minute = minute % 60;
    }
    if (hour >= 24) {
        day = Math.floor(hour / 24);
        hour = hour % 24;
    }


    return   (day === 0 ? "" : day + "天")
        + (hour === 0 ? "" : hour + "时")
        + (minute === 0 ? "" : minute + "分")
        + (second === 0 ? "" : second + "秒");
}



/**
 * 【实例Date】日期格式化
 * @param {String} format
 */
Date.prototype.format = function(format) {
    var str = format;
    var Week = ['日', '一', '二', '三', '四', '五', '六'];
    str = str.replace(/yyyy|YYYY/, this.getFullYear());
    str = str.replace(/yy|YY/, (this.getYear() % 100) > 9 ? (this.getYear() % 100).toString() : '0' + (this.getYear() % 100));
    var month = this.getMonth() + 1;
    str = str.replace(/MM/, month > 9 ? month.toString() : '0' + month);
    str = str.replace(/M/g, month);

    str = str.replace(/w|W/g, Week[this.getDay()]);

    str = str.replace(/dd|DD/, this.getDate() > 9 ? this.getDate().toString() : '0' + this.getDate());
    str = str.replace(/d|D/g, this.getDate());

    str = str.replace(/hh|HH/, this.getHours() > 9 ? this.getHours().toString() : '0' + this.getHours());
    str = str.replace(/h|H/g, this.getHours());
    str = str.replace(/mm/, this.getMinutes() > 9 ? this.getMinutes().toString() : '0' + this.getMinutes());
    str = str.replace(/m/g, this.getMinutes());

    str = str.replace(/ss|SS/, this.getSeconds() > 9 ? this.getSeconds().toString() : '0' + this.getSeconds());
    str = str.replace(/s|S/g, this.getSeconds());
    return str;
};