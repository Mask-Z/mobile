package com.ccjt.ejy.web.api;


import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.commons.Global;
import com.ccjt.ejy.web.commons.MapToBean;
import com.ccjt.ejy.web.commons.httpclient.HttpClient;
import com.ccjt.ejy.web.vo.Paramater;
import com.ccjt.ejy.web.vo.Result;
import com.ccjt.ejy.web.vo.UserReg;
import com.ccjt.ejy.web.vo.m.LoginAccount;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
public class Api {

    /**
     * app登录接口
     * @param user
     * @param httpSession
     * @return
     */
    @RequestMapping("login_api")
    @ResponseBody
    public Object login_in(UserReg user, HttpSession httpSession) {
        Map<String,Object> map = new HashMap<String,Object>();
            Paramater p = new Paramater();
            p.setType("login");
            user.setVercode(null);
            p.setData(user);
            String str = JSON.toJSONString(p);
            Result r = HttpClient.call(Global.register_url, str);
            if(r == null) {
                r.setCode(-2);
                r.setMsg("网络不给力，请稍后重新登录");
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

            }
        if (r!=null && r.getCode() != 0){
            return r.toString();
        }else {
            ModelAndView mv=new ModelAndView("m/index");
            return mv;
        }

    }
}
