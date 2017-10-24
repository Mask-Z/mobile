package com.ccjt.ejy.web.services.m;

import static com.ccjt.ejy.web.commons.JDBC.jdbc;

import java.util.*;

import javax.xml.datatype.DatatypeConfigurationException;

import com.ccjt.ejy.web.vo.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.commons.Global;
import com.ccjt.ejy.web.commons.httpclient.HttpClient;
import com.ccjt.ejy.web.enums.m.DataType;
import com.ccjt.ejy.web.enums.m.FileType;
import com.ccjt.ejy.web.vo.m.Dict;


public class ProjectSignService {

	private static Logger log = LogManager.getLogger(ProjectSignService.class);

	/**
	 * 所属会员机构
	 *
	 * @param
	 * @return
	 */
	public List<Map<String, Object>> sshyjg() {
		List<Map<String, Object>> dict_list = null;
		try {
			String sql = " select DanWeiGuid guid,DanWeiName name from VIEW_HuiYuan_AllDaiLiJG where AuditStatus ='3' and StatusCode='2' order by Row_ID desc ";

			dict_list = jdbc.mapList(sql);

		} catch (Exception e) {
			log.error("获取基础数据出错:", e);
			e.printStackTrace();
		}
		return dict_list;
	}


	/**
	 * 项目报名信息
	 *
	 * @param page
	 * @param status 项目状态
	 * @param pronum 项目编号
	 * @param jyjg   交易机构
	 * @param title  项目名称
	 * @return
	 */
	public List<GongGao> xmbm_more(Page page, String status, String pronum, String jyjg, String title, String dwguid) {
		//报名公告列表
		List<GongGao> bmgg_list = null;
		List<Object> params = new ArrayList<Object>();
		if (StringUtils.isBlank(status)) {
			status = "1";
		}
		try {
			String sql = " select gc.ProjectType projectstyle,v_jygg.systemtype,v_jygg.RowGuid as infoid,v_jygg.ProjectName as title ,v_jygg.GongGaoToDate as gonggaotodate,v_jygg.projectguid, v_jygg.GongGaoFromDate as gonggaofromdate," +
					" case (gc.SystemType) " +
					" when 'NMG' then  " +
					" case (select IsJmrProviseEnable from JGSetMessage where JGCode in(select XiaQuCode from CQJY_GongChengInfo where CQJY_GongChengInfo.ProjectGuid=v_jygg.ProjectGuid)) when '1' then '1' else '0' end " +
					" when 'GQ' then  " +
					" case (select IsJmrProviseEnable from JGSetMessage where JGCode in(select XiaQuCode from CQJY_GongChengInfo where CQJY_GongChengInfo.ProjectGuid=v_jygg.ProjectGuid)) when '1' then '1' else '0' end " +
					" when 'ZZKG' then " +
					" case (select IsJmrProviseEnable from JGSetMessage where JGCode in(select XiaQuCode from CQJY_GongChengInfo where CQJY_GongChengInfo.ProjectGuid=v_jygg.ProjectGuid)) when '1' then '1' else '0' end else '1' " +
					" end " +
					" as IsOpen,v_jygg.GongGaoNo ,bm.RowGuid bmguid,sr.ZhuanRangType zhuanRangType " +
					" from View_CQJY_JiaoYiGongGaoAndInfoNew  v_jygg " +
					" left join CQJY_BaoMing bm on v_jygg.ProjectGuid=bm.ProjectGuid  AND bm.DanWeiGuid=? " +
					" left join CQJY_GongChengInfo gc on gc.RowGuid=v_jygg.ProjectGuid " +
					" left join ShouRangfInfo sr on sr.RowGuid=v_jygg.ProjectGuid " +
					" where " +
					" GongGaoStatusCode='9' and v_jygg.AuditStatus='3' " +
					" and isnull(v_jygg.IsSetJJZT,'') !='1'  " +
					" and isnull(v_jygg.ProjectControlType,'') !='2' " +
					" and isnull(v_jygg.IsLiuBiao,'')!='1' ";


			params.add(dwguid);

			if (StringUtils.isNotBlank(title)) {
				//select语句中用的是ProjectName,这里也用ProjectName
				sql += " and v_jygg.ProjectName like ?";
				params.add("%" + title + "%");
			}

			if (StringUtils.isNotBlank(status)) {
				if (status.equals("0")) {//未开始
					sql += " and v_jygg.GongGaoFromDate > getdate() ";
				} else if (status.equals("1")) {//报名中
					sql += " and v_jygg.GongGaoFromDate <=getdate() and v_jygg.GongGaoToDate > Getdate() ";
				} else if (status.equals("2")) {//报名结束
					sql += " and v_jygg.GongGaoToDate <getdate() ";
				} else if (status.equals("3")){//已报名
					sql += " and exists(select 1 from CQJY_BaoMing where ProjectGuid=v_jygg.ProjectGuid And DanWeiGuid=?) ";
					params.add(dwguid);
				}
			}

			if (StringUtils.isNotBlank(pronum)) {
				sql += " and v_jygg.GongGaoNo like ?";
				params.add("%" + pronum + "%");
			}

			if (StringUtils.isNotBlank(jyjg)) {
				sql += " and v_jygg.XiaQuCode=?  ";
				params.add(jyjg);
			}

			page.setTotal(jdbc.getCount(sql, params.toArray()));

			if (StringUtils.isNotBlank(dwguid)) {
//				sql += " order by v_jygg.Row_ID desc ";//我的报名排序
				sql += " order by (case when v_jygg.GongGaoToDate>=getdate() then 0 else 1 end),v_jygg.Row_ID desc ";//我的报名排序
			} else {
//				sql += "order by (case when v_jygg.GongGaoToDate>=getdate() then 0 else 1 end),v_jygg.Row_ID desc";
				sql += " order by v_jygg.Row_ID desc";
			}
			System.out.println("SQL: " + sql);

			sql = jdbc.pageSql(sql, page.getCurrentPage(), page.getRows());

			bmgg_list = jdbc.beanList(sql, GongGao.class, params.toArray());

			long date=new Date().getTime();
			for (GongGao gg : bmgg_list) {

				if (StringUtils.isBlank(gg.getBmguid())) {
					if (gg.getGonggaofromdate().getTime() > date) {//未开始,不能查看
						gg.setProject_baoming_status(0);
					} else if (gg.getGonggaofromdate().getTime() <= date && gg.getGonggaotodate().getTime() > date) {//报名中,可以查看
						gg.setProject_baoming_status(1);
					} else if (gg.getGonggaotodate().getTime() <= date) {//项目已结束,不能查看
						gg.setProject_baoming_status(2);
					}
				}else {//报过名,可以查看
					gg.setProject_baoming_status(3);
				}


				if (gg != null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() > 55) {
					gg.setTitle(gg.getTitle().substring(0, 55) + "...");
				}
			}


		} catch (Exception e) {
			log.error("获取项目报名公告出错:", e);
			e.printStackTrace();
		}
		return bmgg_list;
	}


