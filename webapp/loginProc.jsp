<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@   page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>


<%
   Logger logger = LogManager.getLogger("loginProc.jsp");

   String userId = HttpUtil.get(request,"userId");
   String userPwd = HttpUtil.get(request,"userPwd");
   
   String msg = "";
   String redirectUrl= "";
   String icon = "";
   
   User user = null;
   UserDao userDao = new UserDao();
   
   if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))    
   {
   
      user = userDao.userSelect(userId);
      
      if(user != null)
      {
         if(StringUtil.equals(userPwd, user.getUserPwd()))            
         {
            if(user.getUserStatus().equals("Y"))
            {   
               CookieUtil.addCookie(response, "/", "USER_ID", userId);
               
               msg = "로그인 성공";
               redirectUrl = "index.jsp";
               icon = "success";
            }
            else
            {
               msg = "정지된 사용자 입니다.";
               redirectUrl = "/";
               icon = "error";
            }
         }
         else
         {
            msg = "비밀번호가 일치하지 않습니다.";
            redirectUrl = "/";
            icon = "warning";
         }
      }
      else
      {
         msg = "아이디가 존재하지 않습니다.";
         redirectUrl = "/";
         icon = "warning";
      }
   }
   else
   {
      msg = "아이디나 비밀번호가 입력되지 않았습니다.";
      redirectUrl = "/";
      icon = "warning";
   }
   
%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<style>
        body {
            background-color: black; 
            color: white; 
        }
</style>
</head>
<body>
<script>
$(document).ready(function() {
    Swal.fire({
        title: '<%= msg %>',
        icon: '<%= icon %>',
        confirmButtonColor: '#3085d6',
        confirmButtonText: '확인',
    }).then(result => {
        if (result.isConfirmed) {
            location.href = '<%= redirectUrl %>';
        }
    });
});
</script>
</body>
</html>