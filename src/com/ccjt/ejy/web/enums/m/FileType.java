package com.ccjt.ejy.web.enums.m;

public enum FileType {

	SW("CQJY_BaoMingNMG"),
	ZT("CQJY_BaoMingZT"),
	CCJT("CQJY_NetBaoMing"),
	GQ("CQJY_GQBaoMing"),
	ZZKG("CQJY_ZZKGBaoMing"),
	;
	private String type;
	
	private FileType(String type){
		this.type = type;
	}
	public String getType() {
		return type;
	}
	
	
}