	/**
	 * 专厅报名
	 *
	 * @param page
	 * @param status
	 * @param pronum 项目编号
	 * @param jyjg 交易机构
	 * @param title
	 * @return
	 */
	public List<GongGao> ztbm_more(Page page, String status, String pronum, String jyjg, String title, String dwguid) {
		//报名公告列表
		List<GongGao> bmgg_list = null;
		List<Object> params = new ArrayList<Object>();
		try {

			String sql = "select  " +
					"(select top 1 BaoMingGuid  from CQJY_BaoMing where ZhuanTingGuid=zt.ZhuanTingGuid And DanWeiGuid=? ) as bmguid, " +
					"case zt.SystemType " +
					"when 'NMG' then  " +
					"  case (select IsJmrProviseEnable from JGSetMessage where JGCode in(select XiaQuCode from CQJY_GongChengInfo where CQJY_GongChengInfo.ZhuanTingGuid=zt.ZhuanTingGuid)) " +
					"  when '1' then '1' " +
					"  else '0'  " +
					"  end " +
					"else '1' " +
					"end as IsOpen,zt.RowGuid as infoid,zt.ZhuanTingGuid as projectguid,zt.ZhuanTingName as title,zt.XiaQuCode,zt.SBR_Code,zt.BZJEndDate as gonggaotodate,zt.SystemType as systemtype,zt.BaoMingStartDate as gonggaofromdate from CQJY_JingJiaZhuanTing zt  " +
					" where AuditStatus='3'";

			params.add(dwguid);
			if (StringUtils.isNotBlank(title)) {
				sql += " and ZhuanTingName like ?";
				params.add("%" + title + "%");
			}

			if (StringUtils.isNotBlank(status)) {
				if (status.equals("0")) {
					sql += " and BaoMingStartDate > getdate() ";
				} else if (status.equals("1")) {
					sql += " and BaoMingStartDate <=getdate() and BaoMingEndDate > Getdate()  ";
				} else if (status.equals("2")) {
					sql += " and BaoMingEndDate <getdate() ";
				} else if (status.equals("3")){
//					sql += " and exists(select 1 from CQJY_BaoMing where ProjectGuid=zt.ZhuanTingGuid And DanWeiGuid=?) ";
					sql +=" and exists(select 1 from CQJY_BaoMing where ZhuanTingGuid=zt.ZhuanTingGuid And DanWeiGuid=?) ";
					params.add(dwguid);
				}
			}
//			else {
//				sql += " and BaoMingStartDate <=getdate() and BaoMingEndDate > Getdate()  ";
//			}

			if (StringUtils.isNotBlank(jyjg)) {
				sql += " and zt.XiaQuCode=?  ";
				params.add(jyjg);
			}

			page.setTotal(jdbc.getCount(sql, params.toArray()));

			if (status.equals("3")){
				sql += " order by (case when BaoMingEndDate>=getdate() then 0 else 1 end),Row_ID desc ";
			}else {
				sql += " order by zt.Row_ID desc  ";
			}
			System.out.println("专厅报名sql: " + sql);
			sql = jdbc.pageSql(sql, page.getCurrentPage(), page.getRows());

			bmgg_list = jdbc.beanList(sql, GongGao.class, params.toArray());

			long date=new Date().getTime();
			for (GongGao gg : bmgg_list) {

				if (StringUtils.isBlank(gg.getBmguid())) {
					if (gg.getGonggaofromdate().getTime() > date) {//未开始,不能查看
						gg.setProject_baoming_status(0);
					} else if (gg.getGonggaofromdate().getTime() <= date && gg.getGonggaotodate().getTime() > date) {//报名中,可以查看
						gg.setProject_baoming_status(1);
					} else if (gg.getGonggaotodate().getTime() <= date) {//项目已结束,不能查看
						gg.setProject_baoming_status(2);
					}
				}else {//报过名,可以查看
					gg.setProject_baoming_status(3);
				}

				if (gg != null && StringUtils.isNotBlank(gg.getTitle()) && gg.getTitle().length() > 55) {
					gg.setTitle(gg.getTitle().substring(0, 55) + "...");
				}
			}


		} catch (Exception e) {
			log.error("获取项目报名公告出错:", e);
			e.printStackTrace();
		}
		return bmgg_list;
	}


