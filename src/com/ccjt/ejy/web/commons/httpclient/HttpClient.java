package com.ccjt.ejy.web.commons.httpclient;

import java.io.IOException;

import org.apache.http.Consts;
import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.commons.db.SQLServerQueryRunner;
import com.ccjt.ejy.web.vo.Result;

public class HttpClient {
	private static Logger log = LogManager.getLogger(HttpClient.class);

	public static Result call(String url,String params) {
		Result result = null;
		String html = null;
			try{
				log.error("开始调用: " + url + " , 参数 : " + params);
				html = httpcall(url, params);
				result = JSON.parseObject(html, Result.class);
				log.error("返回值: " + result);
			}catch (Exception e) {
				log.error("调用接口出错:",e);
				result = new Result();
				result.setCode(-100);
				result.setMsg(html);
			}
		return result;
	}
	
	public static Result call(String url,HttpEntity params) {
		Result result = null;
		String html = null;
			try{
				html = httpcall(url, params);
				result = JSON.parseObject(html, Result.class);
			}catch (Exception e) {
				log.error("调用接口出错:",e);
				result = new Result();
				result.setCode(-100);
				result.setMsg(html);
			}
		return result;
	}

	private static String httpcall(String url,String params) throws Exception {
		String result = null;
		try {
			
			StringEntity st = new StringEntity(params,Consts.UTF_8);
			result = httpcall(url, st);
			
		} catch (Exception e) {
			throw e;
		}
		return result;
	}
	

	private static String httpcall(String url,HttpEntity params) throws Exception {
		CloseableHttpClient httpclient = HttpClients.createDefault();
		String result = null;
		CloseableHttpResponse res = null;
		try {
			
			HttpPost httpPost = new HttpPost(url);

			RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(200000).setConnectTimeout(10000).build();//设置请求和传输超时时间
			httpPost.setConfig(requestConfig);
			
			httpPost.setEntity(params);
			res = httpclient.execute(httpPost);
			int code = res.getStatusLine().getStatusCode();
			if (code == 200) {
				HttpEntity entity = res.getEntity();
				result = EntityUtils.toString(entity);
				EntityUtils.consume(entity);
				
			}else {
				HttpEntity entity = res.getEntity();
				result = EntityUtils.toString(entity);
				EntityUtils.consume(entity);
			}
			
		} catch (Exception e) {
			throw e;
		} finally {
			try {
				if (res != null)res.close();
				httpclient.close();
			} catch (IOException e) {
			}

		}
		return result;
	}
	
	
	



}
