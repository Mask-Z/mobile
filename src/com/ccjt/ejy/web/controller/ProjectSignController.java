package com.ccjt.ejy.web.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.ccjt.ejy.web.enums.ProjectType;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;

import com.ccjt.ejy.web.commons.Global;
import com.ccjt.ejy.web.enums.m.DataType;
import com.ccjt.ejy.web.enums.m.FileType;
import com.ccjt.ejy.web.quartz.job.CityJob;
import com.ccjt.ejy.web.services.JJDTService;
import com.ccjt.ejy.web.services.m.ProjectSignService;
import com.ccjt.ejy.web.services.m.RegService;
import com.ccjt.ejy.web.vo.Page;
import com.ccjt.ejy.web.vo.Paramater;
import com.ccjt.ejy.web.vo.Result;
import com.ccjt.ejy.web.vo.UserMap;

import com.ccjt.ejy.web.vo.m.LoginAccount;

/**
 * 报名流程<br>
 *
 * @author xxf
 */
@Controller
public class ProjectSignController {

	private static Logger logger = LogManager.getLogger(ProjectSignController.class);

	@RequestMapping("pj_list_cqjy")
	public ModelAndView pj_list(String table, String ProjectRegGuid,HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		JJDTService js = new JJDTService();
		
		LoginAccount user = (LoginAccount) request.getSession().getAttribute("loginAccount");
		String dwtype = user.getDanWeiType();//
		if(dwtype.indexOf(Global.danWeiType_jmf) < 0){//不是竞买人
			mv.addObject("msg","当前用户不是竞买人身份");
		}
		
		//机构列表
		mv.addObject("organizeList", js.jjdt_orglist());

		if (StringUtils.isNotBlank(ProjectRegGuid)){
			mv.addObject("ProjectRegGuid",ProjectRegGuid);
			mv.setViewName("m/plgp_pj_list_cqjy");
			return mv;
		}
		if (null != table && table.equals("ztbm")) {
			mv.setViewName("m/pj_list_cqjy_ztbm");
			return mv;
		}
		mv.setViewName("m/pj_list_cqjy");
		return mv;
	}

	@RequestMapping("pj_list_data")
	@ResponseBody
	public String pj_list_data(Page page, String status, String pronum, String jyjg, String title, String flag, HttpServletRequest request,String ProjectRegGuid) {
		if (page == null) {
			page = new Page();
		}

		ProjectSignService pss = new ProjectSignService();
		LoginAccount user = (LoginAccount) request.getSession().getAttribute("loginAccount");
//		List<GongGao> gongGaoList = null;
//
		Map<String, Object> data = new HashMap<String, Object>();
		Paramater params = new Paramater();
		params.setType("getbmprojectlist");

		if (StringUtils.isNotBlank(ProjectRegGuid)){//如果不为空,则为批量挂牌项目
			data.put("ProjectRegGuid",ProjectRegGuid);
		}
		data.put("DanWeiGuid", user.getDanWeiGuid());
		data.put("bmStatus", status);//项目状态 0:未开始 1:报名中 2:报名结束 3:我的报名
		if (null != flag && flag.equals("ztbm")) {
			data.put("bmType", "1");//0:普通 1:专厅
		} else {
			data.put("bmType", "0");//0:普通 1:专厅
		}
		data.put("page", page.getCurrentPage());//页码
		data.put("rows", page.getRows());//每页条数
		data.put("ProjectName", title);//项目名称
		System.out.println(pronum);
		data.put("ProjectNo", pronum);//项目编号
		data.put("XiaQuCode", jyjg);//机构代码
		params.setData(data);
		Result rs = pss.getNMGInfo(params);


		long date = new Date().getTime();
		if (data.get("bmType").equals("0")) {//专厅时执行该操作会报空指针异常
			for (Map map : rs.getData()) {
				String type = (String) map.get("ProjectType");
				String name = ProjectType.get(type).getName();
				map.put("ProjectType", name);
				long starttime = new Date((String) map.get("GongGaoFromDate")).getTime();
				long endtime = new Date((String) map.get("GongGaoToDate")).getTime();
				if (StringUtils.isBlank((CharSequence) map.get("BaoMingGuid"))) {
					if (starttime > date) {//未开始,不能查看
						map.put("project_baoming_status", 0);
					} else if (starttime <= date && endtime > date) {//报名中,可以查看
						map.put("project_baoming_status", 1);
					} else if (endtime <= date) {//项目已结束,不能查看
						map.put("project_baoming_status", 2);
					}
				} else {//报过名,可以查看
					map.put("project_baoming_status", 3);
				}
			}
		}else{
			for (Map map : rs.getData()) {
				long starttime = new Date((String) map.get("BaoMingStartDate")).getTime();
				long endtime = new Date((String) map.get("BaoMingEndDate")).getTime();
				if (StringUtils.isBlank((CharSequence) map.get("BaoMingGuid"))) {
					if (starttime > date) {//未开始,不能查看
						map.put("project_baoming_status", 0);
					} else if (starttime <= date && endtime > date) {//报名中,可以查看
						map.put("project_baoming_status", 1);
					} else if (endtime <= date) {//项目已结束,不能查看
						map.put("project_baoming_status", 2);
					}
				} else {//报过名,可以查看
					map.put("project_baoming_status", 3);
				}
			}
		}
//		if (null != flag && flag.equals("ztbm")) {//专厅报名
//			gongGaoList = pss.ztbm_more(page, status, pronum, jyjg, title, user.getDanWeiGuid());
//		} else {//普通报名
//			gongGaoList = pss.xmbm_more(page, status, pronum, jyjg, title, user.getDanWeiGuid());
//		}
		return JSON.toJSONString(rs);
	}

