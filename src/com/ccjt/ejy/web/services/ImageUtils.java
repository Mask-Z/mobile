package com.ccjt.ejy.web.services;

import com.ccjt.ejy.web.vo.ImageInfo;
import org.apache.commons.lang3.StringUtils;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.ImageWriter;
import javax.imageio.metadata.IIOMetadata;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

public class ImageUtils {
	
	public void imageCopy(String src,String dis,List<ImageInfo> infoList){
		
		Graphics2D g2d = null;
		try{
			File srcFile = new File(src);
			File disFile = new File(dis);
			
			BufferedImage image = ImageIO.read(srcFile);
			
			ImageReader ir = ImageIO.getImageReadersByFormatName("jpeg").next();
			ir.setInput(ImageIO.createImageInputStream(srcFile), true);
			ImageWriter writer = ImageIO.getImageWriter(ir);
			writer.setOutput(ImageIO.createImageOutputStream(new FileOutputStream(disFile)));
			
			BufferedImage img = new BufferedImage(image.getWidth(), image.getHeight(), image.getType());
			g2d = img.createGraphics();
			
			g2d.drawImage(image.getScaledInstance(image.getWidth(), image.getHeight(), Image.SCALE_SMOOTH), 0, 0, null);
			
			if(infoList!=null){
				for(ImageInfo info : infoList){
					if(StringUtils.isNotBlank(info.getPath())){
						
						BufferedImage image_qr = ImageIO.read(new File(info.getPath()));
						g2d.drawImage(image_qr.getScaledInstance(image_qr.getWidth(), image_qr.getHeight(), Image.SCALE_SMOOTH), info.getX(), info.getY(), null);
					
					} else if(StringUtils.isNotBlank(info.getText())){
						
						g2d.setColor(info.getColor());
						g2d.setFont(info.getFont());
						g2d.drawString(info.getText(), info.getX(), info.getY());
						
					}
					
				}
			}
			
			IIOMetadata meta = ir.getImageMetadata(0);
			writer.write(new IIOImage(img, null, meta));
			writer.dispose();
			ir.dispose();
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(g2d!=null)g2d.dispose();
		}
	}
	

	public static void main(String[] args) {

		try{
			List<ImageInfo> list = new ArrayList<>();
			
			ImageInfo ii = new ImageInfo();
			ii.setPath("D:/2.jpg");
			ii.setX(350);
			ii.setY(800);

			ImageInfo ii_t = new ImageInfo();
			Font font = new Font("微软雅黑", Font.PLAIN, 76);

			ii_t.setFont(font);
			ii_t.setColor(Color.black);
			
			ii_t.setText("顶顶顶顶顶顶顶");
			ii_t.setX(300);
			ii_t.setY(350);
			
			list.add(ii);
			list.add(ii_t);
			
			new ImageUtils().imageCopy("D:/1.jpg", "D:/3.jpg", list);
			
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
}