	/**
	 * 项目报名机构列表
	 */
//	public List<Organize> xmbm_orglist(String table) {
//		List<Organize> list = new ArrayList<>();
//		String sql = "select distinct Sys_XiaQu.cityname  as name,CityCode as orgid ";
//		if (StringUtils.isBlank(table) || table.equals("ptbm")) {//普通报名组织机构
//			sql += "from View_CQJY_JiaoYiGongGaoAndInfoNew " +
//					"inner join Sys_XiaQu  on Sys_XiaQu.CityCode=View_CQJY_JiaoYiGongGaoAndInfoNew.XiaQuCode " +
//					"where GongGaoStatusCode='9' and AuditStatus='3' and isnull(IsSetJJZT,'') !='1'  " +
//					"and isnull(ProjectControlType,'') !='2' and isnull(IsLiuBiao,'')!='1' " +
//					"order by name asc ";
//		} else if (StringUtils.isNotBlank(table) && table.equals("ztbm")) {
//			sql += "from CQJY_JingJiaZhuanTing  " +
//					"inner join Sys_XiaQu  on Sys_XiaQu.CityCode=CQJY_JingJiaZhuanTing.XiaQuCode " +
//					"where AuditStatus='3' " +
//					"and Exists(Select 1 From CQJY_GongChengInfo info Where info.ZhuanTingGuid=CQJY_JingJiaZhuanTing.ZhuanTingGuid And ISNULL(IsLiuBiao,'')<>'1' " +
//					"And isnull(ProjectControlType,'') <>'2')  " +
//					"order by name asc";
//		}
//		try {
//			list = jdbc.beanList(sql, Organize.class);
//		} catch (Exception e) {
//			log.error("获取机构数据出错:", e);
//			e.printStackTrace();
//		}
//		return list;
//	}
	public Result getNMGInfo(Paramater param) {
		String pm = null;
		Result rs = null;
		if (param != null) {
			try {
				pm = JSON.toJSONString(param);
				rs = HttpClient.call(Global.baoming_url, pm);
			} catch (Exception e) {
				log.error("接口调用出错: ", e);
			}
		}
		return rs;
	}

