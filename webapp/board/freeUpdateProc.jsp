<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.dao.FreeBbsDao"%>
<%@ page import="com.sist.web.model.FreeBbs" %>


<%
	Logger logger = LogManager.getLogger("/board/freeUpdateProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");		//"sample";	(테스트)
	
	long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", (long)0);			//200; //0; (테스트)
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long currentPage = HttpUtil.get(request, "currentPage", (long)1);
	
	String freeBbsTitle = HttpUtil.get(request, "freeBbsTitle", "");			//"";		(테스트)
	String freeBbsContent = HttpUtil.get(request, "freeBbsContent", "");
	
	boolean bSuccess = false;
	String errorMessage = "";
	
	logger.debug("===================");
	logger.debug(freeBbsSeq);
	logger.debug(searchType);
	logger.debug(searchValue);
	logger.debug(currentPage);
	logger.debug(freeBbsTitle);
	logger.debug(freeBbsContent);
	logger.debug("==================");
	
	if(freeBbsSeq > 0 && !StringUtil.isEmpty(freeBbsTitle) && !StringUtil.isEmpty(freeBbsContent))
	{
		FreeBbsDao freeBbsDao = new FreeBbsDao();
		FreeBbs freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
		
		if(freeBbs != null)
		{
			if(StringUtil.equals(cookieUserId, freeBbs.getUserId()))
			{
				freeBbs.setFreeBbsSeq(freeBbsSeq);
				freeBbs.setFreeBbsTitle(freeBbsTitle);
				freeBbs.setFreeBbsContent(freeBbsContent);
				
				if(freeBbsDao.freeBbsUpdate(freeBbs) == true)			//(board) < 0)	(테스트)
				{
					bSuccess = true;
				}
				else
				{
					errorMessage = "게시물 수정 중 오류가 발생하였습니다.";	
				}
			}
			else
			{
				errorMessage = "사용자 정보가 일치하지 않습니다.";
			}
		}
		else
		{
			errorMessage = "게시물이 존재하지 않습니다.";
		}
	}
	else
	{
		errorMessage = "게시물 수정 값이 <br>올바르지 않습니다.";
	}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
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
	    title: '게시물이 수정 되었습니다.',
	    icon: 'success',
	    confirmButtonColor: '#3085d6',
	    confirmButtonText: '확인',
	}).then(result => {
	    if (result.isConfirmed) {
	    	document.bbsForm.action = "/board/freeView.jsp";		
			document.bbsForm.submit();
	    }
	});

		
		
<%
	}
	else
	{
%>
		$(document).ready(function() {
		    Swal.fire({
		        title: '<%=errorMessage%>',
		        icon: 'warning',
		        confirmButtonColor: '#3085d6',
		        confirmButtonText: '확인',
		    }).then(result => {
		        if (result.isConfirmed) {
		            location.href = '/board/freeList.jsp';
		        }
		    });

<%
	}
%>
});
</script>
</head>
<body>
	<form name="bbsForm" method="post">
		<input type="hidden" name="freeBbsSeq" value="<%=freeBbsSeq%>" />
		<input type="hidden" name="searchType" value="<%=searchType%>" />
		<input type="hidden" name="searchValue" value="<%=searchValue%>" />
		<input type="hidden" name="currentPage" value="<%=currentPage%>" />
	</form>
</body>
</html>