package test;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

import org.joda.time.DateTime;

public class Snippet {
	
	public static void main(String dd []){
		boolean a = false ;
		
		
		System.out.println( TimeUnit.DAYS.toSeconds(1));;
		
		
		Date d = new Date();
		d.setTime(1488849502398L);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		
		System.out.println(sdf.format(d));
		
		System.out.println(d.getTime());
		
		DateTime now1 = new DateTime(1488849502398L);
		System.out.println(now1.toString("yyyy-MM-dd HH:mm:ss.SSS"));
		while(a){
			try {
				Thread.sleep(1);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			DateTime now = new DateTime();
		//	System.out.println(now.getMillis());
			//System.out.println(now.toString("yyyy-MM-dd HH:mm:ss.SSS"));
		}
		
	}
	
}

