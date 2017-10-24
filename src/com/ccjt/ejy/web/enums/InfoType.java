package com.ccjt.ejy.web.enums;

/**
 * 产权交易,项目类别
 * @author xxf
 *
 */
public enum InfoType {

	cqjy_xxgg("产权交易信息公告","003"),
	
//	产权交易交易公告_房屋租赁	
	
	cqjy_gzbc("产权交易更正补充" , "001007002"),
	
	zbcg_zbgg_gc("工程" , "002001001"),
	zbcg_zbgg_hw("货物" , "002001002"),
	zbcg_zbgg_fw("服务" , "002001003"),

	zbcg_cjgg_gc("招标采购中标公示_工程" , "002002001"),
	zbcg_cjgg_hw("招标采购中标公示_货物" , "002002002"),
	zbcg_cjgg_fw("招标采购中标公示_服务" , "002002003"),
	
	zdtj_cqjy("重点推荐项目_产权交易" , "031001"),
	zdtj_zbcg("重点推荐项目_招标采购" , "031002"),
	zdtj_gqypl("重点推荐项目_股权交易预披露" , "031003"),
	
	cqjy_jygg_fdc("房地产","001001001"),
	cqjy_jygg_gq("股权" , "001001002"),
	cqjy_jygg_cl("二手车	" , "001001003"),
	cqjy_jygg_fjwz("废旧物资" , "001001004"),
	cqjy_jygg_ls("粮食" , "001001005"),
	cqjy_jygg_qt("其他资产" , "001001006"),
	cqjy_jygg_gmcp("工美藏品" , "001001007"),
	cqjy_jygg_hmjy("花木交易" , "001001008"),
	cqjy_jygg_fczz("房产招租" , "001001009"),
	cqjy_jygg_cb("船舶" , "001001010"),
	cqjy_jygg_td("土地" , "001001011"),
	
	cqjy_jygg_essb("二手设备" , "001001018"),
	cqjy_jygg_kq("矿权" , "001001014"),
	cqjy_jygg_zq("债权" , "001001013"),
	cqjy_jygg_zzkg("增资扩股" , "001001012"),
	
	
	cqjy_cjgg_fdc("产权交易成交公告_房地产	" , "001002001"),
	cqjy_cjgg_gq("产权交易成交公告_股权" , "001002002"),
	cqjy_cjgg_cl("产权交易成交公告_二手车	" , "001002003"),
	cqjy_cjgg_fjwz("产权交易成交公告_废旧物资" , "001002004"),
	cqjy_cjgg_ls("产权交易成交公告_粮食" , "001002005"),
	cqjy_cjgg_qt("产权交易成交公告_其他资产" , "001002006"),
	cqjy_cjgg_gmcp("产权交易成交公告_工美藏品" , "001002007"),
	cqjy_cjgg_hmjy("产权交易成交公告_花木交易" , "001002008"),
//	cqjy_cjgg_fczr("产权交易成交公告_房产转让" , "001002009"),
	cqjy_cjgg_fczz("产权交易成交公告_房产招租" , "001002009"),
	cqjy_cjgg_cb("产权交易成交公告_船舶" , "001002010"),
	cqjy_cjgg_td("产权交易成交公告_土地" , "001002011"),
	cqjy_cjgg_zzkg("产权交易成交公告_增资扩股" , "001002012"),
	
	cqjy_cjgg_zq("产权交易成交公告_债权 " , "001002013"),
	cqjy_cjgg_kg("产权交易成交公告_矿权" , "001002014"),
	
	cqjy_cjgg_essb("产权交易成交公告_二手设备" , "001002018"),
	
	cqgg("产权公告" , "024"),
	
	ypl_gq("股权预披露" , "001003001"),
	ypl_zq("债权预披露" , "001003002"),
	ypl_fdc("房地产预披露	" , "001003003"),
	ypl_fczz("房产招租预披露" , "001003004"),
	ypl_cl("二手车预披露" , "001003005"),
	ypl_fjwz("废旧物资预披露" , "001003006"),
	
	pic_news("图片新闻" , "018"),
	PTGG("平台公告","030"),
	YJZX("业界资讯","006"),
	
	HYGG("会员公告","004003"),
	ZDGZ("制度规则","004001"),
	HYBZ("会员帮助","004002"),
	RJXZ("软件下载","036"),
	
	SPJC_CQJY("视频教程","035001"),
	SPJC_ZBCG("视频教程","035002"),
	CZZN_CQJY("操作指南","034001"),
	CZZN_ZBCG("操作指南","034002"),
	
	CQJY_ZCFG("产权交易-政策法规","032001"),
	ZBCG_ZCFG("招标采购-政策法规","032002"),
	
	
	BGT("曝光台","028"),

	
	ZBCGGZ("招标采购规则","027002"),
	CQJYGZ("产权交易规则","027001");
	
	private String code;
	private String name;
	
	private InfoType(String name,String code){
		this.code = code;
		this.name = name;
	}
	
	public String getCode() {
		return code;
	}
	
	public String getName() {
		return name;
	}
	
	public static InfoType get(String code){
		InfoType type = null;
		for(InfoType it : InfoType.values()){
			if(it.getCode().equals(code)){
				type = it;
			}
		}
		return type;
	}
	
	public static InfoType getByName(String name){
		InfoType type = null;
		for(InfoType it : InfoType.values()){
			if(it.getName().equals(name)){
				type = it;
			}
		}
		return type;
	}
	
	
}
