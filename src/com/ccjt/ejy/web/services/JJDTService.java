package com.ccjt.ejy.web.services;

import static com.ccjt.ejy.web.commons.JDBC.jdbc;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.cache.redis.JedisTemplate;
import com.ccjt.ejy.web.commons.cache.RedisKeys;
import com.ccjt.ejy.web.commons.cache.RedisTemplateFactory;
import com.ccjt.ejy.web.vo.Jjdt;
import com.ccjt.ejy.web.vo.Organize;
import com.ccjt.ejy.web.vo.Page;

public class JJDTService {
	
	private static Logger log = LogManager.getLogger(JJDTService.class);
	
	/**
	 * E交易入驻机构信息
	 */
	public List<Organize> jjdt_orglist(){
		List<Organize> list =new ArrayList<Organize>();
		String sql ="Select DanWeiName as name,CityCode as orgid from View_HuiYuan_AllPaiMaiDaiLi inner join Sys_XiaQu on View_HuiYuan_AllPaiMaiDaiLi.DanWeiGuid = Sys_XiaQu.RowGuid where AuditStatus='3' and StatusCode='2'";
		try {
			list = jdbc.beanList(sql, Organize.class);
		} catch (Exception e) {
			log.error("获取机构数据出错:" ,e);
			e.printStackTrace();
		}
		return list;
	}
	
	/**
	 * 获取项目分类列表
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public List jjdt_typelist(){
		List list =new ArrayList();
		String sql ="select ItemValue as type,ItemText as typeName from View_CodeMain_CodeItems where CodeName='产权类别';";
		try {
			list =jdbc.mapList(sql);
		} catch (Exception e) {
			log.error("获取项目分类列表出错:" ,e);
			e.printStackTrace();
		}
		return list;
	}
	
	

	/**
	 * 产权交易_竞价大厅列表
	 * @param page 
	 * @param pagesize
	 * @param orgid 机构编码
	 * @param name  项目名称
	 * @param status  项目状态  0  未开始    1 竞价中     2 已结束
	 * @return
	 */
	public List<Jjdt> jjdt_cqjy_List(int page,int pagesize,String orgid,String name,String status){
		List<Jjdt> jjdtList = null;
		try {
			String sql = SQL.jjdt_cqjy_sql;
			
			/**
			 * 
			 * 		<js>if("@orgId" !=""){return " AND g.CityCode ='@orgId' ";}</js>
	    <js>if("@object" !=""){return " AND c.ProjectName LIKE '%@object%' ";}</js>
	    <js>if("@status" !=""){return " AND (CASE WHEN a.ProjectStatus = '0' THEN '未开始' WHEN a.ProjectStatus = '3' THEN '已结束' ELSE '报价中' END) ='@status' ";}</js>
	    <js>if("@type" !=""){return " AND c.ProjectType ='@type' ";}</js>
			 * 
			 * 
			 */
			List<Object> params = new ArrayList<Object>();
			
			if(StringUtils.isNotEmpty(name)){
				sql += " AND c.ProjectName LIKE ? ";
				params.add("%"+name+"%");
			}
			
			if(StringUtils.isNotEmpty(orgid)){
				sql += " AND g.CityCode = ?";
				params.add(orgid);
			}
			
			if(StringUtils.isNotEmpty(status)){
				sql += " AND c.ProjectType = ?";
				params.add(status);
			}
			
			sql += " ORDER BY a.ProjectStatus asc,a.PlanEndTime asc ";
			jjdtList = jdbc.beanList(sql,page,pagesize, Jjdt.class,params.toArray());
		} catch (Exception e) {
			log.error("获取竞价大厅数据出错:" ,e);
			e.printStackTrace();
		}
		return jjdtList;
	}
	
	/**
	 * 获取多个标的信息列表
	 * @param biaodinos	标的编号集合
	 * @return
	 */
	public List jjdt_cache(String[] biaodinos){
		
		
		//是否有标的需要刷新
		if(biaodinos == null || biaodinos.length == 0){
			return null;
		}

//		List<String> biaodino_list =Arrays.asList(biaodinos);
		
		List<Jjdt> jjdtList = new ArrayList<Jjdt>();
		JedisTemplate redis = null;
		
		try {
			redis = RedisTemplateFactory.template.getJedisTemplate();
			
			String uuid = redis.get(RedisKeys.KEY_JJDT_key);
			String field_key = RedisKeys.KEY_JJDT_FIELD + uuid;
			String jjdt_key = RedisKeys.KEY_JJDT + uuid;
			
			
			if(!StringUtils.isNotBlank(field_key)){
				return null;
			}
			
			Long len = redis.llen(field_key);
			
			if(len == null || len == 0){
				return null;
			}
			int total = len.intValue();
			List<String> row_keys = redis.lrange(field_key, 0, total);
			
//			row_keys.size();
			if(row_keys == null ){
				return null;
			}
			
			for(String bino : biaodinos){
				for(String row_key : row_keys){
					if(row_key.endsWith(bino)){
						String json =redis.hget(jjdt_key, row_key);
						
						Jjdt jt = JSON.parseObject(json, Jjdt.class);
						jjdtList.add(jt);
						continue;
					}
				}
			}
			
		} catch (Exception e) {
			log.error("获取竞价大厅缓存出错:" ,e);
			e.printStackTrace();
		}
		return OP(jjdtList);
	}
	
