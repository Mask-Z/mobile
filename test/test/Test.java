package test;

import java.text.DecimalFormat;

import com.ccjt.ejy.web.enums.InfoType;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Test {
	
//	private static Logger log = LogManager.getLogger(Test.class);
	/**
	 * @param args
	 */
	public static void main(String[] args) {
//
//		DecimalFormat df = new DecimalFormat("#.00");
//		double gpj = Double.valueOf(0.0000);
//		String guapaiprice = df.format(gpj);
//		System.out.println(guapaiprice);
//		log.info("11111111111111");
//		log.info("11111111111111");
		InfoType type=InfoType.CQJY_ZCFG;
		System.out.println(type.getCode());
		System.out.println(type.getName());
		System.out.println(InfoType.get("03200*"));

	}

}
