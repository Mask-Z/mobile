package com.ccjt.ejy.web.controller;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.enums.InfoType;
import com.ccjt.ejy.web.services.NewsService;
import com.ccjt.ejy.web.vo.BaoJia;
import com.ccjt.ejy.web.vo.GongGao;
import com.ccjt.ejy.web.vo.m.LoginAccount;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
public class NewsController {

	@RequestMapping("getPLGPStatus")
	@ResponseBody
	public Map<String, Object> getPLGPStatus(String projectguid) {
		NewsService ns = new NewsService();
		Map<String,Object> map=new HashMap<>();
		List<GongGao> xmztList = ns.projectcontrol_Info(projectguid);//获取批量挂牌项目列表
		GongGao gongGao = ns.getGongGaoByProjectguid(projectguid);//获取竞价状态
		String  AuditStatus = ns.getAuditStatusByProjectguid(projectguid);//获取成交状态
		if (null != xmztList && xmztList.size() > 0) {
			GongGao gg = xmztList.get(0);//只获取最新的状态
			gg.setControltype(ns.getLatestControltype(projectguid));
			Integer type = gg.getControltype();
			if (null != type && (type==2 || type ==1)) {// 2中止   1终结  3重新挂牌
				map.put("code",type);
				map.put("infoid",gg.getInfoid());
				return map;
			}
		}

		if (StringUtils.isNotBlank(AuditStatus) && AuditStatus.equals("3")){//AuditStatus为3,说明项目已成交
			map.put("code",5);
//			map.put("status","已成交");
			return map;
		}

		if (null != gongGao) {
			Date now = new Date();
//			if(now.before(gongGao.getGonggaofromdate())){//报名未开始
//				gongGao.setStatus(0);
//			} else if(StringUtils.isNotBlank(gongGao.getCjgg_guid())){//已成交
//				gongGao.setStatus(6);
//			} else if(now.after(gongGao.getGonggaofromdate()) && now.before(gongGao.getGonggaotodate())){//报名中
//				gongGao.setStatus(1);
//			} else if(gongGao.getJingjia_end()!=null){//有竞价数据
//				if(now.after(gongGao.getJingjia_start()) && now.before(gongGao.getJingjia_end())){//竞价中
//					gongGao.setStatus(4);
//				} else if(now.before(gongGao.getJingjia_start())){//竞价未开始
//					gongGao.setStatus(3);
//				}  else if(now.after(gongGao.getJingjia_end())){//竞价已截止
//					gongGao.setStatus(5);
//				}
//			} else if(now.after(gongGao.getGonggaotodate())){//报名已截止
//				gongGao.setStatus(2);
//			}

			if (gongGao.getJingjia_end() != null) {//有竞价数据
				if (now.after(gongGao.getJingjia_start()) && now.before(gongGao.getJingjia_end())) {// 7.竞价中  8.竞价未开始 9.竞价已截止
					map.put("code",7);
					return map;
				} else if (now.before(gongGao.getJingjia_start())) {//如果竞价未开始,就设置为与主项目状态一致
					map.put("code",8);
					return map;
				} else if (now.after(gongGao.getJingjia_end())) {//竞价已截止
					map.put("code",9);
					return map;
				}
			}
		}

		map.put("code",8);
//		map.put("status",gongGao.getStatus_name());
		return map;//与主项目状态一致

	}

