<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.sist.web.dao.FreeBbsDao" %>
<%@ page import="com.sist.web.model.FreeBbs" %>    
<%@ page import="org.apache.logging.log4j.LogManager"%>	
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>

<%
	Logger logger = LogManager.getLogger("/board/freeUpdate.jsp");
	HttpUtil.requestLogString(request, logger);
	
	long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", (long)0);			//200; //0; (테스트)
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long currentPage = HttpUtil.get(request, "currentPage", (long)1);
	
	logger.debug("===================");
	logger.debug(freeBbsSeq);
	logger.debug("==================");
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");	//"sample"; (테스트)
	
	String errorMessage = "";
	boolean bSuccess = false;
	
	FreeBbsDao freeBbsDao = null;
	FreeBbs freeBbs = null;
	
	UserDao userDao = new UserDao();
	User user = userDao.userSelect(cookieUserId);
	
	if(freeBbsSeq > 0)
	{
		freeBbsDao = new FreeBbsDao();
		freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
		
		if(freeBbs != null)
		{

			if(!StringUtil.equals(cookieUserId, freeBbs.getUserId()))
			{
				freeBbs = null;
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
	
	if(freeBbs == null)
	{
%>
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
	else
	{
%>
	$("#bbsTitle").focus();

	$("#btnList").on("click", function(){
		document.freeUpdateForm.action = "/board/freeList.jsp";
		document.freeUpdateForm.submit();
	});
	
	$("#btnUpdate").on("click", function(){
		if($.trim($("#freeBbsTitle").val()).length <= 0)
		{
			Swal.fire({
    	        title: '제목을 입력하세요.',
    	        icon: 'warning',
    	        showCancelButton: true,
    	        showConfirmButton: false,
    	        cancelButtonColor: '#3085d6',
    	        cancelButtonText: '제목 체크하러가기'
    	   });
			$("#bbsTitle").val("");
			$("#bbsTitle").focus();
			return;
		}
		
		else if($.trim($("#freeBbsContent").val()).length <= 0)
		{
			Swal.fire({
    	        title: '내용을 입력하세요.',
    	        icon: 'warning',
    	        showCancelButton: true,
    	        showConfirmButton: false,
    	        cancelButtonColor: '#3085d6',
    	        cancelButtonText: '내용 체크하러가기'
    	   });
			$("#bbsContent").val("");
			$("#bbsContent").focus();
			return;
		}
		
		else
		{
			Swal.fire({
				   title: '정말로 수정 하시겠습니까?',
				   icon: 'warning',
				   showCancelButton: true, 
				   confirmButtonColor: '#3085d6', 
				   cancelButtonColor: '#d33', 
				   confirmButtonText: '확인', 
				   cancelButtonText: '취소', 
				}).then(result => {
				   if (result.isConfirmed) { 
					   document.freeUpdateForm.submit();
				   }
				});
		}
	});
<%
	}
%>
});

</script>
</head>
<body>
  <%
if(freeBbs != null)
{
		
%>
<%@ include file="/include/navigation.jsp" %>

<div class="container">
   <br />
   <h2>자유 게시물 수정</h2>
   <form name="freeUpdateForm" id="freeUpdateForm" action="/board/freeUpdateProc.jsp" method="post">
      <input type="text" name="bbsName" id="bbsName" maxlength="20" value="<%=freeBbs.getUserName()%>" style="ime-mode:active;"class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
      <input type="text" name="bbsEmail" id="bbsEmail" maxlength="30" value="<%=user.getUserEmail() %>"  style="ime-mode:inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
      <input type="text" name="freeBbsTitle" id="freeBbsTitle" maxlength="100" style="ime-mode:active;" value="<%=freeBbs.getFreeBbsTitle() %>" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
      <div class="form-group">
         <textarea class="form-control" rows="10" name="freeBbsContent" id="freeBbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required><%=freeBbs.getFreeBbsContent() %></textarea>
      </div>
       <input type="hidden" name="freeBbsSeq" value="<%=freeBbsSeq %>"/>
      <input type="hidden" name="searchType" value="<%=searchType %>"/>
      <input type="hidden" name="searchValue" value="<%=searchValue %>"/>
      <input type="hidden" name="currentPage" value="<%=currentPage %>"/>
   </form>
   
   <div class="form-group row">
      <div class="col-sm-12">
         <div class="d-flex justify-content-end mt-4">
         <button type="button" id="btnUpdate" class="btn btn-outline-primary"  title="수정"><i class="fa-sharp-duotone fa-solid fa-file-pen"></i> 수정</button>
         <button type="button" id="btnList" class="btn btn-outline-primary" style=" position: relative; left: 10px;"title="리스트"><i class="fa-sharp-duotone fa-solid fa-list"></i> 리스트</button>
         </div>
        </div>
   </div>
</div>
<form name="bbsForm" method="post"> 
   <input type="hidden" name="freeBbsSeq" value="<%=freeBbsSeq %>"/>
   <input type="hidden" name="searchType" value="<%=searchType %>"/>
   <input type="hidden" name="searchValue" value="<%=searchValue %>"/>
   <input type="hidden" name="currentPage" value="<%=currentPage %>"/>
</form>
<%@ include file="/include/footer.jsp" %>
<%
	}
%>
</body>
</html>