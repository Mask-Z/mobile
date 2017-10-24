package com.ccjt.ejy.web.commons.db.connection;

import java.sql.Connection;

public class ConnectionFactory {

	static{
		connectionProvide = new DruidConnectionProvide();
	}
	
	private ConnectionFactory(){
		
	}
	private static ConnectionProvide connectionProvide;

	public static ConnectionProvide getConnectionProvide() {
		return connectionProvide;
	}

	public void setConnectionProvide(ConnectionProvide connectionProvide) {
		ConnectionFactory.connectionProvide = connectionProvide;
	}

	public static Connection getConnection() {
		return getConnectionProvide().getConnection();
	}

	public static Connection getJDBCConnection() {
		return getConnectionProvide().getJDBCConnection();
	}

	public static void rollback() {
		getConnectionProvide().rollback();
	}

	public static void commit() {
		getConnectionProvide().commit();
	}

	public static void close() {
		getConnectionProvide().close();
	}

}
