package com.sist.web.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sist.common.util.StringUtil;
import com.sist.web.dao.FreeComDao;
import com.sist.web.model.FreeCom;

@WebServlet("/freeCom")		//웹 서블릿 URL 요청처리
public class FreeComController extends HttpServlet 
{
    private FreeComDao freeComDao = new FreeComDao();


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String action = request.getParameter("action");		//action 값에따라 작업결정
        
        switch (action) 
        {
            case "insert":	//작성
                insertComment(request, response);
                break;
            case "update":	//수정
                updateComment(request, response);
                break;
            case "delete":	//삭제
                deleteComment(request, response);
                break;
            default:		//요청 오류
                response.getWriter().write("{\"flag\":0}");
                break;
        }
    }

    private void insertComment(HttpServletRequest request, HttpServletResponse response) throws IOException		//댓글작성
    {
    	String userId = getUserIdFromCookies(request);
        long freeBbsSeq = Long.parseLong(request.getParameter("freeBbsSeq"));
        String freeComContent = request.getParameter("freeComContent");

        if (!StringUtil.isEmpty(userId) && freeBbsSeq > 0 && !StringUtil.isEmpty(freeComContent))	//내용검사
        {
            FreeCom freeCom = new FreeCom();
            freeCom.setFreeBbsSeq(freeBbsSeq);
            freeCom.setUserId(userId);
            freeCom.setFreeComContent(freeComContent);
            freeCom.setFreeComStatus("Y");

            boolean result = freeComDao.freeComInsert(freeCom);
            response.getWriter().write(result ? "{\"flag\":1}" : "{\"flag\":0}");	//댓글저장 성공여부 응답
        } 
        else
        {
            response.getWriter().write("{\"flag\":-1}"); // 오류 응답
        }
    }

    private void updateComment(HttpServletRequest request, HttpServletResponse response) throws IOException 
    {
        String userId = getUserIdFromCookies(request);
        long freeComSeq = Long.parseLong(request.getParameter("freeComSeq"));
        String freeComContent = request.getParameter("freeComContent");

        FreeCom existingComment = freeComDao.getCommentById(freeComSeq); // 댓글 조회
        if (existingComment != null && userId.equals(existingComment.getUserId())) 
        {
            existingComment.setFreeComContent(freeComContent);
            boolean result = freeComDao.updateComment(existingComment); 
            response.getWriter().write(result ? "{\"flag\":1}" : "{\"flag\":0}");
        }
        else 
        {
            response.getWriter().write("{\"flag\":0}"); // 쿠키 오류
        }
    }

    private void deleteComment(HttpServletRequest request, HttpServletResponse response) throws IOException 
    {
        String userId = getUserIdFromCookies(request);
        long freeComSeq = Long.parseLong(request.getParameter("freeComSeq"));

        FreeCom existingComment = freeComDao.getCommentById(freeComSeq); // 댓글 조회
        if (existingComment != null && userId.equals(existingComment.getUserId())) 
        {
            boolean result = freeComDao.deleteComment(freeComSeq);
            response.getWriter().write(result ? "{\"flag\":1}" : "{\"flag\":0}");
        }
        else 
        {
            response.getWriter().write("{\"flag\":0}"); // 쿠키 오류
        }
    }

    private String getUserIdFromCookies(HttpServletRequest request) 
    {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) 
        {
            for (Cookie cookie : cookies) 
            {
                if ("USER_ID".equals(cookie.getName())) 
                {
                    return cookie.getValue();
                }
            }
        }
        return null; 
    }
}