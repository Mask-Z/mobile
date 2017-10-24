package test;

import java.text.DecimalFormat;
import java.util.Set;

import org.junit.Before;
import org.junit.Test;

import redis.clients.jedis.Jedis;

import com.ccjt.ejy.web.cache.redis.JedisTemplate;
import com.ccjt.ejy.web.cache.redis.JedisTemplate.JedisAction;
import com.ccjt.ejy.web.commons.cache.RedisTemplateFactory;

public class T {
	static JedisTemplate jt = null;

	@Before
	public void T1() {

		jt = RedisTemplateFactory.template.getJedisTemplate();
	}

	@Test
	public void stringT() {
		jt.set("testt", "ddddddddddddddddddddddddddddddddddddddxxxxxxxxxx");
		jt.pexpire("testt", 5000);
		try {
			while (true) {
				System.out.println(jt.exist("testt"));
				Thread.sleep(1000);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	// @Test
	public void stringHash() {

		// try{
		// while(true){
		//
		//
		// Thread.sleep(1000);
		// }
		// }catch (Exception e) {
		// e.printStackTrace();
		// }

		jt.hset("hash", "a", "ddddddddd");
		jt.hset("hash", "b", "ddddddddd");
		jt.hset("hash", "100", "ddddddddd");
		jt.hset("hash", "11", "ddddddddd");
		System.out.println("hash Keys : " + jt.hkeys("hash"));

		System.out.println(jt.hmget("hash", "11", "100"));
		;
		jt.hset("hash", "11", "d你好");
		String keys[] = { "11", "100" };
		System.out.println(jt.hmget("hash", keys));
		;
	}

	// @Test
	public void stringList() {
		Set<String> set = jt.execute(new JedisAction<Set<String>>() {

			@Override
			public Set<String> action(Jedis jedis) {
				return jedis.keys("*");
			}
		});
		System.out.println(set);
	}

	public static void main(String dd[]) {
//		jt = RedisTemplateFactory.template.getJedisTemplate();
//		ExecutorService es = Executors.newCachedThreadPool();
//		es.submit(new rt(jt));
//
//		es.shutdown();
		
//		System.out.println(String.format("%.2f", 2.333));
		
		double d = (5.5-1.3)*100/1.3;
		DecimalFormat df = new DecimalFormat("#.##");
		System.out.println(df.format(d));
		
	}

}

class rt implements Runnable {
	JedisTemplate p;

	public rt(JedisTemplate pool) {
		this.p = pool;
	}

	@Override
	public void run() {
		try {

			while (true) {

				p.hset("hash", "a", "ddddddddd");
				p.hset("hash", "b", "ddddddddd");
				p.hset("hash", "100", "ddddddddd");
				p.hset("hash", "11", "ddddddddd");

				p.hmget("hash", "11", "100");
				;
				p.hset("hash", "11", "d你好");
				String keys[] = { "11", "100" };
				System.out.println(p.hashCode() + "------"
						+ Thread.currentThread().getName() + "----"
						+ p.hmget("hash", keys));
				;
				// p.returnBrokenResource(jt);

			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
