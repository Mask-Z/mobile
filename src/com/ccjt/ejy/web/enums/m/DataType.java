package com.ccjt.ejy.web.enums.m;

public enum DataType {

	ZJLY("资金来源（新）"),
	GZLX("国资类型"),
	FRLX("法人类型"),
	GZJGLX("国资监管类型"),
	GZJGJG("国资监管机构"),
	ZYQTBWJG("中央其他部委监管"),
	GZJGJG_FYQ("国资监管机构（非央企）"),
	GSLX_JJXZ("公司类型（经济性质）"),
	JJLX("经济类型"),
	JJGM_JMR("经济规模（竞买人）"),
	BZ("币种"),
	ZRF_JJXZ("转让方经济性质"),
	GQJMR_JJLX("股权竞买人经济类型"),
	QYXZ("企业性质"),
	CQYWLB("产权业务类别"),
	CQLB("产权类别"),
	CZJRLFL("(财政)金融业分类"),


	GMQYJJHYFL("国民经济行业分类"),
	GQZRFJJLX("股权转让方经济类型"),
	ZRFJJXZ("转让方经济性质"),
	BDQYJCWJLX("转让方/标的企业决策文件类型"),
	JYGM("经营规模"),
	PZWJLX("批准文件类型及文号");;
	
	;
	private String type;
	private DataType(String type){
		this.type = type;
	}
	public String getType() {
		return type;
	}
	public String toString(){
		return getType();
		
	}
	
}
