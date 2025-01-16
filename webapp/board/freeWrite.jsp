<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="org.apache.logging.log4j.LogManager"%>	
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>

<%
	Logger logger = LogManager.getLogger("/board/freeWrite.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	UserDao userDao = new UserDao();
	User user = userDao.userSelect(cookieUserId);
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/lang/summernote-ko-KR.min.js"></script>
<style>
	.note-editor {
	    border: 2px solid #1e88e5; 
	    border-radius: 5px; 
	    font-family: "GmarketSans"; 
	}
	
	.note-editable {
	    border: 2px solid #1e88e5; 
	    background-color: #f0f5fa; 
	    color: #7B8AB8; 
	    min-height: 500px; 
	    padding: 10px; 
	    border-radius: 5px;
	}
	
	.note-editable:focus {
    	border: 4px solid #abccee;
	}
		
	.note-toolbar {
	    background-color: #f0f5fa;
	    border-radius: 5px; 
	    margin-bottom: 5px; 
	}
</style>
<script>
  $(document).ready(function() {
	  $("#freeBbsTitle").focus();
      $("#freeBbsContent").summernote({
          lang: 'ko-KR',
          toolbar: [
              ["insert", ['picture']],
              ["fontname", ["fontname"]],
              ["fontsize", ["fontsize"]],
              ["color", ["color"]],
              ["style", ["style"]],
              ["font", ["strikethrough", "superscript", "subscript"]],
	          ["table", ["table"]],
	          ["para", ["ul", "ol", "paragraph"]],
	          ["height", ["height"]],
	      ],
	      fontNames: ['GmarketSans', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'],
	      fontNamesIgnoreCheck: ['GmarketSans', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'], 
	  });
      
      
      $("#btnWrite").on("click", function(){
    	 if($.trim($("#freeBbsTitle").val()).length === 0) {
    		 Swal.fire({
 		        title: '게시글 제목을 입력해주세요.',
 		        icon: 'warning',
 		        showCancelButton: true,
 		        showConfirmButton: false,
 		        cancelButtonColor: '#3085d6',
 		        cancelButtonText: '제목 체크하러가기'
 		     })
    		 $("#freeBbsTitle").val("");
    		 $("#freeBbsTitle").focus();
    		 return;
    	 } 
    	 
    	 if($.trim($("#freeBbsContent").val()).length === 0) {
    		 Swal.fire({
  		        title: '게시글 내용을 입력해주세요.',
  		        icon: 'warning',
  		        showCancelButton: true,
  		        showConfirmButton: false,
  		        cancelButtonColor: '#3085d6',
  		        cancelButtonText: '내용 체크하러가기'
  		     })
    		 $("#freeBbsContent").val("");
    		 $('#freeBbsContent').focus();
    		 return;
    	 }
    	
    	 document.writeForm.submit();
      });
      $("#btnList").on("click", function(){
    	  location.href = "/board/freeList.jsp";
      });
  });
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<br />
<div class="container">
   <h2>게시물 쓰기</h2>
   <form name="writeForm" id="writeForm" action="/board/freeWriteProc.jsp" method="post">
      <input type="text" name="freeBbsTitle" id="freeBbsTitle" maxlength="100" style="ime-mode:active;" class="form-control mb-2" placeholder="게시글 제목" required />
      <div class="form-group">
         <textarea class="form-control" name="freeBbsContent" id="freeBbsContent" style="ime-mode:active;" required></textarea>
      </div>

      <div class="form-group row">
         <div class="col-sm-12">
            <div class="d-flex justify-content-end mt-4">
            <button type="button" id="btnWrite" class="btn btn-outline-primary me-2" title="저장" style="background-color: #3f51b5;">작성</button>
            <button type="button" id="btnList" class="btn btn-outline-primary" title="리스트">리스트</button>
            </div>
         </div>
      </div>
   </form>
</div>
<%@ include file="/include/footer.jsp" %>
</body>
</html>