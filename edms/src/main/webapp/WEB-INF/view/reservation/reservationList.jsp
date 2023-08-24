<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jstl 사용 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>reservationList</title>
	<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	
	<script type='text/javascript'>
	// 페이지가 완전히 로드된 후에 실행되는 함수를 정의, HTML 요소들이 모두 로드된 후에 자바스크립트 코드가 실행되어 에러를 방지
	$(document).ready(function(){
	  $(".reservationCancelBtn").click(function(){
		// 클릭한 버튼($(this))의 'data-reservation-no' 속성 값을 가져와서 reservationNo 변수에 저장
	    var reservationNo = $(this).data('reservation-no');
		// jQuery의 AJAX 기능을 사용하여 서버로 비동기 요청을 보냅니다. {} 안의 내용은 AJAX 요청의 세부 사항을 설정하는 곳
	    $.ajax({
	    // AJAX 요청이 보내질 URL을 설정
	      url : "${pageContext.request.contextPath}/reservation/delete",
	      method : "POST",
	    // 서버로 전송될 데이터를 설정
	      data : { reservationNo : reservationNo },
	    //  AJAX 호출이 성공했거나 실패했을 때 실행되는 콜백 함수
	      success : function(response) {
	         // 성공적으로 처리된 후 동작 
	         // 자바스크립트에서 현재 페이지를 새로고침하는 명령
	         location.reload();
	      },
	      // error 콜백: 서버 통신에 문제가 생겼거나 HTTP 에러 상태 코드(400번대, 500번대 등)가 반환될 경우 실행
	      error : function(request, status, error) {
	         // 에러 발생 시 동작
	         alert("Error : " + request.status);
	      }
	    });
	  });
	});
	</script>
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
	            <option value="emp_name" ${searchCol eq 'emp_name' ? 'selected' : ''}>사원명</option>
	            <option value="utility_category" ${searchCol eq 'utility_category' ? 'selected' : ''}>공용품종류</option>
	        </select>
	        <input type="text" name="searchWord" value="${searchWord}">
	        <button type="submit">검색</button>
	    </div>
	</form>
	
	<form method="post" action="${pageContext.request.contextPath}/reservation/delete?reservationNo=${r.reservationNo}">
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
					
					<!-- 세션에서 멤버로그인ID(사원번호) 확인후 작성자사원번호와 일치할경우 취소태그가 보이도록 출력 비교할 값을 하나의 EL태그안에 넣어서 비교해줘야 조건식이 올바르게 작동한다. -->
					<c:if test="${empNo == r.empNo}">
						<td>
							<!-- 취소 버튼 클릭 시 postRequest 함수 호출 -->
                			<!-- data-reservation-no 속성으로 예약 번호 저장 -->
							<button class='reservationCancelBtn' data-reservation-no='${r.reservationNo}'>예약취소</button>
						</td>
					</c:if> 
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
	
	<c:if test="${lastPage > currentPage}">
		<a href="${pageContext.request.contextPath}/reservation/reservationList?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
	</c:if>
	<!-- [끝] 페이징 영역 -->
</body>
</html>