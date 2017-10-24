package test.sql;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

import com.ccjt.ejy.web.commons.db.connection.ConnectionFactory;
import com.ccjt.ejy.web.services.SQL;

public class GetMatedata {
	/**
	 * @param args
	 */
	public static void main(String[] args) {

		Connection conn = null;
		try{
			conn = ConnectionFactory.getJDBCConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL.jjdt_cqjy_sql);
			ResultSet rs = pstmt.executeQuery();
			ResultSetMetaData md = rs.getMetaData();
			int count = md.getColumnCount();
			for(int i = 1;i<=count ;i++){
				//System.out.println(md.getColumnName(i));;
				System.out.println(md.getColumnLabel(i).toLowerCase());
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
}
