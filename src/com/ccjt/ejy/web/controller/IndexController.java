package com.ccjt.ejy.web.controller;

import com.alibaba.fastjson.JSONObject;
import com.ccjt.ejy.web.enums.InfoType;
import com.ccjt.ejy.web.services.IndexService;
import com.ccjt.ejy.web.services.JJDTService;
import com.ccjt.ejy.web.vo.GongGao;
import com.ccjt.ejy.web.vo.Jjdt;
import com.ccjt.ejy.web.vo.Page;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class IndexController {

	private static Logger logger = LogManager.getLogger(IndexController.class.getName());

	IndexService is = new IndexService();
//	JJDTService jjdtService = new JJDTService();

	@RequestMapping("index")
	public ModelAndView index() {


		ModelAndView mv = new ModelAndView();


//		//平台公告
//		List<GongGao> ptgg_List = is.index_info_type(InfoType.PTGG, 6, 18);
//		//业界资讯
//		List<GongGao> yjzx_List = is.index_info_type(InfoType.YJZX, 6, 18);
//
//		mv.addObject("ptgg_List", ptgg_List);
//
//		mv.addObject("yjzx_List", yjzx_List);

		/**
		 * 首页    交易公告
		 */
		List<GongGao> index_gonggao_list = is.index_jygg_info();

		/**
		 * 重点推荐
		 */
		List<GongGao> zdtj = is.index_zdtj_cache();

		mv.addObject("zdtj", zdtj);

		List<GongGao> cqjy_jygg_gq = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_gq); // 产权交易_交易公告_股权
		mv.addObject("cqjy_jygg_gq", cqjy_jygg_gq);

		List<GongGao> cqjy_jygg_cl = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_cl); // 产权交易_交易公告_车辆
		mv.addObject("cqjy_jygg_cl", cqjy_jygg_cl);

		List<GongGao> cqjy_jygg_fdc = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_fdc);// 产权交易_交易公告_房地产
		mv.addObject("cqjy_jygg_fdc", cqjy_jygg_fdc);

		List<GongGao> cqjy_jygg_fjwz = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_fjwz);// 产权交易_交易公告_废旧物资
		mv.addObject("cqjy_jygg_fjwz", cqjy_jygg_fjwz);

//		List<GongGao> cqjy_jygg_td = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_td);// 产权交易_交易公告_土地
//		mv.addObject("cqjy_jygg_td", cqjy_jygg_td);

//		List<GongGao> cqjy_jygg_ls = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_ls);// 产权交易_交易公告_粮食
//		mv.addObject("cqjy_jygg_ls", cqjy_jygg_ls);

//		List<GongGao> cqjy_jygg_qt = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_qt);// 产权交易_交易公告_其他
//		mv.addObject("cqjy_jygg_qt", cqjy_jygg_qt);

//		List<GongGao> cqjy_jygg_cb = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_cb);// 产权交易_交易公告_船舶
//		mv.addObject("cqjy_jygg_cb", cqjy_jygg_cb);

//		List<GongGao> cqjy_jygg_gmcp = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_gmcp);// 产权交易_交易公告_工美藏品
//		mv.addObject("cqjy_jygg_gmcp", cqjy_jygg_gmcp);

//		List<GongGao> cqjy_jygg_hmjy = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_hmjy);// 产权交易_交易公告_花木交易
//		mv.addObject("cqjy_jygg_hmjy", cqjy_jygg_hmjy);

		List<GongGao> cqjy_jygg_fczz = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_fczz);// 产权交易_交易公告_房产招租
		mv.addObject("cqjy_jygg_fczz", cqjy_jygg_fczz);

