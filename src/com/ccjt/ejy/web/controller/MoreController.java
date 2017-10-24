package com.ccjt.ejy.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ccjt.ejy.web.enums.CQYWType;
import com.ccjt.ejy.web.enums.InfoType;
import com.ccjt.ejy.web.services.IndexService;
import com.ccjt.ejy.web.services.JJDTService;
import com.ccjt.ejy.web.services.MoreService;
import com.ccjt.ejy.web.services.NewsService;
import com.ccjt.ejy.web.vo.CQJY_Gonggao;
import com.ccjt.ejy.web.vo.GongGao;
import com.ccjt.ejy.web.vo.Jjdt;
import com.ccjt.ejy.web.vo.Page;
import com.ccjt.ejy.web.vo.m.City;

@Controller
public class MoreController {

	/**
	 * 竞价大厅列表
	 *
	 * @param
	 * @param
	 * @return
	 */
	@RequestMapping("jjdt_more")
	public ModelAndView jjdt_more() {


		ModelAndView mv = new ModelAndView();
		JJDTService js = new JJDTService();
		IndexService is = new IndexService();

		//机构列表
		mv.addObject("orglist", js.jjdt_orglist());
		//项目类型列表
		mv.addObject("typelist", js.jjdt_typelist());

		List<City> cityinfo = is.city_info();
		mv.addObject("cityinfo", cityinfo);

		mv.setViewName("m/jjdt");
		return mv;

	}


	/**
	 * 竞价大厅列表
	 *
	 * @param page
	 * @param rows
	 * @param orgid      机构条件
	 * @param biaodiname 标的名称条件
	 * @param type       项目类型条件
	 * @param status     报名状态条件
	 * @return
	 */
	@RequestMapping("jjdt_more_data")
	@ResponseBody
	public Object jjdt_more_data(Integer page, Integer rows
			, String orgid, String biaodiname, String type, String status, String sheng, String shi) {
		Map<String, String> con = new HashMap<String, String>();

		con.put("orgid", orgid == null ? "" : orgid);
		con.put("biaodiname", biaodiname == null ? "" : biaodiname);
		con.put("type", type == null ? "" : type);
		con.put("sheng", sheng == null ? "" : sheng);
		con.put("shi", shi == null ? "" : shi);
		con.put("status", status == null ? "" : status);
		//
		JJDTService js = new JJDTService();
		Page pageObj = new Page();
		pageObj.setCurrentPage(page);
		rows = rows == null ? 10 : rows;
		pageObj.setRows(rows);
		pageObj.setCurrentPage(page);
		List<Jjdt> jjdt_more = js.jjdt_cache(pageObj, con);
		JSONObject json = new JSONObject();
		json.put("pageObj", pageObj);
		json.put("jjdt_more", jjdt_more);
		return json;
	}

	@RequestMapping("m_jjdt_more_data")
	@ResponseBody
	public String m_jjdt_more_data(Integer page, Integer rows
			, String orgid, String biaodiname, String type, String status, String sheng, String shi) {
		Map<String, String> con = new HashMap<String, String>();

		con.put("orgid", orgid == null ? "" : orgid);
		con.put("biaodiname", biaodiname == null ? "" : biaodiname);
		con.put("type", type == null ? "" : type);
		con.put("sheng", sheng == null ? "" : sheng);
		con.put("shi", shi == null ? "" : shi);
		con.put("status", status == null ? "" : status);
		JJDTService js = new JJDTService();
		Page pageObj = new Page();
		rows = rows == null ? 10 : rows;
		pageObj.setRows(rows);
		pageObj.setCurrentPage(page);
		List<Jjdt> jjdt_more = js.jjdt_cache(pageObj, con);
		return JSON.toJSONString(jjdt_more);
	}


	/**
	 * @param
	 * @param
	 * @param type
	 * @param area
	 * @param status 0 未开始报名  1 报名中  2报名结束
	 * @return
	 */
	@RequestMapping("jygg_more")
	public ModelAndView jygg_more(String type, String area, String status, String cqywtype, String title) {

		ModelAndView mv = new ModelAndView();


		IndexService is = new IndexService();

		List<City> cityinfo = is.city_info();

		mv.addObject("cityinfo", cityinfo);

		mv.addObject("type", type);

		mv.addObject("area", area);

		mv.addObject("title", title);

		mv.addObject("status", status);

		mv.addObject("cqywtype", cqywtype);

		mv.setViewName("m/cqjy");
		return mv;


	}

