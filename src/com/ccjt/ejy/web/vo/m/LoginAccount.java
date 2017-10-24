package com.ccjt.ejy.web.vo.m;

public class LoginAccount implements java.io.Serializable, Cloneable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -1000703662136649600L;
	private String displayName;
	private String userGuid;
	private String dogNum;
	private String danWeiGuid;
	private String danWeiName;
	private String danWeiType;
	private String companyPhone;
	private String mobilePhone;
	private String idCard;
	private boolean isFinish;
	private String memberType;

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getUserGuid() {
		return userGuid;
	}

	public void setUserGuid(String userGuid) {
		this.userGuid = userGuid;
	}

	public String getDogNum() {
		return dogNum;
	}

	public void setDogNum(String dogNum) {
		this.dogNum = dogNum;
	}

	public String getDanWeiGuid() {
		return danWeiGuid;
	}

	public void setDanWeiGuid(String danWeiGuid) {
		this.danWeiGuid = danWeiGuid;
	}

	public String getDanWeiName() {
		return danWeiName;
	}

	public void setDanWeiName(String danWeiName) {
		this.danWeiName = danWeiName;
	}

	public String getDanWeiType() {
		return danWeiType;
	}

	public void setDanWeiType(String danWeiType) {
		this.danWeiType = danWeiType;
	}

	public String getCompanyPhone() {
		return companyPhone;
	}

	public void setCompanyPhone(String companyPhone) {
		this.companyPhone = companyPhone;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

	public boolean getIsFinish() {
		return isFinish;
	}

	public void setIsFinish(boolean isFinish) {
		this.isFinish = isFinish;
	}

	public String getMemberType() {
		return memberType;
	}

	public void setMemberType(String memberType) {
		this.memberType = memberType;
	}

	@Override
	public String toString() {
		return "LoginAccount [displayName=" + displayName + ", userGuid="
				+ userGuid + ", dogNum=" + dogNum + ", danWeiGuid="
				+ danWeiGuid + ", danWeiName=" + danWeiName + ", danWeiType="
				+ danWeiType + ", companyPhone=" + companyPhone
				+ ", mobilePhone=" + mobilePhone + ", idCard=" + idCard
				+ ", isFinish=" + isFinish + ", memberType=" + memberType + "]";
	}

}
