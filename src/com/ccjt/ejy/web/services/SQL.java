package com.ccjt.ejy.web.services;

/**
 * 项目中用到的一些SQL<br>
 * 部分sql语句包含排序,数量等,一些通过语句只有select,不包含排序等语句
 * @author xxf
 *
 */
public class SQL {
	
	
	/**
	 * 首页信息_交易公告_重点推荐_预披露(不包括招标采购的重点推荐)
	 */
/*	public static final String index_jygg_info_sql = " select " +
			//" (CASE WHEN jjia.JingJiaFangShi ='3' THEN '******' ELSE CAST(CAST( ISNULL(jjia.MaxQuotePrice, jjia.FromPrice)  as decimal(18, 2)) as VARCHAR )END) as currentprice , " + 
			" (CASE WHEN jjia.JingJiaFangShi ='3' THEN '******' ELSE CAST ( gc.CRDPrice * isnull(gc.shul,1)  AS DECIMAL (18, 2) ) END) as guapaiprice ," +
			" cjgg.rowguid cjgg_guid,jjia.BeginDate jingjia_start ,cast(jjia.PlanEndTime as datetime) jingjia_end, temp_2.*,temp_3.*,gc.ispllr,jygg.JiaoNaBZJMoney baozhengjprice,jygg.GongGaoFromDate,jygg.GongGaoToDate,jygg.ProjectGuid from ( " +
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001001001' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //产权交易交易公告_房地产
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001001002' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //产权交易交易公告_股权
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001001003' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //产权交易交易公告_二手车
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001001004' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +   //产权交易交易公告_废旧物资
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9'  AND StartDate < GetDate()   and Categorynum ='001001005' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //产权交易交易公告_粮食
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9'  AND StartDate < GetDate()   and Categorynum ='001001006' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //产权交易交易公告_其他资产
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9'  AND StartDate < GetDate()   and Categorynum ='001001007' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //产权交易交易公告_工美藏品
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9'  AND StartDate < GetDate()   and Categorynum ='001001008' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //产权交易交易公告_花木交易
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9'  AND StartDate < GetDate()   and Categorynum ='001001009' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " + //产权交易交易公告_房产招租
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9'  AND StartDate < GetDate()   and Categorynum ='001001010' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //产权交易交易公告_船舶
			" select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum,clicktimes click FROM View_InfoMain  where 1=1  AND InfoStatusCode ='9'  AND StartDate < GetDate()   and Categorynum ='001001011' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 " +
			" ) as temp_2  " +
			" left join CQJY_JiaoYiGongGao jygg on jygg.RowGuid = temp_2.infoid " + 
			" left join CQJY_GongChengInfo gc on gc.ProjectGuid=jygg.ProjectGuid " +
			" left join JQXT_ProjectInfo jjia on jjia.ProjectGuid=jygg.ProjectGuid " +
			" left join CQJY_ChengJiaoGongGao cjgg on cjgg.ProjectGuid = jygg.ProjectGuid and cjgg.AuditStatus=3 " +
			" OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_2.infoid) temp_3  " +
			" where 1=1  ";*/
	
