package com.ccjt.ejy.web.vo;

/**
 * 节点
 * @author rocky(huangchunjie0513@163.com)
 *
 */
public class Progress {

	private String name;	//节点名称
	private String date;	//节点日期yyyy-MM-dd HH:mm:ss
	private boolean isover;	//流程节点是否已经结束
	private boolean isshow;	//是否需要显示时间
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public boolean isIsover() {
		return isover;
	}
	public void setIsover(boolean isover) {
		this.isover = isover;
	}
	public boolean isIsshow() {
		return isshow;
	}
	public void setIsshow(boolean isshow) {
		this.isshow = isshow;
	}
}
