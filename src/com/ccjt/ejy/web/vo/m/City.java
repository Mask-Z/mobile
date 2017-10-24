package com.ccjt.ejy.web.vo.m;

import java.util.List;

public class City implements java.io.Serializable,Cloneable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8320703667236649389L;
	private String name;
	private String code;
	private List<City> sub;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public List<City> getSub() {
		return sub;
	}
	public void setSub(List<City> sub) {
		this.sub = sub;
	}
	
	public City clone() throws CloneNotSupportedException {
		return (City) super.clone();
	}
	
	
	
	
}