	/**
	 * 首页信息_交易公告
	 */
	public static final String index_jygg_info_sql = "   select * from ( " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001001' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001002' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001003' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001004' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001005' order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001006' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001007' order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001008' order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001009' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001010' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,ordertype ASC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all  " +
			" select * from (select (CASE   WHEN  (gonggaofromdate < getdate() and gonggaotodate > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4))) THEN 1  WHEN (jingjia_start < getdate() and  jingjia_end > getdate() and (cjgg_guid is null or cjgg_guid='') AND (projectcontroltype NOT IN ('1', '2') or projectcontroltype is null ) and (jjia_status IS NULL OR  (jjia_status != 3 and  jjia_status != 4) )) THEN 2  WHEN (gonggaofromdate > getdate()) THEN 3 ELSE 4 END ) as ordertype,projectguid,AllowMoreJqxt,jjia_status,zt,projectcontroltype ,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice,IsMianY from view_infomain_jygg where Categorynum ='001001011' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1  " +
			"  ) as temp_111 OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_111.infoid) temp_3 ; ";

//	public static final String index_jygg_info_sql = " select * from ( "+
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001001' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001002' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001003' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001004' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001005' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001006' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001007' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001008' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001009' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001010' and gonggaofromdate < GETDATE() and gonggaotodate > GETDATE()  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
//			"select * from (select zt,ispllr,jygg_guid infoid,ProjectNum,Title,Categoryname ProjectStyle,jingjiafangshi,isfrompricexs,cjgg_guid,gonggaotodate,gonggaofromdate,jingjia_start,jingjia_end,Categorynum, click,guapaiprice from view_infomain_jygg where Categorynum ='001001011' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 " +
//			" ) as temp_111 OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_111.infoid) temp_3 ";

	/**
	 * 首页成交公告
	 */
	/*public static final String index_cjgg_info_sql = 
			"select * from ( " +
			" select IsTop,OrderNum,infomain.ClickTimes click,infomain.CategoryNum,infomain.projectstyle,cjgg.SHR_Date,cjgg.ChengJiaoPrice,gc.IsPLLR ,reg.ProjectRegGuid jygg_guid,infomain.infoid cjgg_guid,infomain.Title,gc.ProjectNo ProjectNum from " + 
			"(select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002001' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " + // --产权交易成交公告_房地产
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002002' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_股权
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002003' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_二手车
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002004' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_废旧物质
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002005' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_粮食
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002006' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_其他
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002007' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_工美藏品
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002008' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_花木交易
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002009' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_房产招租
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002010' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_船舶
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002011' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 " +  
			" ) as infomain " + 
			" left JOIN CQJY_GongChengInfo gc on infomain.ProjectNum=gc.ProjectNo " + 
			" left join CQJY_ChengJiaoGongGao cjgg  on gc.ProjectGuid=cjgg.ProjectGuid " + 
			" left join CQJY_ProjectRegister reg on reg.ProjectRegGuid=gc.ProjectRegGuid " + 
			" where gc.AuditStatus=3 and cjgg.AuditStatus=3 and gc.IsPLLR=1 " + 
			" and infomain.Categorynum like '00100200_' " + 
			
			" UNION all" +
			
			" select IsTop,OrderNum,infomain.ClickTimes click,infomain.CategoryNum,infomain.projectstyle,cjgg.SHR_Date,cjgg.ChengJiaoPrice,gc.IsPLLR ,jygg.RowGuid jygg_guid,infomain.infoid cjgg_guid,infomain.Title,gc.ProjectNo ProjectNum from " + 
			" ( select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002001' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //--产权交易成交公告_房地产
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002002' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //  --产权交易成交公告_股权
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002003' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //  --产权交易成交公告_二手车
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002004' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //  --产权交易成交公告_废旧物质
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002005' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //  --产权交易成交公告_粮食
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002006' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //  --产权交易成交公告_其他
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002007' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //  --产权交易成交公告_工美藏品
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002008' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //  --产权交易成交公告_花木交易
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002009' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //  --产权交易成交公告_房产招租
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002010' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +  //  --产权交易成交公告_船舶
			" select * from ( SELECT infoid,ClickTimes,ProjectNum,CategoryName,Title,ProjectStyle,EndDate,Categorynum,IsTop,OrderNum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='001002011' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 " +  //
			" ) as infomain " +
			" left JOIN CQJY_GongChengInfo gc on infomain.ProjectNum=gc.ProjectNo " +
			" left join CQJY_ChengJiaoGongGao cjgg  on gc.ProjectGuid=cjgg.ProjectGuid " + 
			" left join CQJY_JiaoYiGongGao jygg on jygg.ProjectGuid=cjgg.ProjectGuid " + 
			" where gc.AuditStatus=3 and cjgg.AuditStatus=3 and (gc.IsPLLR<>'1' or gc.IsPLLR is null) " + 
			" and infomain.Categorynum like '00100200_' " +
			" ) as temp_4 where 1=1 " +
			" order by IsTop DESC,OrderNum desc";
	*/

