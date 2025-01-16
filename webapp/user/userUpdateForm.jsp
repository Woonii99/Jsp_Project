<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="org.apache.logging.log4j.LogManager"%>	
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
   Logger logger = LogManager.getLogger("userUpdateForm.jsp");
   HttpUtil.requestLogString(request, logger);
   
   User user = null;
   
   String cookieUserId = CookieUtil.getValue(request, "USER_ID");
   
   if(!StringUtil.isEmpty(cookieUserId))
	{
		logger.debug("cookie userId : " + cookieUserId);
		
		UserDao userDao = new UserDao();
		user = userDao.userSelect(cookieUserId);
		
		if(user == null)
		{
			//정상 사용자가 아니라면 쿠키를 삭제하고 로그인 페이지로 이동
			CookieUtil.deleteCookie(request, response, "/", "USER_ID");
			response.sendRedirect("/");
		}
		else
		{
			if(!StringUtil.equals(user.getUserStatus(), "Y"))
			{
				//정지된 사용자
				CookieUtil.deleteCookie(request, response, "/", "USER_ID");
				user = null;
				response.sendRedirect("/");
			}
			
		}
	}
	if(user != null)
	{
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
<script>
var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;   //아이디,비밀번호 정규표현식
var emptCheck = /\s/g;               //공백체크 정규표현식

$(document).ready(function(){
     
   
   $("#btnUpdate").on("click",function(){
      
      if($.trim($("#userPwd1").val()).length <= 0)
      {
         $(".pwdText1").text("비밀번호를 입력하세요.");
         $(".pwdText1").css('color', 'red');
         $("#userPwd1").val("");
         $("#userPwd1").focus();
         return;   
      }
      if(emptCheck.test($("#userPwd1").val()))
      {
         $(".pwdText1").text("사용자 비밀번호에는 공백을 포함할수 없습니다.");
         $(".pwdText1").css('color', 'red');
         $("#userPwd1").val("");
         $("#userPwd1").focus();
         return;   
      }
      if(!idPwCheck.test($("#userPwd1").val()))
      {
         $(".pwdText1").text("비밀번호는 영문 대소문자와 숫자로 4~12자로 입력가능합니다.");
         $(".pwdText1").css('color', 'red');
         $("#userPwd1").val("");
         $("#userPwd1").focus();
         return;
      }
      else
     {
         $(".pwdText1").text("사용 가능한 비밀번호 입니다.");
         $(".pwdText1").css('color', 'blue');
     }        
         
      
      $("#userPwd").val($("#userPwd1").val());
      
      document.upDateForm.submit();
   });
   
   $("#userPwd1, #userPwd2").on("keyup", checkPassword);
});

function checkPassword() {
    var password = $("#userPwd1").val(); 
    var confirmPassword = $("#userPwd2").val(); 


      if($.trim($("#userPwd1").val()).length > 0)
      {
         if (emptCheck.test(password)) {
             $(".pwdText1").text("사용자 비밀번호에는 공백을 포함할 수 없습니다.");
             $(".pwdText1").css('color', 'red');
             return; 
         } else if($.trim($("#userPwd1").val()).length <= 0){
            
             $(".pwdText1").text("아이디를 입력해주세요."); 
             $(".pwdText1").css('color', 'red');
               
         } else {
            $(".pwdText1").text("사용 가능한 비밀번호 입니다."); 
             $(".pwdText1").css('color', 'blue');
         }
      }

    if ($.trim(password).length > 0 && $.trim(confirmPassword).length > 0) {
        if (password === confirmPassword) {
            $(".pwdText2").text("비밀번호가 일치합니다.").css('color', 'blue');
        } else {
            $(".pwdText2").text("비밀번호가 일치하지 않습니다.").css('color', 'red');
        }
    } else {
        $(".pwdText2").text("");
    }
    

}




</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>

<div class="container">
    <div class="row mt-5">
       <h1>회원정보수정</h1>
    </div>
    <div class="row mt-2">
        <div class="col-12">
         <form name="upDateForm" id="upDateForm" action="/user/userProc.jsp" method="post">
                <div class="form-group fs-4">
                    <label for="username">사용자 아이디 : <%=user.getUserId()%></label>
                   <!-- 쿠키아이디나 유저아이디 둘다 사용가능 -->
                </div>
                <br />
                <div class="form-group">
                    <label for="username">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" value="<%=user.getUserPwd()%>" placeholder="비밀번호" maxlength="12" />
                     <span class="pwdText1"></span>
                </div>
                <br />
                <div class="form-group">
                    <label for="username">비밀번호 확인</label>
                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" value="<%=user.getUserPwd()%>" placeholder="비밀번호 확인" maxlength="12" />
                    <span class="pwdText2"></span>
                </div>
                <br />
                <div class="form-group">
                    <label for="username">사용자 이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" value="<%=user.getUserName()%>" placeholder="사용자 이름" maxlength="15" />
                </div>
                <br />
                <div class="form-group">
                    <label for="username">사용자 이메일</label>
                    <input type="text" class="form-control" id="userEmail" name="userEmail" value="<%=user.getUserEmail()%>" placeholder="사용자 이메일" maxlength="30" readonly/>
                     <span class="emailText"></span>
                </div>
                <br />
                <div class="form-group">
                    <label for="username">사용자 생년월일</label>
                    <input type="text" class="form-control" id="userBirthDay" name="userBirthDay" value="<%= user.getUserBirthday()%>" placeholder="사용자 생년월일" maxlength="30" readonly/>
                </div>
                

                <input type="hidden" id="userId" name="userId" value="<%=user.getUserId() %>" />
            <input type="hidden" id="userPwd" name="userPwd" value="<%=user.getUserPwd()%>" />
            <div class="d-flex justify-content-end mt-4">
                <button type="button" id="btnUpdate" class="btn btn-outline-primary" style="background-color: #3f51b5;">수정</button>
                </div>
         </form>
        </div>
    </div>
</div>
<%@ include file="/include/footer.jsp" %>
</body>
</html>
<%
	}
%>