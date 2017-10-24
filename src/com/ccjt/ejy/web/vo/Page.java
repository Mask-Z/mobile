package com.ccjt.ejy.web.vo;

public class Page implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7371903405542271265L;
	private Integer total;
	private Integer currentPage;
	private Integer rows;
	private Integer totalPage;

	public Integer getTotal() {
		
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

	public Integer getCurrentPage() {
		if (currentPage == null || currentPage==0) {
			currentPage = 1;
		}
		return currentPage;
	}

	public void setCurrentPage(Integer currentPage) {
		this.currentPage = currentPage;
	}

	public Integer getRows() {
		if (rows == null) {
			rows = 8;
		}
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public Integer getTotalPage() {
		if (total != null) {
			totalPage = total / getRows();
			if (total % getRows() > 0) {
				totalPage+=1;
			}
		}else if(totalPage == null){
			totalPage = 1;
		}
		return totalPage;
	}

	public void setTotalPage(Integer totalPage) {
		this.totalPage = totalPage;
	}

}
