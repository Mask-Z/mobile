package com.ccjt.ejy.web.commons.cache;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.ccjt.ejy.web.cache.redis.JedisTemplate;

public class DBCacheManage {

	private static Logger log = LogManager.getLogger(DBCacheManage.class);
	
	public static String get(String key) {
		String value = null;
		try {
			if (StringUtils.isNoneBlank(key)) {
				String k = RedisKeys.KEY_DB_CACHE + key;
				JedisTemplate redis = RedisTemplateFactory.template.getJedisTemplate();
				if (redis.exist(k)) {
					value = redis.get(k);
					log.info("load from redis ,key : " + key);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return value;
	}
	
	public static String set(String key,String value, int second) {
		try {
			if (StringUtils.isNoneBlank(key)) {
				String k = RedisKeys.KEY_DB_CACHE + key;
				JedisTemplate redis = RedisTemplateFactory.template.getJedisTemplate();
				redis.setex(k, value, second);
				log.info("set redis ,key : " + key + ",value : " + value +",expire : "+ second);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return value;
	}
	
	
	public static String set(String key,String value) {
		try {
			if (StringUtils.isNoneBlank(key)) {
				String k = RedisKeys.KEY_DB_CACHE + key;
				JedisTemplate redis = RedisTemplateFactory.template.getJedisTemplate();
				redis.set(k, value);
				//log.info("set redis ,key : " + key + ",value : " + value );
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return value;
	}
}
