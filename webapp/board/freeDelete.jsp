<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.sist.web.dao.FreeBbsDao" %>
<%@ page import="com.sist.web.model.FreeBbs" %>    
<%@ page import="org.apache.logging.log4j.LogManager"%>	
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
	Logger logger = LogManager.getLogger("/board/freeDelete.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", (long)0);
	
	String errorMessage = "";
	boolean bSuccess = false;
	
	if(freeBbsSeq > 0)
	{
		FreeBbsDao freeBbsDao = new FreeBbsDao();
		FreeBbs freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
		
		if(freeBbs != null)
		{
			if(StringUtil.equals(cookieUserId, freeBbs.getUserId()))
			{
				if(freeBbsDao.freeBbsDelete(freeBbsSeq) == true)
				{
					bSuccess = true;
				}
				else
				{
					errorMessage = "게시물 삭제 중 오류가 발생하였습니다.";
				}
			}
			else
			{
				errorMessage = "로그인 사용자의 게시물이 아닙니다.";
			}
		}
		else
		{
			errorMessage = "해당 게시글이 존재하지 않습니다.";
		}
	}
	else
	{
		errorMessage = "게시물 번호가 올바르지 않습니다.";
	}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
<script>
$(document).ready(function(){
<%
	if(bSuccess == true)
	{
%>
		Swal.fire({
		    title: '게시물이 삭제 되었습니다.',
		    icon: 'success',
		    showCancelButton: true,
		    showConfirmButton: false,
		    cancelButtonColor: '#3085d6',
		    cancelButtonText: '다른 게시물 보러가기'
		});
<%
	}
	else
	{
%>
		Swal.fire({
		    title: '<%=errorMessage%>',
		    icon: 'warning',
		    showCancelButton: true,
		    showConfirmButton: false,
		    cancelButtonColor: '#3085d6',
		    cancelButtonText: '다른 게시물 보러가기'
		});
<%
	}
%>

	location.href = "/board/freeList.jsp";	
});
</script>
</head>
<body>

</body>
</html>