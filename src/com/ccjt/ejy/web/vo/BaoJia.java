package com.ccjt.ejy.web.vo;

import org.apache.commons.lang3.StringUtils;

public class BaoJia implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5553593754557625291L;
	private String price;
	private String bj_time;
	private String code;

	public String getPrice() {
		try{
			if (StringUtils.isNotBlank(price)) {
				double p = Double.valueOf(price);
				return String.format("%.2f", p);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}

		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getBj_time() {
		return bj_time;
	}

	public void setBj_time(String bj_time) {
		this.bj_time = bj_time;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

}
