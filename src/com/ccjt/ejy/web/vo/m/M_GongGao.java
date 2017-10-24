package com.ccjt.ejy.web.vo.m;

import java.io.Serializable;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.enums.ProjectType;
import com.ccjt.ejy.web.vo.Pic;

/**
 * 成交/交易公告
 * 
 * @author xxf
 * 
 */
public class M_GongGao implements Serializable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 2540173822278242632L;
	private String systemtype;
	private Integer count;//批量挂牌,标的数量
	private String isfrompricexs;//是否显示低价
	private String jingjiafangshi;//竞价方式
	private int currencyunit;//币种：1是元，2是万元
	
	private String zhuanrangftj;//与转让相关其他条件
	private String projectnum;// 项目编号
	private String title;// 公告标题
	private String projectstyle;// 项目类型
	private String enddate;
	private Date lastupdate;
	
	
	private String zhongdcontent;//重大事项披露
	private String chengjiaodate;//成交时间
	private Date cjdate;//成交时间
	
	private String jygg_guid;
	private String cjgg_guid;
	private String infoid;
	private String titlepic;// 标题图片
	private String categorynum;// 栏目编码
	private String categoryname;// 栏目名称
	private String ispllr;// 1 批量挂牌

	private String projectguid;// 项目编号
	private String baozhengjprice;// 保证金
	private String guapaiprice;// 挂牌价
	private Date gonggaofromdate;// 公告开始时间
	private Date gonggaotodate;// 公告截止时间
	private String currentprice;// 当前价
	private String chengjiaoprice;// 成交价
	private Integer click;// 点击数
	private Integer bmrs;// 报名人数
	private String infodate;
	
	
	/**
	 * 招标采购部分属性
	 */
	private String state;
	private String zgj;//最高价
	private String orgname;//机构名称
	private Integer baojiafangshi;
	private String biaoduanguid;//标段guid
	private String biaoduanbH;//标段编号
	private String xiangmulbcode;//项目类别
	
	private String jiaohuodate;//交货日期
	private String fabudate;//发布日期
	private Integer bjtotalnum;//报价次数
	
	
	/**
	 * 0  未开始<br>
	 * 1 报名中<br>
	 * 2 报名已截止<br>
	 * 3 竞价未开始<br>
	 * 4  竞价中<br>
	 * 5 竞价已截止<br>
	 * 6 已成交<br>
	 */
	private Integer status;//自定义状态
	private String status_name;//自定义状态
	
	
	private Date jingjia_start;//竞价开始时间
	private Date jingjia_end;//竞价结束时间

	private String s1;// 省
	private String s2;// 市
	private Integer id;
	private String content;
	private String info_date;
	private String start_date;
	private String end_date;
	private String description;// 资产描述
	private String zgtj;// 受让方资格条件
	private String project_no;
	private String baoliuprice;
	private String haspriority;// 优先购买权
	private List<Pic> picList;
	
	public String getChengjiaodate() {
		if(StringUtils.isNotBlank(chengjiaodate) && chengjiaodate.length() > 19){
			//chengjiaodate = chengjiaodate.replace("/", "-");
			chengjiaodate = chengjiaodate.substring(0,19);
		}
		
		return chengjiaodate;
	}

	public void setChengjiaodate(String chengjiaodate) {
		this.chengjiaodate = chengjiaodate;
	}

	private Integer chengjiao;// 是否成交

	private String gonggaofromdate_str;
	private String gonggaotodate_str;

	public String getTitlepic() {

		if (StringUtils.isBlank(titlepic)) {
			if (getCategoryname() != null || getProjectstyle()!=null) {
				String typename = getCategoryname()==null?getProjectstyle():getCategoryname();
				ProjectType type = ProjectType.get(typename);
				if (type != null) {
					titlepic = type.getPic();
				}
			}
		}

		return titlepic;
	}

	public void setTitlepic(String titlepic) {
		this.titlepic = titlepic;
	}

	public String getProjectnum() {
		return projectnum;
	}

	public void setProjectnum(String projectnum) {
		this.projectnum = projectnum;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getProjectstyle() {

		ProjectType pt = ProjectType.get(projectstyle);
		if(pt!=null){
			return pt.getName();
		}
		
		return projectstyle;
	}

	public void setProjectstyle(String projectstyle) {
		this.projectstyle = projectstyle;
	}

	public String getEnddate() {
		if(StringUtils.isNotBlank(enddate) && enddate.length() > 19){
			enddate = enddate.substring(0,19);
		}
		return enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public Date getLastupdate() {
		return lastupdate;
	}

	public void setLastupdate(Date lastupdate) {
		this.lastupdate = lastupdate;
	}

	public String getInfoid() {
		return infoid;
	}

	public void setInfoid(String infoid) {
		this.infoid = infoid;
	}

	public String getCategorynum() {
		return categorynum;
	}

	public void setCategorynum(String categorynum) {
		this.categorynum = categorynum;
	}

	public String getInfodate() {
		try {
			if (StringUtils.isNotBlank(infodate)) {
				SimpleDateFormat sdf = new SimpleDateFormat(
						"yyyy-MM-dd HH:mm:ss");
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
				infodate = sdf1.format(sdf.parse(infodate));
			}
		} catch (Exception e) {
		}
		return infodate;
	}

	public void setInfodate(String infodate) {
		this.infodate = infodate;
	}

	public String getBaozhengjprice() {
		return baozhengjprice;
	}

	public void setBaozhengjprice(String baozhengjprice) {
		this.baozhengjprice = baozhengjprice;
	}

	public String getGuapaiprice() {
		try {
			if (StringUtils.isNotBlank(guapaiprice) && guapaiprice.indexOf("-")<0 && guapaiprice.indexOf("*") < 0) {
				DecimalFormat df = new DecimalFormat("0.00");
				double gpj = Double.valueOf(guapaiprice);
				guapaiprice = df.format(gpj);
			}else{
				guapaiprice = "-";
			}
			
			if("3".equals(getJingjiafangshi())){
				if(!"1".equals(getIsfrompricexs())){
					return "-";
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return guapaiprice;
	}

	public void setGuapaiprice(String guapaiprice) {
		this.guapaiprice = guapaiprice;
	}

	public Date getGonggaofromdate() {
		return gonggaofromdate;
	}

	public void setGonggaofromdate(Date gonggaofromdate) {
		this.gonggaofromdate = gonggaofromdate;
	}

	public Date getGonggaotodate() {
		return gonggaotodate;
	}

	public void setGonggaotodate(Date gonggaotodate) {
		this.gonggaotodate = gonggaotodate;
	}

	public String getChengjiaoprice() {
		
		try {
			if (StringUtils.isNotBlank(chengjiaoprice)) {
				DecimalFormat df = new DecimalFormat("0.00");
				double gpj = Double.valueOf(chengjiaoprice);
				chengjiaoprice = df.format(gpj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return chengjiaoprice;
	}

	public void setChengjiaoprice(String chengjiaoprice) {
		this.chengjiaoprice = chengjiaoprice;
	}

	public String getProjectguid() {
		return projectguid;
	}

	public void setProjectguid(String projectguid) {
		this.projectguid = projectguid;
	}

	public String getCurrentprice() {
		try {
			if (StringUtils.isBlank(currentprice)) {
				currentprice = getGuapaiprice();
			}
			if (StringUtils.isNotBlank(currentprice) && currentprice.indexOf("-") < 0) {
				
				DecimalFormat df = new DecimalFormat("0.00");
				double gpj = Double.valueOf(currentprice);
				currentprice = df.format(gpj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return currentprice;
	}

	public void setCurrentprice(String currentprice) {
		this.currentprice = currentprice;
	}

	public String getGonggaofromdate_str() {
		if (gonggaofromdate != null) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			return sdf.format(gonggaofromdate);
		}
		return "";
	}

	public void setGonggaofromdate_str(String gonggaofromdate_str) {

		this.gonggaofromdate_str = gonggaofromdate_str;
	}

	public String getGonggaotodate_str() {
		if (gonggaotodate != null) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			return sdf.format(gonggaotodate);
		}
		return "";
	}

	public void setGonggaotodate_str(String gonggaotodate_str) {
		this.gonggaotodate_str = gonggaotodate_str;
	}

	public Integer getClick() {
		return click;
	}

	public void setClick(Integer click) {
		this.click = click;
	}

	public Integer getChengjiao() {
		return chengjiao;
	}

	public void setChengjiao(Integer chengjiao) {
		this.chengjiao = chengjiao;
	}

	public Integer getBmrs() {
		if(bmrs==null){
			bmrs = 0;
		}
		return bmrs;
	}

	public void setBmrs(Integer bmrs) {
		this.bmrs = bmrs;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getInfo_date() {
		return info_date;
	}

	public void setInfo_date(String info_date) {
		this.info_date = info_date;
	}

	public String getStart_date() {
		return start_date;
	}

	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}

	public String getEnd_date() {
		return end_date;
	}

	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}

	public String getDescription() {
		if(StringUtils.isBlank(description)){
			return "详见公告";
		}
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getZgtj() {
		if(StringUtils.isBlank(zgtj)){
			return "详见公告";
		}
		return zgtj;
	}

	public void setZgtj(String zgtj) {
		this.zgtj = zgtj;
	}

	public String getProject_no() {
		return project_no;
	}

	public void setProject_no(String project_no) {
		this.project_no = project_no;
	}

	public String getBaoliuprice() {
		return baoliuprice;
	}

	public void setBaoliuprice(String baoliuprice) {
		this.baoliuprice = baoliuprice;
	}

	public String getHaspriority() {
		return haspriority;
	}

	public void setHaspriority(String haspriority) {
		this.haspriority = haspriority;
	}

	public List<Pic> getPicList() {
		return picList;
	}

	public void setPicList(List<Pic> picList) {
		this.picList = picList;
	}

	public String getJygg_guid() {
		return jygg_guid;
	}

	public void setJygg_guid(String jygg_guid) {
		this.jygg_guid = jygg_guid;
	}

	public String getS1() {
		return s1;
	}

	public void setS1(String s1) {
		this.s1 = s1;
	}

	public String getS2() {
		return s2;
	}

	public void setS2(String s2) {
		this.s2 = s2;
	}

	public String getCategoryname() {
		return categoryname;
	}

	public void setCategoryname(String categoryname) {
		this.categoryname = categoryname;
	}

	public String getIspllr() {
		return ispllr;
	}

	public void setIspllr(String ispllr) {
		this.ispllr = ispllr;
	}
	
	public Date getJingjia_start() {
		return jingjia_start;
	}

	public void setJingjia_start(Date jingjia_start) {
		this.jingjia_start = jingjia_start;
	}

	public Date getJingjia_end() {
		return jingjia_end;
	}

	public void setJingjia_end(Date jingjia_end) {
		this.jingjia_end = jingjia_end;
	}

	public String getCjgg_guid() {
		return cjgg_guid;
	}

	public void setCjgg_guid(String cjgg_guid) {
		this.cjgg_guid = cjgg_guid;
	}
	/**
	 * 0  未开始<br>
	 * 1 报名中<br>
	 * 2 报名已截止<br>
	 * 3 竞价未开始<br>
	 * 4  竞价中<br>
	 * 5 竞价已截止<br>
	 * 6 已成交<br>
	 */
	public Integer getStatus() {
		return status;
	}
	/**
	 * 0  未开始<br>
	 * 1 报名中<br>
	 * 2 报名已截止<br>
	 * 3 竞价未开始<br>
	 * 4  竞价中<br>
	 * 5 竞价已截止<br>
	 * 6 已成交<br>
	 */
	public void setStatus(Integer status) {
		this.status = status;
	}

	
	/**
	 * 0  未开始<br>
	 * 1 报名中<br>
	 * 2 报名已截止<br>
	 * 3 竞价未开始<br>
	 * 4  竞价中<br>
	 * 5 竞价已截止<br>
	 * 6 已成交<br>
	 */
	public String getStatus_name() {

		if(status!=null){

			if (status == 0) {
				return "未开始";
			} else if (status == 1) {
				return "报名中";
			} else if (status == 2) {
				return "报名已截止";
			} else if (status == 3) {
				return "竞价未开始";
			} else if (status == 4) {
				return "竞价中";
			} else if (status == 5) {
				return "竞价已截止";
			} else if (status == 6) {
				return "已成交";
			} else {
				return "";
			}
		}

		return "";
	}

	public String getSystemtype() {
		return systemtype;
	}

	public void setSystemtype(String systemtype) {
		this.systemtype = systemtype;
	}

	public int getCurrencyunit() {
		return currencyunit;
	}

	public void setCurrencyunit(int currencyunit) {
		this.currencyunit = currencyunit;
	}

	public void setStatus_name(String status_name) {
		this.status_name = status_name;
	}

	public String getZhongdcontent() {
		if(StringUtils.isBlank(zhongdcontent)){
			return "详见公告";
		}
		return zhongdcontent;
	}

	public void setZhongdcontent(String zhongdcontent) {
		this.zhongdcontent = zhongdcontent;
	}

	
	public String getJingjiafangshi() {
		return jingjiafangshi;
	}

	public void setJingjiafangshi(String jingjiafangshi) {
		this.jingjiafangshi = jingjiafangshi;
	}
	
	public String getState() {
		if(state==null){
			state = "";
		}
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getZgj() {
		
		try {
			if (StringUtils.isNotBlank(zgj) && zgj.indexOf("-")<0) {
				DecimalFormat df = new DecimalFormat("0.00");
				double temp_zgj = Double.valueOf(zgj);
				if(temp_zgj > 0){
					zgj = df.format(temp_zgj);
				}else{
					zgj = "-";
				}
				
			}else{
				zgj = "-";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return zgj;
	}

	public void setZgj(String zgj) {
		this.zgj = zgj;
	}

	public String getOrgname() {
		return orgname;
	}

	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}

	public Integer getBaojiafangshi() {
		return baojiafangshi;
	}

	public void setBaojiafangshi(Integer baojiafangshi) {
		this.baojiafangshi = baojiafangshi;
	}

	public String getBiaoduanguid() {
		return biaoduanguid;
	}

	public void setBiaoduanguid(String biaoduanguid) {
		this.biaoduanguid = biaoduanguid;
	}

	public String getBiaoduanbH() {
		return biaoduanbH;
	}

	public void setBiaoduanbH(String biaoduanbH) {
		this.biaoduanbH = biaoduanbH;
	}

	public String getXiangmulbcode() {
		return xiangmulbcode;
	}

	public void setXiangmulbcode(String xiangmulbcode) {
		this.xiangmulbcode = xiangmulbcode;
	}

	public String getJiaohuodate() {
		return jiaohuodate;
	}

	public void setJiaohuodate(String jiaohuodate) {
		this.jiaohuodate = jiaohuodate;
	}

	public String getFabudate() {
		return fabudate;
	}

	public void setFabudate(String fabudate) {
		this.fabudate = fabudate;
	}

	public Integer getBjtotalnum() {
		return bjtotalnum;
	}

	public void setBjtotalnum(Integer bjtotalnum) {
		this.bjtotalnum = bjtotalnum;
	}
	
	public String getZhuanrangftj() {
		return zhuanrangftj;
	}

	public void setZhuanrangftj(String zhuanrangftj) {
		this.zhuanrangftj = zhuanrangftj;
	}

	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}
	
	public Date getCjdate() {
		return cjdate;
	}

	public void setCjdate(Date cjdate) {
		this.cjdate = cjdate;
	}
	
	public String getIsfrompricexs() {
		return isfrompricexs;
	}

	public void setIsfrompricexs(String isfrompricexs) {
		this.isfrompricexs = isfrompricexs;
	}

	@Override
	public String toString() {
		return JSON.toJSONString(this);
	}

}