	@RequestMapping("infodetail")
	public ModelAndView infodetail(String infoid, String categoryNum, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String cjgg_guid = null;
		NewsService ns = new NewsService();
		GongGao news = null;
		List<Map> infoList = null;
		if (StringUtils.isBlank(categoryNum)) {
			categoryNum = ns.getCategoryCode(infoid);
		}

		InfoType it = InfoType.get(categoryNum);
		mv.addObject("type", it);

		if ("031001".equals(categoryNum)) {

			String style = ns.getProjectStyle(infoid);
			InfoType itype = InfoType.getByName(style);
			if (itype != null) {
				categoryNum = itype.getCode();
			}
		}

		if (StringUtils.isBlank(categoryNum)) {
			categoryNum = "001001";
		}

		if (StringUtils.isNotBlank(infoid)) {

			if (infoid.length() >= 36) {

				if (categoryNum.startsWith("001002")) {// 成交公告

					GongGao cjgg = ns.getCjGG_detail(infoid);

					GongGao jygg = ns.getJYGG(cjgg.getJygg_guid(), cjgg.getCjgg_guid());//交易公告

					List<BaoJia> his = ns.baojiaHIS(cjgg.getProjectguid(),cjgg.getSystemtype());
					List baojiaHis = ns.getBaoJiaHis(cjgg.getProjectguid(),cjgg.getSystemtype());
					mv.addObject("baojiaHis", baojiaHis);
					mv.addObject("his", his);
					mv.addObject("cjgg", cjgg);

					mv.addObject("jygg", jygg);
//					mv.setViewName("cjgg_news_detail");

					/**
					 * 成交公告推荐
					 */
					List<GongGao> more = ns.more_cjgg_Info(categoryNum, 5);
					mv.addObject("moreinfo", more);

				} else if (categoryNum.startsWith("001001")) {//交易公告
					if (infoid.endsWith("zdxm")) {
						infoid = infoid.substring(0, 36);
					}
//					mv.setViewName("jygg_news_detail");
					news = ns.getJYGG_detail(infoid);

					//获取项目当前状态
					Map map=ns.getCurrentControltype(news.getProjectguid());
					Integer projectCurrentControltype = 0;
					Date operateDate=null;
					if (null != map){
							Object tempControlType=map.get("ProjectControlType");
							operateDate= (Date) map.get("SHR_Date");
							if (null != tempControlType){
								projectCurrentControltype= Integer.valueOf((String) tempControlType);
							}
					}
					if (null == projectCurrentControltype || (projectCurrentControltype !=1 && projectCurrentControltype !=2)) {//当前项目是正常状态
						mv.addObject("gonggaostatue", projectCurrentControltype);
					} else {//当前项目可能有中止终结
						List<GongGao> xmztList = ns.projectcontrol_Info(news.getProjectguid());
						if (null != xmztList && xmztList.size() > 0) {
							mv.addObject("gonggaostatue", xmztList.get(0).getControltype());
							List<GongGao> zzList = new ArrayList<>();
							List<GongGao> zjList = new ArrayList<>();
							for (GongGao gongGao : xmztList) {// 2中止   1终结  3重新挂牌  null 正常项目
								if (gongGao.getControltype() == 2){
									gongGao.setGonggaofromdate(operateDate);//设置中止时间
									zzList.add(gongGao);
								}
								if (gongGao.getControltype() == 1){
									gongGao.setGonggaofromdate(operateDate);
									zjList.add(gongGao);
								}
							}
							mv.addObject("zzList", zzList);
							mv.addObject("zjList", zjList);
						}
					}
//					} else if (StringUtils.isNotBlank(projectcontroltype)) {//项目状态不为空,直接跳转
//						return new ModelAndView("redirect:/newsinfo?infoid=" + infoid);
//					}
					mv.setViewName("m/detail");
					if (null != news.getSystemtype()) {
						switch (news.getSystemtype()) {
							case "ZZKG":
								infoList = ns.getZZKGList(news.getProjectguid());
								mv.addObject("qyxxlist", infoList == null ? "" : ns.getRealName(infoList.get(0)));
								mv.setViewName("m/gq_zzkg_detail");
								break;
							case "GQ":
								//获取产权标的企业信息
								Map m = ns.getGQList(news.getProjectguid());
								if(m!=null){
									Map<String, Object> nn = ns.gf(news.getProjectguid());
									if(nn.containsKey("b")){
										m.put("gf", nn.get("b"));
									}
									mv.addObject("qyxxlist", ns.getRealName(m));
								}
								mv.setViewName("m/gq_zzkg_detail");
								break;
							default:
								break;
						}
					}
					if (news != null) {

						news.setInfoid(infoid);
//						cjgg_guid = ns.getCJGGByJYGG(infoid);
						cjgg_guid = news.getCjgg_guid();
						mv.addObject("cjgg_guid", cjgg_guid);
						if (news != null) {
							boolean ispl = "1".equals(news.getIspllr());
							if (ispl) {

								DateTimeFormatter format = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
								List<Map> plist = ns.getProjectList(infoid);
								//批量挂牌多个标的的挂牌截止时间可能不一致,将最大
								for(Map pmap : plist){
									Object str = pmap.get("GongGaoFromDate");
									Object str2 = pmap.get("GongGaoToDate");

									Date ggstart = new DateTime().parse(str.toString(), format).toDate();
									Date ggend = new DateTime().parse(str2.toString(), format).toDate();

									if (news.getGonggaotodate().before(ggend)) {
										news.setGonggaotodate(ggend);
									}
									if (news.getGonggaofromdate().after(ggstart)) {
										news.setGonggaofromdate(ggstart);
									}
								}

								mv.addObject("projectList", ns.getProjectList(infoid));
								mv.addObject("projectListJson", JSON.toJSON(ns.getProjectList(infoid)));
//								mv.addObject("progresses", ns.getProgressByJYGG_PL(infoid));//批量挂牌时间轴
								mv.addObject("allcount", ns.hlgp_bj_count(infoid));
								mv.setViewName("m/plgp_detail");
							} else {
								List<BaoJia> his = ns.baojiaHIS(news.getProjectguid(), news.getSystemtype());
								mv.addObject("his", his);
//								mv.addObject("progresses", ns.getProgressByJYGG(news));//普通挂牌时间轴

								mv.addObject("jinjia_1", ns.baojia_status(news.getProjectguid(), null));//3.已结束
								if ("1".equals(news.getAllowMoreJqxt())) {//二次报价
									List<BaoJia> his_erci = ns.ERCI_baojiaHIS(news.getProjectguid(), news.getSystemtype());
									mv.addObject("his_erci", his_erci);
									mv.addObject("jinjia_2", ns.baojia_status(news.getProjectguid(), "1"));
									GongGao g = ns.baojiafangshi(news.getProjectguid());//二次报价的报价方式,竞价开始,结束时间
									if(g!=null){
										news.setJingjiafangshi_1(g.getJingjiafangshi_1());
										news.setJingjia_start(g.getJingjia_start());
										news.setJingjia_end(g.getJingjia_end());
									}
								}

							}

							//获取isOpen
							if (StringUtils.isNotBlank(news.getZt())){
								news.setIsOpen(ns.ztbmIsOpen(news.getZt()));
							}else {
								news.setIsOpen(ns.ptbmIsOpen(news.getProjectguid()));
							}

							//判断项目是否报名
							LoginAccount loginAccount = (LoginAccount) request.getSession().getAttribute("loginAccount");
							if (null != loginAccount) {
								String guid = "";
								if (StringUtils.isNotBlank(news.getZt())) {
									guid = news.getZt();
								} else {
									guid = news.getProjectguid();
								}
								mv.addObject("BaoMingGuid", ns.IsBM(loginAccount.getDanWeiGuid(), guid));
							}

						}

						//设置公告状态
						ns.getJYGG_status(news);

						news.setDescription(getNewStr(news.getDescription()));
						news.setZgtj(getNewStr(news.getZgtj()));
						news.setZhuanrangftj(getNewStr(news.getZhuanrangftj()));
						news.setZhongdcontent(getNewStr(news.getZhongdcontent()));
						mv.addObject("news", news);

						/**
						 * 交易公告推荐
						 */
						List<GongGao> more = ns.more_jygg_Info(infoid,categoryNum, 5);
						mv.addObject("moreinfo", more);
					}

				} else if (categoryNum.startsWith("031003") || categoryNum.equals("031002") || categoryNum.startsWith("00200100")) {//招标采购_交易公告
					GongGao gao = ns.getZBCG(infoid);
					mv.addObject("news", gao);

				} else if (categoryNum.startsWith("00200200")) {//招标采购_成交公告
					GongGao gao = ns.getZBCG(infoid);
					mv.addObject("news", gao);

				} else if (categoryNum.startsWith("00100300")) {//预披露
					GongGao gao = ns.getZBCG(infoid);
					mv.addObject("news", gao);
				} else {
					return new ModelAndView("redirect:/newsinfo?infoid=" + infoid);

				}

			}
		}





		if (null != cjgg_guid) {//已成交页面

			String ChengJiaoPrice=ns.getChengJiaoPrice(cjgg_guid);
			mv.addObject("ChengJiaoPrice",ChengJiaoPrice);
			if (news.getSystemtype().equals("GQ") || news.getSystemtype().equals("ZZKG")) {
				mv.setViewName("m/gq_zzkg_detail_ycj");
			} else {
				mv.setViewName("m/detail_ycj");
			}
		}


		//判断项目是否可以报名
		
		Boolean flag = true;
		
		if("1".equals(news.getZhuanTingIsSelected())){
			
			if(!"3".equals(ns.zt_status(news.getZt()))){
				flag=false;
			}
			
		}
		mv.addObject("couldSign",flag);


		return mv;
	}

