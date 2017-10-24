package com.ccjt.ejy.web.controller.baoming;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
public class UnionController {

    @RequestMapping(value = "/addUnion")
    public ModelAndView ad_add(String id, HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/addUnion");
//        List<Map> orgList=ls.getOrgList();
        if (StringUtils.isNotBlank(id)) {
//            Logo ad = ls.getLogo(id);
//            mv.addObject("ad", ad);
            mv.addObject("type", "edit");
        }else{
            mv.addObject("type", "add");
        }
        return mv;
    }
}
