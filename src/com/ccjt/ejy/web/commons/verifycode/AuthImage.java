package com.ccjt.ejy.web.commons.verifycode;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthImage extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7818869067848904579L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("image/jpeg");

		String verifyCode = VerifyCodeUtils.generateVerifyCode(4);
		HttpSession session = request.getSession(true);
		session.setAttribute("verCode", verifyCode.toLowerCase());
		// 生成图片
		int w = 100, h = 45;
		VerifyCodeUtils.outputImage(w, h, response.getOutputStream(),verifyCode);

	}
}