	/**
	 * 首页成交公告
	 */
	public static final String index_cjgg_info_sql = 
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002001'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002002'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002003'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002004'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002005'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002006'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002007'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002008'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"SELECT * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002009'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002010'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 UNION all " +
			"select * from (select IsTop,OrderNum, click,CategoryNum,Categoryname, chengjiaodate,ChengJiaoPrice,IsPLLR , jygg_guid, cjgg_guid,Title, ProjectNum from view_infomain_cjgg where Categorynum ='001002011'  order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY) as temp_1 ";
	
	
	
	/**
	 * 首页招标采购
	 */
	public static final String zgcc_sql = 
			"select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='002001001' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//招标采购招标公告_工程
			"select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='002001002' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//招标采购招标公告_货物
			"select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='002001003' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//招标采购招标公告_服务
			
			"select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='002002001' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//招标采购中标公示_工程
			"select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='002002002' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//招标采购中标公示_货物
			"select * from ( SELECT infoid,ProjectNum,Title,ProjectStyle,EndDate,Categorynum FROM View_InfoMain  where 1=1 AND InfoStatusCode ='9' AND StartDate < GetDate()   and Categorynum ='002002003' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 " ;//招标采购中标公示_服务

	/**
	 * 首页预披露
	 */
	public static final String index_ypl = "select * from ( " +
			"select * from ( SELECT infoid,ProjectNum,Title,StartDate,EndDate,Categorynum,ClickTimes click,infodate,case when CategoryName='产股权' then '股权' else CategoryName end as CategoryName FROM View_InfoMain  where 1=1 AND (InfoStatusCode ='9' or InfoStatusCode ='-2')    and Categorynum ='001003001' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//股权预披露
			"select * from ( SELECT infoid,ProjectNum,Title,StartDate,EndDate,Categorynum,ClickTimes click,infodate,case when CategoryName='产股权' then '股权' else CategoryName end as CategoryName FROM View_InfoMain  where 1=1 AND (InfoStatusCode ='9' or InfoStatusCode ='-2')    and Categorynum ='001003002' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//债权预披露
			"select * from ( SELECT infoid,ProjectNum,Title,StartDate,EndDate,Categorynum,ClickTimes click,infodate,case when CategoryName='产股权' then '股权' else CategoryName end as CategoryName FROM View_InfoMain  where 1=1 AND (InfoStatusCode ='9' or InfoStatusCode ='-2')    and Categorynum ='001003003' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//房地产预披露
			"select * from ( SELECT infoid,ProjectNum,Title,StartDate,EndDate,Categorynum,ClickTimes click,infodate,case when CategoryName='产股权' then '股权' else CategoryName end as CategoryName FROM View_InfoMain  where 1=1 AND (InfoStatusCode ='9' or InfoStatusCode ='-2')    and Categorynum ='001003004' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//房产招租预披露
			"select * from ( SELECT infoid,ProjectNum,Title,StartDate,EndDate,Categorynum,ClickTimes click,infodate,case when CategoryName='产股权' then '股权' else CategoryName end as CategoryName FROM View_InfoMain  where 1=1 AND (InfoStatusCode ='9' or InfoStatusCode ='-2')    and Categorynum ='001003005' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 union all " +//二手车预披露
			"select * from ( SELECT infoid,ProjectNum,Title,StartDate,EndDate,Categorynum,ClickTimes click,infodate,case when CategoryName='产股权' then '股权' else CategoryName end as CategoryName FROM View_InfoMain  where 1=1 AND (InfoStatusCode ='9' or InfoStatusCode ='-2')    and Categorynum ='001003006' order by IsTop DESC,OrderNum desc  offset 0 rows  FETCH NEXT 8 ROWS ONLY  )as temp_2 " +//废旧物资预披露
			") as temp_2  OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_2.infoid) temp_3 ";



