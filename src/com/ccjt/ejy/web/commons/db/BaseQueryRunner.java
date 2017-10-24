package com.ccjt.ejy.web.commons.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ColumnListHandler;
import org.apache.commons.dbutils.handlers.MapHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.ccjt.ejy.web.commons.db.connection.ConnectionFactory;

/**
 * 常用sql方法的集合,可根据需要自行扩展
 * @author xxf
 *
 */
public abstract class BaseQueryRunner extends QueryRunner {

	private static Logger log = LogManager.getLogger(BaseQueryRunner.class);

	public BaseQueryRunner(String datasourceName){
		//TODO 多数据源支持
	}
	
	public BaseQueryRunner(){
	}
	
    protected Connection prepareConnection() throws SQLException {
        return ConnectionFactory.getConnection();
    }

    /**
     * 新增方法,不同的数据库insert后对于自增主键返回的数据类型是不同的<br>
     * MySQL 返回LONG<br>
     * SQL server 返回bigdeimel<br>
     * @param conn
     * @param sql
     * @param params
     * @return
     * @throws Exception
     */
	abstract int insert(Connection conn, String sql, Object... params) throws Exception;

	/**
	 * insert 方法,返回新增记录的id <br>
	 * 需要数据库驱动支持
	 * 
	 * @param sql
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int insert(String sql, Object... params) throws Exception {
		Connection conn = prepareConnection();
		Integer id = null;
		try {
			id = insert(conn, sql, params);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		}
		return id;
	}

	/**
	 * 批量新增
	 * 
	 * @param sql
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int[] batchInsert(String sql, Object[][] params) throws SQLException {
		Connection conn = prepareConnection();
		return this.batchInsert(conn, sql, params);
	}

	private int[] batchInsert(Connection conn, String sql, Object[][] params)
			throws SQLException {

		int[] id = batch(conn,sql, params);
		
		return id;
	}

	/**
	 * 返回list,list内为map ,map的key=列名 value=列值
	 * 
	 * @param sql
	 * @param rows
	 *            起始行数
	 * @param count
	 *            返回的记录数 若为0 则返回全部记录
	 * @param args
	 *            sql参数
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> mapList(String sql, int page, int count,
			Object... args) throws Exception {

		List<Map<String, Object>> l = null;
		page = page == 0 ? 1 : page;
		Connection conn = prepareConnection();
		try {
			MapListHandler mh = new MapListHandler();
			l = this.query(conn, this.pageSql(sql, page, count), mh, args);

			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return l;
	}

	/**
	 * 返回list,内部对象为map ,map的key=列名 value=列值
	 * 
	 * @param sql
	 * @param rows
	 *            起始行数
	 * @param count
	 *            返回的记录数 若为0 则返回全部记录
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> mapList(String sql, int page, int count)
			throws Exception {

		List<Map<String, Object>> l = null;
		Connection conn = prepareConnection();
		page = page == 0 ? 1 : page;
		try {
			MapListHandler mh = new MapListHandler();
			l = this.query(conn, this.pageSql(sql, page, count), mh);

			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return l;
	}

	/**
	 * 返回list,list内为map ,map的key=列名 value=列值
	 * 
	 * @param sql
	 * @param rows
	 *            起始行数
	 * @param count
	 *            返回的记录数 若为0 则返回全部记录
	 * @param args
	 *            sql参数
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> mapList(String sql, Object... args)
			throws Exception {

		List<Map<String, Object>> l = null;
		Connection conn = prepareConnection();
		try {
			MapListHandler mh = new MapListHandler();
			l = this.query(conn, sql, mh, args);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return l;
	}

	/**
	 * 返回list,内部对象为map ,map的key=列名 value=列值
	 * 
	 * @param sql
	 * @param rows
	 *            起始行数
	 * @param count
	 *            返回的记录数 若为0 则返回全部记录
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> mapList(String sql) throws Exception {

		List<Map<String, Object>> l = null;
		Connection conn = prepareConnection();
		try {
			MapListHandler mh = new MapListHandler();
			l = this.query(conn, sql, mh);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return l;
	}

	/**
	 * 
	 * @param <T>
	 * @param sql
	 * @param rows
	 * @param count
	 * @param bean
	 * @param args
	 * @return
	 * @throws Exception
	 */
	public <T> List<T> beanList(String sql, int page, int count, Class<T> bean,
			Object... args) throws Exception {

		List<T> l = null;
		page = page == 0 ? 1 : page;
		Connection conn = prepareConnection();
		try {
			BeanListHandler<T> rsh = new BeanListHandler<T>(bean);
			l = this.query(conn, this.pageSql(sql, page, count), rsh, args);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return l;
	}

	public <T> List<T> beanList(String sql, Class<T> bean, Object... args)
			throws Exception {

		List<T> l = null;
		Connection conn = prepareConnection();
		try {
			BeanListHandler<T> rsh = new BeanListHandler<T>(bean);
			l = this.query(conn, sql, rsh, args);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return l;
	}

	public <T> List<T> beanList(String sql, int page, int count, Class<T> bean)
			throws Exception {

		List<T> l = null;
		page = page == 0 ? 1 : page;
		Connection conn = prepareConnection();
		try {
			BeanListHandler<T> rsh = new BeanListHandler<T>(bean);
			String pasql = this.pageSql(sql, page, count);
			l = this.query(conn, pasql, rsh);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return l;
	}

	public <T> List<T> beanList(String sql, Class<T> bean) throws Exception {

		List<T> l = null;
		Connection conn = prepareConnection();
		try {
			BeanListHandler<T> rsh = new BeanListHandler<T>(bean);
			l = this.query(conn, sql, rsh);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return l;
	}

	public <T> T bean(String sql, Class<T> bean, Object... args)
			throws Exception {

		T obj = null;
		Connection conn = prepareConnection();
		try {
			BeanHandler<T> mh = new BeanHandler<T>(bean);
			obj = this.query(conn, sql, mh, args);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return obj;
	}

	/**
	 * 将sql结果转换成bean返回, 如果sql返回多条记录,只返回第一条记录
	 * 
	 * @param <T>
	 * @param sql
	 * @param bean
	 * @return
	 * @throws Exception
	 */
	public <T> T bean(String sql, Class<T> bean) throws Exception {

		T obj = null;
		Connection conn = prepareConnection();
		try {
			BeanHandler<T> mh = new BeanHandler<T>(bean);
			obj = this.query(conn, sql, mh);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return obj;
	}

	public Map<String, Object> map(String sql, Object... args) throws Exception {

		Map<String, Object> m = null;
		Connection conn = prepareConnection();
		try {
			MapHandler mh = new MapHandler();
			m = this.query(conn, sql, mh, args);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return m;
	}

	public Map<String, Object> map(String sql) throws Exception {

		Map<String, Object> m = null;
		Connection conn = prepareConnection();
		try {
			MapHandler mh = new MapHandler();
			m = this.query(conn, sql, mh);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return m;
	}

	public Integer getInteger(String sql) throws Exception {

		Integer result = null;
		Connection conn = prepareConnection();
		try {
			ScalarHandler<Integer> mh = new ScalarHandler<Integer>();
//			BigDecimal bigResult = this.query(conn, sql, mh);
			result = this.query(conn, sql, mh);
//			bigResult.intValue();
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return result;
	}
	
	public Integer getInteger(String sql,Object... args) throws Exception {

		Integer result = null;
		Connection conn = prepareConnection();
		try {
			ScalarHandler<Integer> mh = new ScalarHandler<Integer>();
			result = this.query(conn, sql, mh,args);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return result;
	}
	

	public String getString(String sql, Object... args) throws Exception {

		String result = null;
		Connection conn = prepareConnection();
		try {
			ScalarHandler<String> mh = new ScalarHandler<String>();
			result = this.query(conn, sql, mh, args);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return result;
	}

	public String getString(String sql) throws Exception {

		String result = null;
		Connection conn = prepareConnection();
		try {
			ScalarHandler<String> mh = new ScalarHandler<String>();
			result = this.query(conn, sql, mh);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return result;
	}
	
	
	public List<String> getStringList(String sql, Object... args) throws Exception {

		List<String> result = null;
		Connection conn = prepareConnection();
		try {
			ColumnListHandler<String> mh = new ColumnListHandler<String>();
			result = this.query(conn, sql, mh, args);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return result;
	}

	public List<String> getStringList(String sql) throws Exception {

		List<String> result = null;
		Connection conn = prepareConnection();
		try {
			ColumnListHandler<String> mh = new ColumnListHandler<String>();
			result = this.query(conn, sql, mh);
			log.info(sql);
		} catch (Exception e) {
			throw e;
		} finally {

		}
		return result;
	}

	public int getCount(String sql, Object... args) throws Exception {
		Connection conn = prepareConnection();
		int count = 0;
		String countsql = "select count(1) as count from ( " + sql
				+ " ) ";
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
		String countsql = "select count(1) as count from ( " + sql + " )";
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

	/**
	 * 分页sql
	 * 
	 * @param sql
	 * @param rows
	 *            起始行数
	 * @param count
	 *            返回的记录数 若为0 则返回全部记录
	 * @return
	 * @throws Exception
	 */
	public abstract String pageSql(String sql, Integer page, Integer rows) throws Exception;

	public int delete(String sql, Object... params) throws Exception {
		return this.update(sql, params);
	}

	public int execute(String sql, Object... params) throws Exception {
		PreparedStatement stmt = null;
		Connection conn = prepareConnection();
		int result = 0;
		try {
			stmt = this.prepareStatement(conn, sql);
			this.fillStatement(stmt, params);
			result = stmt.executeUpdate();

		} catch (SQLException e) {
			this.rethrow(e, sql, params);

		} finally {

		}
		return result;
	}

}
