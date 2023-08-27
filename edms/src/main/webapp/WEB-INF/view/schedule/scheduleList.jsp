<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jstl 사용 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleList</title>

</head>
<body>

	<h1>일정리스트</h1>
	
	<!-- 검색 조건 영역 -->
	<form method="get" action="${pageContext.request.contextPath}/schedule/scheduleList">
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
	        	? 'selected' : '' 조건이 참일 경우 selected 속성을 추가하여 <option> 요소가 선택된 상태로 표시함. 
	        	조건이 거짓일 경우 빈 문자열('') -->
	            <option value="createdate" ${col eq 'createdate' ? 'selected' : ''}>신청일</option>
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
	            <option value="schedule_content" ${searchCol eq 'schedule_content' ? 'selected' : ''}>내용</option>
	        </select>
	        <input type="text" name="searchWord" value="${searchWord}">
	        <button type="submit">검색</button>
	    </div>
	</form>
	
	<div>
		<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함-->
		<a href="${pageContext.request.contextPath}/schedule/addSchedule">일정추가</a>
	</div>	
	
	<form method="post" action="${pageContext.request.contextPath}/schedule/delete">
		<!-- [시작] 테이블 영역 -->
		<table border="1">
			<tr>
				<th>선택</th>
				<th>일정번호</th>
				<th>시작시간</th>
				<th>종료시간</th>
				<th>내용</th>
				<th>등록일</th>
			</tr>
			<c:forEach var="s" items="${scheduleList}">
				<tr>
					<!-- 각 리스트마다 체크박스를 생성 -->
					<td>
						<input type="checkbox" name="selectedItems" value="${s.scheduleNo}">
					</td>
					<td>${s.scheduleNo}</td>
					<td>${s.scheduleStartTime}</td>
					<td>${s.scheduleEndTime}</td>
					<td>${s.scheduleContent}</td>
					<td>${s.createdate}</td>
				</tr>
			</c:forEach>
			<!-- [끝] 조건문 -->
		</table>
		<!-- [끝] 테이블 영역 -->
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
		<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함-->
		<button type="submit" id="deleteBtn">삭제</button> <!-- 오른쪽 정렬 -->
	</form>
	
	<!-- [시작] 페이징 영역 -->
	<c:if test="${minPage > 1 }">
		<a href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">이전</a>
	</c:if>
	
	<c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
    	<c:if test="${i == currentPage}">
        	${i}
        </c:if>
        <c:if test="${i != currentPage}">
        	<a  href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
    	</c:if>
    </c:forEach>
	
	<c:if test="${lastPage > currentPage}">
		<a href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
	</c:if>
	<!-- [끝] 페이징 영역 -->
</body>
</html>