	/**
	 * 竞价大厅_产权交易
	 */
	public static final String jjdt_cqjy_sql = "select * from ( " + 
		" SELECT b.GongGaoFromDate " +
		" ,b.GongGaoToDate ,d.sheng,d.shi" +
		" , a.BiaoDiNO, b.GongGaoGuid AS infoguid, a.BiaoDiName AS object , g.Citycode AS orgName " +
//		-- ProjectStatus：0尚未开始、1正在竞价、2延时竞价、3竞价结束、4竞价暂停
//		--2017-05-25 为排序需要将竞价中的排在前面,将竞价中的状态改成 0 ,未开始改为  1
		" ,(case when a.ProjectStatus = '0' THEN '2' WHEN (a.ProjectStatus = '1' or a.ProjectStatus = '2') THEN '0' ELSE '3' END)AS status  " +
		" ,cast(a.BeginDate as datetime) as start " +
		" ,cast(a.PlanEndTime as datetime) endTime, c.ProjectType " +
		" ,ISNULL(c.ProjectControlType, '') as ProjectControlType " +
		" ,(case when a.MaxQuotePrice is null then '0' else '1' end) as hasBid " +
//		-- 密封报价，不显示价格 " 
		" ,(CASE WHEN (a.JingJiaFangShi ='3' ) THEN '******' ELSE CAST(CAST((CASE WHEN a.CurrencyUnit = '2' THEN ISNULL(a.MaxQuotePrice, a.FromPrice) *10000 ELSE ISNULL(a.MaxQuotePrice, a.FromPrice) END) as decimal(18, 2)) as VARCHAR )END) as maxPrice " +
		" ,(CASE WHEN (a.JingJiaFangShi ='3' and a.IsFromPriceXs!='1' ) THEN '******' ELSE CAST(CAST((CASE WHEN a.CurrencyUnit = '2' THEN a.FromPrice * 10000 ELSE a.FromPrice END) as decimal(18, 2)) as varchar) END) as price " +
		" ,(case when e.IsPLLR ='1' then ('infodetail?infoid=' +e.projectRegGuid) else ('infodetail?infoid=' +b.RowGuid) end) as project_url " +
		" FROM dbo.JQXT_ProjectInfo AS a  " +
		" INNER JOIN dbo.CQJY_JiaoYiGongGao AS b ON a.ProjectGuid = b.ProjectGuid  " +
		" INNER JOIN dbo.CQJY_GongChengInfo AS c ON a.ProjectGuid = c.ProjectGuid  " +
		" INNER JOIN dbo.WebDB_Information AS d ON (b.GongGaoGuid = d.InfoID or c.ProjectRegGuid=d.InfoID) " +
		" INNER JOIN CQJY_ProjectRegister e ON c.ProjectRegGuid =e.ProjectRegGuid AND e.AuditStatus ='3' " +
		" INNER JOIN Sys_XiaQu g ON g.CityCode =c.XiaQuCode " +
		" WHERE (a.ProjectJiaoYiType = '产权交易') AND (b.AuditStatus = '3') and a.BiaoDiName not like '%勿拍' and a.BiaoDiName not like '%勿报名%'  and cast(a.BeginDate as datetime) > (GETDATE()-90) " +
		" ) as temp_111";
//		+ "ORDER BY a.ProjectStatus asc,a.PlanEndTime desc ";
	//ORDER BY a.ProjectStatus asc,a.PlanEndTime asc
	
	
	
// where BiaoDiNO in('12ZZKG20170016');

	

	
	
