package com.ccjt.ejy.web.commons.interceptor;

public class NOTLoginException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5430244099154408004L;
	
	public NOTLoginException(){
		super();
	}
	
	public NOTLoginException(String msg){
		super(msg);
	}

}
