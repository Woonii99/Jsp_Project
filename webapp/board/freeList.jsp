<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.sist.web.dao.FreeBbsDao" %>
<%@ page import="com.sist.web.model.FreeBbs" %>
<%@ page import="com.sist.web.model.PageConfig" %>
<%@ page import="com.sist.web.model.Paging" %>
<%@ page import="org.apache.logging.log4j.LogManager"%>	
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
	Logger logger = LogManager.getLogger("/board/freeList.jsp");
	HttpUtil.requestLogString(request, logger);
	
	
	String searchType = HttpUtil.get(request, "searchType", "");

	String searchValue = HttpUtil.get(request, "searchValue", "");

	long currentPage = HttpUtil.get(request, "currentPage", (long)1);		

	long totalPost = 0;
	

	//게시물 리스트
	List<FreeBbs> list = null;
	
	//페이징 객체
	Paging paging = null;
	
	FreeBbs search = new FreeBbs();
	FreeBbsDao freeBbsDao = new FreeBbsDao();
	
	if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
	{
		if(StringUtil.equals(searchType, "1"))
		{
			search.setUserName(searchValue);
		}
		else if(StringUtil.equals(searchType, "2"))
		{

			search.setFreeBbsTitle(searchValue);
		}
		else if(StringUtil.equals(searchType, "3"))
		{
			search.setFreeBbsTitle(searchValue);
			search.setFreeBbsContent(searchValue);
		}
	}
	else
	{
		searchType = "";
		searchValue = "";
	}
	
	totalPost = freeBbsDao.freeBbsTotalPost(search);
	
	
	if(totalPost > 0)
	{
		paging = new Paging(totalPost, PageConfig.NUM_OF_POST_PER_PAGE,
									PageConfig.NUM_OF_PAGE_PER_BLOCK, currentPage);
		
		search.setStartPost(paging.getStartPost());
		search.setEndPost(paging.getEndPost());
		
		list = freeBbsDao.freeBbsList(search);

	}
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
 <script>
 $(document).ready(function() {
	   $("#btnFreeListWrite").on("click", function() {
	     location.href = "/board/freeWrite.jsp";
	     });
	   
	   $("#_searchType").change(function(){
	      $("#_searchValue").val("");
	   });
	    
	     
	     $("#btnSearch").on("click",function(){
	       if($("#_searchType").val() != "")
	       {
	          if($.trim($("#_searchValue").val()) == "")
	          {
	        	  Swal.fire({
	      	        title: '조회항목 선택시 조회값을 입력하세요.',
	      	        icon: 'warning',
	      	        showCancelButton: true,
	      	        showConfirmButton: false,
	      	        cancelButtonColor: '#3085d6',
	      	        cancelButtonText: '조회값 체크하러가기'
	      	   });
	             $("#_searchValue").val();
	             $("#_searchValue").focus();
	             return;
	          }
	       }
	       
	       document.freeBbsForm.searchType.value = $("#_searchType").val();
	       document.freeBbsForm.searchValue.value = $("#_searchValue").val();
	       document.freeBbsForm.currentPage.value = "";
	       document.freeBbsForm.action = "/board/freeList.jsp";
	       document.freeBbsForm.submit();
	    });   
	});
	function fn_list(currentPage)
	{
	   document.freeBbsForm.currentPage.value = currentPage;
	   document.freeBbsForm.action = "/board/freeList.jsp";
	   document.freeBbsForm.submit();
	}

	function fn_view(freeBbsSeq)
	{
	   document.freeBbsForm.freeBbsSeq.value = freeBbsSeq;
	   document.freeBbsForm.action = "/board/freeView.jsp";
	   document.freeBbsForm.submit();
	}  
	   
	</script>
	</head>
	<body>
	   <%@ include file="/include/navigation.jsp"%>
	   <div style="display: flex; justify-content: center; align-items: center; flex-wrap: wrap; margin-top: 40px;">

	      <select class="form-select" id="_searchType"
	         style="flex: 1; max-width: 200px; margin-right: 10px;">
	         <option value="" selected>조회항목</option>
	         <option value="1" <%if (StringUtil.equals(searchType, "1")) {%>
	            selected <%}%>>작성자</option>
	         <option value="2" <%if (StringUtil.equals(searchType, "2")) {%>
	            selected <%}%>>제목</option>
	         <option value="3" <%if (StringUtil.equals(searchType, "3")) {%>
	            selected <%}%>>제목 + 내용</option>
	      </select> <input type="text" name="_searchValue" id="_searchValue"
	         value="<%=searchValue%>" class="form-control mx-1" maxlength="20"
	         style="flex: 1; max-width: 800px; ime-mode: active; margin-right: 10px; width: 800px;"
	         placeholder="검색" />
	      <button type="button" id="btnSearch" style="margin-top: 10px;"
	         class="btn btn-outline-light mb-3 mx-1">검색</button>
	   </div>

	   <div class="container mt-4">
	      <div class="row">
	         <!-- 자유 게시판 카드 -->
	         <div class="col-md-12">
	            <!-- 12로 변경하여 전체 너비 사용 -->
	            <div class="card text-white bg-info mb-3">
	               <div class="card-header">
	                  <h2>자유 게시판</h2>
	               </div>
	               <div class="card-body d-flex flex-column">
	                  <table class="table table-info">
	                     <thead>
	                        <tr>
	                           <th scope="col">번호</th>
	                           <th scope="col">제목</th>
	                           <th scope="col">작성자</th>
	                           <th scope="col">등록일</th>
	                           <th scope="col">조회수</th>
	                        </tr>
	                     </thead>
	                     <tbody>

	                        <%
	                        if (list != null && list.size() > 0) {
	                           long postNumber = paging.getPostNumber();

	                           for (int i = 0; i < list.size(); i++) {
	                              FreeBbs freeBbs = list.get(i);
	                        %>
	                        <tr class="table-light">
	                           <td class="text-left"><%=postNumber%></td>
	                           <td><a href="javascript:void(0)"
	                              onclick="fn_view(<%=freeBbs.getFreeBbsSeq()%>)"><%=freeBbs.getFreeBbsTitle()%></a></td>
	                           <td class="text-left"><%=freeBbs.getUserName()%></td>
	                           <td class="text-left"><%=freeBbs.getRegDate()%></td>
	                           <td class="text-left"><%=StringUtil.toNumberFormat(freeBbs.getFreeBbsReadCnt())%></td>
	                        </tr>
	                        <%
	                        postNumber--;
	                        }
	                        } else {
	                        %>
	                        <tr>
	                           <td colspan="5" class="text-center">해당 데이터가 존재하지 않습니다.</td>
	                        </tr>

	                        <%
	                        }
	                        %>

	                     </tbody>
	                  </table>
	                  <div>
	                     <div>
	                        <ul class="pagination d-flex justify-content-between mb-0 w-100">
	                           <%
	                           if (paging != null) {
	                              if (paging.getPrevBlockPage() > 0) {
	                           %>
	                           <li class="page-item disabled"><a class="page-link"
	                              href="#">&laquo;</a></li>
	                           <%
	                           }
	                           for (long i = paging.getStartPage(); i <= paging.getEndPage(); i++) {
	                           if (paging.getCurrentPage() != i) {
	                              // 현재 페이지가 i가 다를떄 버튼 활성화
	                           %>
	                           <li class="page-item active flex-fill text-center"><a
	                              class="page-link" href="javascript:void(0)"
	                              onclick="fn_list(<%=i%>)"><%=i%></a></li>
	                           <%
	                           } else { // // 현재 페이지가 i가 같을때 버튼 비활성화
	                           %>
	                           <li class="page-item active flex-fill text-center"><a
	                              class="page-link" href="javascript:void(0)"
	                              style="cursor: default;"><%=i%></a></li>
	                           <%
	                           }
	                           }
	                           if (paging.getNextBlockPage() > 0) {
	                           %>
	                           <li class="page-item"><a class="page-link" href="#">&raquo;</a>
	                           </li>
	                           <%
	                           }
	                           }
	                           %>
	                           <li class="ms-auto">
	                              <button type="button" id="btnFreeListWrite"
	                                 class="btn btn-outline-primary d-flex align-items-center">
	                                 <i class="fa-sharp-duotone fa-solid fa-pen me-1"></i> <span>자유
	                                    글쓰기</span>
	                              </button>
	                              <form name="freeBbsForm" id="freeBbsForm" method="post">
	                                 <input type="hidden" name="freeBbsSeq" value="" /> <input
	                                    type="hidden" name="searchType" value="<%=searchType%>" />
	                                 <input type="hidden" name="searchValue" value="<%=searchValue%>" /> 
	                                    <input type="hidden" name="currentPage" value="<%=currentPage%>" />
	                              </form>
	                           </li>
	                        </ul>
	                     </div>
	                  </div>
	               </div>
	            </div>
	         </div>
	      </div>
	   </div>
	</body>
	</html>