//		List<GongGao> cqjy_jygg_zzkg = is.infoHandle(index_gonggao_list, InfoType.cqjy_jygg_zzkg);// 产权交易_交易公告_增资扩股
//		mv.addObject("cqjy_jygg_zzkg", cqjy_jygg_zzkg);

		/**
		 * 每个类别取两条
		 */
		List<GongGao> cqjy_jygg_all = new ArrayList<GongGao>();

		cqjy_jygg_all.add(cqjy_jygg_gq.get(0));cqjy_jygg_all.add(cqjy_jygg_gq.get(1));
		cqjy_jygg_all.add(cqjy_jygg_fdc.get(0));cqjy_jygg_all.add(cqjy_jygg_fdc.get(1));

		if(cqjy_jygg_fczz!=null && cqjy_jygg_fczz.size() > 0){
			cqjy_jygg_all.add(cqjy_jygg_fczz.get(0));
		}
		if(cqjy_jygg_cl!=null && cqjy_jygg_cl.size() > 1){
			cqjy_jygg_all.add(cqjy_jygg_cl.get(0));
		}
		if(cqjy_jygg_fjwz!=null){
			if(cqjy_jygg_fjwz.size() > 1 ){
				cqjy_jygg_all.add(cqjy_jygg_fjwz.get(0));
				cqjy_jygg_all.add(cqjy_jygg_fjwz.get(1));
			}else if(cqjy_jygg_fjwz.size()==1){
				cqjy_jygg_all.add(cqjy_jygg_fjwz.get(0));
			}
		}

		mv.addObject("cqjy_jygg_all", cqjy_jygg_all);
//		}

		/**
		 * 首页"全部"成交公告_8条
		 */
//		List<GongGao> cqjy_cjgg_all = is.index_cjgg_8_info();
//		mv.addObject("cqjy_cjgg_all", cqjy_cjgg_all);

		/**
		 * 首页成交公告
		 */
//		List<GongGao> cjgg_list = is.index_cjgg_info();
//
//		List<GongGao> cqjy_cjgg_gq = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_gq);// 产权交易_成交公告_股权
//		mv.addObject("cqjy_cjgg_gq", cqjy_cjgg_gq);
//
//		List<GongGao> cqjy_cjgg_cl = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_cl);// 产权交易_成交公告_车辆
//		mv.addObject("cqjy_cjgg_cl", cqjy_cjgg_cl);
//
//		List<GongGao> cqjy_cjgg_fdc = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_fdc);// 产权交易_成交公告_房地产
//		mv.addObject("cqjy_cjgg_fdc", cqjy_cjgg_fdc);
//
//		List<GongGao> cqjy_cjgg_fjwz = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_fjwz);// 产权交易_成交公告_废旧物资
//		mv.addObject("cqjy_cjgg_fjwz", cqjy_cjgg_fjwz);
//
//		List<GongGao> cqjy_cjgg_ls = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_ls);// 产权交易_成交公告_粮食
//		mv.addObject("cqjy_cjgg_ls", cqjy_cjgg_ls);
//
//		List<GongGao> cqjy_cjgg_qt = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_qt);// 产权交易_成交公告_其他
//		mv.addObject("cqjy_cjgg_qt", cqjy_cjgg_qt);
//
//		List<GongGao> cqjy_cjgg_gmcp = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_gmcp);// 产权交易_成交公告_工美藏品
//		mv.addObject("cqjy_cjgg_gmcp", cqjy_cjgg_gmcp);
//
//		List<GongGao> cqjy_cjgg_hmjy = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_hmjy);// 产权交易_成交公告_花木交易
//		mv.addObject("cqjy_cjgg_hmjy", cqjy_cjgg_hmjy);
//
//		List<GongGao> cqjy_cjgg_fczz = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_fczz);// 产权交易_成交公告_房产招租
//		mv.addObject("cqjy_cjgg_fczz", cqjy_cjgg_fczz);
//
//		List<GongGao> cqjy_cjgg_cb = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_cb);// 产权交易_成交公告_船舶
//		mv.addObject("cqjy_cjgg_cb", cqjy_cjgg_cb);
//
//		List<GongGao> cqjy_cjgg_td = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_td);// 产权交易_成交公告_土地
//		mv.addObject("cqjy_cjgg_td", cqjy_cjgg_td);
//
//		List<GongGao> cqjy_cjgg_zzkg = is.infoHandle(cjgg_list, InfoType.cqjy_cjgg_zzkg);// 产权交易_成交公告_增资扩股
//		mv.addObject("cqjy_cjgg_zzkg", cqjy_cjgg_zzkg);


		/**
		 * 首页招标采购
		 */
		List<GongGao> zbcg_zbgg_gc = is.index_info_type(InfoType.zbcg_zbgg_gc, 8, 40);// zbcg_zbgg_gc招标采购_交易公告_工程
		mv.addObject("zbcg_zbgg_gc", zbcg_zbgg_gc);

