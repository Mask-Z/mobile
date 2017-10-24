package com.ccjt.ejy.web.commons.cache;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPoolConfig;

import com.ccjt.ejy.web.cache.redis.JedisTemplate;
import com.ccjt.ejy.web.cache.redis.pool.ConnectionInfo;
import com.ccjt.ejy.web.cache.redis.pool.JedisDirectPool;
import com.ccjt.ejy.web.cache.redis.pool.JedisPool;
import com.ccjt.ejy.web.commons.PropertiesReader;

public enum RedisTemplateFactory {
	
	template;

	public JedisTemplate getJedisTemplate() {
		return jedisTemplate;
	}

	private JedisTemplate jedisTemplate;
	
	private Logger log = LogManager.getLogger(RedisTemplateFactory.class);

	private RedisTemplateFactory() {
		// private static final int initialPoolSize = 10;
		int maxPoolSize = 800;
		int minIdle = 5;
		int maxIdle = 10;
		try {

			String ip = PropertiesReader.get("redis.ip");
			String port = PropertiesReader.get("redis.port");
			String pwd = PropertiesReader.get("redis.password");
			HostAndPort hp = new HostAndPort(ip, Integer.valueOf(port));
			JedisPoolConfig config = new JedisPoolConfig();
			ConnectionInfo info = new ConnectionInfo();
			info.setPassword(null);

			info.setTimeout(10000);

			config.setMaxIdle(maxIdle);
			config.setMinIdle(minIdle);
			// config.setMaxWaitMillis(3000);
			config.setMaxTotal(maxPoolSize);

			JedisPool pool = new JedisDirectPool(hp, info, config);
			
			this.jedisTemplate = new JedisTemplate(pool);
			
			log.info("jedisTemplate初始化完成.......IP:"+ip + ",port : " + port);
		} catch (Exception e) {
			log.error("初始化jedisTemplate出错:",e);
			e.printStackTrace();
		}

	}

}