	@RequestMapping("newsinfo")
	public ModelAndView newsinfo(String infoid) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/news-detail");

		NewsService ns = new NewsService();
		GongGao news = ns.getNews(infoid);
		if (news != null && StringUtils.isNotBlank(news.getCategorynum())) {
			InfoType type = InfoType.get(news.getCategorynum());
			mv.addObject("type", type);
		}


		String gg = ns.getContent(infoid);
		mv.addObject("con", gg);

		mv.addObject("news", news);
		//截掉infoid末尾的ypl
		if (infoid.endsWith("ypl")) {
			infoid = infoid.substring(0, infoid.length() - 3);
			mv.setViewName("m/news-detail-ypl");
			String projectGuid = ns.getYPLProjectGuid(infoid);
			List<Map> yplList = ns.getYPLList(projectGuid);
			mv.addObject("qyxxlist", yplList.size() == 0 ? null : ns.getRealName(yplList.get(0)));
		}

		


		return mv;

	}

	@RequestMapping("jyggcontent")
	public ModelAndView jyggContent(String infoid,String result) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("m/jygg-content");


		NewsService ns = new NewsService();
		GongGao news=new GongGao();
		if (StringUtils.isNotBlank(result)){
			mv.addObject("result",result);
			news = ns.getCJNews(infoid);
		}else {
			news = ns.getNews(infoid);
		}
		mv.addObject("news", news);
		String gg = ns.getContent(infoid);
		mv.addObject("con", gg);

		return mv;

	}

	@RequestMapping("about")
	public ModelAndView zbcg_detail() {

		ModelAndView mv = new ModelAndView();
		NewsService ns = new NewsService();
		GongGao gg = ns.getCGongGao();
		mv.addObject("gonggao", gg);
		mv.setViewName("m/about");
		return mv;
	}

	@RequestMapping("content")
	public ModelAndView content(String infoid) {
		ModelAndView mv = new ModelAndView();
		NewsService ns = new NewsService();
		if (infoid != null && infoid.length() >= 36) {
			String gg = ns.getContent(infoid);
			mv.addObject("con", gg);
		}

		mv.setViewName("m/content");
		return mv;
	}

	private String getNewStr(String str) {
		if(StringUtils.isNotBlank(str)){
			return str.replaceAll("\r\n","<br/>");
		}else{
			return str;
		}
	}
}