	/**
	 * 批量挂牌_交易公告 lastupdate 是否更新sql
	 */
	public static String plgp_chengjiao_gonggao_pic_handle_sql = " select DISTINCT infoid,lastupdate from (	select " +
			" max (a.SHR_Date) lastupdate,c.InfoID 	" +
			" from View_InfoMain AS c " +
			" INNER JOIN CQJY_ProjectRegister g ON g.ProjectRegGuid =c.InfoID " +
			" INNER JOIN dbo.CQJY_GongChengInfo AS b ON g.ProjectRegGuid = b.ProjectRegGuid " +
			" INNER JOIN CQJY_JiaoYiGongGao AS a ON a.ProjectGuid =b.ProjectGuid " +
			" WHERE a.AuditStatus = '3' and b.IsPLLR=1 and (c.InfoStatusCode=9  or c.InfoStatusCode='-2')  group by c.InfoID) as temp_1 " ;
			
//			" where temp_1.lastupdate > (select top 1 optime from web_pic_handle)";
	
	
	/**
	 * 非批量挂牌_交易公告 lastupdate 是否更新sql,包含重点推荐,普通挂牌的公告
	 */
	public static String jiaoyi_gonggao_pic_handle_sql = "select DISTINCT infoid,lastupdate from ( select " +
			"  c.infoid, a.SHR_Date as lastupdate " +
			" from dbo.CQJY_JiaoYiGongGao AS a " + 
			" INNER JOIN View_InfoMain AS c ON SUBSTRING(c.InfoID,0,37) = a.GongGaoGuid " + 
			" WHERE  1=1 and a.AuditStatus = '3' and  ( c.InfoStatusCode=9 or c.InfoStatusCode=-2 )) as temp_1 " ;
			
			
//			" where temp_1.lastupdate > (select top 1 optime from web_pic_handle) ";

	
	/**
	 * 预披露 图片处理
	 */
	public static String ypl_pic_handle_sql = " select  infoid from View_InfoMain " +
			"where CategoryNum like '00100300_' and  ( InfoStatusCode=9 or InfoStatusCode=-2 )  ";

 

	
//" and c.infoid='87598153-d439-4949-bb99-6f9d1db433cd'"

	
	
	/**
	 * 产权交易_项目类别
	 */
	public static String cqjy_type_sql = "select ItemValue as type,ItemText as typeName from View_CodeMain_CodeItems where CodeName='产权类别' ";
	
	/**
	 * 资产类别
	 */
	
	public static String zc_type_sql = "select ItemText,ItemValue from VIEW_CodeMain_CodeItems where codeid=2835";
	
	
	/**
	 * 交易公告当前状态
	 */
	public static String jygg_state_sql ="SELECT  cjgg.rowguid cjgg_guid,jjia.BeginDate jingjia_start ,cast(jjia.PlanEndTime as datetime) jingjia_end,jygg.GongGaoFromDate,\n" +
			"\t\t\tjygg.GongGaoToDate\n" +
			"\t\t\t from   CQJY_JiaoYiGongGao jygg \n" +
			"\t\t\t left JOIN CQJY_GongChengInfo gc ON gc.ProjectGuid = jygg.ProjectGuid \n" +
			"\t\t\t LEFT JOIN JQXT_ProjectInfo jjia ON jjia.ProjectGuid = jygg.ProjectGuid \n" +
			"\t\t\t LEFT JOIN CQJY_ChengJiaoGongGao cjgg ON cjgg.ProjectGuid = jygg.ProjectGuid and cjgg.AuditStatus=3 \n" +
			"\t\t\t WHERE vi.InfoID = ? ";
//	public static String jygg_state_sql = "SELECT cjgg.rowguid cjgg_guid,jjia.BeginDate jingjia_start ,cast(jjia.PlanEndTime as datetime) jingjia_end,vi.StartDate GongGaoFromDate,vi.EndDate GongGaoToDate " +
//			" from  View_InfoMain vi left join  CQJY_JiaoYiGongGao jygg on jygg.RowGuid=vi.InfoID " +
//			" left JOIN CQJY_GongChengInfo gc ON gc.ProjectGuid = jygg.ProjectGuid " +
//			" LEFT JOIN JQXT_ProjectInfo jjia ON jjia.ProjectGuid = jygg.ProjectGuid " +
//			" LEFT JOIN CQJY_ChengJiaoGongGao cjgg ON cjgg.ProjectGuid = jygg.ProjectGuid and cjgg.AuditStatus=3 " +
//			" WHERE vi.InfoID = ? ";
	
