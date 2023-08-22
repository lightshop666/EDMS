<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jstl 사용 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>reservationList</title>
</head>
<body>
	<!-- 탭 메뉴 형식으로 회사일정 or 공용품리스트 형식으로 나누면서 확인해야함 템플릿 이용 -->
	<h1>예약리스트</h1>
	
	<!-- 검색 조건 영역 -->
	<form method="get" action="${pageContext.request.contextPath}/reservation/reservationList">
	<!-- 날짜 조회 -->
	 	<div class="date-area">
	        <label class="date-label">검색 시작일</label>
	        <input type="date" name="startDate" value="${startDate}">
	        
	        <label class="date-label">검색 종료일</label>
	        <input type="date" name="endDate" value="${endDate}">
	        
	        <button type="submit">조회</button>
		</div>

	<!-- 정렬조건 영역 -->
	    <div class="sort-area">
	        <label class="sort-label">정렬</label>
	        <select name="col">
	        	<!-- ${col eq 'createdate' ? 'selected' : ''}는 조건문을 통해 선택 여부를 결정하는 부분 
	        	col eq 'createdate' 는 col 변수의 값이 createdate와 같은지 비교 
	        	? 'selected' : '' 조건이 참일 경우 selected 속성을 추가하여 <option> 요소가 선택된 상태로 표시함. 조건이 거짓일 경우 빈 문자열('') -->
	            <option value="createdate" ${col eq 'createdate' ? 'selected' : ''}>Created Date</option>
	        </select>
	        <select name="ascDesc">
	            <option value="ASC" ${ascDesc eq 'ASC' ? 'selected' : ''}>오름차순</option>
	            <option value="DESC" ${ascDesc eq 'DESC' ? 'selected' : ''}>내림차순</option>
	        </select>
	        <button type="submit">정렬</button> 
	    </div>
	    
   	<!-- 검색조건 영역 -->
	    <div class="search-area">
	        <label class="search-label">검색</label>
	        <select name="searchCol">
	            <option value="emp_name" ${searchCol eq 'emp_name' ? 'selected' : ''}>Emp Name</option>
	            <option value="utility_category" ${searchCol eq 'utility_category' ? 'selected' : ''}>Utility Category</option>
	        </select>
	        <input type="text" name="searchWord" value="${searchWord}">
	        <button type="submit">검색</button>
	    </div>
	    
	</form>
	
	<form action="${pageContext.request.contextPath}/delete" method="post">
		<!-- [시작] 테이블 영역 -->
		<table border="1">
			<tr>
				<th>공용품 종류</th>
				<th>사원명</th>
				<th>공용품 번호</th>
				<th>예약일</th>
				<th>예약시간</th>
				<th>신청일</th>
				<th>취소</th>
			</tr>
			<c:forEach var="r" items="${reservationList}">
				<tr>
					<td>${r.utilityCategory}</td>
					<td>${r.empName}</td>
					<td>${r.utilityNo}</td>
					<td>${r.reservationDate}</td>
					<td>${r.reservationTime}</td>
					<td>${r.createdate}</td>
					<!-- 세션에서 멤버로그인ID 확인후 일치할경우 취소태그가 보이도록 출력-->
					<td>
						<a href="${pageContext.request.contextPath}/reservation/delete?reservationNo=${r.reservationNo}">취소</a>
					</td>
				</tr>
			</c:forEach>
			<!-- [끝] 조건문 -->
		</table>
		<!-- [끝] 테이블 영역 -->
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
	</form>
	
	<!-- [시작] 페이징 영역 -->
	<c:if test="${minPage > 1 }">
		<a href="${pageContext.request.contextPath}/reservation/reservationList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">이전</a>
	</c:if>
	
	<c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
    	<c:if test="${i == currentPage}">
        	${i}
        </c:if>
        <c:if test="${i != currentPage}">
        	<a  href="${pageContext.request.contextPath}/reservation/reservationList?currentPage=${i}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
    	</c:if>
    </c:forEach>
	
	<c:if test="${lastPage > currentPage }">
		<a href="${pageContext.request.contextPath}/reservation/reservationList?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
	</c:if>
	<!-- [끝] 페이징 영역 -->
</body>
</html>