	/**
	 * 报名页面
	 *
	 * @param infoid 项目guid
	 * @param type
	 * @param bmguid 修改时需要传入
	 * @return
	 */
	@RequestMapping("pj_sign_up")
	public ModelAndView pj_sign_up(String infoid, String type, String bmguid, HttpServletRequest request) throws JsonProcessingException {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> data = new HashMap<String, Object>();
		ProjectSignService pss = new ProjectSignService();
		List<Map<String, Object>> sshyjg = pss.sshyjg();//所属会员机构
		LoginAccount user = (LoginAccount) request.getSession().getAttribute("loginAccount");
//		if(!user.getIsFinish()){//个人信息未完善
//			mv.setViewName("redirect:/getUserInfo");
//		}
		String dwtype = user.getDanWeiType();//
		if(dwtype.indexOf(Global.danWeiType_jmf) < 0){//不是竞买人
			mv.setViewName("redirect:/pj_list_cqjy");
			return mv;
		}
		
		mv.addObject("user_type", user.getMemberType());
		mv.addObject("user", user);
		mv.addObject("sshyjg", sshyjg);
		mv.addObject("bm_file_download", Global.bm_file_download);//附件下载url
		/**
		 * 如有bmguid则是修改,没有是新增
		 */
		if (StringUtils.isNotBlank(bmguid) && bmguid.length() == 36) {
			data.put("OprationType", "edit");
			mv.addObject("bmguid", bmguid);
		} else {
			bmguid = "";
			data.put("OprationType", "add");
		}

		List<Map<String, Object>> filelist = null;

		if ("NMG".equals(type)) {//实物
			/**
			 * 需要上传的附件
			 */
			filelist = pss.uploadFileList(FileType.SW);
			Paramater params = new Paramater();
			params.setType("flow_pageload");
			data.put("systemType", type.toLowerCase());
			data.put("RowGuid", bmguid);
			data.put("UserGuid", user.getUserGuid());
			data.put("DanWeiGuid", user.getDanWeiGuid());
			data.put("DisplayName", user.getDisplayName());
			data.put("ProjectGuid", infoid);
			params.setData(data);
			Result rs = pss.getNMGInfo(params);
			if (0 == rs.getCode()) {//正常
				List list = rs.getData();
				if (list != null && list.size() == 1) {
					//AuditStatus 1:初始信息录入   2:待审核    3:审核通过   4:审核不通过
					Object obj = list.get(0);
					pss.getGSType(obj);//给代码值赋中文值
					mv.addObject("data", obj);
					mv.addObject("ProjectGuid", infoid);
				}
			}
			mv.addObject("citys", CityJob.cityListWithEmpty);//所有的省市县信息
			mv.addObject("result", rs);
			mv.setViewName("m/pj_sign_up_sw");
		} else if ("GQ".equals(type)) {//股权
			/**
			 * 需要上传的附件
			 */
			filelist = pss.uploadFileList(FileType.GQ);
			Paramater params = new Paramater();
			params.setType("flow_pageload");
			data.put("systemType", type.toLowerCase());
			data.put("UserGuid", user.getUserGuid());
			data.put("RowGuid", bmguid);
			data.put("DanWeiGuid", user.getDanWeiGuid());
			data.put("ProjectGuid", infoid);
			params.setData(data);
			Result rs = pss.getGQInfo(params);
			
			mv.addObject("citysWithEmpty", CityJob.cityListWithEmpty);
			
			if (0 == rs.getCode()) {//正常
				List list = rs.getData();
				
				if (list != null && list.size() == 1) {
					Map map = (Map) list.get(0);
					List mapList = pss.getUnionList(bmguid);
					Map zhuanRangInfo = pss.getZhuanRangInfo(infoid);
					if (mapList != null && mapList.size() > 0) {
						map.put("IsUnionShouRang", "1");
					} else {
						map.put("IsUnionShouRang", "0");
					}
					map.put("unionList", mapList);
					mv.addObject("data", map);
					mv.addObject("zhuanRangInfo", zhuanRangInfo);
					mv.addObject("bmguid", bmguid);
					mv.addObject("ProjectGuid", infoid);
					
					mv.addObject("biZhongs", RegService.getDate(DataType.BZ));
					mv.addObject("hangYeTypes", RegService.belong_industrys());
					mv.addObject("industryCs", RegService.getDate(DataType.CZJRLFL));
					mv.addObject("shouRangRenTypes", RegService.getDate(DataType.FRLX));
					mv.addObject("companyLeiXings", RegService.getDate(DataType.ZRF_JJXZ));
					mv.addObject("companyXingZhis", RegService.getDate(DataType.GQJMR_JJLX));
				}
			}
			mv.addObject("result", rs);
			mv.setViewName("m/pj_sign_up_gq");
		} else if ("ZZKG".equals(type)) {//增资扩股			
			mv.addObject("zjly", RegService.getDate(DataType.ZJLY));//资金来源
			mv.addObject("citys", CityJob.cityListWithEmpty);//所有的省市县信息
			mv.addObject("bz_list", RegService.getDate(DataType.BZ));//币种
			mv.addObject("companyTypes", RegService.getDate(DataType.ZRF_JJXZ));//公司类型（经济性质）列表
			mv.addObject("gdList", pss.getGDList(infoid));//股东列表
			mv.addObject("sshy", RegService.belong_industrys());//所属行业
			mv.addObject("qyxz", RegService.getDate(DataType.GQJMR_JJLX));//企业性质
			mv.addObject("jjgm_jmr", RegService.getDate(DataType.JJGM_JMR));//经济规模_竞买人
			/**
			 * 需要上传的附件
			 */
			filelist = pss.uploadFileList(FileType.ZZKG);
			Paramater params = new Paramater();
			params.setType("flow_pageload");
			data.put("systemType", type.toLowerCase());
			data.put("RowGuid", bmguid);
			data.put("UserGuid", user.getUserGuid());
			data.put("DanWeiGuid", user.getDanWeiGuid());
			data.put("ProjectGuid", infoid);
			params.setData(data);
			Result rs = pss.getNMGInfo(params);
			if (0 == rs.getCode()) {//正常
				List list = rs.getData();
				if (list != null && list.size() == 1) {
					Map map = (Map) list.get(0);
					List mapList = pss.getUnionList(bmguid);
					if (mapList != null && mapList.size() > 0) {
						map.put("IsUnionShouRang", "1");
					} else {
						map.put("IsUnionShouRang", "0");
					}
					map.put("unionList", mapList);
					pss.getZZKGType(map);//代码转换;//给代码值赋中文值					
					mv.addObject("data", map);
					mv.addObject("ProjectGuid", infoid);
					mv.addObject("shouRangRenTypes", RegService.getDate(DataType.FRLX));
				}
			}
			mv.addObject("result", rs);
			mv.setViewName("m/pj_sign_up_zzkg");
		} else if ("CCJT".equals(type)) {//常创集团
			/**
			 * 需要上传的附件
			 */
			filelist = pss.uploadFileList(FileType.CCJT);
			Paramater params = new Paramater();
			params.setType("flow_pageload");
			data.put("systemType", type.toLowerCase());
			data.put("RowGuid", bmguid);
			data.put("UserGuid", user.getUserGuid());
			data.put("DanWeiGuid", user.getDanWeiGuid());
			/**
			 * 44代表竞买人身份
			 */
			data.put("DanWeiType", Global.danWeiType_jmf);
			data.put("ProjectGuid", infoid);
			params.setData(data);
			Result rs = pss.getNMGInfo(params);
			if (0 == rs.getCode()) {//正常
				List list = rs.getData();
				if (list != null && list.size() == 1) {
					Object obj = list.get(0);
					pss.getGSType(obj);//给代码值赋中文值
					mv.addObject("data", obj);
					mv.addObject("ProjectGuid", infoid);
				}
			}
			mv.addObject("result", rs);
			mv.setViewName("m/pj_sign_up_ccjt");
		} else if ("ZT".equals(type)) {//专厅
			/**
			 * 需要上传的附件
			 */
			filelist = pss.uploadFileList(FileType.ZT);
			Paramater params = new Paramater();
			params.setType("flow_pageload");
			data.put("systemType", type.toLowerCase());
			data.put("RowGuid", bmguid);
			data.put("DisplayName", user.getDisplayName());
			data.put("UserGuid", user.getUserGuid());
			data.put("DanWeiGuid", user.getDanWeiGuid());
			data.put("ZhuanTingGuid", infoid);

			params.setData(data);
			Result rs = pss.getNMGInfo(params);
			if (0 == rs.getCode()) {//正常
				List list = rs.getData();
				if (list != null && list.size() == 1) {
					Object obj = list.get(0);
					pss.getZTGSType(obj);//给代码值赋中文值
					mv.addObject("data", obj);
					mv.addObject("ProjectGuid", infoid);
				}
			}
			mv.addObject("result", rs);
			//接口返回的数据中没有专厅Guid,先这样手动传一个
			mv.addObject("ZhuanTingGuid", infoid);
			//专厅的需要显示标的列表


			mv.setViewName("m/pj_sign_up_zt");
		} else {
			throw new RuntimeException("类型参数错误!");
		}
		mv.addObject("citys", CityJob.cityListWithEmpty);//所有的省市县信息
		mv.addObject("filelist", filelist);
		return mv;
	}