	@SuppressWarnings("unchecked")
	public Object getGSType(Object obj) {
		Map<String, Object> data = null;
		String sql = "select ItemText from VIEW_CodeMain_CodeItems where CodeName = ? and ItemValue = ?";
		if (obj != null) {
			try {
				data = (Map<String, Object>) obj;

				String GongSiType = "GongSiType";
				String JingJiType = "JingJiType";
				String GuiMo = "GuiMo";
				String zjly_13003 = "ZiJinLaiYuan_13003";
				String zjly = "ZiJinLaiYuan";
				
				String gslx = "GongSiType_13003";//公司类型(经济性质)
				String jjtype = "JingJiType_13003";
				String cqlx = "ProjectType_3006";
				String cqlx_1 = "ProjectType_3001";
				
				String gzjgjg = "YQGuoZiJG_13003";//国资监管机构
				String gzjgjg_1 = "YQGuoZiJG";
				String gzjgjg_fyq = "FYQGuoZiJG_13003";//国资监管机构_非央企
				String gzjgjg_fyq_1 = "FYQGuoZiJG";//国资监管机构_非央企

				String jjgm = "GuiMo_13003";//经济规模

				if(data.containsKey(jjgm)){
					String typecode = data.get(jjgm).toString();
					String typename = jdbc.getString(sql, DataType.JJGM_JMR.getType(), typecode);
					data.put(jjgm + "_name", typename);
				}

				if (data.containsKey(GongSiType)) {//公司类型(经济性质)
					String typecode = data.get(GongSiType).toString();
					String typename = jdbc.getString(sql, "公司类型(经济性质)", typecode);
					data.put("gsType_name", typename);
				}
				if (data.containsKey(JingJiType)) {//经济类型
					String typecode = data.get(JingJiType).toString();
					String typename = jdbc.getString(sql, DataType.JJLX.getType(), typecode);
					data.put("JingJiType_name", typename);
				}
				if (data.containsKey(GuiMo)) {//经济规模（竞买人）
					String typecode = data.get(GuiMo).toString();
					String typename = jdbc.getString(sql, DataType.JJGM_JMR.getType(), typecode);
					data.put("GuiMo_name", typename);
				}
				if (data.containsKey(zjly_13003)) {//资金来源（新）
					String typecode = data.get(zjly_13003).toString();
					String typename = jdbc.getString(sql, DataType.ZJLY.getType(), typecode);
					data.put(zjly_13003 + "_name", typename);
				}
				
				if (data.containsKey(zjly)) {//资金来源（新）
					String typecode = data.get(zjly).toString();
					String typename = jdbc.getString(sql, DataType.ZJLY.getType(), typecode);
					data.put(zjly + "_name", typename);
				}

				if(data.containsKey(gzjgjg_1)){//国资监管机构
					String typecode = data.get(gzjgjg_1).toString();
					String typename = jdbc.getString(sql, DataType.GZJGJG.getType(), typecode);
					data.put(gzjgjg_1 + "_name", typename);
				}
				
				if(data.containsKey(gzjgjg)){//国资监管机构
					String typecode = data.get(gzjgjg).toString();
					String typename = jdbc.getString(sql, DataType.GZJGJG.getType(), typecode);
					data.put(gzjgjg + "_name", typename);
				}
				
				if(data.containsKey(gzjgjg_fyq)){//国资监管机构_非央企
					String typecode = data.get(gzjgjg_fyq).toString();
					String typename = jdbc.getString(sql, DataType.GZJGJG_FYQ.getType(), typecode);
					data.put(gzjgjg_fyq + "_name", typename);
				}
				if(data.containsKey(gzjgjg_fyq_1)){//国资监管机构_非央企
					String typecode = data.get(gzjgjg_fyq_1).toString();
					String typename = jdbc.getString(sql, DataType.GZJGJG_FYQ.getType(), typecode);
					data.put(gzjgjg_fyq_1 + "_name", typename);
				}
				
				
				if(data.containsKey(gzjgjg_fyq)){//国资监管机构_非央企
					String typecode = data.get(gzjgjg_fyq).toString();
					String typename = jdbc.getString(sql, DataType.GZJGJG_FYQ.getType(), typecode);
					data.put(gzjgjg_fyq + "_name", typename);
				}
				if(data.containsKey(gslx)){//公司类型-经济性质
					String typecode = data.get(gslx).toString();
					String typename = jdbc.getString(sql, DataType.GSLX_JJXZ.getType(), typecode);
					data.put(gslx + "_name", typename);
				}
				if(data.containsKey(jjtype)){//经济类型
					String typecode = data.get(jjtype).toString();
					String typename = jdbc.getString(sql, DataType.JJLX.getType(), typecode);
					data.put(jjtype + "_name", typename);
				}
				if(data.containsKey(cqlx)){//产权类型
					String typecode = data.get(cqlx).toString();
					String typename = jdbc.getString(sql, DataType.CQLB.getType(), typecode);
					data.put(cqlx + "_name", typename);
				}
				if(data.containsKey(cqlx_1)){//产权类型
					String typecode = data.get(cqlx_1).toString();
					String typename = jdbc.getString(sql, DataType.CQLB.getType(), typecode);
					data.put(cqlx_1 + "_name", typename);
				}
				
			} catch (Exception e) {
				log.error("获取实物报名数据出错: ", e);
			}
		}
		return data;
	}
	
