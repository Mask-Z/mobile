package com.ccjt.ejy.web.vo;

public class User implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1522222229702536117L;
	private int id;
	private Integer age;
	private String name;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public Integer getAge() {
		return age;
	}
	public void setAge(Integer age) {
		this.age = age;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
}
