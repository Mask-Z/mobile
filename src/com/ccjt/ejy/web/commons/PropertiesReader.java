package com.ccjt.ejy.web.commons;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;



public class PropertiesReader {

	private static Logger log = LogManager.getLogger(PropertiesReader.class);
	
	private static Properties pros = new Properties();
	private static InputStream is;
	static {
		try {
			is = PropertiesReader.class.getResourceAsStream("/conf.properties");
			pros.load(is);
			log.info("conf加载资源文件完成......");
		} catch (Exception e) {
			log.error("conf加载出错:", e);
			e.printStackTrace();
		} finally{
			if(is!=null)
				try {is.close();} catch (IOException e) {}
		}
	}
	
	public static String get(String key){
		return pros.getProperty(key);
	}
	
	/**
	 * 重新加载配置文件,<b>慎用</b>...
	 */
	public static void reload(){
		try {
			is = PropertiesReader.class.getResourceAsStream("/conf.properties");
			pros.load(is);
			log.info("reload conf finish ......");
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

}