	@RequestMapping("iframeData")
	public ModelAndView iframeData(Integer page,Integer rows,String ZhuanTingGuid ) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("ZhuanTingGuid", ZhuanTingGuid);
		ProjectSignService pss=new ProjectSignService();
		Paramater params = new Paramater();
		Map<String, Object> ztData = new HashMap<>();
		params.setType("getztbiaodilist");
		page=page==null?1:page;
		rows=rows==null?15:rows;
		ztData.put("page",page);
		ztData.put("rows",rows);
		ztData.put("ZhuanTingGuid",ZhuanTingGuid);

		params.setData(ztData);
		Result rs = pss.getNMGInfo(params);
		if (0 == rs.getCode()) {//正常
			List list = rs.getData();
			if (list != null && list.size() == 1) {
				Map<String,Object>  obj = (Map<String, Object>) list.get(0);
				int total= Integer.valueOf((String) obj.get("count"));
				mv.addObject("data", obj);
				mv.addObject("page",page);
				mv.addObject("total",total);
				int totalPage = total % rows == 0 ? total / rows : (total / rows) + 1;
				mv.addObject("totalPage", totalPage);
			}
		}
		mv.setViewName("m/zt_iframe");
		return mv;
	}

	@RequestMapping("pj_sign_up_view")
	public ModelAndView pj_sign_up_view(String infoid, String type, String bmguid, String zhuanRangType, HttpServletRequest request) throws JsonProcessingException {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> data = new HashMap<String, Object>();
		ProjectSignService pss = new ProjectSignService();
		List<Map<String, Object>> sshyjg = pss.sshyjg();// 所属会员机构
		LoginAccount user = (LoginAccount) request.getSession().getAttribute("loginAccount");
		mv.addObject("user_type", user.getMemberType());
		mv.addObject("user", user);
		mv.addObject("sshyjg", sshyjg);

		List<Map<String, Object>> filelist = null;

		if (StringUtils.isNotBlank(bmguid) && bmguid.length() == 36) {
			if ("NMG".equals(type)) {// 实物
				Paramater params = new Paramater();
				filelist = pss.uploadFileList(FileType.SW);//需要上传的附件
				params.setType("detail_pageload");
				data.put("systemType", type.toLowerCase());
				data.put("RowGuid", bmguid);
				data.put("UserGuid", user.getUserGuid());
				data.put("DanWeiGuid", user.getDanWeiGuid());
				data.put("ProjectGuid", infoid);
				params.setData(data);
				Result rs = pss.getNMGInfo(params);
				if (rs != null && 0 == rs.getCode()) {// 正常
					List list = rs.getData();
					if (list != null && list.size() == 1) {
						Object obj = list.get(0);
						pss.getGSType(obj);// 给代码值赋中文值
						mv.addObject("data", obj);
						mv.addObject("params", data);
					}
				}
				mv.addObject("result", rs);
				mv.setViewName("m/pj_sign_up_sw_view");
			} else if ("GQ".equals(type)) {// 股权				
				filelist = pss.uploadFileList(FileType.GQ);//需要上传的附件
				Paramater params = new Paramater();
				params.setType("detail_pageload");
				data.put("systemType", type.toLowerCase());
				data.put("RowGuid", bmguid);
				data.put("UserGuid", user.getUserGuid());
				data.put("DanWeiGuid", user.getDanWeiGuid());
				data.put("ProjectGuid", infoid);
				data.put("ZhuanRangType", zhuanRangType);
				params.setData(data);
				Result rs = pss.getGQInfo(params);
				if (rs != null && 0 == rs.getCode()) {// 正常
					List list = rs.getData();
					if (list != null && list.size() == 1) {
						Map map = (Map) list.get(0);
						List mapList = pss.getUnionList(bmguid);
						map.put("unionList", mapList);
						mv.addObject("auditStatus", pss.getAuditStatus(bmguid));
						mv.addObject("data", map);
						mv.addObject("params", data);
					}
				}
				mv.addObject("result", rs);
				mv.setViewName("m/pj_sign_up_gq_view");
			} else if ("ZZKG".equals(type)) {// 增资扩股
				filelist = pss.uploadFileList(FileType.ZZKG);//需要上传的附件
				Paramater params = new Paramater();
				params.setType("detail_pageload");
				data.put("systemType", type.toLowerCase());
				data.put("RowGuid", bmguid);
				data.put("UserGuid", user.getUserGuid());
				data.put("DanWeiGuid", user.getDanWeiGuid());
				data.put("ProjectGuid", infoid);
				params.setData(data);
				Result rs = pss.getGQInfo(params);
				if (rs != null && 0 == rs.getCode()) {// 正常
					List<Map<String, Object>> list = rs.getData();
					if (list != null && list.size() == 1) {
						Map<String, Object> map = (Map) list.get(0);
						List<Map<String, Object>> mapList = pss.getUnionList(bmguid);
						pss.getZZKGType(map);//代码转换
						map.put("unionList", mapList);
						mv.addObject("data", map);
						mv.addObject("params", data);
					}
				}
				mv.addObject("result", rs);
				mv.setViewName("m/pj_sign_up_zzkg_view");
			} else if ("CCJT".equals(type)) {// 常创集团				
				filelist = pss.uploadFileList(FileType.CCJT);//需要上传的附件				
				Paramater params = new Paramater();
				params.setType("detail_pageload");
				data.put("systemType", type.toLowerCase());
				data.put("RowGuid", bmguid);
				data.put("UserGuid", user.getUserGuid());
				data.put("ProjectGuid", infoid);
				data.put("DanWeiGuid", user.getDanWeiGuid());
				params.setData(data);
				Result rs = pss.getNMGInfo(params);
				if (rs != null && 0 == rs.getCode()) {// 正常
					List list = rs.getData();
					if (list != null && list.size() == 1) {
						Object obj = list.get(0);
						pss.getGSType(obj);// 给代码值赋中文值
						mv.addObject("data", obj);
						mv.addObject("params", data);
					}
				}
				mv.addObject("RowGuid", bmguid);
				mv.addObject("result", rs);
				mv.setViewName("m/pj_sign_up_ccjt_view");
			} else if ("ZT".equals(type)) {// 专厅				
				filelist = pss.uploadFileList(FileType.ZT);//需要上传的附件				
				Paramater params = new Paramater();
				params.setType("detail_pageload");
				data.put("systemType", type.toLowerCase());
				data.put("RowGuid", bmguid);
				data.put("UserGuid", user.getUserGuid());
				data.put("ZhuanTingGuid", infoid);
				data.put("DanWeiGuid", user.getDanWeiGuid());

				params.setData(data);
				Result rs = pss.getNMGInfo(params);
				if (rs != null && 0 == rs.getCode()) {// 正常
					List list = rs.getData();
					if (list != null && list.size() == 1) {
						Object obj = list.get(0);
						pss.getZTGSType(obj);// 给代码值赋中文值
						mv.addObject("data", obj);
						mv.addObject("params", data);
					}
				}
				mv.addObject("RowGuid", bmguid);
				mv.addObject("ZhuanTingGuid", infoid);
				mv.addObject("result", rs);
				mv.setViewName("m/pj_sign_up_zt_view");
			} else {
				throw new RuntimeException("类型参数错误!");
			}

			mv.addObject("filelist", filelist);//需要上传的附件
			mv.addObject("bm_file_download", Global.bm_file_download);//附件下载url
		}

		return mv;
	}

