<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
$(document).ready(function(){

      var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
      var emptCheck = /\s/g;

      $('#userId').on('input', function() {
          var userId = $("#userId").val();
          var idMessage = $('.idText');

          idMessage.html('');

          if ($.trim(userId).length <= 0)
          {
              idMessage.append('<p style="color: red;">아이디를 입력하세요</p>');
          }
          
          else if (emptCheck.test(userId))
          {
              idMessage.append('<p style="color: red;">아이디에는 공백을 포함할 수 없습니다.</p>');
          }
          
          else if (!idPwCheck.test(userId))
          {
              idMessage.append('<p style="color: red;">아이디는 영문 대소문자와 숫자로 4~12자로만 입력 가능합니다.</p>');
          }
          else
          {
              idMessage.append('<p style="color: blue;">아이디 형식이 올바릅니다.</p>');
          }
      });
  	
  	$('#userPwd1').on('input', function() {
        var userPwd1 = $("#userPwd1").val();
        var pwMessage = $('.pwdText1');

        pwMessage.html('');
        
        if($.trim(userPwd1).length <= 0) {
     	   pwMessage.append('<p style="color: red;">비밀번호를 입력하세요.</p>');
        }

        else if(emptCheck.test(userPwd1)) {
     	   pwMessage.append('<p style="color: red;">사용자 비밀번호에는 공백을 포함할수 없습니다.</p>');
        }

        else if (!idPwCheck.test(userPwd1)) {
     	   pwMessage.append('<p style="color: red;">비밀번호는 영문 대소문자와 숫자로 4~12자로만 <br/>입력가능합니다.</p>');
        }
       
        else{
     	   pwMessage.append('<p style="color: blue;">비밀번호 형식이 올바릅니다.</p>');	
        }
    });
    
    $('#userPwd2').on('input', function() {
 	   var cpPwMessage = $(".pwdText2");
 	   cpPwMessage.empty();

 	   if($("#userPwd1").val() !== $("#userPwd2").val()) {
 		   cpPwMessage.append('<p style="color: red;">비밀번호가 일치하지 않습니다.</p>');
 	   } else if ($("#userPwd1").val() !== "") {
 		   cpPwMessage.append('<p style="color: blue;">비밀번호가 일치하였습니다.</p>');
 	   }
 	});
      
      
      $("#btnWithDraw").on("click",function(){
      
    	$("#userPwd").val($("#userPwd1").val());
    	
   	  Swal.fire({
		   title: '탈퇴를 진행 하시겠습니까?',
		   icon: 'question',
		   showCancelButton: true, 
		   confirmButtonColor: '#3085d6', 
		   cancelButtonColor: '#d33', 
		   confirmButtonText: '확인', 
		   cancelButtonText: '취소', 
		}).then(result => {
		   if (result.isConfirmed) { 
			   document.wdForm.submit();
		   }
		});
    	  
   });
});
</script>
</head>
<body>
   <%@ include file="/include/navigation.jsp"%>
<div class="container" style="max-width: 400px; background-color: #e8eaf6; border-radius: 10px; padding: 20px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
    <div class="row mt-5">
        <h1 class="text-center text-nowrap">회원탈퇴</h1>
    </div>
    <div class="row mt-4">
        <div class="col-12">
            <form id="wdForm" name="wdForm" method="post" action="/user/userWithDrawProc.jsp">
                <div class="form-group mb-3">
                    <label for="userId" class="form-label">사용자 아이디</label>                    
                    <input type="text" class="form-control me-3" id="userId" name="userId" placeholder="사용자 아이디" maxlength="12" required style="flex: 1;">                     
                	<span class="idText"></span>
                </div>
                <div class="form-group mb-3">
                    <label for="userPwd1" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" placeholder="비밀번호" maxlength="12" required style="flex: 1;">
                   <span class="pwdText1"></span>
                </div>
                <div class="form-group mb-3">
                    <label for="userPwd2" class="form-label">비밀번호 확인</label>
                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인" maxlength="12" required style="flex: 1;">
                   <span class="pwdText2"></span>
                </div>
                <input type="hidden" id="userPwd" name="userPwd" value="">
                <div class="d-flex justify-content-end mt-4">
                <script  src="http://code.jquery.com/jquery-latest.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
                    <button type="button" id="btnWithDraw" class="btn btn-outline-primary" style="background-color: #3f51b5;">탈퇴</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/include/footer.jsp" %>
</body>
</html>