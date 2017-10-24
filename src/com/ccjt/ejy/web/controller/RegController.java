package com.ccjt.ejy.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.commons.Global;
import com.ccjt.ejy.web.commons.httpclient.HttpClient;
import com.ccjt.ejy.web.enums.m.DataType;
import com.ccjt.ejy.web.quartz.job.CityJob;
import com.ccjt.ejy.web.services.m.RegService;
import com.ccjt.ejy.web.vo.Paramater;
import com.ccjt.ejy.web.vo.Result;
import com.ccjt.ejy.web.vo.UnitReg;
import com.ccjt.ejy.web.vo.UserReg;
import com.ccjt.ejy.web.vo.m.Dict;

@SuppressWarnings({ "rawtypes", "unchecked" })
@Controller
public class RegController {

	private static Logger logger = LogManager.getLogger(RegController.class.getName());
	
	@RequestMapping("reg_xz")
	public ModelAndView reg_xz() {
		ModelAndView mv = new ModelAndView();
		mv.addObject("register_xz", RegService.getRegister_Xz());				
		mv.setViewName("m/register_xz");
		return mv;
	}
	
	@RequestMapping("reg_checkLoginName")
	@ResponseBody
	public Object reg_checkLoginName(String loginName) {
		Map map = new HashMap();
		Paramater p = new Paramater();
		p.setType("checklogin");
		Map<String,String> data = new HashMap<String,String>();
		data.put("loginName", loginName);
		p.setData(data);
		Result r = HttpClient.call(Global.register_url, JSON.toJSONString(p));		
		if(r != null && r.getCode() == 0) {
			logger.info("登录名：" + loginName + "可用");			
			map.put("msg", "该登录名未被注册，可以注册");
		} else {
			logger.info("单位名称：" + loginName + "不可用");		
			map.put("msg", "登录名" + loginName + "已经被注册，请更换登录名");
		}		
		return map;
	}