	@ResponseBody
	@RequestMapping("cqjy_data")
	public String getcqjydata(Page page, String type, String area, String status, String cqywtype, String title, String order, String xiaqu, HttpServletRequest request) {
		IndexService is = new IndexService();
		if (page == null) {
			page = new Page();
		}
		String qt = "";
		if ("其他".equals(type)) {
			qt = "其他资产";
		} else {
			qt = type;
		}
		MoreService ms = new MoreService();
		List<City> cityinfo = is.city_info();
		String citycode = "";
		if (StringUtils.isNotBlank(area)) {
			for (City city : cityinfo) {
				if (area.equals(city.getName())) {
					citycode = city.getCode();
					break;
				}
			}
		}
		String cqcode = "";
		CQYWType ywtype = CQYWType.getCQYWType(cqywtype);
		if (ywtype != null) {
			cqcode = ywtype.getCode();
		} else {
			cqcode = "";
		}
		List<CQJY_Gonggao> cqjyList = ms.jygg_more(page, qt, citycode, status, cqcode, title, order, xiaqu);

		return JSON.toJSONString(cqjyList);
	}

	@RequestMapping("cjgg_more")
	public ModelAndView cjgg_more(HttpServletRequest request, Page page, String type, String area, String cqywtype, String order) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/index");
		return mv;
	}


	@RequestMapping("zdtj_more")
	public ModelAndView zdtj_more(Page page, String type, String area, String ptype) {

		ModelAndView mv = new ModelAndView();

		MoreService ms = new MoreService();

		IndexService is = new IndexService();

		if (page == null) {
			page = new Page();
		}

		List<City> cityinfo = is.city_info();
		String citycode = "";
		if (StringUtils.isNotBlank(area)) {
			for (City city : cityinfo) {
				if (area.equals(city.getName())) {
					citycode = city.getCode();
					break;
				}
			}
		}

		mv.addObject("cityinfo", cityinfo);

		mv.addObject("page", page);

		mv.addObject("type", type);

		mv.addObject("area", area);

		List<GongGao> zdtj_more = ms.zdtj_more(page, type, citycode, ptype);

		mv.addObject("page", page);
		mv.addObject("zdtj_more", zdtj_more);

		return mv;
	}

