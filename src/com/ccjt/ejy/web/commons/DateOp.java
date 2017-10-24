package com.ccjt.ejy.web.commons;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * 日期操作方法
 * @author rocky(huangchunjie0513@163.com)
 *
 */
public class DateOp {
	
	/**
     * 毫秒 转换 为 字符串
     *
     * @param seconds	毫秒
     * @return 返回格式：1年7个月20天3时20分50秒48毫秒
     */
    public static String formatMsToStr(long seconds) {
        if (seconds == 0) {
            return "0毫秒";
        }

        long year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0, minsec = seconds;
        if (seconds >= 1000) {
            second = seconds / 1000;
            minsec = seconds % 1000;
        }
        if (second >= 60) {
            minute = second / 60;
            second = second % 60;
        }
        if (minute >= 60) {
            hour = minute / 60;
            minute = minute % 60;
        }
        if (hour >= 24) {
            day = hour / 24;
            hour = hour % 24;
        }
        //1年以365为基数计算
        if (day >= 365) {
            year = day / 365;
            day = day % 365;
            month = day / 30;
            day = day % 30;
        }else{
            //1个月以30为基数计算
            if (day >= 30) {
                month = day / 30;
                day = day % 30;
            } 
        }
        return (year == 0 ? "" : year + "年") 
                + (month == 0 ? "" : month + "个月") 
                + (day == 0 ? "" : day + "日")
                + (hour == 0 ? "" : hour + "时")
                + (minute == 0 ? "" : minute + "分钟") 
                + (second == 0 ? "" : second + "秒") ;
//                + (minsec == 0 ? "" : minsec + "毫秒");
    }
	
	/**
     * 时间毫秒 转 时间字符串
     * @param time
     * @param format
     * @return
     */
    public static String formatMsToStr(Long time, String format) {
        Date date = new Date(time);
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(date);
    }

    /**
     * 时间字符串 转 时间毫秒
     * @param timeStr
     * @param format
     * @return
     */
    public static long formatStrToMs(String timeStr, String format){
        return formatStrToMs(timeStr, format ,null);
    }
    public static long formatStrToMs(String timeStr, String format ,Locale locale){
    	if(timeStr ==null || timeStr.trim().equals(""))
            return 0;
        SimpleDateFormat formatter;
        if(locale ==null){
        	formatter =new SimpleDateFormat(format);
        }else{
        	formatter =new SimpleDateFormat(format ,locale);
        }
        Date date =null;
		try {
			date = formatter.parse(timeStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
        return date ==null ? -1:date.getTime();
    }
}