	/**
	 * 从缓存中获取竞价列表
	 * @param page
	 * @return
	 */
	public List<Jjdt> jjdt_cache(Page page){
		return jjdt_cache(page ,null);
	}
	
	/**
	 * 从缓存中获取竞价列表
	 * @param page
	 * @param condition	条件
	 * @return
	 */
	public List<Jjdt> jjdt_cache(Page page ,Map<String ,String> condition){
		List<Jjdt> jjdtList = new ArrayList<Jjdt>();
		JedisTemplate redis = null;
		//条件
		String con_orgid =null;//机构id
		String con_biaodiname =null;//标的名称 关键字
		String con_status =null;//报名状态
		String con_type =null;//项目类型
		String con_sheng = null;
		String con_shi = null;
		if(condition !=null){
			con_orgid =condition.get("orgid").trim();
			con_biaodiname =condition.get("biaodiname").trim();
			con_status =condition.get("status").trim();
			con_type =condition.get("type").trim();
			con_sheng =condition.get("sheng").trim();
		}
		boolean hasConditon =!(StringUtils.isBlank(con_orgid) && StringUtils.isBlank(con_status)
				&& StringUtils.isBlank(con_type) && StringUtils.isBlank(con_biaodiname)&& StringUtils.isBlank(con_sheng));
		try {
			redis = RedisTemplateFactory.template.getJedisTemplate();
			String uuid = redis.get(RedisKeys.KEY_JJDT_key);
			String field_key = RedisKeys.KEY_JJDT_FIELD + uuid;
			String jjdt_key = RedisKeys.KEY_JJDT + uuid;
			if(!StringUtils.isNotBlank(field_key)){
				return null;
			}
			int start = (page.getCurrentPage()-1) * page.getRows();
			
			Long len = redis.llen(field_key);
			
			
			if(len == null || len == 0){
				return null;
			}
			int total = len.intValue();
			List<String> row_keys = redis.lrange(field_key, 0, total);
			
//			System.out.println(row_keys);
			if(row_keys==null || row_keys.size() ==0){
				return null;
			}
			//redis缓存中有数据，开始遍历
			
			int show = page.getRows();
			
			String[] _arr;
			String _biaodiname, _type ,_status ,_orgid,_sheng;
			int index =-1;
			//-----------------------------没有查询条件-----------------------------
			if(!hasConditon){
				page.setTotal(total);
				page.setTotalPage(getTotalPage(total, show));
				if(page.getCurrentPage() >page.getTotalPage()){
					page.setCurrentPage(page.getTotalPage());
				}
				//如果start起始索引超出总数据长度，直接获取最后一页的数据
				if(start > row_keys.size() -1){
					start = getStart(page.getTotalPage(), show);
				}
				for(String row_key : row_keys){
					index++;
					if(index <start)continue;
					if(show ==0){
						break;
					}
					Jjdt jt = JSON.parseObject(redis.hget(jjdt_key, row_key), Jjdt.class);
					if(jt == null){
						log.error("竞价大厅:" + jjdt_key + "row_key - : " + row_key);
					}else{
						jjdtList.add(jt);
						show--;
						index++;
					}
					
				}
				return OP(jjdtList);
			}
			
			//-----------------------------有查询条件-----------------------------
			total =0;
			show =page.getRows();
			index =-1;
			boolean f =true;//符合条件
			List<String> key_list =new ArrayList<String>();
			for(String row_key : row_keys){
				_arr = row_key.split("ζ");
				_status =_arr[0];//0未开始、1报价中、2已结束
				_type =_arr[1];
				_biaodiname =_arr[2];
				_orgid =_arr[3];
				_sheng = _arr[4];
				//查询条件成立的数据为合法数据，需要累积index
				if(StringUtils.isNotBlank(con_orgid) && !con_orgid.trim().equals(_orgid) ){
					continue;
				}
				if(StringUtils.isNotBlank(con_sheng) && !con_sheng.trim().equals(_sheng) ){
					continue;
				}
				if(StringUtils.isNotBlank(con_biaodiname) &&_biaodiname !=null && !_biaodiname.contains(con_biaodiname) ){
					continue;
				}
				if(StringUtils.isNotBlank(con_status) &&!con_status.equals(_status) ){
					continue;
				}
				if(StringUtils.isNotBlank(con_type) &&!con_type.equals(_type)){
					continue;
				}
				if(f){
					key_list.add(row_key);
				}
			}
			//
			total =key_list.size();
			page.setTotal(total);
			if(page.getCurrentPage() > page.getTotalPage()){
				page.setCurrentPage(page.getTotalPage());
			}
			if(start >page.getTotal() - 1){
				start =getStart(page.getTotalPage(), show);
			}
			int end =start + page.getRows();
			end =end > page.getTotal() -1 ?page.getTotal() :end;
			key_list = key_list.subList(start, end);
			
			
			for(String row_key : key_list){
				Jjdt jt = JSON.parseObject(redis.hmget(jjdt_key, row_key).get(0), Jjdt.class);
				jjdtList.add(jt);
			}
			return OP(jjdtList);
		} catch (Exception e) {
			log.error("获取竞价大厅缓存出错:" ,e);
			e.printStackTrace();
		}
		
		return OP(jjdtList);
		
	}
	