//	@RequestMapping("friends")
//	public ModelAndView friends() {
//
//		ModelAndView mv = new ModelAndView();
//		mv.setViewName("m/index");
//		return mv;
//	}

	@ResponseBody
	@RequestMapping("gggs_data")
	public String gethybzdata(Page page, String flag) {
		if (page == null) {
			page = new Page();
		}
		if (null == flag || "".equals(flag)) {
			flag = "ptgg";
		}
		MoreService ms = new MoreService();
		List<GongGao> gongGaoList = null;
		if ("ptgg".equals(flag)) {
			gongGaoList = ms.news_more(InfoType.PTGG, page, 50);
		}
		if ("zcfg".equals(flag)) {
			//政策法规包含招标采购和产权交易
			gongGaoList = ms.new_news_more("03200_", page, 50);
		}
		if ("yjzx".equals(flag)) {
			gongGaoList = ms.news_more(InfoType.YJZX, page, 50);
		}
		if ("jygz".equals(flag)) {
			//交易规则包含产权交易规则和招标采购规则
			gongGaoList = ms.new_news_more("02700_", page, 50);
		}

		return JSON.toJSONString(gongGaoList);
	}

	@RequestMapping("news_more")
	public ModelAndView news_more() {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/gggs");
		return mv;
	}


	@ResponseBody
	@RequestMapping("zbcg_data")
	public String getzbcgdata(Page page, String type, String area, String title, String flag) {
		if (page == null) {
			page = new Page();
		}
		if (null == flag || "".equals(flag)) {
			flag = "zbgg";
		}
		MoreService ms = new MoreService();
		List<GongGao> gongGaoList = null;
		if ("zbgg".equals(flag)) {
			gongGaoList = ms.zdcg_more(page, type, area, "00200100_", title);
		}
		if ("cjgg".equals(flag)) {
			gongGaoList = ms.zdcg_more(page, type, area, "00200200_", title);
		}
		return JSON.toJSONString(gongGaoList);
	}

	/**
	 * 招标采购挂牌
	 *
	 * @return
	 */
	@RequestMapping("zbcg_more")
	public ModelAndView zbcg_more(String title, String tab) {
		ModelAndView mv = new ModelAndView();
		if (null == title) {
			title = "";
		}
		JJDTService js = new JJDTService();
//		IndexService is = new IndexService();
//		Page pageObj = new Page();
//		pageObj.setCurrentPage(page);
//		if (rows == null) {
//			rows = 10;
//		}
//		pageObj.setRows(rows);
//		pageObj.setCurrentPage(page == null ? 1 : page);
//		pageObj.setTotalPage(1);
//		mv.addObject("page", pageObj);
//		js.jjdt_cache(pageObj);

		mv.addObject("title", title);
		//机构列表
		mv.addObject("orglist", js.jjdt_orglist());
//		//项目类型列表
//		mv.addObject("typelist", js.jjdt_typelist());
//
//		List<City> cityinfo = is.city_info();
//		mv.addObject("cityinfo", cityinfo);

		if (null != tab && tab.equals("cjgg")) {
			mv.setViewName("m/zbcg_cjgg");
		} else {
			mv.setViewName("m/zbcg");
		}
		return mv;
	}


	/**
	 * 招标采购_成交
	 *
	 * @return
	 */
	@RequestMapping("zbcg_cj_more")
	public ModelAndView zbcg_cj_more() {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/zbcg");
		return mv;


	}


	/**
	 * 预披露_更多
	 *
	 * @param page
	 * @param type
	 * @param area
	 * @return
	 */
	@RequestMapping("ypl_more")
	public ModelAndView ypl_more(Page page, String type, String area) {


		ModelAndView mv = new ModelAndView();

		MoreService ms = new MoreService();

		IndexService is = new IndexService();

		if (page == null) {
			page = new Page();
		}

		List<City> cityinfo = is.city_info();
		String citycode = "";
		if (StringUtils.isNotBlank(area)) {
			for (City city : cityinfo) {
				if (area.equals(city.getName())) {
					citycode = city.getCode();
					break;
				}
			}
		}

		mv.addObject("cityinfo", cityinfo);

		mv.addObject("page", page);

		mv.addObject("type", type);

		mv.addObject("area", area);

		List<GongGao> ypl_more = ms.ypl_more(page, type, area);

		mv.addObject("page", page);
		mv.addObject("ypl_more", ypl_more);

		mv.setViewName("m/ypl_more");
		return mv;

	}

	@ResponseBody
	@RequestMapping("ypl_data")
	public String getypldata(Page page, String type, String area) {
		MoreService ms = new MoreService();
		IndexService is = new IndexService();
		if (page == null) {
			page = new Page();
		}
		List<City> cityinfo = is.city_info();
		List<GongGao> ypl_more = ms.ypl_more(page, type, area);
		return JSON.toJSONString(ypl_more);
	}

	@RequestMapping("bgt")
	public ModelAndView bgt() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/index");
		return mv;
	}


	@RequestMapping("wyjm/{categoryNum}")
	public ModelAndView jgjm(@PathVariable("categoryNum") String categoryNum) {

		ModelAndView mv = new ModelAndView();
		MoreService ms = new MoreService();
		NewsService ns = new NewsService();
		String infoid1 = ms.getInfoIDByCategoryNum("014001");
		String infoid2 = ms.getInfoIDByCategoryNum("014002");
		String infoid3 = ms.getInfoIDByCategoryNum("014003");
		mv.addObject("con1", ns.getContent(infoid1));
		mv.addObject("con2", ns.getContent(infoid2));
		mv.addObject("con3", ns.getContent(infoid3));
		mv.setViewName("m/jgjm");
		return mv;

	}


	@RequestMapping("tzjr/{categoryNum}")
	public ModelAndView tzjr(@PathVariable("categoryNum") String categoryNum) {

		ModelAndView mv = new ModelAndView();
		MoreService ms = new MoreService();
		NewsService ns = new NewsService();
		String infoid1 = ms.getInfoIDByCategoryNum("038001");
		String infoid2 = ms.getInfoIDByCategoryNum("038004001");
		String infoid3 = ms.getInfoIDByCategoryNum("038004002");
		String infoid4 = ms.getInfoIDByCategoryNum("038004003");
		mv.addObject("xydb", ns.getContent(infoid1));
		mv.addObject("ysd", ns.getContent(infoid2));
		mv.addObject("cqd", ns.getContent(infoid3));
		mv.addObject("jer", ns.getContent(infoid4));
		mv.setViewName("m/news");
		return mv;

	}
}
