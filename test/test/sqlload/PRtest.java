package test.sqlload;

import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Test;

import com.ccjt.ejy.web.commons.PropertiesReader;
import com.ccjt.ejy.web.services.SQL;


public class PRtest {

	private static Logger log = LogManager.getLogger(PRtest.class);
	
	
	private static Properties pros = null;
	private static InputStream is;
	public PRtest(String name) {
		try {
			pros = new Properties();
			is = PRtest.class.getResourceAsStream(name);
			pros.load(is);
			log.info("conf加载资源文件完成......");
		} catch (Exception e) {
			log.error("conf加载出错:", e);
			e.printStackTrace();
		} finally{
			if(is!=null)
				try {
					is.close();
				} catch (IOException e) {}
		}
	}
	
	public String get(String key){
		String v = null;
		if(pros != null){
			v = pros.getProperty(key);
		}
		
		return v;
	}
	
	
	public static void main(String d[]){
		DecimalFormat df = new DecimalFormat("#.00");
		double dd = 100.1264;
		System.out.println(df.format(dd));
		
		
	}

}