	public Object getZZKGType(Map<String, Object> obj) {
		String sql = "select ItemText from VIEW_CodeMain_CodeItems where CodeName = ? and ItemValue = ?";
		if (obj != null) {
			try {

				String yewu_type = "CQYWType_3001";//产权类型
				String bz = "BiZhong_13003";//币种
				String hy = "HangYeType_13003";//行业
				String gslx = "CompanyLeiXing_13003";//公司类型
				String jjgm = "GuiMo_13003";//经济规模
				String bz2 = "MoneyType_13003";//币种2
				
				String zjly = "ZiJinLaiYuan_13003";
				
				String gsxz = "CompanyXingZhi_13003";//公司性质
				
				
				if(obj.containsKey(yewu_type)){//产权业务类别
					String typecode = obj.get(yewu_type).toString();
					String typename = jdbc.getString(sql, DataType.CQYWLB.getType(), typecode);
					obj.put(yewu_type + "_name", typename);
				}
				if(obj.containsKey(bz)){//币种
					String typecode = obj.get(bz).toString();
					String typename = jdbc.getString(sql, DataType.BZ.getType(), typecode);
					obj.put(bz + "_name", typename);
				}
				
				if(obj.containsKey(hy)){
					String typecode = obj.get(hy).toString();
					String typename = jdbc.getString("select IndustryName from Sys_IndustryCode where len(IndustryCode) = 3 and IndustryCode=?", typecode);
					obj.put(hy + "_name", typename);
				}
				
				if(obj.containsKey(gslx)){
					String typecode = obj.get(gslx).toString();
					String typename = jdbc.getString(sql, DataType.ZRF_JJXZ.getType(), typecode);
					obj.put(gslx + "_name", typename);
				}
				if(obj.containsKey(jjgm)){
					String typecode = obj.get(jjgm).toString();
					String typename = jdbc.getString(sql, DataType.JJGM_JMR.getType(), typecode);
					obj.put(jjgm + "_name", typename);
				}
				
				if(obj.containsKey(bz2)){//币种
					String typecode = obj.get(bz2).toString();
					String typename = jdbc.getString(sql, DataType.BZ.getType(), typecode);
					obj.put(bz2 + "_name", typename);
				}
				
				if (obj.containsKey(zjly)) {//资金来源（新）
					String typecode = obj.get(zjly).toString();
					String typename = jdbc.getString(sql, DataType.ZJLY.getType(), typecode);
					obj.put(zjly + "_name", typename);
				}
				if (obj.containsKey(gsxz)) {//公司性质
					String typecode = obj.get(gsxz).toString();
					String typename = jdbc.getString(sql, DataType.GQJMR_JJLX.getType(), typecode);
					obj.put(gsxz + "_name", typename);
				}
				
				
				
//				if (obj.containsKey(GongSiType)) {//公司类型(经济性质)
//					typecode = data.get(GongSiType);
//					if (null !=typecode) {
//						String typename = jdbc.getString(sql, "公司类型(经济性质)", typecode.toString());
//						data.put("gsType_name", typename);
//					}
//
//				}

			} catch (Exception e) {
				log.error("获取实物报名数据出错: ", e);
			}
		}
		return obj;
	}


