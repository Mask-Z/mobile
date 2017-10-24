package com.ccjt.ejy.web.services;

import static com.ccjt.ejy.web.commons.JDBC.jdbc;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.ccjt.ejy.web.commons.db.connection.ConnectionFactory;
import com.ccjt.ejy.web.vo.GongGao;

public class PicHandleService {
	
	private static Logger log = LogManager.getLogger(PicHandleService.class);
	
	/**
	 * 图片未处理的公告列表
	 * @return
	 */
	public static List<GongGao> picNOTHandleList(){
		List<GongGao> jjdtList = null;
		try {
			jjdtList = jdbc.beanList(SQL.plgp_chengjiao_gonggao_pic_handle_sql, GongGao.class);
		} catch (Exception e) {
			log.error("获取图片未处理的公告列表数据出错:" ,e);
			e.printStackTrace();
		} finally{
			ConnectionFactory.close();
		}
		return jjdtList;
	}
	
	
}