	/**
	 * 成交公告更多 sql,根据成交公告获取交易公告(包括了批量挂牌的)
	 */
//	public static String cjgg_more_bak = "select * from ( " +
//			" select infomain.ClickTimes click,infomain.CategoryNum,infomain.SHENG,infomain.SHI,infomain.CategoryName,cjgg.SHR_Date,cjgg.ChengJiaoPrice,infomain.IsTop,infomain.OrderNum,gc.IsPLLR ,reg.ProjectRegGuid jygg_guid,infomain.infoid cjgg_guid,infomain.Title,gc.ProjectNo ProjectNum from  View_InfoMain infomain " + 
//			" left JOIN CQJY_GongChengInfo gc on infomain.ProjectNum=gc.ProjectNo " +
//			" left join CQJY_ChengJiaoGongGao cjgg  on gc.ProjectGuid=cjgg.ProjectGuid " +
//			" left join CQJY_ProjectRegister reg on reg.ProjectRegGuid=gc.ProjectRegGuid " +
//			" where gc.AuditStatus=3 and cjgg.AuditStatus=3 and gc.IsPLLR=1 " +
//			" and infomain.Categorynum like ? and infomain.InfoStatusCode='9' and infomain.StartDate < GetDate() " + 
//			" UNION all " +
//			" select infomain.ClickTimes click,infomain.CategoryNum,infomain.SHENG,infomain.SHI,infomain.CategoryName,cjgg.SHR_Date,cjgg.ChengJiaoPrice,infomain.IsTop,infomain.OrderNum,gc.IsPLLR ,jygg.RowGuid jygg_guid,infomain.infoid cjgg_guid,infomain.Title,gc.ProjectNo ProjectNum from  View_InfoMain infomain " + 
//			" left JOIN CQJY_GongChengInfo gc on infomain.ProjectNum=gc.ProjectNo " +
//			" left join CQJY_ChengJiaoGongGao cjgg  on gc.ProjectGuid=cjgg.ProjectGuid " +
//			" left join CQJY_JiaoYiGongGao jygg on jygg.ProjectGuid=cjgg.ProjectGuid " +
//			" where gc.AuditStatus=3 and cjgg.AuditStatus=3 and (gc.IsPLLR<>'1' or gc.IsPLLR is null) " +
//				" and infomain.Categorynum like ? and infomain.InfoStatusCode='9' and infomain.StartDate < GetDate() " + 
//			" ) as temp_4 OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_4.jygg_guid) temp_3 where 1=1 ";


