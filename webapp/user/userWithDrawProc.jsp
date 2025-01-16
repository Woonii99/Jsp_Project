<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@   page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
   Logger logger = LogManager.getLogger("userWithDrawProc.jsp");
   HttpUtil.requestLogString(request, logger);
   
   String msg = "";
   String redirectUrl = "";
   
   String userId = HttpUtil.get(request, "userId");
   String userPwd = HttpUtil.get(request, "userPwd");
   String userName = HttpUtil.get(request, "userName");
   String userEmail = HttpUtil.get(request, "userEmail");
   String cookieUserId = CookieUtil.getValue(request,"USER_ID");
   
   UserDao userDao = new UserDao();
   String icon = "";
   logger.info("userId: " + userId);
   logger.info("userPwd: " + userPwd);
   if(StringUtil.isEmpty(cookieUserId))   
   {   
      msg = "로그인 후 진행가능합니다.";
      redirectUrl = "/";
      icon = "warning";
   }
   else
   {   
      User user = userDao.userSelect(cookieUserId);
      
      if(user != null)
      {
         if(StringUtil.equals(user.getUserStatus(),"Y") && 
               StringUtil.equals(user.getUserId(), userId))
         {   
            if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
            {
               user.setUserId(userId);
               user.setUserStatus("N");
               
               if(userDao.userCancel(userId))
               {
                  msg = "맛집리스트 들고 <br>기다릴게요T^T";
                  redirectUrl = "index.jsp";
                  icon = "success";
               }
               else
               {
                  msg = "회원 탈퇴중 오류가 발생하였습니다.";
                  redirectUrl = "/user/userWithDraw.jsp";
                  icon = "warning";
               }
               
            }
            else
            {
               msg = "회원정보 중 값이 올바르지 않습니다.";
               redirectUrl = "/user/userWithDraw.jsp";
               icon = "warning";
            }
         }
         else
         {
            CookieUtil.deleteCookie(request, response, "/", "USER_ID");
            msg = "정지된 사용자 입니다.";
            redirectUrl = "/";
            icon = "error";
         }
         
      }
      else
      {
         CookieUtil.deleteCookie(request, response, "/", "USER_ID");
         msg = "올바른 사용자가 아닙니다.";
         redirectUrl = "/";
         icon = "warning";
      }
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
	   Swal.fire({
	        title: '<%= msg %>',
	        icon: '<%= icon %>',
	        confirmButtonColor: '#3085d6',
	        confirmButtonText: '확인',
	    }).then(result => {
	        if (result.isConfirmed) {
	        	window.close();
	        }
	    });	
   });
</script>
</head>
<body>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
</body>
</html>