package com.ccjt.ejy.web.commons.mapper;

import org.springframework.http.converter.json.Jackson2ObjectMapperFactoryBean;

import com.fasterxml.jackson.annotation.JsonInclude.Include;

public class Jackson2ObjectMapper extends Jackson2ObjectMapperFactoryBean {

	public Jackson2ObjectMapper() {

		//Include.Include.ALWAYS 默认 
		//Include.NON_DEFAULT 属性为默认值不序列化 
		//Include.NON_EMPTY 属性为 空（“”） 或者为 NULL 都不序列化 
		//Include.NON_NULL 属性为NULL 不序列化 
		super();
		this.setSerializationInclusion(Include.NON_NULL);
		setFailOnEmptyBeans(false);
		//是否格式化输出
		setIndentOutput(false);
		
	}

}