//	/**
//   * 股权报名新增联合受让方
//   */
//	@RequestMapping("pj_sign_up_gq_addUnion")
//	public ModelAndView pj_sign_up_gq_addUnion(String rowGuid,String projectGuid,HttpServletRequest request) {	
//		ModelAndView mv = new ModelAndView();
//		mv.addObject("rowGuid",rowGuid);
//		mv.addObject("projectGuid",projectGuid);
//		mv.addObject("shouRangRenTypes",RegService.getDate(DataType.FRLX));
//		mv.setViewName("m/pj_sign_up_gq_addUnion");
//		return mv;
//	}

	/**
	 * 股权报名新增/修改联合受让方
	 */
	@RequestMapping("pj_gq_addUnion_submit")
	@ResponseBody
	public Object pj_gq_addUnion_submit(UserMap info) {
		ProjectSignService pss = new ProjectSignService();
		Paramater params = new Paramater();
		Result rs = null;
		try {
			Map<String, String> mapInfo = info.getInfo();
			if ("union_add".equals(mapInfo.get("unionType"))) {
				mapInfo.put("rowGuid", null);
			} else if ("union_edit".equals(mapInfo.get("unionType"))) {
				mapInfo.put("baoMingGuid", null);
			}
			//按比例转让
			if ("1".equals(mapInfo.get("zhuanRangType"))) {
				mapInfo.remove("shouRangGuFen");
			} else if ("2".equals(mapInfo.get("zhuanRangType"))) {//按股份转让
				mapInfo.remove("shouRangPercent");
			}
			params.setType("unionshourang_add");
			params.setData(mapInfo);
			rs = pss.getGQInfo(params);
		} catch (Exception e) {
			if (rs == null) {
				rs = new Result();
				rs.setCode(-100);
				rs.setMsg("新增/修改联合受让方失败:" + e.getMessage());
			}
		}
		return rs;
	}

	/**
	 * 根据输入获取竞买方列表
	 */
	@RequestMapping("get_srf_list")
	@ResponseBody
	public Object get_srf_list(String srfNameOrUnitCode, String projectGuid, String rowGuid, String type) {
		ProjectSignService pss = new ProjectSignService();
		return pss.getSrfList(srfNameOrUnitCode, projectGuid, rowGuid, type);
	}

	/**
	 * 获取竞买方列表(用于easyui)
	 */
	@RequestMapping("get_srf_listToEasyui")
	@ResponseBody
	public Object get_srf_listToEasyui() {
		ProjectSignService pss = new ProjectSignService();
		return JSON.toJSON(pss.getSrfListToEasyui());
	}

	/**
	 * 股权报名根据baoMingGuid获取联合受让方
	 */
	@RequestMapping("pj_gq_getUnionList")
	@ResponseBody
	public Object pj_gq_getUnionList(String baoMingGuid) {
		ProjectSignService pss = new ProjectSignService();
		return pss.getUnionList(baoMingGuid);
	}

	/**
	 * 股权报名根据baoMingGuid获取联合受让方(用于easyui)
	 */
	@RequestMapping("pj_gq_getUnionListToEasyui")
	@ResponseBody
	public Object pj_gq_getUnionListToEasyui(String baoMingGuid) {
		ProjectSignService pss = new ProjectSignService();
		return JSON.toJSON(pss.getUnionListToEasyui(baoMingGuid));
	}

	/**
	 * 股权报名根据rowGuid删除联合受让方
	 */
	@RequestMapping("pj_gq_delUnion")
	@ResponseBody
	public Object pj_gq_delUnion(String rowGuid) {
		ProjectSignService pss = new ProjectSignService();
		Paramater params = new Paramater();
		Result rs = null;
		try {
			Map<String, String> mapInfo = new HashMap<String, String>();
			mapInfo.put("rowGuid", rowGuid);
			params.setType("unionshourang_del");
			params.setData(mapInfo);
			rs = pss.getGQInfo(params);
		} catch (Exception e) {
			if (rs == null) {
				rs = new Result();
				rs.setCode(-100);
				rs.setMsg("删除联合受让方失败:" + e.getMessage());
			}
		}
		return rs;
	}

	/**
	 * 股权报名根据rowGuid获取联合受让方
	 */
	@RequestMapping("pj_gq_getUnion")
	@ResponseBody
	public Object pj_gq_getUnion(String rowGuid) {
		ProjectSignService pss = new ProjectSignService();
		return pss.getUnion(rowGuid);
	}

	/**
	 * 报名提交第一步
	 */
	@RequestMapping("pj_sign_up_submit")
	@ResponseBody
	public Object pj_sign_up_submit(UserMap info, String bmguid, HttpServletRequest request) {
		ProjectSignService pss = new ProjectSignService();
		Paramater params = new Paramater();
		Result rs = null;
		LoginAccount user = (LoginAccount) request.getSession().getAttribute("loginAccount");

		try {
			if (info != null) {

				Map<String, String> mapInfo = info.getInfo();

				/**
				 * 如有bmguid则是修改,没有是新增
				 */
				if (StringUtils.isNotBlank(bmguid) && bmguid.length() == 36) {
					mapInfo.put("OprationType", "edit");
				} else {
					bmguid = "";
					mapInfo.put("OprationType", "add");
				}


				if (mapInfo != null && mapInfo.containsKey("type")) {
					String type = mapInfo.get("type");
					if ("NMG".equals(type)) {//实物
						mapInfo.put("systemType", "nmg");
						mapInfo.put("UserGuid", user.getUserGuid());
						mapInfo.put("DanWeiGuid", user.getDanWeiGuid());
						mapInfo.put("DisplayName", user.getDisplayName());
						params.setType("bm_flow");
						params.setData(mapInfo);
						rs = pss.getNMGInfo(params);
					} else if ("GQ".equals(type)) {//股权
						if (StringUtils.isEmpty(mapInfo.get("IsUnionShouRang"))) {
							List mapList = pss.getUnionList(mapInfo.get("RowGuid"));
							if (mapList != null && mapList.size() > 0) {
								mapInfo.put("IsUnionShouRang", "1");
							} else {
								mapInfo.put("IsUnionShouRang", "0");
							}
						}
						mapInfo.put("systemType", "gq");
						mapInfo.put("UserGuid", user.getUserGuid());
						mapInfo.put("DanWeiGuid", user.getDanWeiGuid());
						mapInfo.put("DisplayName", user.getDisplayName());
						params.setType("bm_flow");
						params.setData(mapInfo);
						rs = pss.getGQInfo(params);
					} else if ("ZZKG".equals(type)) {//增资扩股
						if (StringUtils.isEmpty(mapInfo.get("IsUnionShouRang"))) {
							List mapList = pss.getUnionList(mapInfo.get("RowGuid"));
							if (mapList != null && mapList.size() > 0) {
								mapInfo.put("IsUnionShouRang", "1");
							} else {
								mapInfo.put("IsUnionShouRang", "0");
							}
						}
						mapInfo.put("systemType", "zzkg");
						mapInfo.put("UserGuid", user.getUserGuid());
						mapInfo.put("DisplayName", user.getDisplayName());
						mapInfo.put("DanWeiGuid", user.getDanWeiGuid());
						mapInfo.put("IpAddress", "");

						params.setType("bm_flow");
						params.setData(mapInfo);
						rs = pss.getNMGInfo(params);

					} else if ("CCJT".equals(type)) {//常创集团
						mapInfo.put("systemType", "ccjt");
						mapInfo.put("UserGuid", user.getUserGuid());
						mapInfo.put("DanWeiGuid", user.getDanWeiGuid());
						params.setType("bm_flow");
						params.setData(mapInfo);
						rs = pss.getNMGInfo(params);
					} else if ("ZT".equals(type)) {//专厅
						mapInfo.put("systemType", "zt");
						mapInfo.put("UserGuid", user.getUserGuid());
						mapInfo.put("DanWeiGuid", user.getDanWeiGuid());
						mapInfo.put("DisplayName", user.getDisplayName());
						params.setType("bm_flow");
						params.setData(mapInfo);
						rs = pss.getNMGInfo(params);
					} else {
						logger.error("调用接口异常,type=" + type);
						rs = new Result();
						rs.setMsg("调用接口异常,type=" + type);
						rs.setCode(-100);
					}
				}
			}
		} catch (Exception e) {
			if (rs == null) {
				rs = new Result();
				rs.setCode(-100);
				rs.setMsg("报名失败:" + e.getMessage());
			}
		}

		return rs;
	}

	/**
	 * 报名提交审核
	 */
	@RequestMapping("pj_sign_up_audit")
	@ResponseBody
	public Object pj_sign_up_audit(UserMap info, HttpServletRequest request) {
		ProjectSignService pss = new ProjectSignService();
		Paramater params = new Paramater();
		Result rs = null;
		LoginAccount user = (LoginAccount) request.getSession().getAttribute("loginAccount");
		Map<String, String> m_info = null;
		if (info != null) {
			m_info = info.getInfo();
		}
		try {
			if (m_info != null
					&& m_info.containsKey("ProjectGuid")
					&& m_info.containsKey("RowGuid")
					&& m_info.containsKey("type")
					&& m_info.containsKey("operationName")
					&& m_info.containsKey("operationGuid")
					&& m_info.containsKey("transitionGuid")
					&& m_info.containsKey("operationType")) {
				String type = m_info.get("type");
				if ("NMG".equals(type)) {// 实物
					params.setType("detail");
					m_info.put("UserGuid", user.getUserGuid());
					m_info.put("DanWeiGuid", user.getDanWeiGuid());
					m_info.put("DisplayName", user.getDisplayName());
					m_info.put("DanWeiName", user.getDanWeiName());
					m_info.put("systemType", type.toLowerCase());
					params.setData(m_info);
					rs = pss.getNMGInfo(params);
					if (rs != null && 0 == rs.getCode()) {// 正常

					}
				} else if ("GQ".equals(type)) {// 股权					
					params.setType("detail");
					m_info.put("UserGuid", user.getUserGuid());
					m_info.put("DanWeiGuid", user.getDanWeiGuid());
					m_info.put("DisplayName", user.getDisplayName());
					m_info.put("DanWeiName", user.getDanWeiName());
					m_info.put("systemType", type.toLowerCase());
					params.setData(m_info);
					rs = pss.getGQInfo(params);
					if (rs != null && 0 == rs.getCode()) {// 正常

					}
				} else if ("ZZKG".equals(type)) {// 增资扩股					
					params.setType("detail");
					m_info.put("UserGuid", user.getUserGuid());
					m_info.put("DanWeiGuid", user.getDanWeiGuid());
					m_info.put("DisplayName", user.getDisplayName());
					m_info.put("DanWeiName", user.getDanWeiName());
					m_info.put("systemType", type.toLowerCase());
					params.setData(m_info);
					rs = pss.getGQInfo(params);
					if (rs != null && 0 == rs.getCode()) {// 正常

					}
				} else if ("CCJT".equals(type)) {// 常创集团
					params.setType("detail");
					m_info.put("UserGuid", user.getUserGuid());
					m_info.put("DanWeiGuid", user.getDanWeiGuid());
					m_info.put("DisplayName", user.getDisplayName());
					m_info.put("DanWeiName", user.getDanWeiName());
					m_info.put("systemType", type.toLowerCase());
					params.setData(m_info);
					rs = pss.getNMGInfo(params);
					if (rs != null && 0 == rs.getCode()) {// 正常

					}
				} else if ("ZT".equals(type)) {// 专厅
					params.setType("detail");
					m_info.put("systemType", type.toLowerCase());
					m_info.put("UserGuid", user.getUserGuid());
					m_info.put("DanWeiGuid", user.getDanWeiGuid());
					m_info.put("DisplayName", user.getDisplayName());
					m_info.put("DanWeiName", user.getDanWeiName());
					params.setData(m_info);
					rs = pss.getNMGInfo(params);
				} else {
					logger.error("调用接口异常,type=" + type);
				}
			}
		} catch (Exception e) {
			if (rs == null) {
				rs = new Result();
				rs.setCode(-100);
				rs.setMsg("报名失败:" + e.getMessage());
			}
		}

		return rs;
	}

	/**
	 * 获取打印回执数据
	 */
	@RequestMapping("getReceipt")
	@ResponseBody
	public Object getReceipt(String type, String rowGuid) {
		Map<String, Object> data = new HashMap<String, Object>();
		ProjectSignService pss = new ProjectSignService();
		Paramater params = new Paramater();
		params.setType("printreceipt");
		Result rs = null;
		try {
			data.put("rowGuid", rowGuid);
			data.put("systemType", type);
			params.setData(data);
			rs = pss.getNMGInfo(params);
		} catch (Exception e) {
			rs = new Result();
			rs.setCode(-100);
			rs.setMsg("获取打印回执数据失败:" + e.getMessage());
		}

		return rs;
	}

	/**
	 * 获取竞买人条款
	 *
	 * @return
	 */
	@RequestMapping("getJMRProvisions")
	@ResponseBody
	public Object getJMRProvisions(String ProjectGuid, String systemType) {
		Map<String, Object> data = new HashMap<String, Object>();
		ProjectSignService pss = new ProjectSignService();
		Paramater params = new Paramater();
		params.setType("getjmrprovisions");
		Result rs = null;
		try {
			data.put("projectGuid", ProjectGuid);
			data.put("systemType", systemType.toLowerCase());
			params.setData(data);
			rs = pss.getNMGInfo(params);
		} catch (Exception e) {
			rs = new Result();
			rs.setCode(-100);
			rs.setMsg("获取竞买人条款数据失败:" + e.getMessage());
		}

		return rs;
	}
}
