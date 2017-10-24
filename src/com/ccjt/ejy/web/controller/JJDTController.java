package com.ccjt.ejy.web.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ccjt.ejy.web.services.JJDTService;
import com.ccjt.ejy.web.services.MoreService;
import com.ccjt.ejy.web.services.NewsService;
import com.ccjt.ejy.web.vo.BaoJia;
import com.ccjt.ejy.web.vo.GongGao;
import com.ccjt.ejy.web.vo.Page;
import com.ccjt.ejy.web.vo.m.City;

@Controller
public class JJDTController {
	// private static volatile long lastTime = 0;

	private JJDTService jjdtService = new JJDTService();
	private NewsService ns = new NewsService();

	/**
	 * 获取竞价详情
	 *
	 * @param projectGuid
	 * @return
	 */
	@RequestMapping("/jjdt_baojiahis")
	@ResponseBody
	public JSONObject jjdt_baojiahis(String projectGuid) {
		List<BaoJia> his = ns.baojiaHIS(projectGuid,"");
		List baojiaHis = ns.getBaoJiaHis(projectGuid,"");
		JSONObject json = new JSONObject();
		json.fluentPut("his", his);
		json.fluentPut("baojiaHis", baojiaHis);
		/*
		 * if(his !=null)System.out.println(his.size()); if(baojiaHis
		 * !=null)System.out.println(baojiaHis.size());
		 */
		return json;
	}

	/**
	 * 刷新标的的信息
	 *
	 * @param biaoDiNOs
	 * @return
	 */
	@RequestMapping("/refresh")
	@ResponseBody
	public List refresh(@RequestParam String biaoDiNOs) {
		// lastTime =lastTime ==0 ? System.currentTimeMillis(): lastTime;
		// int step =2*60*1000;//2分钟
		//
		// if(System.currentTimeMillis() -lastTime <step){
		// //System.out.println(this.toString() +"时间尚未到2分钟");
		// return null;
		// }
		// System.out.println("时间到达2分钟，正在获取刷新数据");
		// lastTime =System.currentTimeMillis();

		// System.out.println("biaoDiNOs：" +biaoDiNOs);
		List list = jjdtService.jjdt_cache(biaoDiNOs.split(","));
		return list;
	}

	@RequestMapping("/zbcg_jjdt")
	public ModelAndView zbcg_jjdt(String orgid,
								  String biaodiname, String type, String status) {

		ModelAndView mv = new ModelAndView();

		MoreService ms = new MoreService();
		List<City> cityinfo = ms.zbcg_city();

		mv.addObject("cityinfo", cityinfo);

		mv.addObject("orgid", orgid);
		mv.addObject("biaodiname", biaodiname);
		mv.addObject("type", type);
		mv.addObject("status", status);
//		mv.addObject("sheng", sheng);
		mv.setViewName("m/jjdt_zbcg");
		return mv;

	}

	@ResponseBody
	@RequestMapping("jjdt_zbcg_more_data")
	public String get_jjdt_zbcg_more_data(Page page, String sheng, String orgid,
										  String biaodiname, String type, String status) {
		if (page == null) {
			page = new Page();
		}
		MoreService ms = new MoreService();
		List<GongGao> jjdt_zbcg_list = ms.jjdt_zbcg_more(page, sheng, orgid,
				biaodiname, type, status);
		return JSON.toJSONString(jjdt_zbcg_list);
	}
}