//		List<GongGao> zbcg_zbgg_hw = is.index_info_type(InfoType.zbcg_zbgg_hw, 8, 40);// zbcg_zbgg_hw招标采购_交易公告_货物
//		mv.addObject("zbcg_zbgg_hw", zbcg_zbgg_hw);
//
//		List<GongGao> zbcg_zbgg_fw = is.index_info_type(InfoType.zbcg_zbgg_fw, 8, 40);// zbcg_zbgg_fw招标采购_交易公告_服务
//		mv.addObject("zbcg_zbgg_fw", zbcg_zbgg_fw);
//
//		List<GongGao> zbcg_cjgg_gc = is.index_info_type(InfoType.zbcg_cjgg_gc, 8, 40);// zbcg_cjgg_gc招标采购_成交公告_工程
//		mv.addObject("zbcg_cjgg_gc", zbcg_cjgg_gc);
//
//		List<GongGao> zbcg_cjgg_hw = is.index_info_type(InfoType.zbcg_cjgg_hw, 8, 40);// zbcg_cjgg_hw招标采购_成交公告_货物
//		mv.addObject("zbcg_cjgg_hw", zbcg_cjgg_hw);
//
//		List<GongGao> zbcg_cjgg_fw = is.index_info_type(InfoType.zbcg_cjgg_fw, 8, 40);// zbcg_cjgg_fw招标采购_成交公告_服务
//		mv.addObject("zbcg_cjgg_fw", zbcg_cjgg_fw);


		/**
		 * 首页_预披露
		 */
		List<GongGao> ypl_all = is.index_ypl_info();

		List<GongGao> ypl_fczz = is.infoHandle(ypl_all, InfoType.ypl_fczz);// ypl_fczz预披露_房产招租
		mv.addObject("ypl_fczz", ypl_fczz);

		List<GongGao> ypl_gq = is.infoHandle(ypl_all, InfoType.ypl_gq);// ypl_gq预披露_产股权

		mv.addObject("ypl_gq", ypl_gq);

//		List<GongGao> ypl_cl = is.infoHandle(ypl_all, InfoType.ypl_cl);// ypl_cl预披露_车辆
//		mv.addObject("ypl_cl", ypl_cl);
//
//
//		List<GongGao> ypl_fdc = is.infoHandle(ypl_all, InfoType.ypl_fdc);// ypl_fdc预披露_房产
//		mv.addObject("ypl_fdc", ypl_fdc);
//
//		List<GongGao> ypl_fjwz = is.infoHandle(ypl_all, InfoType.ypl_fjwz);// ypl_fjwz预披露_废旧物资
//		mv.addObject("ypl_fjwz", ypl_fjwz);
//
//		List<GongGao> ypl_zq = is.infoHandle(ypl_all, InfoType.ypl_zq);// ypl_zq预披露_债券
//		mv.addObject("ypl_zq", ypl_zq);


		/**
		 * 竞价大厅_招标采购
		 */
//		MoreService ms = new MoreService();
//		List<GongGao> zbcg_jjdt = ms.jjdt_zbcg_more(8);
//		mv.addObject("zbcg_jjdt", zbcg_jjdt);

		/**
		 * 数量统计
		 */
//		Map<String, Object> map = is.statistics();
//		mv.addObject("tongji", map);

//		List<Pics> flash = is.pic("018", 5);

//		List<Pics> friends = is.pic("013", null);

//		mv.addObject("flash", flash);
//		mv.addObject("friends", friends);

		mv.setViewName("m/index");
		return mv;


	}

//	/**
//	 * 首页招标采购刷新时间
//	 * @return
//	 */
//	@RequestMapping("zbcg_more_data")
//	@ResponseBody
//	public Object zbcg() {
//		List<GongGao> zbcg = is.index_info_type(InfoType.zbcg_zbgg_gc, 8, 40);// zbcg_zbgg_gc招标采购_交易公告_工程
//		JSONObject json = new JSONObject();
//		json.put("zbcg", zbcg);
//		return json;
//	}
}
