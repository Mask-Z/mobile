package com.ccjt.ejy.web.commons;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class OS {

	private static String android = "android";
	private static String apple = "iphone";

	/**
	 * 是否手机访问验证
	 * @param request
	 * @return
	 */
	public static boolean isMobile(HttpServletRequest request) {
		boolean m = false;
		if (request != null) {
			HttpSession session = request.getSession();
			Object mb = session.getAttribute("mobile");
			if (mb != null) {
				m = Boolean.valueOf(mb.toString());
			} else {
				String agent = request.getHeader("user-agent");
				if (agent != null) {
					agent = agent.toLowerCase();
					if (agent.indexOf(android) > 0) {
						m = true;
					} else if (agent.indexOf(apple) > 0) {
						m = true;
					}
					if(m)session.setAttribute("mobile", m);
				}
			}
		}
		return m;
	}
}
