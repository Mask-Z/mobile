package com.ccjt.ejy.web.commons.db.connection;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import org.apache.commons.dbutils.DbUtils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class DruidConnectionProvide implements ConnectionProvide {

	private static Logger log = LogManager.getLogger(DruidConnectionProvide.class);
	private static final ThreadLocal<Connection> threadLocal = new ThreadLocal<Connection>();

	private static boolean autoCommit = false;
	private static com.alibaba.druid.pool.DruidDataSource cpds = null;
	private static String jdbcUrl = null;
	private static String user = null;
	private static String password = null;
	private static final int initialPoolSize = 10;
	private static final int maxPoolSize = 100;
	private static final int minIdle = 10;

	static {
		InputStream is = null;
		Properties dbProps = new Properties();
		try {

			is = DruidConnectionProvide.class.getResourceAsStream("/jdbc.properties");

			dbProps.load(is);
			jdbcUrl = dbProps.getProperty("url");
			user = dbProps.getProperty("user");
			password = dbProps.getProperty("password");
			DruidConnectionProvide.cpds = new com.alibaba.druid.pool.DruidDataSource();
			DruidConnectionProvide.cpds.setUrl(jdbcUrl);
			DruidConnectionProvide.cpds.setUsername(user);
			DruidConnectionProvide.cpds.setPassword(password);
			DruidConnectionProvide.cpds.setInitialSize(initialPoolSize);
			DruidConnectionProvide.cpds.setMinIdle(minIdle);
			DruidConnectionProvide.cpds.setMaxActive(maxPoolSize);
			DruidConnectionProvide.cpds.setMaxWait(10000);
			DruidConnectionProvide.cpds.setTimeBetweenEvictionRunsMillis(60000);
			DruidConnectionProvide.cpds.setMinEvictableIdleTimeMillis(300000);
			DruidConnectionProvide.cpds.setValidationQuery("SELECT 'x'");
			DruidConnectionProvide.cpds.setTestWhileIdle(true);
			DruidConnectionProvide.cpds.setTestOnBorrow(false);
			DruidConnectionProvide.cpds.setPoolPreparedStatements(true);
			DruidConnectionProvide.cpds.setMaxPoolPreparedStatementPerConnectionSize(20);
			log.info("初始化连接池成功:url=" + jdbcUrl + " user = " + user + " passowrd=****");
		} catch (Exception e) {
			log.error("jdbc资源文件load出错:",e);
			e.printStackTrace();
		}finally{
			try{
				if(is!=null)is.close();
			}catch (Exception e) {
			}
			
		}
	}


	public Connection getConnection() {
		Connection conn = (Connection) threadLocal.get();

		if (conn == null) {
			try {
				conn = cpds.getConnection();
				conn.setAutoCommit(autoCommit);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			threadLocal.set(conn);
			log.info("获取连接.." + conn.hashCode());
		}

		return conn;
	}

	
	public Connection getJDBCConnection() {
		Connection conn = null;

		try {
			
			conn = DriverManager.getConnection(jdbcUrl, user,
					password);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return conn;
	}

	public void close() {
		Connection conn = (Connection) threadLocal.get();
		threadLocal.set(null);

		if (conn != null) {
			try {
				DbUtils.close(conn);
				log.info("关闭连接.." + conn.hashCode());
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public void commit() {
		try {
			Connection conn = (Connection) threadLocal.get();
			if (conn != null) {
				conn.commit();
				log.info("transaction is commit....");
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}

	public void rollback() {
		try {
			Connection conn = (Connection) threadLocal.get();
			if (conn != null) {
				conn.rollback();
				log.info("transaction is rollback....");
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}


}