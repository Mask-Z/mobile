package com.ccjt.ejy.web.vo;

import java.util.Date;

import com.alibaba.fastjson.JSON;

/**
 * 竞价大厅
 * @author xxf
 *
 */

public class Jjdt implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3580179476436027210L;
	
	private String citycode;
	private long current;
	private long last_times;//剩余时间
	private String jingJiaFangShi;
	private String statusCN;
	private Date gonggaofromdate;
	private Date gonggaotodate;
	private String biaodino;
	private String infoguid;
	private String object;
	private String orgname;
	private String status;
	private Date start;
	private Date endtime;
	private Integer hasbid;
	private String projecttype;
	private String projectcontroltype;
	private String maxprice;
	private String price;
	private String project_url;
	private String orgid;
	private String sheng;
	
	private String shi;
	private String categorynum;
	private String projectguid;
	
	public String getStatusCN() {
		return statusCN;
	}
	public void setStatusCN(String statusCN) {
		this.statusCN = statusCN;
	}
	public Date getGonggaotodate() {
		return gonggaotodate;
	}
	public void setGonggaotodate(Date gonggaotodate) {
		this.gonggaotodate = gonggaotodate;
	}
	public String getBiaodino() {
		return biaodino;
	}
	public void setBiaodino(String biaodino) {
		this.biaodino = biaodino;
	}
	public String getInfoguid() {
		return infoguid;
	}
	public void setInfoguid(String infoguid) {
		this.infoguid = infoguid;
	}
	public String getObject() {
		return object;
	}
	public void setObject(String object) {
		this.object = object;
	}
	public String getOrgname() {
		return orgname;
	}
	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getStart() {
		return start;
	}
	public void setStart(Date start) {
		this.start = start;
	}
	public Date getEndtime() {
		return endtime;
	}
	public void setEndtime(Date endtime) {
		this.endtime = endtime;
	}
	public String getProjecttype() {
		return projecttype;
	}
	public void setProjecttype(String projecttype) {
		this.projecttype = projecttype;
	}
	public String getProjectcontroltype() {
		return projectcontroltype;
	}
	public void setProjectcontroltype(String projectcontroltype) {
		this.projectcontroltype = projectcontroltype;
	}
	public String getMaxprice() {
		return maxprice;
	}
	public void setMaxprice(String maxprice) {
		this.maxprice = maxprice;
	}
	public String getPrice() {
		if(price==null){
			price = "";
		}
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getProject_url() {
		return project_url;
	}
	public void setProject_url(String project_url) {
		this.project_url = project_url;
	}
	public String getCitycode() {
		return citycode;
	}
	public void setCitycode(String citycode) {
		this.citycode = citycode;
	}
	public Date getGonggaofromdate() {
		return gonggaofromdate;
	}
	public void setGonggaofromdate(Date gonggaofromdate) {
		this.gonggaofromdate = gonggaofromdate;
	}
	public Integer getHasbid() {
		return hasbid;
	}
	public void setHasbid(Integer hasbid) {
		this.hasbid = hasbid;
	}
	public String getOrgid() {
		return orgid;
	}
	public void setOrgid(String orgid) {
		this.orgid = orgid;
	}
	
	public String getCategorynum() {
		return categorynum;
	}
	public void setCategorynum(String categorynum) {
		this.categorynum = categorynum;
	}
	
	public String getSheng() {
		return sheng;
	}
	public void setSheng(String sheng) {
		this.sheng = sheng;
	}
	public String getShi() {
		return shi;
	}
	public void setShi(String shi) {
		this.shi = shi;
	}
	
	
	public long getCurrent() {
		return current;
	}
	public void setCurrent(long current) {
		this.current = current;
	}
	
	public long getLast_times() {
		return last_times;
	}
	public void setLast_times(long last_times) {
		this.last_times = last_times;
	}
	
	public String getProjectguid() {
		return projectguid;
	}
	public void setProjectguid(String projectguid) {
		this.projectguid = projectguid;
	}
	
	public String getJingJiaFangShi() {
		return jingJiaFangShi;
	}
	public void setJingJiaFangShi(String jingJiaFangShi) {
		this.jingJiaFangShi = jingJiaFangShi;
	}
	@Override
	public String toString() {
		return JSON.toJSONString(this);
	}

	
}