	/**
	 * 重点推荐更多
	 */
	public static String zdtj_more_sql = "select * from ( " +
			" SELECT startdate,enddate,infoid, sheng,shi,InfoStatusCode,cast( price as NUMERIC) as guapaiprice,ProjectNum,Title,ProjectStyle,EndDate gonggaotodate,StartDate gonggaofromdate,Categorynum ,clicktimes click,IsTop , orderNum ,InfoDate ,PubInWebDate ,SysID " +
			" FROM View_InfoMain  where 1=1 " +
			" and (Categorynum  = '031001' or  Categorynum  = '031003') " +
			" UNION all " +
			" SELECT startdate,enddate,infoid, sheng,shi,InfoStatusCode,cast(biaoduan.YuSuanTotalPrice as NUMERIC) as guapaiprice,ProjectNum,Title,ProjectStyle,EndDate,StartDate,Categorynum,clicktimes click,IsTop , orderNum ,InfoDate ,PubInWebDate ,SysID " +
			" FROM View_InfoMain vmain " +
			" left join Zfcg_BiaoDuan biaoduan on biaoduan.BiaoDuanBH = vmain.ProjectNum " +
			" where 1=1 and (Categorynum  = '031002') " +
			" ) as temp_4  OUTER APPLY (select top 1 path titlepic from web_gonggao_pic pic where pic.guid=temp_4.infoid)  temp_3 " +
			"where 1=1 and temp_4.guapaiprice > 5000000";

//" order by IsTop DESC,OrderNum desc ";

//order by IsTop DESC,OrderNum desc  
//offset 0 rows  FETCH NEXT 8 ROWS ONLY

	/**
	 * 首页交易公告more(已改成试图)
	 */
//	public static String jygg_more_sql_bak ="" +
//			"select * from ( " +
//			" SELECT " +
//			" (CASE WHEN jjia.JingJiaFangShi = '3' THEN '******' ELSE CAST (CAST (ISNULL(jjia.MaxQuotePrice,jjia.FromPrice) AS DECIMAL (18, 2)) AS VARCHAR)END) AS currentprice, " +
//			" CAST (((CASE WHEN gc.SystemType NOT IN ('CCJT', 'NMG') THEN( gc.CRDPrice * isnull(gc.shul, 1) * 10000 ) ELSE gc.CRDPrice * isnull(gc.shul, 1)END)) AS DECIMAL (18, 2)) AS guapaiprice, " +
//			" cjgg.rowguid cjgg_guid, " +
//			" jjia.BeginDate jingjia_start, " +
//			" CAST (jjia.PlanEndTime AS datetime) jingjia_end, " +
//			" gc.ispllr,jygg.JiaoNaBZJMoney baozhengjprice, " +
//			" webdb.startdate gonggaofromdate,webdb.enddate gonggaotodate,webdb.title,webdb.sheng,webdb.infoid,webdb.projectNum,webdb.projectstyle,webdb.clicktimes click,webdb.IsTop,webdb.OrderNum,webdb.infodate " +
//			" ,gc.CQYWType ,webdb.categorynum" +
//			" FROM view_infomain webdb " +
//			" left JOIN CQJY_JiaoYiGongGao jygg ON jygg.RowGuid = webdb.infoid " +
//			" left JOIN CQJY_GongChengInfo gc ON gc.ProjectGuid = jygg.ProjectGuid and (gc.IsPLLR=0 or gc.IsPLLR is null) " +
//			" left JOIN JQXT_ProjectInfo jjia ON jjia.ProjectGuid = jygg.ProjectGuid " +
//			" left JOIN CQJY_ChengJiaoGongGao cjgg ON cjgg.ProjectGuid = jygg.ProjectGuid AND cjgg.AuditStatus = 3 " + 
//			" WHERE webdb.InfoStatusCode = '9' AND webdb.StartDate < GetDate() AND webdb.Categorynum LIKE '001001___' " + 
//			
//			" UNION all " +
//			
//			" SELECT DISTINCT " + 
//			" null currentprice, " +
//			" null guapaiprice, " +
//			" null cjgg_guid, " +
//			" null jingjia_start, " +
//			" null jingjia_end, " +
//			" gc.IsPLLR, " +
//			" null baozhengjprice, " +
//			"  webdb.startdate gonggaofromdate,webdb.enddate gonggaotodate,webdb.title,webdb.sheng,webdb.infoid,webdb.projectNum,webdb.projectstyle,webdb.clicktimes click,webdb.IsTop,webdb.OrderNum,webdb.infodate " +
//			" ,gc.CQYWType ,webdb.categorynum" +
//			" FROM view_infomain webdb " +
//			" inner  JOIN CQJY_ProjectRegister reg ON webdb.infoid = reg.ProjectRegGuid " +
//			" inner JOIN CQJY_GongChengInfo gc ON reg.ProjectRegGuid=gc.ProjectRegGuid and gc.IsPLLR=1" +
//			" WHERE webdb.InfoStatusCode = '9' AND webdb.StartDate < GetDate() AND webdb.Categorynum LIKE '001001___' " + 
//			" ) as temp_2 where 1=1 ";
	
