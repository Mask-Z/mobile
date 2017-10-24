package com.ccjt.ejy.web.controller;

import java.io.File;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;

import com.ccjt.ejy.web.commons.Global;
import com.ccjt.ejy.web.commons.httpclient.HttpClient;
import com.ccjt.ejy.web.services.m.ProjectSignService;
import com.ccjt.ejy.web.services.m.UploadService;
import com.ccjt.ejy.web.vo.Paramater;
import com.ccjt.ejy.web.vo.Result;
import com.ccjt.ejy.web.vo.m.LoginAccount;

@Controller
public class UploadController {

	@RequestMapping("file_upload")
	@ResponseBody
	//@RequestParam("file") MultipartFile file,
	public Object upload(String rowGuid,String fileCode,HttpServletRequest request){
		Map<String,Object> result = new HashMap<String, Object>();
		File disFile = null;
		LoginAccount user = (LoginAccount) request.getSession().getAttribute("loginAccount");
		try {
			if(ServletFileUpload.isMultipartContent(request)
					&& StringUtils.isNotBlank(rowGuid) 
					&& StringUtils.isNotBlank(fileCode)){
				
				DefaultMultipartHttpServletRequest req = (DefaultMultipartHttpServletRequest) request;
				MultipartFile file = req.getFile("file");
//				String filename=file.getOriginalFilename();
//				System.out.println("fileName: "+filename);
//				String[] temp=filename.split("\\.");
//				int length=temp.length;
//				if (length<2){
//					result.put("code", -3);
//					result.put("msg", "请上传后缀名为doc,docx,txt,rar,jpg,jpeg,pdf,mp3,xls,xlsx,gif,bmp类型的文件! \n上传文件名称请勿含特殊符号! ");
//					return  result;
//				}
//				if (length >=2){
//					String suffix=temp[length-1].toLowerCase();
//					String[] array={"doc","docx","txt","rar","jpg","jpeg","pdf","mp3","xls","xlsx","gif","bmp"};
//					List<String> list= Arrays.asList(array);
//					if (!list.contains(suffix)){
//						result.put("code", -3);
//						result.put("msg", "请上传后缀名为doc,docx,txt,rar,jpg,jpeg,pdf,mp3,xls,xlsx,gif,bmp类型的文件! \n上传文件名称请勿含特殊符号! ");
//						return  result;
//					}
//				}

					String root = request.getServletContext().getRealPath("/") + "temp" + File.separator;
					disFile = new File(root);
					if (!disFile.exists()) {
						disFile.mkdirs();
					}
					
					if (file.getSize() > 0) {
						disFile = new File(root + file.getOriginalFilename());
						file.transferTo(disFile);
						
						Result rs = UploadService.upload(user, rowGuid, fileCode, disFile);
						result.put("code", rs.getCode());
						result.put("msg", rs.getMsg());
						
					}
					
			}
			
		} catch (Exception e) {
			result.put("code", -2);
			result.put("msg", e.getMessage());
			e.printStackTrace();
		} finally{
			try{
				if(disFile!=null){
					disFile.delete();
				}
			}catch (Exception e) {
			}
		}
		return result;
	}
	
	
	private String download_ip = "192.168.12.116";
	private String download_url = "www.e-jy.com.cn";
	
	/**
	 * 获取已存在的附件
	 * @param typs
	 * @param bmguid
	 * @param taskCode
	 * @return
	 */
	@RequestMapping("getFileList")
	@ResponseBody
	public Object getFileList(String bmguid, String taskCode) {
		
		
		
		/**
		 * taskcode 实物：CQJY_BaoMingNMG 专厅：CQJY_BaoMingZT 常州产权： CQJY_NetBaoMing
		 * 股权：CQJY_GQBaoMing 增资扩股：CQJY_ZZKGBaoMing
		 */
		Map<String, Object> result = new HashMap<String, Object>();
		ProjectSignService pss = new ProjectSignService();
		Result rs = null;
		try {
			if (StringUtils.isNotBlank(bmguid)
					&& StringUtils.isNotBlank(taskCode)) {

				Paramater params = new Paramater();
				Map<String, Object> data = new HashMap<String, Object>();
				params.setType("getfilelist");
				data.put("rowGuid", bmguid);
				data.put("taskCode", taskCode);
				params.setData(data);

				rs = pss.getNMGInfo(params);

				for (Map map: rs.getData()){
					Result temprs = new Result();
					Paramater tempparams = new Paramater();
					Map<String, Object> tempdata = new HashMap<>();
					tempparams.setType("download");
					JSONArray jsonArray=new JSONArray((List<Object>) map.get("fileList"));
					for(int i=0;i<jsonArray.size();i++) {
						JSONObject jsonObject=jsonArray.getJSONObject(i);
						jsonObject.get("RowGuid");
						String attachGuid = (String) jsonObject.get("RowGuid");
						tempdata.put("attachGuid", attachGuid);
						tempparams.setData(tempdata);
						temprs = pss.getNMGInfo(tempparams);
						if (temprs.getCode() == 0) {

							Object o = temprs.getData().get(0).get("url");
							if(o!=null){
								((JSONObject)((List<Object>) map.get("fileList")).get(i)).put("url",o.toString().replace(download_ip, download_url));
							}
							
							
						}
					}
				}
			}

		} catch (Exception e) {
			result.put("code", -2);
			result.put("msg", e.getMessage());
			e.printStackTrace();
		}
		return rs;
	}
	
	
	
	/**
	 * 获取已存在的附件
	 * @param typs
	 * @param bmguid
	 * @param taskCode
	 * @return
	 */
	@RequestMapping("file_del")
	@ResponseBody
	public Object file_del(String fileid) {
		Map<String, Object> result = new HashMap<String, Object>();
		ProjectSignService pss = new ProjectSignService();
		Result rs = null;
		try {
			if (StringUtils.isNotBlank(fileid)
					&& fileid.length() ==36) {

				Paramater params = new Paramater();
				Map<String, Object> data = new HashMap<String, Object>();
				params.setType("delfiles");
				data.put("rowGuids", fileid);
				params.setData(data);

				rs = pss.getNMGInfo(params);
			}

		} catch (Exception e) {
			result.put("code", -2);
			result.put("msg", e.getMessage());
			e.printStackTrace();
		}
		return rs;
	}
}
