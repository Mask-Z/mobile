package com.ccjt.ejy.web.vo.m;

import java.util.List;

public class Dict implements java.io.Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3527672069056881216L;
	private String code;
	private String value;
	private List<Dict> dictList;
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public List<Dict> getDictList() {
		return dictList;
	}
	public void setDictList(List<Dict> dictList) {
		this.dictList = dictList;
	}
	
	

}
