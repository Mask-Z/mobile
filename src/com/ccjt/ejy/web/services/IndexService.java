package com.ccjt.ejy.web.services;

import static com.ccjt.ejy.web.commons.JDBC.jdbc;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.commons.cache.DBCacheManage;
import com.ccjt.ejy.web.commons.cache.RedisKeys;
import com.ccjt.ejy.web.enums.InfoType;
import com.ccjt.ejy.web.vo.GongGao;
import com.ccjt.ejy.web.vo.Jjdt;
import com.ccjt.ejy.web.vo.Pics;
import com.ccjt.ejy.web.vo.m.City;

public class IndexService {
	
	
	/**
	 * 缓存有效期/秒
	 */
	int cache = 60;
	private static Logger log = LogManager.getLogger(IndexService.class);
	
	/**
	 * 首页_交易公告
	 * @return
	 */
	public List<GongGao> index_jygg_info() {
		List<GongGao> newslist = null;
		try {
			
			String cache = DBCacheManage.get(RedisKeys.KEY_DB_CACHE_INDEX_JYGG);
			newslist = JSON.parseArray(cache, GongGao.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newslist;
	}
	
	
	/**
	 * 首页_成交公告_
	 * @return
	 */
	public List<GongGao> index_cjgg_info() {
		List<GongGao> newslist = null;
		try {
			
			String cache = DBCacheManage.get(RedisKeys.KEY_DB_CACHE_INDEX_CJGG);
			newslist = JSON.parseArray(cache, GongGao.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newslist;
	}
	
	/**
	 * 首页_成交公告_8条
	 * @return
	 */
	public List<GongGao> index_cjgg_8_info() {
		List<GongGao> newslist = null;
		try {
			
			String cache = DBCacheManage.get(RedisKeys.KEY_DB_CACHE_INDEX_CJGG_8_ROWS);
			newslist = JSON.parseArray(cache, GongGao.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newslist;
	}
	
	
	public List<GongGao> index_zdtj_cache() {
		List<GongGao> newslist = null;
		try {
			
			String cache = DBCacheManage.get(RedisKeys.KEY_DB_CACHE_INDEX_ZDTJ);
			newslist = JSON.parseArray(cache, GongGao.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newslist;
	}
	
	/**
	 * 首页招标采购
	 * @param type
	 * @return
	 */
	public List<GongGao> index_info_type(InfoType type,Integer count,Integer legth) {
		List<GongGao> zbcgList = null;
		try {
			String sql = "SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum FROM " +
					"View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   " +
					"and Categorynum =? order by IsTop DESC,OrderNum desc";
			
			zbcgList = jdbc.beanList(sql,0,count, GongGao.class,type.getCode());
			
			for(GongGao gg : zbcgList){
				if(gg.getTitle().length() > legth){
					gg.setTitle(gg.getTitle().substring(0,legth) + "...");
				}
			}
		} catch (Exception e) {
			log.error("获取竞价大厅数据出错:" ,e);
			e.printStackTrace();
		}
		return zbcgList;
	}
	
	
	/**
	 * 首页_预披露
	 * @return
	 */
	public List<GongGao> index_ypl_info() {
		List<GongGao> newslist = null;
		try {
			
			newslist = jdbc.beanList(SQL.index_ypl, GongGao.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newslist;
	}
	
	/**
	 * 首页数量统计
	 * @return
	 */
	public Map<String,Object> statistics(){
		Map<String,Object> map = new HashMap<String, Object>();
		
		try {
			String value = DBCacheManage.get(RedisKeys.KEY_DB_CACHE_INDEX_TJXX);
			map = JSON.parseObject(value,Map.class);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return map;
	}
	
	
//	private static Integer cache_time = Integer.valueOf(String.valueOf(TimeUnit.DAYS.toSeconds(1)));

	
	public List<GongGao> infoHandle(List<GongGao> gglist,InfoType type) {
		List<GongGao> newslist = null;
		try {
			if(type!=null && gglist!=null){
				newslist = new ArrayList<GongGao>();
				NewsService ns=new NewsService();
				for(GongGao gg : gglist){

					if (StringUtils.isNotBlank(gg.getIspllr()) && gg.getIspllr().equals("1")) {//如果项目是批量挂牌,重新设置开始,结束时间
						DateTimeFormatter format = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
						List<Map> plist = ns.getProjectList(gg.getInfoid());
						//批量挂牌多个标的的挂牌截止时间可能不一致,分别取最大和最小时间
						for (Map map : plist) {

							Object str = map.get("GongGaoFromDate");
							Object str2 = map.get("GongGaoToDate");

							Date ggstart = new DateTime().parse(str.toString(), format).toDate();
							Date ggend = new DateTime().parse(str2.toString(), format).toDate();

							if (gg.getGonggaotodate().before(ggend)) {
								gg.setGonggaotodate(ggend);
							}
							if (gg.getGonggaofromdate().after(ggstart)) {
								gg.setGonggaofromdate(ggstart);
							}

						}
					}

					if(type.getCode().equals(gg.getCategorynum())){
//						if(gg.getTitle().length() > 40){
//							gg.setTitle(gg.getTitle().substring(0,40) + "...");
//						}
						newslist.add(gg);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newslist;
	}
	
	/**
	 * 竞价大厅
	 * @param page
	 * @param pagesize
	 * @return
	 */
	public List<Jjdt> jjdt_cqjyList(int page,int pagesize){
		List<Jjdt> jjdtList = null;
		try {
			String sql = SQL.jjdt_cqjy_sql;
			sql += " ORDER BY a.ProjectStatus asc,a.PlanEndTime asc ";
			jjdtList = jdbc.beanList(sql,page,pagesize, Jjdt.class);
		} catch (Exception e) {
			log.error("获取竞价大厅数据出错:" ,e);
			e.printStackTrace();
		}
		return jjdtList;
	}
	

	
	/**
	 * 城市获取
	 * @param
	 */
	public List<City> city_info() {
		List<City> citylist = null;
		try {
			
			String cache = DBCacheManage.get(RedisKeys.WEB_DATA_CACHE_CITY);
			citylist = JSON.parseArray(cache, City.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return citylist;
	}
	
	
	/**
	 * 013 友情链接  018 首页flash
	 * @return
	 */
	public List<Pics> pic(String type,Integer count) {
		
		String sql = "select 'http://www.e-jy.com.cn/ejy/Upfiles/FileAttach/' + attachid + '/' + filename pic,UrlName url,Title name from View_InfoMain infomain "
				+ " inner join WebDB_Info_Upfiles upf  on infomain.infoid=upf.infoid "
				+ " where 1=1 and infomain.categorynum=? and infomain.InfoStatusCode='9' "
				+ " order by infomain.IsTop desc,  infomain.orderNum desc,infomain.InfoDate desc,infomain.PubInWebDate desc,infomain.SysID desc ";

		List<Pics> picList = null;
		try {

			if(count!=null){
				picList = jdbc.beanList(sql,0,count, Pics.class,type);
			}else{
				picList = jdbc.beanList(sql, Pics.class,type);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return picList;
	}
	
}