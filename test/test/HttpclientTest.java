package test;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.commons.httpclient.HttpClient;
import com.ccjt.ejy.web.vo.Paramater;
import com.ccjt.ejy.web.vo.Result;
import com.ccjt.ejy.web.vo.UnitReg;
import com.ccjt.ejy.web.vo.UserReg;

public class HttpclientTest {

	static String url = "http://58.216.221.106:8001/cjsapi/Register.ashx";
	
//	@Test
//	/**
//	 * 短信
//	 */
//	public void testWebService() {
//		Paramater p = new Paramater();
//		p.setType("sendMsg");
//		Map<String,String> data = new HashMap<String,String>();
//		data.put("phoneNum", "13861089530");
//		p.setData(data);
//		Result r = HttpClient.call(url, JSON.toJSONString(p));
//		System.out.println(r);
//	}
	
	@Test
	/**
	 * 单位注册
	 */
	public void ttest(){
		
//		Paramater p = new Paramater();
//		p.setType("first");		
//		UnitReg data = new UnitReg();
//		data.setDanWeiType("44");
//		data.setMemberType("1");//会员类型（单位:1 个人:2）
//		data.setPhoneNum("18796931683");
//		data.setVerificationCode("816884");
//		data.setLoginName("测试654321");
//		data.setUserName("测试654321");
//		data.setPassWord("654321");
//		data.setAgainPwd("654321");
//		data.setApplicant("申报人");
//		p.setData(data);
//		Result r = HttpClient.call(url, JSON.toJSONString(p));
//		System.out.println(r);
		
//		Paramater p = new Paramater();
//		p.setType("sendMsg");
//		Map<String,String> data = new HashMap<String,String>();
//		data.put("phoneNum", "18796931683");
//		p.setData(data);
//		Result r = HttpClient.call(url, JSON.toJSONString(p));
//		System.out.println(r);
		
//		Paramater p = new Paramater();
//		p.setType("checklogin");
//		Map<String,String> data = new HashMap<String,String>();
//		data.put("loginName", "典韦");
//		p.setData(data);
//		Result r = HttpClient.call(url, JSON.toJSONString(p));
//		System.out.println(r);
		
//		Paramater p = new Paramater();
//		p.setType("makeup");
//		UnitReg data = new UnitReg();
//		data.setDanWeiType("44");
//		data.setMemberType("1");//会员类型（单位:1 个人:2）
//		data.setDanWeiGuid("6232812f-a8fd-4465-bf34-0a7e153954f0");
//		data.setUserGuid("9e15baf1-0cb5-406f-89e3-a8235eac334c");
//		data.setDanWeiName("等我");
//		data.setCompanyDes("单位简介单位简介单位简介单位简介单位简介");
//		data.setKaiHuBank("10");
//		data.setBankAreaCode("330502");
//		data.setBankAreaName("江苏省•常州市•天宁区");
//		data.setAreaCode("");
//		data.setAreaName("");
//		data.setBelongAreaCode("320400");
//		data.setBelongAreaName("江苏省•常州市");
//		data.setSuoZaiAreaCode("320402");
//		data.setSuoZaiAreaName("江苏省•常州市•天宁区");
//		data.setUnitOrgNum("321123321");
//		data.setGuoZiType("T");
//		data.setJianGuanType("1");
//		data.setYqGuoZiRegulator("A02005");
//		data.setFyqRegulator("A02005");
//		data.setBuMenName("主管单位");
//		data.setJiGouCode("321123321");
//		data.setRegisterZiBen("1000");
//		data.setFoundDate("2016-05-31");
//		data.setFaDingDaiBiao("法定代表");
//		data.setBelongIndustry("纺织业");
//		data.setBelongIndustryCode("C17");
//		data.setCompanyType("5");
//		data.setEconomicType("A05003");
//		data.setEconomicSize("1");
//		data.setRegisterNum("21342134234");
//		data.setJingYingRange("经营范围");
//		data.setShouRangZiGe("受让资格陈述");
//		data.setGuoShuiNo("123123");
//		data.setDiShuiNO("112233");
//		data.setLocalMobile("18812312311");
//		data.setLocalTel("051988822233");
//		data.setLocalEmail("");
//		data.setLocalFax("");
//		data.setWebAddress("www.ejy.com");
//		data.setAddress("江苏省常州市新北区龙锦路1259号");
//		data.setIsReceiveMessage("1");
//		data.setJinMaiRen("测试短信地区二");
//		data.setJinMaiRenValue("AA03");
//		data.setKaiHuAccount("01234567");
//		p.setData(data);
//		Result r = HttpClient.call(url, JSON.toJSONString(p));
//		System.out.println(r);
		
		Paramater p = new Paramater();
		p.setType("checkunit");
		Map<String,String> data = new HashMap<String,String>();
		data.put("unitName", "01ab");
		p.setData(data);
		Result r = HttpClient.call(url, JSON.toJSONString(p));
		System.out.println(r);
		
	}
	
//	用户注册
//	@Test
//	public void user(){
//		//{"code":0,"data":[{"danWeiGuid":"8832c2e3-8e48-47e4-9e63-d61f5de4d3cb","userGuid":"44048fa5-d552-4e3f-aef1-2ef3d08cb4d7"}],"msg":"新增网员信息成功！"}
//		UserReg user = new UserReg();
//		Paramater p = new Paramater();
//		p.setType("first");
//		
//		user.setDanWeiType("44");
//		user.setMemberType("2");
//		user.setPhoneNum("13861089530");
//		user.setVerificationCode("502327");
//		user.setLoginName("2222");
//		user.setUserName("1111");
//		user.setPassWord("1111");
//		user.setAgainPwd("1111");
//		p.setData(user);
//		Result r = HttpClient.call(url, JSON.toJSONString(p));
//		System.out.println(r);
//	}

//	@Test
//	public void user_2(){
//		
//		
//		UserReg user = new UserReg();
//		Paramater p = new Paramater();
//		p.setType("makeup");
//		
//		user.setDanWeiType("44");
//		user.setMemberType("2");
//		user.setIsReceiveMessage("1");
//		user.setKaiHuAccount("2");
//		user.setZiJinResource("998998");
//		user.setGrMobilePhone("13861089530");
//		user.setGrIDCard("320911198410121913");
//		user.setBankAreaCode("320411");
//		user.setDanWeiName("单位");
//		user.setZhiWu("促销员");
//		user.setBankAreaName("江苏省•常州市•新北区");
//		user.setDanWeiGuid("8832c2e3-8e48-47e4-9e63-d61f5de4d3cb");
//		user.setZiChanApply("个人资产申报");
//		user.setGrAddress("住址");
//		user.setJinMaiRen("试短信地区二;测试短信地区一;花木类别;");
//		user.setKaiHuBank("1");
//		user.setWorkDanWei("工作单位");
//		user.setJinMaiRenValue("AA03;AA02;DD01;");
//		user.setGrEmail("52604462@qq.com");
//		user.setUserGuid("44048fa5-d552-4e3f-aef1-2ef3d08cb4d7");
//		
//		p.setData(user);
//		JSON.toJSONString(p);
//		Result r = HttpClient.call(url, JSON.toJSONString(p));
//		System.out.println(r);
//		
//	}
}
