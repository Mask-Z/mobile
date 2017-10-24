<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>出错了</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    

  </head>
  
  <body>
    
    <% Exception ex = (Exception)request.getAttribute("exception"); %>
    <H2>Exception: <%= ex.getMessage()%></H2>
    <P/>
    <% ex.printStackTrace(new java.io.PrintWriter(out)); %>
    
  </body>
</html>
