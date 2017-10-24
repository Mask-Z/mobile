package com.ccjt.ejy.web.commons;

import java.io.*;
import java.util.Date;
import java.awt.*;
import java.awt.image.*;
import javax.imageio.ImageIO;
import com.sun.image.codec.jpeg.*;

public class ImgCompress {

	/**
	 * 图片压缩处理
	 * 
	 */
	
//	private  img;
//	private  width;
//	private  height;

	public static void main(String[] args) throws Exception {
		ImgCompress imgCom = new ImgCompress();
		imgCom.resizeFix(400, 400,new File("C:\\Users\\xxf\\Desktop\\3.jpg"),new File("d:\\1.jpg"));
	}


	/**
	 * 按照宽度还是高度进行压缩
	 * 
	 * @param w
	 *            int 最大宽度
	 * @param h
	 *            int 最大高度
	 */
	public void resizeFix(int w, int h,File src,File des) throws IOException {
		
		Image img = ImageIO.read(src); // 构造Image对象
		int width = img.getWidth(null); // 得到源图宽
		int height = img.getHeight(null); // 得到源图长
		
		if (width / height > w / h) {
			
//			以宽度为基准，等比例放缩图片
			int h1 = (int) (height * w / width);
			resize(w, h1,img,des);
			
		} else {
//			以高度为基准，等比例缩放图片
			int w1 = (int) (width * h / height);
			resize(w1, h,img,des);
		}
	}

	
	
	public void resizeFix(int w, int h,InputStream src,File des) throws IOException {
		
		Image img = ImageIO.read(src); // 构造Image对象
		int width = img.getWidth(null); // 得到源图宽
		int height = img.getHeight(null); // 得到源图长
		
		if (width / height > w / h) {
			
//			以宽度为基准，等比例放缩图片
			int h1 = (int) (height * w / width);
			resize(w, h1,img,des);
			
		} else {
//			以高度为基准，等比例缩放图片
			int w1 = (int) (width * h / height);
			resize(w1, h,img,des);
		}
	}

	/**
	 * 强制压缩/放大图片到固定的大小
	 * 
	 * @param w
	 *            int 新宽度
	 * @param h
	 *            int 新高度
	 */
	public void resize(int w, int h,Image src,File des) throws IOException {
		FileOutputStream out = null;
		try{
			BufferedImage image = new BufferedImage(w, h,BufferedImage.TYPE_INT_RGB);
			image.getGraphics().drawImage(src, 0, 0, w, h, null); // 绘制缩小后的图
			out = new FileOutputStream(des); // 输出到文件流
			// 可以正常实现bmp、png、gif转jpg
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
			encoder.encode(image); // JPEG编码
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out!=null){out.close();}
		}
	}
}