	@RequestMapping("user_reg")
	public ModelAndView user_reg_1() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/user_reg_1");
		return mv;
	}
	
	@RequestMapping("user_reg_sub")
	@ResponseBody
	public Object user_reg_sub(UserReg user, HttpSession httpSession) {		
		Map<String,Object> map = new HashMap<String,Object>();
		//session中保存的verCode
		String verCode = (String)httpSession.getAttribute("verCode");
		String msg = RegService.getMsg(verCode, user.getVercode());
		if(StringUtils.isEmpty(msg)) {
			Paramater p = new Paramater();
			p.setType("first");		
			user.setDanWeiType(Global.danWeiType_jmf);
			user.setMemberType(Global.memberType_gr);//会员类型（单位:0 个人:1）
			p.setData(user);
			Result r = HttpClient.call(Global.register_url, JSON.toJSONString(p));
			if(r == null) {
				msg = "网络不给力，请稍后重新注册";
			} else if(r.getCode() == 0) {
				map = r.getData().get(0);
			} else {
				msg = (String)r.getMsg();
				msg = msg.replace("!", "").replace("！", "");
			}
		}
		map.put("msg", msg);
		return map;
	}
	
	@RequestMapping("user_reg_sub_more")
	public ModelAndView user_reg_sub_more(@CookieValue("danWeiGuid") String danWeiGuid, @CookieValue("userGuid") String userGuid) {
		logger.info("个人用户注册获取到的danWeiGuid：" + danWeiGuid + ",userGuid：" + userGuid);
		ModelAndView mv = new ModelAndView();
		RegService rs = new RegService();
		//开户银行列表
		List<Dict> kaiHuBanks = rs.kaihu_banks();
		//竞买人类别列表
		List<Dict> jmrlist = rs.jmr_type("");
		//资金来源（新）列表
		List<Dict> ziJinResources = RegService.getDate(DataType.ZJLY);
		mv.addObject("jmrlist",jmrlist);			
		mv.addObject("kaiHuBanks", kaiHuBanks);		
		mv.addObject("citys",CityJob.cityList);			
		mv.addObject("ziJinResources", ziJinResources);
		mv.setViewName("m/user_reg_2");
		return mv;
	}
	

	@RequestMapping("user_reg_finish")
	@ResponseBody
	public Object user_reg_finish(UserReg user) {
		Map map = new HashMap();
		Result r = null;
		String msg = "";
		Paramater p = new Paramater();
		p.setType("makeup");		
		user.setDanWeiType(Global.danWeiType_jmf);
		user.setMemberType(Global.memberType_gr);//会员类型（单位:0 个人:1）
		p.setData(user);
		r = HttpClient.call(Global.register_url, JSON.toJSONString(p));
		if(r == null) {
			msg = "网络不给力，请稍后重新注册";
		} else if(r.getCode() == 0) {
			map.put("msg", "");
		} else {
			msg = (String)r.getMsg();				
		}
		map.put("msg", msg);
		return map;
	}

	@RequestMapping("user_info_update")
	@ResponseBody
	public Object user_info_update(UserReg user) {
		Map map = new HashMap();
		Result r = null;
		String msg = "";
		Paramater p = new Paramater();
		p.setType("updateformakeup");
		user.setDanWeiType(Global.danWeiType_jmf);
		user.setMemberType(Global.memberType_gr);//会员类型（单位:0 个人:1）
		p.setData(user);
		r = HttpClient.call(Global.register_url, JSON.toJSONString(p));
		if(r == null) {
			msg = "网络不给力，请稍后再试";
		} else if(r.getCode() == 0) {
			map.put("msg", "");
		} else {
			msg = (String)r.getMsg();
		}
		map.put("msg", msg);
		return map;
	}
	@RequestMapping("unit_reg")
	public ModelAndView unit_reg() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/unit_reg_1");
		return mv;
	}
	
	
	@RequestMapping("unit_reg_checkDanWeiName")
	@ResponseBody
	public Object unit_reg_checkDanWeiName(UnitReg unit) {
		Map map = new HashMap();
		Paramater p = new Paramater();
		p.setType("checkunit");
		Map<String,String> data = new HashMap<String,String>();
		data.put("unitName", unit.getUserName());
		p.setData(data);
		Result r = HttpClient.call(Global.register_url, JSON.toJSONString(p));		
		if(r != null && r.getCode() == 0) {
			logger.info("单位名称：" + unit.getUserName() + "可用");			
			map.put("msg", "该单位名称未被注册，可以注册");
		} else {
			logger.info("单位名称：" + unit.getUserName() + "不可用");		
			map.put("msg", unit.getUserName() + "，该单位名称已经存在");
		}		
		return map;
	}
	
	@RequestMapping("unit_reg_sub")
	@ResponseBody
	public Object unit_reg_sub(UnitReg unit, HttpSession httpSession) {
		Map map = new HashMap();
		//session中保存的verCode
		String verCode = (String)httpSession.getAttribute("verCode");
		String msg = RegService.getMsg(verCode, unit.getVercode());
		if(StringUtils.isEmpty(msg)) {
			Paramater p = new Paramater();
			p.setType("first");		
			unit.setDanWeiType(Global.danWeiType_jmf);
			unit.setMemberType(Global.memberType_dw);//会员类型（单位:0 个人:1）
			p.setData(unit);
			Result r = HttpClient.call(Global.register_url, JSON.toJSONString(p));
			if(r == null) {
				msg = "网络不给力，请稍后重新注册";
			} else if(r.getCode() == 0) {
				map = r.getData().get(0);
			} else {
				msg = (String)r.getMsg();			
				msg = msg.replace("!", "").replace("！", "");
			}
		}
		map.put("msg", msg);
		return map;
	}
	
	@RequestMapping("unit_reg_sub_more")
	@ResponseBody
	public ModelAndView unit_reg_sub_more(@CookieValue("danWeiGuid") String danWeiGuid, @CookieValue("userGuid") String userGuid) {
		logger.info("单位用户注册获取到的danWeiGuid：" + danWeiGuid + ",userGuid：" + userGuid);
		ModelAndView mv = new ModelAndView();
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
		
		mv.setViewName("m/unit_reg_2");
		return mv;
	}
	
	@RequestMapping("unit_reg_finish")
	@ResponseBody
	public Object unit_reg_finish(UnitReg unit) {
		Map map = new HashMap();
		String msg = "";
		Paramater p = new Paramater();
		p.setType("makeup");		
		unit.setDanWeiType(Global.danWeiType_jmf);
		unit.setMemberType(Global.memberType_dw);//会员类型（单位:0 个人:1）
		p.setData(unit);
		Result r = HttpClient.call(Global.register_url, JSON.toJSONString(p));
		if(r == null) {
			msg = "网络不给力，请稍后重新注册";
		} else if(r.getCode() == 0) {
			map.put("msg", "");
		} else {
			msg = (String)r.getMsg();				
		}
		map.put("msg", msg);
		return map;
	}

	@RequestMapping("unit_info_update")
	@ResponseBody
	public Object unit_info_update(UnitReg unit) {
		Map map = new HashMap();
		String msg = "";
		Paramater p = new Paramater();
		p.setType("updateformakeup");
		unit.setDanWeiType(Global.danWeiType_jmf);
		unit.setMemberType(Global.memberType_dw);//会员类型（单位:0 个人:1）
		p.setData(unit);
		Result r = HttpClient.call(Global.register_url, JSON.toJSONString(p));
		if(r == null) {
			msg = "网络不给力，请稍后再试";
		} else if(r.getCode() == 0) {
			map.put("msg", "");
		} else {
			msg = (String)r.getMsg();
		}
		map.put("msg", msg);
		return map;
	}
	
	@RequestMapping("reg_getVercode")
	@ResponseBody
	public Object reg_getVercode(String phoneNum, String imgVerCode, HttpSession httpSession) {
		Map map = new HashMap();
		//session中保存的verCode
		String verCode = (String)httpSession.getAttribute("verCode");
		String msg = RegService.getMsg(verCode, imgVerCode);
		if(StringUtils.isEmpty(msg)) {
			Paramater p = new Paramater();
			p.setType("sendMsg");
			Map<String,String> data = new HashMap<String,String>();
			data.put("phoneNum", phoneNum);
			p.setData(data);
			Result r = HttpClient.call(Global.register_url, JSON.toJSONString(p));		
			if(r != null && r.getCode() == 0) {
				logger.info("手机号：" + phoneNum + "成功发送验证短信，验证码：" + r.getData().get(0).get("IdentifyingCode"));			
				map.put("msg", "");
			} else {
				logger.info("手机号：" + phoneNum + "发送验证短信失败");		
				map.put("msg", "发送验证短信失败");
			}		
		} else {
			map.put("msg", msg);
		}		
		return map;
	}
}
