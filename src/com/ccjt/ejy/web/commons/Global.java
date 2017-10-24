package com.ccjt.ejy.web.commons;

public class Global {

	/**
	 * 自动生成的小图存储目录
	 */
	public static String small_file_dir = PropertiesReader.get("small_file_dir");
	
	/**
	 * 自动生成的小图访问路径
	 */
//	public static String small_file_url = PropertiesReader.get("small_file_url");
	
	/**
	 * 大图访问url
	 */
	public static String big_pic_url = PropertiesReader.get("big_pic_url");
	
	/**
	 * 公告正文中需要替换的老url
	 */
	public static final String old_pic = "/cjszx/uploadfile";
	
	/**
	 * 交易公告中的图片链接替换
	 */
	public static final String old_pic_2 = "\"/ejyzx/";
	
	public static final String old_pic_2_new = "\"http://www.e-jy.com.cn/ejyzx/";
	
	/**
	 * 移动端网站调用业务系统注册相关接口url地址
	 */
	public static String register_url = PropertiesReader.get("bm_reg_url");
	
	/**
	 * 项目报名数据接口
	 */
	public static String baoming_url = PropertiesReader.get("bm_pj_signup_url");
	
	/**
	 * 附件下载路径
	 */
	public static String bm_file_download = PropertiesReader.get("bm_file_download");
	
	/**
	 * 注册类型（竞买方）
	 */
	public static String danWeiType_jmf = "44";
	
	/**
	 * 会员类型（单位）
	 */
	public static String memberType_dw = "0";
	
	/**
	 * 会员类型（个人）
	 */
	public static String memberType_gr = "1";

	public static final String gonggao_file_dir = PropertiesReader.get("gonggao_file_dir");
}
