package com.ccjt.ejy.web.vo;

import java.util.List;

public class BaoJia_Pllr implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4725206054187231239L;
	private String projectname;
	private String projectid;
	
	private List<BaoJia> baojiaList;
	
	
	public String getProjectname() {
		return projectname;
	}
	public void setProjectname(String projectname) {
		this.projectname = projectname;
	}
	public String getProjectid() {
		return projectid;
	}
	public void setProjectid(String projectid) {
		this.projectid = projectid;
	}
	public List<BaoJia> getBaojiaList() {
		return baojiaList;
	}
	public void setBaojiaList(List<BaoJia> baojiaList) {
		this.baojiaList = baojiaList;
	}
	
	
}