	/**
	 * 为节约网络带宽,部分值设置为null,不返回给客户端
	 * @param jjdtList
	 * @return
	 */
	private List<Jjdt> OP(List<Jjdt> jjdtList){
		Date now = new Date();
		if(jjdtList!=null && jjdtList.size() > 0){
			for(Jjdt jjdt : jjdtList){
				jjdt.setCurrent(now.getTime());
				jjdt.setSheng(null);
				jjdt.setShi(null);
				jjdt.setOrgname(null);
				jjdt.setProjecttype(null);
				if(jjdt.getGonggaofromdate().before(now) && jjdt.getGonggaotodate().after(now)){//报名中
					
					jjdt.setStatus("4");//报名中
				}
				if(jjdt.getStart().before(now) && jjdt.getEndtime().after(now)){
					jjdt.setStatus("0");
				}
				
				jjdt.setGonggaofromdate(null);
				jjdt.setGonggaotodate(null);
				jjdt.setInfoguid(null);
				//排序需要将竞价中的排在前面, 竞价中、延时竞价 的状态改成 0 、1  竞价暂停 、未开始改为  2 、 3 为已结束
				try {
					Jjdt j = jdbc.bean("SELECT cast(a.PlanEndTime as datetime) endtime,cast(a.BeginDate as datetime) start" +
							" ,(case when a.ProjectStatus = '0' THEN '2' WHEN (a.ProjectStatus = '1' or a.ProjectStatus = '2') THEN '0' WHEN (a.ProjectStatus = '4') THEN '1'  ELSE '3' END)AS status  " +
							" ,(case when a.ProjectStatus = '0' THEN '未开始' WHEN a.ProjectStatus=1 THEN '竞价中' WHEN a.ProjectStatus=2 THEN '延时竞价' WHEN a.ProjectStatus=4 THEN '竞价暂停' WHEN a.ProjectStatus=3 THEN '已结束' END)AS statusCN  " +
							" ,CAST(CAST((CASE WHEN a.CurrencyUnit = '2' THEN ISNULL(a.MaxQuotePrice, a.FromPrice) *10000 ELSE ISNULL(a.MaxQuotePrice, a.FromPrice) END) as decimal(18, 2)) as VARCHAR ) as maxPrice  " +
							"from JQXT_ProjectInfo a where ProjectGuid=?",Jjdt.class,jjdt.getProjectguid());
					
					if(j!=null){
						if(j.getStart()!=null) jjdt.setStart(j.getStart());
						if(j.getEndtime()!=null) jjdt.setEndtime(j.getEndtime());
						
						if("3".equals(jjdt.getJingJiaFangShi()) && !"3".equals(j.getStatus())){//密封式报价且报价未结束
							jjdt.setMaxprice("****");
						}
						else {
							jjdt.setMaxprice(j.getMaxprice());
						}
						
						jjdt.setStatus(j.getStatus());
						jjdt.setStatusCN(j.getStatusCN());
						
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				if(!"2".equals(jjdt.getStatus())){//所有未结束的都返回剩余时间
					jjdt.setLast_times(jjdt.getEndtime().getTime() - now.getTime());
				}
			}
		}
		
		return jjdtList;
	}
	
	private static int getTotalPage(int count, int pageSize) {
		if (count < pageSize || pageSize ==0) { return 1; }
		return count % pageSize == 0 ? count / pageSize : count / pageSize + 1;
	}
	
	private static int getStart(int page, int pageSize){
        page = page <= 0 ? 1 : page;
        int start = (page - 1) * pageSize;
        return start;
    }
	
	public static void main(String aa[]){
		JJDTService jj = new JJDTService();
		System.out.println(jj.jjdt_cqjy_List(1, 10, "", "1", "")); ;
		
	}
	
}
