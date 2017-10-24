package com.ccjt.ejy.web.commons.db.connection;

import java.sql.Connection;

public interface ConnectionProvide {

	public Connection getConnection();

	/**
	 * 提供非连接池维护的jdbc链接,需要自行回收各类资源
	 * @return
	 */
	public Connection getJDBCConnection();

	public void rollback();

	public void commit();

	public void close();

}