	/**
	 * 首页交易公告more_数量统计(已改成试图)
	 */
	
	/*
	public static String jygg_more_count_sql ="" +
			"select * from ( " +
			" SELECT " +
			" (CASE WHEN jjia.JingJiaFangShi = '3' THEN '******' ELSE CAST (CAST (ISNULL(jjia.MaxQuotePrice,jjia.FromPrice) AS DECIMAL (18, 2)) AS VARCHAR)END) AS currentprice, " +
			" CAST (((CASE WHEN gc.SystemType NOT IN ('CCJT', 'NMG') THEN( gc.CRDPrice * isnull(gc.shul, 1) * 10000 ) ELSE gc.CRDPrice * isnull(gc.shul, 1)END)) AS DECIMAL (18, 2)) AS guapaiprice, " +
			" cjgg.rowguid cjgg_guid, " +
			" jjia.BeginDate jingjia_start, " +
			" CAST (jjia.PlanEndTime AS datetime) jingjia_end, " +
			" gc.ispllr,jygg.JiaoNaBZJMoney baozhengjprice, " +
			" webdb.startdate gonggaofromdate,webdb.enddate gonggaotodate,webdb.title,webdb.sheng,webdb.infoid,webdb.projectNum,webdb.projectstyle,webdb.clicktimes click,webdb.IsTop,webdb.OrderNum,webdb.infodate " +
			" ,gc.CQYWType " +
			" FROM view_infomain webdb " +
			" left JOIN CQJY_JiaoYiGongGao jygg ON jygg.RowGuid = webdb.infoid " +
			" left JOIN CQJY_GongChengInfo gc ON gc.ProjectGuid = jygg.ProjectGuid and (gc.IsPLLR=0 or gc.IsPLLR is null) " +
			" left JOIN JQXT_ProjectInfo jjia ON jjia.ProjectGuid = jygg.ProjectGuid " +
			" left JOIN CQJY_ChengJiaoGongGao cjgg ON cjgg.ProjectGuid = jygg.ProjectGuid AND cjgg.AuditStatus = 3 " + 
			" WHERE webdb.InfoStatusCode = '9' AND webdb.StartDate < GetDate() AND webdb.Categorynum LIKE '001001___' " + 
			
			" UNION all " +
			
			" SELECT DISTINCT " + 
			" null currentprice, " +
			" null guapaiprice, " +
			" null cjgg_guid, " +
			" null jingjia_start, " +
			" null jingjia_end, " +
			" gc.IsPLLR, " +
			" null baozhengjprice, " +
			"  webdb.startdate gonggaofromdate,webdb.enddate gonggaotodate,webdb.title,webdb.sheng,webdb.infoid,webdb.projectNum,webdb.projectstyle,webdb.clicktimes click,webdb.IsTop,webdb.OrderNum,webdb.infodate " +
			" ,gc.CQYWType " +
			" FROM view_infomain webdb " +
			" inner  JOIN CQJY_ProjectRegister reg ON webdb.infoid = reg.ProjectRegGuid  " +
			" inner JOIN CQJY_GongChengInfo gc ON reg.ProjectRegGuid=gc.ProjectRegGuid and gc.IsPLLR=1 " +
			" WHERE webdb.InfoStatusCode = '9' AND webdb.StartDate < GetDate() AND webdb.Categorynum LIKE '001001___' " + 
			" ) as temp_2 where 1=1 ";
	*/
}
