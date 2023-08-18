<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Vacation History List</title>
</head>
<body>
    <h1>Vacation History List</h1>
	    <!-- 보상휴가 지급 버튼 -->
	<div align="center">
	    <a href="${pageContext.request.contextPath}/adminAddVacation?empNo=${empNo}" class="btn btn-primary">보상휴가 지급</a>
	</div>
    <form method="post" action="${pageContext.request.contextPath}/vacationHistory">
        <div class="search-area">
            <label class="search-label">기간검색</label>
            <input type="date" name="startDate">
            <input type="date" name="endDate">
            <button type="submit">검색</button>
        </div>      
		<div class="sort-area">
		    <label class="sort-label">정렬</label>
		    <select name="col">
		        <option value="createdate">발생 일자</option>
		        <option value="vacationHistoryNo">휴가 번호</option>
		    </select>
		    <select name="ascDesc">
		        <option value="ASC">오름차순</option>
		        <option value="DESC">내림차순</option>
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
    
    <nav class="pagination justify-content-center">
        <ul class="pagination">
            <c:forEach var="page" begin="${minPage}" end="${maxPage}">
                <li class="page-item ${currentPage eq page ? 'active' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/vacationHistory?currentPage=${page}&empNo=${empNo}&startDate=${startDate}&endDate=${endDate}&vacationName=${vacationName}&ascDesc=${ascDesc}">
                        ${page}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</body>
</html>