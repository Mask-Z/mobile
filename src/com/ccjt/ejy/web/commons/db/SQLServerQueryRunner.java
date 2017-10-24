package com.ccjt.ejy.web.commons.db;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ParameterMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class SQLServerQueryRunner extends BaseQueryRunner {

	public SQLServerQueryRunner(String datasourceName) {
		super(datasourceName);
	}

	private static Logger log = LogManager
			.getLogger(SQLServerQueryRunner.class);

	public int getCount(String sql, Object... args) throws Exception {
		Connection conn = prepareConnection();
		int count = 0;
		String countsql = "select count(1) as count from ( " + sql + " ) as temp_999";
		try {
			count = this.query(conn, countsql, new ResultSetHandler<Integer>() {

				public Integer handle(ResultSet rs) throws SQLException {

					if (rs.next()) {
						return rs.getInt("count");
					} else {
						return 0;
					}
				}

			}, args);

			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return count;
	}

	/**
	 * 获取sql返回的记录数
	 * 
	 * @param sql
	 * @return
	 * @throws Exception
	 */
	public int getCount(String sql) throws Exception {
		Connection conn = prepareConnection();
		int count = 0;
		String countsql = "select count(1) as count from ( " + sql + " ) as temp_000";
		try {
			count = this.query(conn, countsql, new ResultSetHandler<Integer>() {

				public Integer handle(ResultSet rs) throws SQLException {

					if (rs.next()) {
						return rs.getInt("count");
					} else {
						return 0;
					}
				}

			}, (Object[]) null);

			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return count;
	}
	

	protected int insert(Connection conn, String sql, Object... params)
			throws Exception {

		Integer id = null;
		ScalarHandler<BigDecimal> rsh = new ScalarHandler<BigDecimal>(1);
		try{
			BigDecimal bd = insert(conn, sql, rsh,params);
			id = bd.intValue();
		}catch (Exception e) {
			throw e;
		}

		return id;
	}
	
	

	public BigDecimal getBigDecimal(String sql) throws Exception {

		BigDecimal result = null;
		Connection conn = prepareConnection();
		try {
			ScalarHandler<BigDecimal> mh = new ScalarHandler<BigDecimal>();
			result = this.query(conn, sql, mh);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return result;
	}
	
	public BigDecimal getBigDecimal(String sql,Object... args) throws Exception {

		BigDecimal result = null;
		Connection conn = prepareConnection();
		try {
			ScalarHandler<BigDecimal> mh = new ScalarHandler<BigDecimal>();
			result = this.query(conn, sql, mh,args);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return result;
	}

	/**
	 * 分页sql
	 * 
	 * @param sql
	 * @param page
	 *            页数
	 * @param rows
	 *            每页记录数
	 * @return
	 * @throws Exception
	 */
	public String pageSql(String sql, Integer page, Integer rows) throws Exception {
		StringBuffer sqlbf = new StringBuffer();
		try {
			if(page==null){
				page = 0;
			}
			if(rows == null){
				rows = 20;
			}
			
			int offset = 0;

			
			if (page >= 1) {
				offset = (page - 1) * rows;
			}
			sqlbf.append(sql).append(" offset ").append(offset).append(" rows  FETCH NEXT ").append(rows).append(" ROWS ONLY ");
//			pagesql += " offset " + offset + " rows  FETCH NEXT " + rows + "";

		} catch (Exception e) {
			throw e;
		} finally {

		}
		return sqlbf.toString();
	}

	public void fillStatement(PreparedStatement stmt, Object... params)
			throws SQLException {

		// check the parameter count, if we can
		ParameterMetaData pmd = null;

		pmd = stmt.getParameterMetaData();
		int stmtCount = pmd.getParameterCount();
		int paramsCount = params == null ? 0 : params.length;

		// 以stmtCount实际参数数量为准,paramsCount数量可大于等于stmtCount
		if (stmtCount > paramsCount) {
			throw new SQLException("Wrong number of parameters: expected "
					+ stmtCount + ", was given " + paramsCount);
		}

		// nothing to do here
		if (params == null) {
			return;
		}

		for (int i = 0; i < stmtCount; i++) {
			if (params[i] != null) {
				stmt.setObject(i + 1, params[i]);
			} else {
				int sqlType = Types.VARCHAR;
				stmt.setNull(i + 1, sqlType);
			}
		}
	}


}
