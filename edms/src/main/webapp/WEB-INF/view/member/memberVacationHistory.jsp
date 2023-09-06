<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>memberVacationHistory</title>
<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!--
        탭 네비게이션
         1. 개인정보 수정
         2. 비밀번호 수정
         3. 휴가정보
    -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
       <div class="collapse navbar-collapse" id="navbarNav">
           <ul class="navbar-nav">
               <li class="nav-item">
                   <a class="nav-link active" href="/member/modifyMember?result=success">개인정보 수정</a>
               </li>
               <li class="nav-item">
                   <a class="nav-link" href="/member/modifyMemberPw">비밀번호 수정</a>
               </li>
               <li class="nav-item">
                   <a class="nav-link" href="/member/memberVacationHistory">휴가정보</a>
               </li>
           </ul>
       </div>
   </nav>
   
    <h1>휴가정보</h1>
    
    <table border="1">
		<tr>
			<td>지급연차<br>${vacationByPeriod}일</td>
			<td>남은연차<br>${remainDays}일</td>
			<td>남은보상휴가<br>${remainRewardDays}일</td>
		</tr>
	</table>
	
    <form method="GET" action="/member/memberVacationHistory">
        <div class="search-area">
            <label class="search-label">기간검색</label>
            <input type="date" name="startDate" value="${param.startDate}">
            <input type="date" name="endDate" value="${param.endDate}">
            <button type="submit">검색</button>
        </div>
    </form>
	    
    <div>
        <a href="/member/memberVacationHistory?vacationName=연차">연차</a>
        <a href="/member/memberVacationHistory?vacationName=보상">보상</a>
    </div>
    
    <table class="table">
        <thead class="table-active">
            <tr>
                <th>휴가종류</th>
                <th>휴가일수(+/-)</th>
                <th>휴가일수</th>
                <th>발생일</th>
            </tr>
        </thead>
        <tbody>
	        <c:choose>
		        <c:when test="${empty vacationHistoryList}">
		        	<tr>
		            	<td colspan="5">휴가정보가 없습니다.</td>
		            </tr>
	            </c:when>
	        </c:choose>    
            <c:forEach var="history" items="${vacationHistoryList}">
				<tr>
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
                    <a class="page-link" href="/member/memberVacationHistory?currentPage=${page}&startDate=${startDate}&endDate=${endDate}&vacationName=${vacationName}&col=${col}&ascDesc=${ascDesc}">
                        ${page}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</body>
</html>