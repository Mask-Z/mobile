package com.ccjt.ejy.web.vo;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSON;

/**
 * 接口返回值对象
 * @author xxf
 *
 */
public class Result implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7874687649300195677L;
	private Integer code;
	private String msg;
	private List<Map<String, Object>> data;

	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public List<Map<String, Object>> getData() {
		return data;
	}

	public void setData(List<Map<String, Object>> data) {
		this.data = data;
	}

	@Override
	public String toString() {
		return JSON.toJSONString(this);
	}
	
	

}