	public Object getZTGSType(Object obj) {
		Map<String, Object> data = null;
		String sql = "select ItemText from VIEW_CodeMain_CodeItems where CodeName = ? and ItemValue = ?";
		if (obj != null) {
			try {
				data = (Map<String, Object>) obj;
				String GongSiType = "GongSiType_13003";
				String JingJiType = "JingJiType_13003";
				String GuiMo = "GuiMo_13003";
				String zjly_13003 = "ZiJinLaiYuan_13003";
				Object typecode = null;
				if (data.containsKey(GongSiType)) {//公司类型(经济性质)
					typecode = data.get(GongSiType);
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "公司类型(经济性质)", typecode.toString());
						data.put("gsType_name", typename);
					}

				}
				if (data.containsKey("GongSiType")) {//公司类型(经济性质)
					typecode = data.get("GongSiType");
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "公司类型(经济性质)", typecode.toString());
						data.put("gsType_name", typename);
					}

				}


				if (data.containsKey(JingJiType)) {//经济类型
					typecode = data.get(JingJiType);
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "经济类型", typecode.toString());
						data.put("JingJiType_name", typename);
					}

				}
				if (data.containsKey("JingJiType")) {//经济类型
					typecode = data.get("JingJiType");
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "经济类型", typecode.toString());
						data.put("JingJiType_name", typename);
					}

				}


				if (data.containsKey(GuiMo)) {//经济规模（竞买人）
					typecode = data.get(GuiMo);
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "经济规模（竞买人）", typecode);
						data.put("GuiMo_name", typename);
					}

				}
				if (data.containsKey("GuiMo")) {//经济规模（竞买人）
					typecode = data.get("GuiMo");
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "经济规模（竞买人）", typecode);
						data.put("GuiMo_name", typename);
					}

				}


				if (data.containsKey(zjly_13003)) {//资金来源（新）
					typecode = data.get(zjly_13003);
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "资金来源（新）", typecode);
						data.put("ZiJinLaiYuan_name", typename);
					}

				}

				if (data.containsKey("GuoZiJianGuanType_13003")) {//国资监管类型
					typecode = data.get("GuoZiJianGuanType_13003");
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "国资监管类型", typecode.toString());
						data.put("GuoZiJianGuanType_13003", typename);
					}

				}

				if (data.containsKey("IsGuoZi_13003")) {//国资类型
					typecode = data.get("IsGuoZi_13003");
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "国资类型", typecode.toString());
						data.put("IsGuoZi_13003", typename);
					}

				}

				if (data.containsKey("lblDanWeiXingZhi")) {//企业性质(数据库中的CodeName字段是委托方性质)
					typecode = data.get("lblDanWeiXingZhi");
					try {
						Integer itemvalue=Integer.valueOf(typecode.toString());
						if (null !=itemvalue) {
							String typename = jdbc.getString(sql, "委托方性质", itemvalue.toString());
							data.put("lblDanWeiXingZhi", typename);
						}
					}catch (Exception e){
//						e.printStackTrace();
						log.info("单位性质为字符串,不再转换类型");
					}


				}

				if (data.containsKey("YQGuoZiJG_13003")) {//国资监管机构
					typecode = data.get("YQGuoZiJG_13003");
					if (null !=typecode) {
						String typename = jdbc.getString(sql, "国资监管机构", typecode.toString());
						data.put("YQGuoZiJG_13003", typename);
					}

				}

			} catch (Exception e) {
				log.error("获取专厅报名数据出错: ", e);
			}
		}
		return data;
	}


	public Result getGQInfo(Paramater param) {
		String pm = null;
		Result rs = null;
		if (param != null) {
			try {
				pm = JSON.toJSONString(param);
				rs = HttpClient.call(Global.baoming_url, pm);
			} catch (Exception e) {
				log.error("获取股权报名数据出错: ", e);
			}
		}
		return rs;
	}

	public List<Map<String, Object>> getSrfList(String srfNameOrUnitCode, String projectGuid, String rowGuid, String type) {
		List<Map<String, Object>> srfList = null;
		if (srfNameOrUnitCode != null) {
			String sql = "select isnull(UnitOrgNum,'') as UnitOrgNum,DanWeiName,DanWeiGuid from VIEW_HuiYuan_AllJingJiaDW where AuditStatus = '3' and StatusCode = '2' "
					+ "@and "
					+ "order by Row_ID desc";
			if ("0".equals(type)) {
				sql = sql.replace("@and", "and DanWeiName like ?");
			} else {
				sql = sql.replace("@and", "and UnitOrgNum like ?");
			}
			try {
				srfList = jdbc.mapList(sql, "%" + srfNameOrUnitCode + "%");
			} catch (Exception e) {
				log.error("获取受让方列表数据出错: ", e);
			}
		}
		return srfList;
	}

	public Map<String, Object> getSrfListToEasyui() {
		Map<String, Object> m = new HashMap<>();
		List<SRF> list=null;
			String sql = "select row_number() over (order by Row_ID  ) as id, isnull(UnitOrgNum,'') as UnitOrgNum,DanWeiName,DanWeiGuid from VIEW_HuiYuan_AllJingJiaDW where AuditStatus = '3' and StatusCode = '2' ";

			try {
				m.put("total", jdbc.getCount(sql));
				sql+="order by Row_ID asc";
				list = jdbc.beanList(sql,SRF.class);
				m.put("rows", list);
			} catch (Exception e) {
				log.error("获取联合受让方列表数据出错: ", e);
			}

		return m;
	}

	public List<Map<String, Object>> getUnionList(String baoMingGuid) {
		List<Map<String, Object>> unionList = null;
		if (StringUtils.isNotEmpty(baoMingGuid)) {
			String sql = "select RowGuid,ShouRangName,ShouRangPercent,ShouRangGufen,(case when ShouRangRenType='1' then '法人' when ShouRangRenType='2' then '自然人' end) as ShouRangRenType "
		            + "from UnionShouRang where baoMingGuid = ?";
			try {
				unionList = jdbc.mapList(sql, baoMingGuid);
			} catch (Exception e) {
				log.error("获取联合受让方列表数据出错: ", e);
			}
		}
		return unionList;
	}

	public Map<String, Object> getUnionListToEasyui(String baoMingGuid) {
		Map<String, Object> m = new HashMap<>();
		List<LHSRF> list=null;
		if (StringUtils.isNotEmpty(baoMingGuid)) {
			String sql = "select row_number() over (order by RowGuid ) as id,RowGuid,ShouRangName,ShouRangPercent,ShouRangGufen,(case when ShouRangRenType='1' then '法人' when ShouRangRenType='2' then '自然人' end) as ShouRangRenType "
					+ "from UnionShouRang where baoMingGuid = ?";
			try {
				m.put("total", jdbc.getCount(sql,baoMingGuid));
				list = jdbc.beanList(sql, LHSRF.class,baoMingGuid);
				m.put("rows", list);
			} catch (Exception e) {
				log.error("获取联合受让方列表数据出错: ", e);
			}
		}
		return m;
	}
	public Map<String, Object> getUnion(String rowGuid) {
		Map<String, Object> map = null;
		if (StringUtils.isNotEmpty(rowGuid)) {
			String sql = "select * from UnionShouRang where rowGuid = ?";
			try {
				map = jdbc.map(sql, rowGuid);
			} catch (Exception e) {
				log.error("获取联合受让方数据出错: ", e);
			}
		}
		return map;
	}
	
	public Map<String, Object> getAuditStatus(String rowGuid) {
		Map<String, Object> map = null;
		if (StringUtils.isNotEmpty(rowGuid)) {
			String sql = "select AuditStatus from CQJY_BaoMingNMG where RowGuid = ?";
			try {
				map = jdbc.map(sql, rowGuid);
			} catch (Exception e) {
				log.error("获取报名数据出错: ", e);
			}
		}
		return map;
	}
	
	public Map<String, Object> getZhuanRangInfo(String projectGuid) {
		Map<String, Object> map = null;
		if (StringUtils.isNotEmpty(projectGuid)) {
			String sql = "select sum(sellPercent) as sellPercent,sum(sellAmount) as sellAmount from ("
					   + "select isnull(a.ZhuanRangPercent,0.0000) as sellPercent,isnull(a.ZhuanRangGuFen,0) as sellAmount " 
		               + "from ShouRangfInfo a where a.RowGuid = ? "
		               + "union all "
		               + "select isnull(a.ZhuanRangPercent,0.0000) as sellPercent,isnull(a.ZhuanRangGuFen,0) as sellAmount "
		               + "from ShouRangfInfoUnion a "
		               + "inner join ShouRangfInfo b on a.ShouRangfGuid = b.RowGuid " 
		               + "where b.RowGuid = ?) t";
			try {
				map = jdbc.map(sql, projectGuid, projectGuid);
			} catch (Exception e) {
				log.error("获取拟转让比例股份出错: ", e);
			}
		}
		return map;
	}

	/**
	 * 获取需要上传的附件
	 *
	 * @param type
	 * @return
	 */
	public List<Map<String, Object>> uploadFileList(FileType type) {
		List<Map<String, Object>> fileList = null;
		try {
			Map<String, Object> data = new HashMap<String, Object>();
			Paramater param = new Paramater();
			param.setType("fileinfo");
			data.put("taskCode", type.getType());
			param.setData(data);

			String pm = JSON.toJSONString(param);
			Result rs = HttpClient.call(Global.baoming_url, pm);
			List<Map<String, Object>> fileListMap = rs.getData();
			if (fileListMap != null && fileListMap.size() > 0) {
				fileList = (List<Map<String, Object>>) fileListMap.get(0).get("list");
			}

		} catch (Exception e) {
			log.error("获取需要上传的附件出错:", e);
		}
		return fileList;
	}

	/**
	 * 增资扩股,股东列表
	 *
	 * @param projectguid
	 * @return
	 */
	public List<Dict> getGDList(String projectguid) {

		List<Dict> dict_list = null;
		try {
			String sql = "select CompanyGuDong value,GuDongXuHao code from CompanyGuDongInfo where ProjectGuid=?";
			dict_list = jdbc.beanList(sql, Dict.class, projectguid);
		} catch (Exception e) {
			log.error("获取基础数据出错:", e);
			e.printStackTrace();
		}
		return dict_list;
	}

}
