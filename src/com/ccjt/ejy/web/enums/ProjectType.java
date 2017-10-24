package com.ccjt.ejy.web.enums;

/**
 * 产权交易,项目类别
 * @author xxf
 *
 */
public enum ProjectType {
	
	/**
	 * FC	房地产
FCZZ	房产招租
GQ	股权
ZZKG	增资扩股
CL	二手车
WZ	废旧物资
LS	粮食
CP	工美藏品
5	花木交易
zq	债权
kq	矿权
LQ	林权
NCCQ	农村产权
ADQ	广告经营权
QT	其他
	 */

	FC("FC","房地产","image/default/fc.png"),
	GQ("GQ","股权","image/default/gq.png"),
	CL("CL","二手车","image/default/esc.png"),
	WZ("WZ","废旧物资","image/default/fjwz.png"),
	LS("LS","粮食","image/default/ls.png"),
	ZQ("ZQ","债权","image/default/zq.png"),
	KQ("KQ","矿权","image/default/kq.png"),
	LQ("LQ","林权","image/default/zq.png"),
	NCCQ("NCCQ","农村产权","image/default/nccq.png"),
	ADQ("ADQ","广告经营权","image/default/asq.png"),
	QTZC("QTZC","其他资产","image/default/qt.png"),
	QT("QT","其他","image/default/qt.png"),
	CP("CP","工美藏品","image/default/cp.png"),
	HM("5","花木交易","image/default/hm.png"),
	TD("TD","土地","image/default/td.png"),
	FCZZ("FCZZ","房产招租","image/default/fczz.png"),
	ZZKG("ZZKG","增资扩股","image/default/zzkg.png"),
	CB("CB","船舶","image/default/zzkg.png"),
	
	GC("B","工程","image/default/gc.png"),
	FW("C","服务","image/default/fw.png"),
	HW("A","货物","image/default/fw.png"),
	ESSB("ESSB","二手设备" , "image/default/essb.png")
	
	
	;;
	private String code;
	private String pic;
	private String name;
	private ProjectType(String code,String name,String pic){
		this.code = code;
		this.name = name;
		this.pic = pic;
	}
	
	public String getCode() {
		return code;
	}
	public String getName() {
		return name;
	}
	public String getPic() {
		return pic;
	}
	
	public static ProjectType get(String code){
		
		for(ProjectType type : ProjectType.values()){
			if(type.getCode().toLowerCase().equals(code.toLowerCase()) || type.getName().equals(code)){
				return type;
			}
		}
		return null;
	}
	
}
