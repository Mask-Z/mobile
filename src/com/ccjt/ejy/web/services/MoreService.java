package com.ccjt.ejy.web.services;

import static com.ccjt.ejy.web.commons.JDBC.jdbc;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import com.ccjt.ejy.web.enums.InfoType;
import com.ccjt.ejy.web.vo.CQJY_Gonggao;
import com.ccjt.ejy.web.vo.GongGao;
import com.ccjt.ejy.web.vo.Page;
import com.ccjt.ejy.web.vo.m.City;

public class MoreService {
	private static Logger log = LogManager.getLogger(MoreService.class);


	/**
	 *
	 * @param page
	 * @param type
	 * @param area
	 * @param status 0 未开始报名  1 报名中  2报名结束
	 * @return
	 */
	public List<CQJY_Gonggao> jygg_more(Page page,String type,String area,String status,String cqywtype,String title,String showorder,String xiaqu){
		List<CQJY_Gonggao> jygg_list = null;
		List<Object> params = new ArrayList<Object>();
		Date now = new Date();
		try{
			/**
			 * 修改此sql时,请同步修改 jygg_more_count_sql
			 */
//			String sql = " select ispllr,projectguid,AllowMoreJqxt,jjia_status,projectcontroltype ,guapaiprice,jingjiafangshi,isfrompricexs,cjgg_guid,jingjia_start,jingjia_end,gonggaofromdate,gonggaotodate,jygg_guid,projectNum,categorynum,title,CategoryName,click,SystemType as systemtype from view_infomain_jygg as temp_2 where 1=1 ";
//			String sql="select * from ( SELECT    (CASE   WHEN  (temp_2.gonggaofromdate < getdate() and temp_2.gonggaotodate > getdate() and temp_2.cjgg_guid is null AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null )) THEN 1  WHEN (temp_2.jingjia_start < getdate() and  temp_2.jingjia_end > getdate() and temp_2.cjgg_guid is null AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ))    THEN 2 WHEN (temp_2.gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype, " +
//					" ispllr,  projectguid,  AllowMoreJqxt,  jjia_status,  projectcontroltype,  guapaiprice,  jingjiafangshi,  isfrompricexs,  cjgg_guid,  jingjia_start,  jingjia_end,  gonggaofromdate,  gonggaotodate,  jygg_guid,  projectNum,  categorynum,  title,  CategoryName,  click,  SystemType AS systemtype ,IsTop,infodate,orderNum,PubInWebDate,SysID FROM  view_infomain_jygg AS temp_2 ) as temp_2 WHERE  1 = 1 ";

			String sql="select * from ( SELECT    (CASE   WHEN  (temp_2.gonggaofromdate < getdate() and temp_2.gonggaotodate > getdate() and (temp_2.cjgg_guid is null or temp_2.cjgg_guid='') AND (temp_2.projectcontroltype NOT IN ('1', '2') or temp_2.projectcontroltype is null ) and (temp_2.jjia_status IS NULL OR  (temp_2.jjia_status != 3 and  temp_2.jjia_status != 4))) THEN 1  " +
					"WHEN (temp_2.jingjia_start < getdate() and  temp_2.jingjia_end > getdate() and (temp_2.cjgg_guid is null or temp_2.cjgg_guid='') AND (temp_2.projectcontroltype NOT IN ('1', '2') or temp_2.projectcontroltype is null ) and (temp_2.jjia_status IS NULL OR  (temp_2.jjia_status != 3 and  temp_2.jjia_status != 4) )) THEN 2 " +
					"WHEN (temp_2.gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype, " +
					" ispllr,  projectguid,  AllowMoreJqxt,  jjia_status,  projectcontroltype,  guapaiprice,  jingjiafangshi,  isfrompricexs,  cjgg_guid,  jingjia_start,  jingjia_end,  gonggaofromdate,  gonggaotodate,  jygg_guid,  projectNum,  categorynum,  title,  CategoryName,  click,  SystemType AS systemtype ,IsTop,infodate,orderNum,PubInWebDate,SysID FROM  view_infomain_jygg AS temp_2 ) as temp_2 WHERE  1 = 1 ";

			if(StringUtils.isNotBlank(area)){
				sql += " and temp_2.sheng=?";
				params.add(area);
			}
			if(StringUtils.isNotBlank(type)){
				sql += " and temp_2.categoryname=?";
				params.add(type);
			}

			if(StringUtils.isNoneBlank(title)){
				sql += " and temp_2.title like ?";
				params.add("%"+title+"%");

			}
			if(StringUtils.isNoneBlank(cqywtype)){
				sql += " and temp_2.CQYWType=?";
				params.add(cqywtype);

			}

			if(StringUtils.isNotBlank(status)){//当筛选条件不为全部时,不显示中止终结的项目
				if("未开始".equals(status)){

//					sql += " and temp_2.gonggaofromdate > getdate() and projectcontroltype is null";
					sql += " and temp_2.gonggaofromdate > getdate()";

				}else if("正在报名".equals(status)){

					sql += " and temp_2.gonggaofromdate < getdate() and temp_2.gonggaotodate > getdate() and (temp_2.cjgg_guid is null or temp_2.cjgg_guid='') AND (temp_2.projectcontroltype NOT IN ('1', '2') or temp_2.projectcontroltype is null ) and (temp_2.jjia_status IS NULL OR  (temp_2.jjia_status != 3 and  temp_2.jjia_status != 4))";
				}else if("竞价中".equals(status)){

//					sql += " and temp_2.jingjia_start < getdate() and  temp_2.jingjia_end > getdate() and projectcontroltype not in ('1','2') ";
					sql += " and temp_2.jingjia_start < getdate() and  temp_2.jingjia_end > getdate() and (temp_2.cjgg_guid is null or temp_2.cjgg_guid='') AND (temp_2.projectcontroltype NOT IN ('1', '2') or temp_2.projectcontroltype is null ) and (temp_2.jjia_status IS NULL OR  (temp_2.jjia_status != 3 and  temp_2.jjia_status != 4) ) ";

				}else if("报名已截止".equals(status)){

					sql += " and ( temp_2.jingjia_start is null or getdate() < temp_2.jingjia_start) and getdate()>temp_2.gonggaotodate and (temp_2.cjgg_guid is null or temp_2.cjgg_guid='') AND (temp_2.projectcontroltype NOT IN ('1', '2') or temp_2.projectcontroltype is null )  and (temp_2.jjia_status IS NULL OR  (temp_2.jjia_status != 3 and  temp_2.jjia_status != 4))";

				}else if("竞价已截止".equals(status)){

					sql += " and temp_2.jingjia_end < getdate() and (temp_2.cjgg_guid is null or temp_2.cjgg_guid='')  AND (temp_2.projectcontroltype NOT IN ('1', '2') or temp_2.projectcontroltype is null ) and  getdate() > temp_2.gonggaofromdate ";

				}
				else if("已成交".equals(status)){

//					sql += " and temp_2.cjgg_guid is not null and projectcontroltype is null";
					sql += " and temp_2.cjgg_guid is not null and temp_2.cjgg_guid!=''";

				}
			}

			if(StringUtils.isNoneBlank(xiaqu)){

				sql += " and temp_2.xiaquname=?";
				params.add(xiaqu);

			}

			Object obj [] = params.toArray();

			page.setTotal(jdbc.getCount(sql,obj));

			if(StringUtils.isNotBlank(showorder)){
				if("1".equals(showorder)){//价格
					sql += " order by guapaiprice,ordertype asc";
				} else if("2".equals(showorder)){//最新
					sql += " order by infodate desc,ordertype asc";
				} else{
//					sql += " order by IsTop DESC,OrderNum desc " ;
					sql += " order by IsTop desc, ordertype asc, orderNum desc,InfoDate desc,PubInWebDate desc,SysID desc ";
				}
			}else{
//				sql += " order by IsTop DESC,OrderNum desc " ;
				sql += " order by IsTop desc,ordertype asc,  orderNum desc,InfoDate desc,PubInWebDate desc,SysID desc ";
			}

			sql = jdbc.pageSql(sql, page.getCurrentPage(), page.getRows());

			sql = " select * from (" + sql + " ) as temp_2 OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_2.jygg_guid) temp_3 ";
			jygg_list = jdbc.beanList(sql, CQJY_Gonggao.class,obj);
			NewsService ns=new NewsService();
			for(CQJY_Gonggao gg : jygg_list){

				if (StringUtils.isNotBlank(gg.getIspllr()) && gg.getIspllr().equals("1")) {//批量挂牌
					DateTimeFormatter format = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
					List<Map> plist = ns.getProjectList(gg.getCjgg_guid());
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

				if("1".equals(gg.getAllowmorejqxt())){
					
					String erci_sql = " select top 1 JingJiaFangShi JingJiaFangShi_1,cast(PlanEndTime as datetime) jingjia_end ,cast(begindate as datetime) jingjia_start  from JQXT_ProjectInfo where OrgBiaoDiGuid=? order by Row_ID desc ";
					CQJY_Gonggao g = jdbc.bean(erci_sql, CQJY_Gonggao.class,gg.getProjectguid());
					if (g!=null) {
						gg.setJingjia_start(g.getJingjia_start());
						gg.setJingjia_end(g.getJingjia_end());
					}
				}

				if("3".equals(gg.getJingjiafangshi())){
					if(!"1".equals(gg.getIsfrompricexs())){
						gg.setGuapaiprice("****");
					}
				}

//				1终结  2中止  3重新挂牌  null 正常项目
				String  controlType=gg.getProjectcontroltype();
				 if(now.before(gg.getGonggaofromdate())){//报名未开始

					gg.setStatus(0);

				} else if(StringUtils.isNotBlank(gg.getCjgg_guid())){//已成交

					gg.setStatus(6);

				} 		/**
				 * 如果中止终结状态不为空,就在列表页显示中止终结的状态
				 */
				else if (StringUtils.isNotBlank(controlType)&&!controlType.equals("0")&&!controlType.equals("3")){
					if (controlType.equals("1")){
						gg.setStatus(7);
					}else if(controlType.equals("2")){
						gg.setStatus(8);
					}
				}else if(gg.getJingjia_end()!=null){//有竞价数据

					 String jjia_status=gg.getJjia_status();
					if(StringUtils.isNotBlank(jjia_status)&&jjia_status.equals("4")){//jjia_status为4,代表竞价暂停
						gg.setStatus(9);
					} else if(now.after(gg.getJingjia_start()) && now.before(gg.getJingjia_end())){ //竞价中
						gg.setStatus(4);
					} else if(now.before(gg.getJingjia_start())){//竞价未开始
						gg.setStatus(3);
					} else if(now.after(gg.getJingjia_end())){//竞价已截止
						gg.setStatus(5);
					}
				}else if(now.after(gg.getGonggaofromdate()) && now.before(gg.getGonggaotodate())){//报名中

					 gg.setStatus(1);

				 }  else if(now.after(gg.getGonggaotodate())){//报名已截止
					gg.setStatus(2);
				}

				if(gg!=null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() >  35){
					gg.setTitle(gg.getTitle().substring(0,35) + "...");
				}
			}

		}catch (Exception e) {
			log.error("获取交易公告出错:",e);
			e.printStackTrace();
		}
		return jygg_list;
	}

	/**
	 * 猜你喜欢
	 * @param type
	 * @param area
	 * @param status
	 * @param cqywtype
	 * @return
	 */
	public List<GongGao> cnxh_more(String type,String area,String status,String cqywtype){
		List<GongGao> jygg_list = null;
		List<Object> params = new ArrayList<Object>();
		Date now = new Date();
		try{

			String sql = "select guapaiprice,jingjiafangshi,CategoryName,jingjia_start,jingjia_end,gonggaofromdate,gonggaotodate,jygg_guid,projectNum,categorynum,title,click from view_infomain_jygg webdb where 1=1 ";


			if(StringUtils.isNotBlank(area)){
				sql += " and webdb.sheng=?";
				params.add(area);
			}

			if(StringUtils.isNotBlank(type)){
				sql += " and webdb.categoryname=?";
				params.add(type);
			}

			if(StringUtils.isNoneBlank(cqywtype)){
				sql += " and webdb.CQYWType=?";
				params.add(cqywtype);

			}

			Object obj [] = params.toArray();

//			sql += " and gonggaofromdate > sysdate() and gonggaotodate < sysdate() ";

			sql += "  order by IsTop desc,  orderNum desc,InfoDate desc,PubInWebDate desc,SysID desc " ;
			sql = jdbc.pageSql(sql, 0,4);

			sql = " select * from (" + sql + " ) as temp_2 OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_2.jygg_guid) temp_3 ";
			jygg_list = jdbc.beanList(sql, GongGao.class,obj);

			for(GongGao gg : jygg_list){

				if(now.before(gg.getGonggaofromdate())){//报名未开始

					gg.setStatus(0);

				} else if(StringUtils.isNotBlank(gg.getCjgg_guid())){//已成交

					gg.setStatus(6);

				} else if(now.after(gg.getGonggaofromdate()) && now.before(gg.getGonggaotodate())){//报名中

					gg.setStatus(1);

				} else if(gg.getJingjia_end()!=null){//有竞价数据

					if(now.after(gg.getJingjia_start()) && now.before(gg.getJingjia_end())){//竞价中

						gg.setStatus(4);

					} else if(now.before(gg.getJingjia_start())){//竞价未开始

						gg.setStatus(3);

					} else if(now.after(gg.getJingjia_start()) && now.before(gg.getJingjia_end())){//竞价中

						gg.setStatus(4);

					} else if(now.after(gg.getJingjia_end())){//竞价已截止

						gg.setStatus(5);

					}

				} else if(now.after(gg.getGonggaotodate())){//报名已截止

					gg.setStatus(2);

				}

				if(gg!=null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() >  35){
					gg.setTitle(gg.getTitle().substring(0,35) + "...");
				}
			}

		}catch (Exception e) {
			log.error("获取交易公告出错:",e);
			e.printStackTrace();
		}
		return jygg_list;
	}


	public List<GongGao> cjgg_more(Page page,String type,String area,String cqywtype,String showorder){
		List<GongGao> jygg_list = null;
		List<Object> params = new ArrayList<Object>();
		try{

			String sql = "select * from view_infomain_cjgg temp_2 where 1=1 ";

			if(StringUtils.isNotBlank(area)){
				sql += " and temp_2.sheng=?";
				params.add(area);
			}
			if(StringUtils.isNotBlank(type)){
				sql += " and temp_2.categoryname=?";
				params.add(type);
			}

//			if(StringUtils.isNoneBlank(title)){
//				sql += " and temp_2.title like ?";
//				params.add("%"+title+"%");
//				
//			}
			if(StringUtils.isNoneBlank(cqywtype)){
				sql += " and temp_2.CQYWType=?";
				params.add(cqywtype);

			}

			Object [] arr = params.toArray();

			page.setTotal(jdbc.getCount(sql,arr));

			if(StringUtils.isNotBlank(showorder)){
				if("1".equals(showorder)){//价格
					sql += " order by chengjiaoprice";
				} else if("2".equals(showorder)){//最新
					sql += " order by chengjiaodate desc";
				} else{
//					sql += " order by IsTop DESC,OrderNum desc " ;
					sql += " order by IsTop desc,  orderNum desc,InfoDate desc,PubInWebDate desc,SysID desc ";
				}
			}else{
//				sql += " order by IsTop DESC,OrderNum desc " ;
				sql += " order by IsTop desc,  orderNum desc,InfoDate desc,PubInWebDate desc,SysID desc ";
			}

			sql = jdbc.pageSql(sql, page.getCurrentPage(), page.getRows());



			sql = " select * from (" + sql + " ) as temp_2 OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_2.jygg_guid) temp_3 ";
			jygg_list = jdbc.beanList(sql, GongGao.class,arr);

			for(GongGao gg : jygg_list){

				if(gg!=null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() >  33){
					gg.setTitle(gg.getTitle().substring(0,33) + "...");
				}
			}

		}catch (Exception e) {
			log.error("获取成交公告出错:",e);
			e.printStackTrace();
		}
		return jygg_list;
	}



	public List<GongGao> zdtj_more(Page page,String type,String area,String ggtype){
		List<GongGao> jygg_list = null;
		List<Object> params = new ArrayList<Object>();
		try{

			String sql = SQL.zdtj_more_sql;

			if(StringUtils.isNotBlank(area)){
				sql += " and temp_4.sheng=?";
				params.add(area);
			}

			if(StringUtils.isNotBlank(type)){
				sql += " and temp_4.projectstyle=?";
				params.add(type);
			}

			page.setTotal(jdbc.getCount(sql,params.toArray()));

			sql += "  order by IsTop desc,  orderNum desc,InfoDate desc,PubInWebDate desc,SysID desc ";

			sql = jdbc.pageSql(sql, page.getCurrentPage(), page.getRows());

			sql = "select * from ( "+sql+" ) as temp_2 OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_2.infoid) temp_3 ";

			jygg_list = jdbc.beanList(sql, GongGao.class,params.toArray());

			NewsService ns = new NewsService();
			for(GongGao gg : jygg_list){

				if(gg!=null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() > 35){
					gg.setTitle(gg.getTitle().substring(0,35) + "...");
				}

//				GongGao st = ns.getJYGG_status(gg.getInfoid().substring(0,36));
				GongGao st = ns.getJYGG_status(gg);
				if(st!=null){
					gg.setStatus(st.getStatus());
				}

			}


		}catch (Exception e) {
			log.error("获取成交公告出错:",e);
			e.printStackTrace();
		}
		return jygg_list;
	}





	public List<GongGao> news_more(InfoType type,Page page,Integer titlelegth) {
		List<GongGao> zbcgList = null;
		try {
			String sql = "SELECT infoid,Title,EndDate,Categorynum,infodate,strComment description FROM " +
					"View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   " +
					"and Categorynum =?";

			if(type.equals(InfoType.CZZN_CQJY) || type.equals(InfoType.CZZN_ZBCG)){

				sql = "SELECT infoid,Title,EndDate,Categorynum,infodate,strComment description FROM " +
						"View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   " +
						"and Categorynum in ('034001','034002')";

				page.setTotal(Integer.valueOf(jdbc.getCount(sql)));

				sql += "  order by IsTop DESC,OrderNum desc ";
				zbcgList = jdbc.beanList(sql,page.getCurrentPage(),page.getRows(), GongGao.class);

			}else{


				page.setTotal(Integer.valueOf(jdbc.getCount(sql,type.getCode())));

				sql += "  order by IsTop DESC,OrderNum desc ";
				zbcgList = jdbc.beanList(sql,page.getCurrentPage(),page.getRows(), GongGao.class,type.getCode());
			}




			for(GongGao gg : zbcgList){
				if(gg.getTitle().length() > titlelegth){
					gg.setTitle(gg.getTitle().substring(0,titlelegth) + "...");
				}
			}
		} catch (Exception e) {
			log.error("获取竞价大厅数据出错:" ,e);
			e.printStackTrace();
		}
		return zbcgList;
	}

	public List<GongGao> new_news_more(String strs,Page page,Integer titlelegth) {
		List<GongGao> zbcgList = null;
		try {
			String sql = "SELECT infoid,Title,EndDate,Categorynum,infodate,strComment description FROM " +
					"View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   " +
					"and Categorynum like ?";


			page.setTotal(Integer.valueOf(jdbc.getCount(sql,strs)));

			sql += "  order by IsTop DESC,OrderNum desc ";
			zbcgList = jdbc.beanList(sql,page.getCurrentPage(),page.getRows(), GongGao.class,strs);

			for(GongGao gg : zbcgList){
				if(gg.getTitle().length() > titlelegth){
					gg.setTitle(gg.getTitle().substring(0,titlelegth) + "...");
				}
			}
		} catch (Exception e) {
			log.error("获取竞价大厅数据出错:" ,e);
			e.printStackTrace();
		}
		return zbcgList;
	}

	public List<GongGao> zdcg_more(Page page,String type,String area,String ggtype,String title){
		List<GongGao> jygg_list = null;
		List<Object> params = new ArrayList<Object>();
		try{

			String sql = "select InfoID,title,InfoDate,CategoryName from View_InfoMain where CategoryNum like ?";

			params.add(ggtype);

			if(StringUtils.isNotBlank(title)){
				sql += " and title like ?";
				params.add("%"+title+"%");
			}

			if(StringUtils.isNotBlank(area)){
				sql += " and sheng=?";
				params.add(area);
			}

			if(StringUtils.isNotBlank(type)){
				sql += " and CategoryName=?";
				params.add(type);
			}

			page.setTotal(jdbc.getCount(sql,params.toArray()));

			sql += " order by IsTop DESC,OrderNum desc ";

			sql = jdbc.pageSql(sql, page.getCurrentPage(), page.getRows());

			jygg_list = jdbc.beanList(sql, GongGao.class,params.toArray());

			for(GongGao gg : jygg_list){

				if(gg!=null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() >  55){
					gg.setTitle(gg.getTitle().substring(0,55) + "...");
				}
			}


		}catch (Exception e) {
			log.error("获取招标采购出错:",e);
			e.printStackTrace();
		}
		return jygg_list;
	}




	public List<GongGao> cnxh_zbcg_more(String type,String area,String ggtype){
		List<GongGao> jygg_list = null;
		List<Object> params = new ArrayList<Object>();
		try{

			String sql = "select InfoID,title,EndDate,ProjectNum from View_InfoMain where CategoryNum like ?";

			params.add(ggtype);

			if(StringUtils.isNotBlank(area)){
				sql += " and sheng=?";
				params.add(area);
			}

			if(StringUtils.isNotBlank(type)){
				sql += " and CategoryName=?";
				params.add(type);
			}

			sql += " order by IsTop DESC,OrderNum desc ";

			sql = jdbc.pageSql(sql, 0,9);

			jygg_list = jdbc.beanList(sql, GongGao.class,params.toArray());

			for(GongGao gg : jygg_list){
				if(gg!=null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() >  45){
					gg.setTitle(gg.getTitle().substring(0,45) + "...");
				}
			}

		}catch (Exception e) {
			log.error("获取招标采购出错:",e);
			e.printStackTrace();
		}
		return jygg_list;
	}

	public List<GongGao> ypl_more(Page page,String type,String area){
		List<GongGao> jygg_list = null;
		List<Object> params = new ArrayList<Object>();
		try{

			String sql = " select infoid,price guapaiprice,ProjectNum,Title,StartDate,EndDate,case when CategoryName='产股权' then '股权' else CategoryName end as ProjectStyle from View_InfoMain  " +
					" where CategoryNum like '00100300_' and (InfoStatusCode ='9' or InfoStatusCode ='-2')  ";

			//params.add(ggtype);

			if(StringUtils.isNotBlank(area)){
				sql += " and sheng=?";
				params.add(area);
			}

			if(StringUtils.isNotBlank(type)){
				if("股权".equals(type)){
					type = "产股权";
				}
				sql += " and CategoryName=?";
				params.add(type);
			}

			page.setTotal(jdbc.getCount(sql,params.toArray()));

			sql += " order by IsTop desc,  orderNum desc,InfoDate desc,PubInWebDate desc,SysID desc ";

			sql = jdbc.pageSql(sql, page.getCurrentPage(), page.getRows());


			sql = " select * from ( " + sql + " ) as temp_2 OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_2.infoid) temp_3";

			jygg_list = jdbc.beanList(sql, GongGao.class,params.toArray());

			for(GongGao gg : jygg_list){

				if(gg!=null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() >  35){
					gg.setTitle(gg.getTitle().substring(0,35) + "...");
				}
			}


		}catch (Exception e) {
			log.error("获取招标采购出错:",e);
			e.printStackTrace();
		}
		return jygg_list;
	}



	public List<GongGao> jjdt_zbcg_more(Page page,String sheng,String orgid,String biaodiname,String type,String status){
		List<GongGao> jygg_list = null;
		List<Object> params = new ArrayList<Object>();
		try{

			String sql = "select title,projectnum,jingjia_start,jingjia_end,state ,zgj,infoid from view_infomain_zbcg_jjdt temp_4 where 1=1 ";

			if(StringUtils.isNotBlank(biaodiname)){
				sql += " and temp_4.title like ?";
				params.add("%"+biaodiname+"%");
			}

			if(StringUtils.isNotBlank(orgid)){
				sql += " and temp_4.orgname=?";
				params.add(orgid);
			}

			if(StringUtils.isNotBlank(type)){
				sql += " and temp_4.xiangmulbcode like ?";
				params.add(type+"%");
			}

			if(StringUtils.isNotBlank(status)){
				sql += " and temp_4.state=?";
				params.add(status);
			}

			Object [] arr = params.toArray();
			page.setTotal(jdbc.getCount(sql,arr));

			sql += "  ORDER BY state asc,jingjia_start desc";

			sql = jdbc.pageSql(sql, page.getCurrentPage(), page.getRows());

			jygg_list = jdbc.beanList(sql, GongGao.class,arr);

			for(GongGao gg : jygg_list){

				if(gg!=null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() >  33){
					gg.setTitle(gg.getTitle().substring(0,33) + "...");
				}
			}

		}catch (Exception e) {
			log.error("获取招标采购竞价大厅出错:",e);
			e.printStackTrace();
		}
		return jygg_list;
	}



	public List<GongGao> jjdt_zbcg_more(Integer count){
		List<GongGao> jygg_list = null;
		try{

			String sql = "select title,projectnum,jingjia_start,jingjia_end,state ,zgj,infoid from view_infomain_zbcg_jjdt temp_4 where 1=1 ";

			sql += "  ORDER BY state asc,jingjia_start desc";

			jygg_list = jdbc.beanList(sql,0,count, GongGao.class);

			for(GongGao gg : jygg_list){

				if(gg!=null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() >  33){
					gg.setTitle(gg.getTitle().substring(0,33) + "...");
				}
			}

		}catch (Exception e) {
			log.error("获取招标采购竞价大厅出错:",e);
			e.printStackTrace();
		}
		return jygg_list;
	}



	public List<City> zbcg_city(){
		List<City> citylist = new ArrayList<City>();
		try{

			String sql = " select distinct xiaqucode code,xq.CityName name from Zfcg_ZhaoBiaoGG zbcg inner join Sys_XiaQu xq on zbcg.XiaQuCode=xq.CityCode where 1=1 and auditstatus=3 ";

			citylist = jdbc.beanList(sql, City.class);

		}catch (Exception e) {
			log.error("获取招标采购项目所在城市出错:",e);
			e.printStackTrace();
		}
		return citylist;
	}

	public String getInfoIDByCategoryNum(String type){
		String infoid = null;
		try{

			infoid = jdbc.getString("select top 1 infoid from View_InfoMain where CategoryNum =?",type);

		}catch (Exception e) {
			log.error("获取招标采购项目所在城市出错:",e);
			e.printStackTrace();
		}
		return infoid;
	}



}
