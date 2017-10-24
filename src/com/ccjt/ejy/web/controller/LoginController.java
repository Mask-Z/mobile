package com.ccjt.ejy.web.controller;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.commons.Global;
import com.ccjt.ejy.web.commons.MapToBean;
import com.ccjt.ejy.web.commons.httpclient.HttpClient;
import com.ccjt.ejy.web.enums.m.DataType;
import com.ccjt.ejy.web.quartz.job.CityJob;
import com.ccjt.ejy.web.services.m.RegService;
import com.ccjt.ejy.web.vo.Paramater;
import com.ccjt.ejy.web.vo.Result;
import com.ccjt.ejy.web.vo.UserReg;
import com.ccjt.ejy.web.vo.m.Dict;
import com.ccjt.ejy.web.vo.m.LoginAccount;

@Controller
public class LoginController {

	private static Logger logger = LogManager.getLogger(LoginController.class.getName());

	@RequestMapping("login")
	public ModelAndView login(HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/login");
		return mv;
	}

	@RequestMapping("loginOut")
	public ModelAndView loginOut( HttpSession httpSession) {

		ModelAndView mv = new ModelAndView();
		//清除登录用户session
		Object object = httpSession.getAttribute("loginAccount");
		if (object != null) {
			try {
				httpSession.removeAttribute("loginAccount");
			} catch (Exception e) {
				object = null;
			}
		}
		mv.setViewName("m/login");
		return mv;
	}

	@RequestMapping("login_in")
	@ResponseBody
	public Object login_in(UserReg user, HttpSession httpSession) {		
		Map<String,Object> map = new HashMap<String,Object>();
		String msg = "";
		String verCode = (String)httpSession.getAttribute("verCode");
		if(verCode == null) {
			msg = "验证码失效，请重新刷新验证码";
    	} else if(!verCode.equalsIgnoreCase(user.getVercode())) {
    		msg = "验证码错误";
    	} 
		if(StringUtils.isEmpty(msg)) {
			Paramater p = new Paramater();
			p.setType("login");	
			user.setVercode(null);
			p.setData(user);
			String str = JSON.toJSONString(p);
			Result r = HttpClient.call(Global.register_url, str);
			if(r == null) {
				msg = "网络不给力，请稍后重新注册";
			} else if(r.getCode() == 0) {
				map = r.getData().get(0);
				LoginAccount loginAccount = new LoginAccount();
				MapToBean.transMap2Bean(map, loginAccount);
				
				String memberType = "";
				String mt = loginAccount.getMemberType();
				if (StringUtils.isNotBlank(mt)) {
					memberType = mt.split(",")[0];
				}
				
				loginAccount.setMemberType(memberType);
				//保存登录用户到session
				httpSession.setAttribute("loginAccount", loginAccount);
			} else {
				msg = (String)r.getMsg();				
			}
		}
		map.put("msg", msg);
		return map;
	}

	/**
	 * 查看个人信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getUserInfo")
	public ModelAndView getUserInfo(HttpServletRequest request) throws ParseException {

		ModelAndView mv = new ModelAndView();
		LoginAccount loginAccount = (LoginAccount) request.getSession().getAttribute("loginAccount");
		String memberType=loginAccount.getMemberType();
		Paramater paramater=new Paramater();
		paramater.setType("pageloadformakeup");
		Map<String,Object> map=new HashMap<>();
		map.put("DanWeiGuid",loginAccount.getDanWeiGuid());
		paramater.setData(map);
		String str = JSON.toJSONString(paramater);
		Result result = HttpClient.call(Global.register_url, str);
		List<Map<String,Object>> list=result.getData();
		if (list.size()>0){
			Map<String,Object> map1=list.get(0);
			mv.addObject("userInfo",map1);
		}
		mv.addObject("citys", CityJob.cityList);

		RegService rs = new RegService();
		//开户银行列表
		List<Dict> kaiHuBanks = rs.kaihu_banks();
		//竞买人类别列表
		List<Dict> jmrlist = rs.jmr_type("");
		//国资类型列表
		List<Dict> guoZiTypes = RegService.getDate(DataType.GZLX);
		//国资监管类型列表
		List<Dict> jianGuanTypes = RegService.getDate(DataType.GZJGLX);
		//国资监管机构列表
		List<Dict> yqGuoZiRegulators = RegService.getDate(DataType.GZJGJG);
		//国资监管机构（非央企）列表
		List<Dict> fyqRegulators = RegService.getDate(DataType.GZJGJG_FYQ);
		//所属行业列表
		List<Dict> belongIndustrys = RegService.belong_industrys();
		//公司类型（经济性质）列表
		List<Dict> companyTypes = RegService.getDate(DataType.GSLX_JJXZ);
		//经济类型列表
		List<Dict> economicTypes = RegService.getDate(DataType.JJLX);
		//经济规模（竞买人）列表
		List<Dict> economicSizes = RegService.getDate(DataType.JJGM_JMR);
		//资金来源（新）列表
		List<Dict> ziJinResources = RegService.getDate(DataType.ZJLY);

		mv.addObject("kaiHuBanks", kaiHuBanks);
		mv.addObject("citys",CityJob.cityList);
		mv.addObject("jmrlist",jmrlist);
		mv.addObject("guoZiTypes", guoZiTypes);
		mv.addObject("jianGuanTypes", jianGuanTypes);
		mv.addObject("yqGuoZiRegulators", yqGuoZiRegulators);
		mv.addObject("fyqRegulators", fyqRegulators);
		mv.addObject("belongIndustrys", belongIndustrys);
		mv.addObject("companyTypes", companyTypes);
		mv.addObject("economicTypes", economicTypes);
		mv.addObject("economicSizes", economicSizes);
		mv.addObject("ziJinResources", ziJinResources);

		if (memberType.equals("0")){//单位
			mv.setViewName("m/unit_info");
		}else {//个人
			mv.setViewName("m/user_info");
		}
		return mv;
	}
}
