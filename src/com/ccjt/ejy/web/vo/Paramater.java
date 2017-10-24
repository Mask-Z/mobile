package com.ccjt.ejy.web.vo;

import java.util.List;
import java.util.Map;

/**
 * 接口参数对象
 * @author xxf
 *
 */
public class Paramater implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4100571187502705535L;
	private String type;
	private Object data;
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Object getData() {
		return data;
	}
	public void setData(Object data) {
		this.data = data;
	}

	

}
