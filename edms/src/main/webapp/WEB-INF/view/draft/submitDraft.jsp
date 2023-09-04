<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기안함</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
    <script type='text/javascript'>
        $(document).ready(function(){
            $(".draftDeleteBtn").click(function(){
                var documentId = $(this).data('document-id');
                $.ajax({
                    url : "${pageContext.request.contextPath}/submitDraft",
                    method : "POST",
                    data : { documentId : documentId },
                    success : function(response) {
                        location.reload();
                    },
                    error : function(request, status, error) {
                        alert("Error : " + request.status);
                    }
                });
            });
        });
    </script>
</head>
<body>
    <h1>기안함</h1>
    
    <!-- 검색 조건 영역 -->
    결재대기 ${approvalDraftCount}건, 결재중 ${approvalInProgressCount}건, 결재완료 ${approvalCompletCount}건, 반려 ${approvalRejectCount}건 
    
    <form method="get" action="${pageContext.request.contextPath}/submitDraft">
        <div class="date-area">
            <label class="date-label">검색 시작일</label>
            <input type="date" name="startDate" value="${startDate}">
            
            <label class="date-label">검색 종료일</label>
            <input type="date" name="endDate" value="${endDate}">
            
            <button type="submit">조회</button>
        </div>

        <div class="sort-area">
            <label class="sort-label">정렬</label>
            <select name="col">
                <option value="createdate" ${col eq 'createdate' ? 'selected' : ''}>작성일</option>
            </select>
            <select name="ascDesc">
                <option value="ASC" ${ascDesc eq 'ASC' ? 'selected' : ''}>오름차순</option>
                <option value="DESC" ${ascDesc eq 'DESC' ? 'selected' : ''}>내림차순</option>
            </select>
            <button type="submit">정렬</button>
        </div>
        
        <div class="search-area">
            <label class="search-label">검색</label>
            <select name="searchCol">
                <option value="doc_title" ${searchCol eq 'doc_title' ? 'selected' : ''}>문서 제목</option>
            </select>
            <input type="text" name="searchWord" value="${searchWord}">
            <button type="submit">검색</button>
        </div>

    
        <table border="1">
            <tr>
            	<th>양식</th>
                <th>문서 제목</th>
                <th>결재상태</th>
                <th>작성일</th>
            </tr>
            <c:forEach var="draft" items="${draftList}">
                <tr>
                	<td>${draft.documentCategory}</td>
                    <td>
					    <c:choose>
					        <c:when test="${draft.documentCategory eq '지출결의서'}">
					            <a href="${pageContext.request.contextPath}/draft/expenseDraftOne?approvalNo=${draft.approvalNo}">${draft.docTitle}</a>
					        </c:when>
					        <c:when test="${draft.documentCategory eq '기안서'}">
					            <a href="${pageContext.request.contextPath}/draft/basicDraftOne?approvalNo=${draft.approvalNo}">${draft.docTitle}</a>
					        </c:when>
					        <c:when test="${draft.documentCategory eq '매출보고서'}">
					            <a href="${pageContext.request.contextPath}/draft/salesDraftOne?approvalNo=${draft.approvalNo}">${draft.docTitle}</a>
					        </c:when>
					        <c:when test="${draft.documentCategory eq '휴가신청서'}">
					            <a href="${pageContext.request.contextPath}/draft/vacationDraftOne?approvalNo=${draft.approvalNo}">${draft.docTitle}</a>
					        </c:when>
					        <c:otherwise>
					            ${draft.docTitle}
					        </c:otherwise>
					    </c:choose>
					</td>
                    <td>${draft.approvalState}</td>
                    <td>${draft.createdate}</td>
                </tr>
            </c:forEach>
        </table>
    </form>
    
    <!-- 페이징 영역 -->
    <c:if test="${minPage > 1 }">
        <a href="${pageContext.request.contextPath}/draft/submitDraft?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">이전</a>
    </c:if>
    
    <c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
        <c:if test="${i == currentPage}">
            ${i}
        </c:if>
        <c:if test="${i != currentPage}">
            <a href="${pageContext.request.contextPath}/draft/submitDraft?currentPage=${i}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
        </c:if>
    </c:forEach>
    
    <c:if test="${lastPage > currentPage}">
        <a href="${pageContext.request.contextPath}/draft/submitDraft?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
    </c:if>
</body>
</html>