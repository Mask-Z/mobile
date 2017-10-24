package com.ccjt.ejy.web.commons.db.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import com.ccjt.ejy.web.commons.db.connection.ConnectionFactory;

public class DBConnectionFilter implements Filter {

	public void doFilter(ServletRequest arg0, ServletResponse arg1,
			FilterChain chain) throws IOException, ServletException {

		try {
			chain.doFilter(arg0, arg1);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionFactory.close();
		}
	}

	@Override
	public void destroy() {

	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {

	}

}