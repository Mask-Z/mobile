package com.ccjt.ejy.web.quartz.job;

import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.commons.db.connection.ConnectionFactory;
import com.ccjt.ejy.web.services.m.RegService;
import com.ccjt.ejy.web.vo.m.City;

public class CityJob extends QuartzJobBean {

	private static Logger log = LogManager.getLogger(CityJob.class);

	public static String cityList = "";
	
	public static String cityListWithEmpty = "";
	
	@Override
	protected void executeInternal(JobExecutionContext arg0)
			throws JobExecutionException {

		try {
			log.info("uodate city info .......");
			
			List<City> citys = RegService.cityList();
			
			cityList = JSON.toJSONString(citys);
			
			City city = new City();
			city.setCode("请选择");
			city.setName("请选择");
			city.setSub(new ArrayList<City>());			
			List<City> sub_shi = new ArrayList<City>();
			List<City> xian_list = new ArrayList<City>();			
			City shi = city.clone();
			City xian = city.clone();
			xian.setSub(null);			
			sub_shi.add(shi);			
			xian_list.add(xian);
			shi.setSub(xian_list);			
			city.setSub(sub_shi);
			citys.add(0, city);
			cityListWithEmpty = JSON.toJSONString(citys);
			
		} catch (Exception e) {
			log.error("更新city 出错:" ,e );
		} finally {
			ConnectionFactory.close();
		}
	}
}
