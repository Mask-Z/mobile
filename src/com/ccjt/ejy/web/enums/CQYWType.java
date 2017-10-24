package com.ccjt.ejy.web.enums;

import org.apache.commons.lang3.StringUtils;

/**
 * 产权业务类型
 * @author xxf
 *
 */
public enum CQYWType {

	GYZC("03","国有企业资产"),
	MYZC("04","民营企业资产"),
	JRZC("05","金融企业资产"),
	SSZC("01","涉诉资产"),
	XZSYZC("02","行政事业单位资产"),
	;
	private String name;
	private String code;
	
	private CQYWType(String code,String name){
		this.code = code;
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public String getCode() {
		return code;
	}
	
	public static CQYWType getCQYWType(String value){
		CQYWType type = null;
		if(StringUtils.isNotBlank(value)){
			for(CQYWType t : CQYWType.values()){
				if(t.getCode().equals(value) || t.getName().equals(value)){
					type = t;
				}
			}
		}
		return type;
	}
}
