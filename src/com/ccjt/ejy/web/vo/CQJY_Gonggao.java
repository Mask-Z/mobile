package com.ccjt.ejy.web.vo;

import java.io.Serializable;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.enums.ProjectType;

/**
 * 成交/交易公告,(属性较少)
 *
 * @author xxf
 *
 */
public class CQJY_Gonggao implements Serializable {
//guapaiprice,cjgg_guid,jingjia_start,jingjia_end,gonggaofromdate,gonggaotodate,jygg_guid,projectNum,categorynum,title,CategoryName,click
	/**
	 *
	 */
	private static final long serialVersionUID = 7858376771665461474L;

	private String ispllr;// 1 批量挂牌
	private String jjia_status;// 竞价状态 4.竞价暂停
	private String projectguid;
	private String projectnum;// 项目编号
	private String title;// 公告标题
	private String allowmorejqxt;//1 多轮次报价
	private String ismiany;//面议
	private String isfrompricexs;//是否显示低价
	private String jingjiafangshi;//竞价方式
	private Date gonggaofromdate;// 公告开始时间
	private Date gonggaotodate;// 公告截止时间
	private Date jingjia_start;//竞价开始时间
	private Date jingjia_end;//竞价结束时间
	private String guapaiprice;// 挂牌价
	private String jygg_guid;
	private String cjgg_guid;
	private String titlepic;// 标题图片
	private String categorynum;// 栏目编码
	private String categoryname;// 栏目名称
	private Integer controltype;//项目状态   1终结  2中止  3重新挂牌  null 正常项目
	private String projectcontroltype;//项目状态   1终结  2中止  3重新挂牌  null 正常项目
	private String systemtype;
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
	private Integer click;// 点击数

	private String gonggaofromdate_str;
	private String gonggaotodate_str;

	public String getJjia_status() {
		return jjia_status;
	}

	public void setJjia_status(String jjia_status) {
		this.jjia_status = jjia_status;
	}

	public String getTitlepic() {

		if (StringUtils.isBlank(titlepic)) {
			if (getCategoryname() != null) {
				String typename = getCategoryname();
				ProjectType type = ProjectType.get(typename);
				if (type != null) {
					titlepic = type.getPic();
				}
			}
		}

		return titlepic;
	}

	public String getIspllr() {
		return ispllr;
	}

	public void setIspllr(String ispllr) {
		this.ispllr = ispllr;
	}

	public Integer getControltype() {
		return controltype;
	}

	public void setControltype(Integer controltype) {
		this.controltype = controltype;
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

	public String getCategorynum() {
		return categorynum;
	}

	public void setCategorynum(String categorynum) {
		this.categorynum = categorynum;
	}


	public String getGuapaiprice() {
		try {
			if (StringUtils.isNotBlank(guapaiprice) && !"1".equals(ismiany) && guapaiprice.indexOf("-") < 0 && guapaiprice.indexOf("*") < 0) {
				try{
					DecimalFormat df = new DecimalFormat("0.00");
					double gpj = Double.valueOf(guapaiprice);
					guapaiprice = df.format(gpj);
				}catch (Exception e) {
				}

			}else{
				guapaiprice = "-";
			}

			if("3".equals(getJingjiafangshi())){
				if(!"1".equals(getIsfrompricexs())){
					return "-";
				}
			}

			if("1".equals(ismiany)){
				guapaiprice = "面议";
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




	public String getJygg_guid() {
		return jygg_guid;
	}

	public void setJygg_guid(String jygg_guid) {
		this.jygg_guid = jygg_guid;
	}

	public String getCategoryname() {
		return categoryname;
	}

	public void setCategoryname(String categoryname) {
		this.categoryname = categoryname;
	}

	public void setStatus_name(String status_name) {
		this.status_name = status_name;
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
	 * 7 已终结<br>
	 * 8 已中止<br>
	 * 9 竞价暂停<br>
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
			} else if (status == 7) {
				return "已终结";
			} else if (status == 8) {
				return "已中止";
			} else if (status == 9) {
				return "竞价暂停";
			} else {
				return "";
			}
		}

		return "";
	}



	public String getIsfrompricexs() {
		return isfrompricexs;
	}

	public void setIsfrompricexs(String isfrompricexs) {
		this.isfrompricexs = isfrompricexs;
	}

	public String getJingjiafangshi() {
		return jingjiafangshi;
	}

	public void setJingjiafangshi(String jingjiafangshi) {
		this.jingjiafangshi = jingjiafangshi;
	}

	public String getIsmiany() {
		return ismiany;
	}

	public void setIsmiany(String ismiany) {
		this.ismiany = ismiany;
	}
	

	public String getAllowmorejqxt() {
		return allowmorejqxt;
	}

	public void setAllowmorejqxt(String allowmorejqxt) {
		this.allowmorejqxt = allowmorejqxt;
	}
	
	public String getProjectguid() {
		return projectguid;
	}

	public void setProjectguid(String projectguid) {
		this.projectguid = projectguid;
	}

	@Override
	public String toString() {
		return JSON.toJSONString(this);
	}

	public String getProjectcontroltype() {
		return projectcontroltype;
	}

	public void setProjectcontroltype(String projectcontroltype) {
		this.projectcontroltype = projectcontroltype;
	}

	public String getSystemtype() {
		return systemtype;
	}

	public void setSystemtype(String systemtype) {
		this.systemtype = systemtype;
	}
}
