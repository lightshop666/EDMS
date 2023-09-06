<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Vacation History List</title>
</head>
<body>
	<br>
	   <nav class="navbar navbar-expand-lg navbar-light">
	       <div class="collapse navbar-collapse" id="navbarNav">
	           <ul class="nav nav-tabs">
	               <li class="nav-item">
	                   <a class="nav-link" href="${pageContext.request.contextPath}/emp/modifyEmp?empNo=${empNo}">인사정보</a>
	               </li>
	               <li class="nav-item">
	                   <a class="nav-link" href="${pageContext.request.contextPath}/emp/adminMemberOne?empNo=${empNo}">개인정보</a>
	               </li>
	               <li class="nav-item">
	                   <a class="nav-link active" href="${pageContext.request.contextPath}/vacation/vacationHistory?empNo=${empNo}">휴가정보</a>
	               </li>
	           </ul>
	       </div>
	   </nav>
  	<br>
    <h1>Vacation History List</h1>
	    <!-- 보상휴가 지급 버튼 -->
	<div align="center">
	    <a href="${pageContext.request.contextPath}/adminAddVacation?empNo=${empNo}" class="btn btn-primary">보상휴가 지급</a>
	</div>
    <form method="get" action="${pageContext.request.contextPath}/vacationHistory">
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
        
    </form>
    
    <div align="center">
        <a href="${pageContext.request.contextPath}/vacationHistory?vacationName=연차">연차</a>
        <a href="${pageContext.request.contextPath}/vacationHistory?vacationName=보상">보상</a>
    </div>
    
    <table class="table">
        <thead class="table-active">
            <tr>
                <th>휴가 번호</th>
                <th>사원 번호</th>
                <th>휴가 종류</th>
                <th>휴가 일수(+/-)</th>
                <th>휴가 일수</th>
                <th>발생 일자</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="history" items="${vacationHistoryList}">
				<tr>
				    <td>${history.vacationHistoryNo}</td>
				    <td>${history.empNo}</td>
				    <td>${history.vacationName}</td>
				    <td>${history.vacationPm}</td>
				    <td>${history.vacationDays}</td>
				    <td>${history.createdate}</td>
				</tr>
            </c:forEach>
        </tbody>
    </table>
    
    <!-- 페이징 영역 -->
    <c:if test="${minPage > 1 }">
        <a href="${pageContext.request.contextPath}/vacationHistory?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">이전</a>
    </c:if>
    
    <c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
        <c:if test="${i == currentPage}">
            ${i}
        </c:if>
        <c:if test="${i != currentPage}">
            <a href="${pageContext.request.contextPath}/vacationHistory?currentPage=${i}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
        </c:if>
    </c:forEach>
    
    <c:if test="${lastPage > currentPage}">
        <a href="${pageContext.request.contextPath}/vacationHistory?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
    </c:if>
</body>
</html>