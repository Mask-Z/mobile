package com.ccjt.ejy.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.alibaba.fastjson.JSON;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.ccjt.ejy.web.enums.InfoType;
import com.ccjt.ejy.web.services.JJDTService;
import com.ccjt.ejy.web.services.MoreService;
import com.ccjt.ejy.web.services.NewsService;
import com.ccjt.ejy.web.vo.BaoJia;
import com.ccjt.ejy.web.vo.GongGao;
import com.ccjt.ejy.web.vo.Page;

import static com.ccjt.ejy.web.commons.OS.isMobile;

@Controller
public class HuiYuanController {

	@ResponseBody
	@RequestMapping("hyzx_data")
	public String gethybzdata(Page page, String flag) {
		if (page == null) {
			page = new Page();
		}
		if (null == flag || "".equals(flag)) {
			flag = "hygg";
		}
		InfoType infoType = null;
		switch (flag) {
			case "hygg":
				infoType = InfoType.HYGG;
				break;
			case "zdgz":
				infoType = InfoType.ZDGZ;
				break;
			case "hybz":
				infoType = InfoType.HYBZ;
				break;
		}
		MoreService ms = new MoreService();
		List<GongGao> gongGaoList = ms.news_more(infoType, page, 40);//获取会员帮助列表
		return JSON.toJSONString(gongGaoList);
	}

	@RequestMapping("hyzx")
	public ModelAndView index() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/member");
		return mv;
	}
}
