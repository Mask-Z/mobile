package com.ccjt.ejy.web.vo;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;

public class Screen implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -888050436444490283L;
	private String title;
	private String price;
	private String s1;
	private String s2;
	private String startdate;
	private Date enddate;
	private String enddate_str;
	
	public String getTitle() {
		if(StringUtils.isNotBlank(title) && title.length() > 40){
			return title = title.substring(0,40) + "...";
		}
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getPrice() {
		return price;
	}
	
	public void setPrice(String price) {
		this.price = price;
	}
	
	public String getS1() {
		return s1;
	}
	
	public void setS1(String s1) {
		this.s1 = s1;
	}
	
	public String getS2() {
		return s2;
	}
	public void setS2(String s2) {
		this.s2 = s2;
	}
	
	public String getStartdate() {
		return startdate;
	}
	
	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}
	
	public Date getEnddate() {
		return enddate;
	}
	
	public void setEnddate(Date enddate) {
		this.enddate = enddate;
	}
	
	public String getEnddate_str() {
		if(enddate!=null){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			return sdf.format(enddate);
		}
		return enddate_str;
	}
	
	public void setEnddate_str(String enddate_str) {
		this.enddate_str = enddate_str;
	}
	
}
