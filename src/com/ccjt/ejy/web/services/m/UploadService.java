package com.ccjt.ejy.web.services.m;

import java.io.File;
import java.nio.charset.Charset;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.protocol.HTTP;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.ccjt.ejy.web.commons.Global;
import com.ccjt.ejy.web.commons.httpclient.HttpClient;
import com.ccjt.ejy.web.vo.Result;
import com.ccjt.ejy.web.vo.m.LoginAccount;

public class UploadService {

	private static Logger log = LogManager.getLogger(UploadService.class);

	public static Result upload(LoginAccount user, String rowGuid, String fileCode,File file) {
		Result rs = null;
		if (user != null && StringUtils.isNotBlank(rowGuid)
				&& StringUtils.isNotBlank(fileCode)) {
			try {
				FileBody fb = new FileBody(file,ContentType.MULTIPART_FORM_DATA.withCharset(Charset.forName("utf-8")));
				
				StringBody rowGuid_sb = new StringBody(rowGuid,ContentType.TEXT_PLAIN.withCharset(Charset.forName("utf-8")));
				
				StringBody type = new StringBody("uploadfile",ContentType.TEXT_PLAIN.withCharset(Charset.forName("utf-8")));
				
				StringBody fileCode_sb = new StringBody(fileCode,ContentType.TEXT_PLAIN.withCharset(Charset.forName("utf-8")));
				
				StringBody displayName = new StringBody(user.getDisplayName(),ContentType.TEXT_PLAIN.withCharset(Charset.forName("utf-8")));
				
				StringBody userGuid = new StringBody(user.getUserGuid(),ContentType.TEXT_PLAIN.withCharset(Charset.forName("utf-8")));

				StringBody filename = new StringBody(fb.getFilename(),ContentType.TEXT_PLAIN.withCharset(Charset.forName("utf-8")));
				
				MultipartEntityBuilder builder = MultipartEntityBuilder.create();

				builder.addPart("file", fb);
				builder.addPart("fileName", filename);
				builder.addPart("rowGuid", rowGuid_sb);
				builder.addPart("fileCode", fileCode_sb);
				builder.addPart("displayName", displayName);
				builder.addPart("userGuid", userGuid);
				builder.addPart("type", type);
				HttpEntity reqEntity = builder.build();

				rs = HttpClient.call(Global.baoming_url, reqEntity);
				if(rs!=null && 0==rs.getCode()){
					rs.setMsg("上传成功!");
				}
			} catch (Exception e) {
				log.error("获取实物报名数据出错: ", e);
			}
		}
		return rs;
	}
}
