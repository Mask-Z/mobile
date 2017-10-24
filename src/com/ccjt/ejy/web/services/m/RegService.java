package com.ccjt.ejy.web.services.m;

import static com.ccjt.ejy.web.commons.JDBC.jdbc;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.enums.m.DataType;
import com.ccjt.ejy.web.vo.m.City;
import com.ccjt.ejy.web.vo.m.Dict;

public class RegService {

	private static Logger log = LogManager.getLogger(RegService.class);
	
	/**
	 * 竞买人类别
	 * @param code
	 * @return
	 */
	public List<Dict> jmr_type(String code) {
		List<Dict> dict_list = null;
		try {
			String sql = " SELECT CaiGouNo AS code,CaiGouName AS value FROM HuiYuan_CaiGouItem " +
					"WHERE CaiGouNo like ? and CaiGouNo != ? ORDER BY OrderNum DESC";

			String p1 = "____";//第一级编码为4位
			String p2 = "";
			if(StringUtils.isNoneBlank(code)){
				p1 = code+"__";
				p2 = code;
			}
			
			dict_list = jdbc.beanList(sql, Dict.class,p1,p2);
			for(Dict dic : dict_list){
				dic.setDictList(jmr_type(dic.getCode()));
			}
			
		} catch (Exception e) {
			log.error("获取竞买方类型出错:",e);
			e.printStackTrace();
		}
		return dict_list;
	}
	
	/**
	 * VIEW_CodeMain_CodeItems 中一些基础数据的查询
	 * @param type
	 * @return
	 */
	public static List<Dict> getDate(DataType type) {
		List<Dict> dict_list = null;
		try {
			String sql = "select ItemText as value,ItemValue as code from VIEW_CodeMain_CodeItems where CodeName = ?";
			dict_list = jdbc.beanList(sql, Dict.class, type.getType());			
		} catch (Exception e) {
			log.error("获取基础数据出错:",e);
			e.printStackTrace();
		}
		return dict_list;
	}
	
	
	public static List<City> cityList(){		
		List<City> dict_list = null;
		try {
			String sql = "select CityName as name,CityCode as code from HuiYuan_City where citycode like ? and CityCode != ? order by CityCode";			
			dict_list = jdbc.beanList(sql, City.class, "__0000", "");
			for(City dic : dict_list){
				String p1 = dic.getCode().substring(0,2) + "__00";
				String p2 = dic.getCode().substring(0,2) + "0000";
				List<City> shiList = jdbc.beanList(sql,City.class,p1,p2);				
				if(shiList.size()>0){//有市级地区
					for(City shi : shiList){
						String p3 = shi.getCode().substring(0,4) + "__";
						String p4 = shi.getCode();
						shi.setSub(jdbc.beanList(sql,City.class,p3,p4));
					}
					dic.setSub(shiList);
				}else{//无市级,生成一个与省级一样的市级					
					List<City> sub_shi = new ArrayList<City>();
					List<City> xian_list = new ArrayList<City>();
					
					City shi = dic.clone();
					City xian = dic.clone();
					
					sub_shi.add(shi);
					
					xian_list.add(xian);
					shi.setSub(xian_list);					
					dic.setSub(sub_shi);
				}				
			}			
		} catch (Exception e) {
			log.error("获取省市区出错:",e);
			e.printStackTrace();
		}
		return dict_list;		
	}
	
	public static List<City> cityListWithEmpty(){		
		List<City> dict_list = null;
		try {
			String sql = "select CityName as name,CityCode as code from HuiYuan_City where citycode like ? and CityCode != ? order by CityCode";			
			dict_list = jdbc.beanList(sql, City.class, "__0000", "");
			for(City dic : dict_list){
				String p1 = dic.getCode().substring(0,2) + "__00";
				String p2 = dic.getCode().substring(0,2) + "0000";
				List<City> shiList = jdbc.beanList(sql,City.class,p1,p2);				
				if(shiList.size()>0){//有市级地区
					for(City shi : shiList){
						String p3 = shi.getCode().substring(0,4) + "__";
						String p4 = shi.getCode();
						shi.setSub(jdbc.beanList(sql,City.class,p3,p4));
					}
					dic.setSub(shiList);
				}else{//无市级,生成一个与省级一样的市级					
					List<City> sub_shi = new ArrayList<City>();
					List<City> xian_list = new ArrayList<City>();
					
					City shi = dic.clone();
					City xian = dic.clone();
					
					sub_shi.add(shi);
					
					xian_list.add(xian);
					shi.setSub(xian_list);
					
					dic.setSub(sub_shi);
				}				
			}			
		} catch (Exception e) {
			log.error("获取省市区出错:",e);
			e.printStackTrace();
		}
		return dict_list;		
	}
	
	/**
	 * 开户银行列表
	 * @return
	 */
	public List<Dict> kaihu_banks() {
		List<Dict> dict_list = null;
		try {
			String sql = "select ItemValue code,ItemText value from VIEW_CodeMain_CodeItems where CodeName = '开户银行' and ItemValue != '0'";
			dict_list = jdbc.beanList(sql, Dict.class, "");	
		} catch (Exception e) {
			log.error("获取开户银行出错:",e);
			e.printStackTrace();
		}
		return dict_list;
	}
	
	/**
	 * 所属行业列表
	 * @return
	 */
	public static List<Dict> belong_industrys() {
		List<Dict> dict_list = null;
		try {
			String sql = "select IndustryCode code,IndustryName value from Sys_IndustryCode where len(IndustryCode) = 3";
			dict_list = jdbc.beanList(sql, Dict.class, "");	
		} catch (Exception e) {
			log.error("获取所属行业出错:",e);
			e.printStackTrace();
		}
		return dict_list;
	}
	
	/**
	 * 注册须知
	 * @return
	 */
	public static Map<String, Object> getRegister_Xz() {
		Map<String, Object> map = null;
		try {
			String sql = "select ProtocolInfo from HuiYuan_UserProtocol where UserType = '10'";
			map = jdbc.map(sql);	
		} catch (Exception e) {
			log.error("获取注册须知出错:",e);
			e.printStackTrace();
		}
		return map;
	}
	
	/**
	 * 校验图形验证码
	 * verCode session中保存的verCode
	 * imgVerCode 用户页面输入的imgVerCode
	 * @return
	 */
	public static String getMsg(String verCode, String imgVerCode) {
		String msg = "";
		if(verCode == null) {
			msg = "图形验证码失效，请重新刷新图形验证码";
		} else if(!verCode.equalsIgnoreCase(imgVerCode)) {
			msg = "图形验证码错误";
		}		
		return msg;
	}	
	
	public static void main(String dd[]){
		List l = new RegService().cityList();
		System.out.println(JSON.toJSONString(l));		
	}	
}