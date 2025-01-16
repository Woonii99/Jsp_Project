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
    Logger logger = LogManager.getLogger("/board/freeView.jsp");
    HttpUtil.requestLogString(request, logger);
    
    String cookieUserId = CookieUtil.getValue(request, "USER_ID");
    
    long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", (long)0);
    String searchType = HttpUtil.get(request, "searchType", "");
    String searchValue = HttpUtil.get(request, "searchValue", "");
    long currentPage = HttpUtil.get(request, "currentPage", (long)1);
    
    FreeBbsDao freeBbsDao = new FreeBbsDao();
    FreeBbs freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
    
    UserDao userDao = new UserDao();
    User user = userDao.userSelect(cookieUserId);
    
    if(freeBbs != null) {
        freeBbsDao.freeBbsReadCntPlus(freeBbsSeq);
    }
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>

<script>
$(document).ready(function() 
		{

    <% if(freeBbs == null) { %>
        Swal.fire({
            title: '조회 하신 게시물이 존재하지 않습니다.',
            icon: 'warning',
            confirmButtonColor: '#3085d6',
            confirmButtonText: '확인',
        }).then(result => {
            if (result.isConfirmed) {
                location.href = '/board/freeList.jsp';
            }
        });
    <% } else { %>
        $("#btnList").on("click", function() {
            document.bbsForm.action = "/board/freeList.jsp";
            document.bbsForm.submit();
        });

    <% if (StringUtil.equals(cookieUserId, freeBbs.getUserId())) { %>
            $("#btnUpdate").on("click", function() {
                document.bbsForm.action = "/board/freeUpdate.jsp";
                document.bbsForm.submit();
            });

            $("#btnDelete").on("click", function() {
                Swal.fire({
                    title: '게시물을 삭제 하시겠습니까?',
                    icon: 'question',
                    showCancelButton: true, 
                    confirmButtonColor: '#3085d6', 
                    cancelButtonColor: '#d33', 
                    confirmButtonText: '확인', 
                    cancelButtonText: '취소', 
                }).then(result => {
                    if (result.isConfirmed) { 
                        document.bbsForm.action = "/board/freeDelete.jsp";
                        document.bbsForm.submit();
                    }
                });
            });
        <% } %>
    <% } %>

});

function submitComment() 
{
    const commentContent = $("#commentText").val();
    if (commentContent.trim() === "") 
    {
        Swal.fire("댓글 내용을 입력하세요.");
        return;
    }

    $.post("/freeCom", {
        action: "insert",
        freeBbsSeq: <%= freeBbsSeq %>,
        freeComContent: commentContent
    }, function(response) {
        if (response.flag === 1) 
        {
            Swal.fire("댓글이 작성되었습니다.").then(() => location.reload());
        } 
        else {
            Swal.fire("댓글 작성에 실패했습니다.");
        }
    }, "json");
}

</script>
</head>
<body>
<%
    if(freeBbs != null) {
%>

<%@include file="/include/navigation.jsp"%>
<div class="container mt-5">
    <h2>자유 게시물</h2>
    <div class="row" style="margin-right: 0; margin-left: 0;">
        <table class="table table-hover">
            <thead>
                <tr class="table-active">
                    <th scope="col" style="width:60%">
                        <%=freeBbs.getFreeBbsTitle()%><br/>
                        작성자 : <%=freeBbs.getUserName()%>&nbsp;&nbsp;&nbsp;
                        <a href="mailto:<%=user.getUserEmail()%>" style="color:#828282;"><%=user.getUserEmail()%></a> 
                    </th>
                    <th scope="col" style="width:40%" class="text-end">
                        조회 : <%=freeBbs.getFreeBbsReadCnt()%><br/> 
                        <%=freeBbs.getRegDate()%>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="2"><pre><%=freeBbs.getFreeBbsContent()%></pre></td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="2"></td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div class="d-flex justify-content-end">
        <button type="button" id="btnList" class="btn btn-outline-primary me-2" style="background-color: #3f51b5;">리스트</button>
        <%
        if(StringUtil.equals(cookieUserId, freeBbs.getUserId())) {
        %>
            <button type="button" id="btnUpdate" class="btn btn-outline-primary me-2">수정</button>
            <button type="button" id="btnDelete" class="btn btn-outline-primary">삭제</button>
        <%
        }
        }
        %>
    </div>
    <form name="bbsForm" id="bbsForm" method="post">
        <input type="hidden" name="freeBbsSeq" value="<%=freeBbsSeq%>" />
        <input type="hidden" name="searchType" value="<%=searchType%>" />
        <input type="hidden" name="searchValue" value="<%=searchValue%>" />
        <input type="hidden" name="currentPage" value="<%=currentPage%>" />
    </form>

    <hr>
    <!-- 댓글 입력 폼 -->
    <div class="mt-4">
        <h5>댓글 작성</h5>
        <div class="mb-3">
            <label for="commentText" class="form-label">댓글 내용</label>
            <textarea class="form-control" name="commentText" id="commentText" rows="3"
                placeholder="댓글을 입력하세요."></textarea>
        </div>
        <div class="d-flex justify-content-end mt-4">
            <button type="button" id="btnComWrite" class="btn btn-outline-primary" onclick="submitComment()">댓글 작성</button>
        </div>
    </div>
</div>
<%@include file="/include/footer.jsp"%>
</body>
</html>
