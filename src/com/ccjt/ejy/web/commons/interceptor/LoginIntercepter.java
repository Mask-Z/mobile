package com.ccjt.ejy.web.commons.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ccjt.ejy.web.vo.m.LoginAccount;

/**
 * @author XXF
 * 
 */
public class LoginIntercepter extends HandlerInterceptorAdapter {

	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {

		Object obj = request.getSession().getAttribute("loginAccount");

		if (!(obj instanceof LoginAccount)) {

			response.setContentType("text/html;charset=\"UTF-8\"");
			PrintWriter pw = response.getWriter();
			pw.println("<script type=\"text/javascript\">");
			pw.println("alert('您没有登录或登录已超时,请重新登录.');");
			pw.println("window.location.href='login';");
			pw.println("</script>");
			return false;
			// System.out.println(Thread.currentThread().getName());

		}
		return super.preHandle(request, response, handler);
	}

}