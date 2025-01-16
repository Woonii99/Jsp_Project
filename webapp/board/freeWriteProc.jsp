<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="org.apache.logging.log4j.LogManager"%>	
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.FreeBbsDao" %>
<%@ page import="com.sist.web.model.FreeBbs" %>

<%
	Logger logger = LogManager.getLogger("/board/freeWriteProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	boolean bSuccess = false;
	String errorMessage = "";
	
	String freeBbsTitle = HttpUtil.get(request, "freeBbsTitle", "");
	String freeBbsContent = HttpUtil.get(request, "freeBbsContent", "");
	
	if(!StringUtil.isEmpty(freeBbsTitle) && !StringUtil.isEmpty(freeBbsContent))
	{
		//게시물 등록
		FreeBbsDao freeBbsDao = new FreeBbsDao();
		FreeBbs freeBbs = new FreeBbs();
		
		freeBbs.setUserId(cookieUserId);
		freeBbs.setFreeBbsTitle(freeBbsTitle);
		freeBbs.setFreeBbsContent(freeBbsContent);
		
		if(freeBbsDao.freeBbsInsert(freeBbs) == true)
		{
			bSuccess = true;
		}
		else
		{
			errorMessage = "게시물 등록중 오류가 발생하였습니다.";
		}
   }
   else
   {
		errorMessage = "게시물 등록시 필요한 값이 올바르지 않습니다.";
   }
%>
    
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
<style>
        body {
            background-color: black; 
            color: white; 
        }
</style>

<script>
	$(document).ready(function(){
<%
	if(bSuccess == true)
	{
%>
	Swal.fire({
	    title: '게시물이 등록되었습니다.',
	    icon: 'success',
	    confirmButtonColor: '#3085d6',
	    confirmButtonText: '확인',
	}).then(result => {
	    if (result.isConfirmed) {
	        location.href = '/board/freeList.jsp';
	    }
	});
		
<%
	}
	else
	{
%>
	Swal.fire({
	    title: '<%=errorMessage%>',
	    icon: 'warning',
	    confirmButtonColor: '#3085d6',
	    confirmButtonText: '확인',
	}).then(result => {
	    if (result.isConfirmed) {
	        location.href = '/board/freeWrite.jsp';
	    }
	});
<%
	}
%>
	});
</script>
</head>
<body>

</body>
</html>