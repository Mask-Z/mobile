package com.ccjt.ejy.web.vo;

import java.util.Map;

public class UserMap implements java.io.Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -6703450884785314260L;
	private Map<String, String> info;

	public Map<String, String> getInfo() {
		return info;
	}

	public void setInfo(Map<String, String> info) {
		this.info = info;
	}	
}
