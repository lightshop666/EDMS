<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jstl 사용 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>utilityList</title>
</head>
<body>
	<!-- 탭 메뉴 형식으로 회사일정 or 공용품리스트 형식으로 나누면서 확인해야함 템플릿 이용 -->
	<h1>공용품리스트</h1>
	<div>
		<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함-->
		<a href="${pageContext.request.contextPath}/utility/addUtility">공용품추가</a>
	</div>	
	<form action="${pageContext.request.contextPath}/delete" method="post">
		<!-- [시작] 테이블 영역 -->
		<table border="1">
			<tr>
				<th>선택</th>
				<th>공용품 번호</th>
				<th>공용품 이미지</th>
				<th>공용품 종류</th>
				<th>공용품 이름</th>
				<th>공용품 정보</th>
				<th>등록일</th>
				<th>수정일</th>
				<th>신청</th>
				<th>수정</th>
			</tr>
			<c:forEach var="u" items="${utilityList}">
					<tr>
						<!-- 각 리스트마다 체크박스를 생성 -->
						<td>
							<input type="checkbox" name="selectedItems" value="${u.utilityNo}">
						</td>
						<td>${u.utilityNo}</td>
						<td>
							<!-- 공용품은 고정된 폴더에 저장되는것으로 생각하고 리스트에 사진을 출력한다. -->
							<img class="thumbnail" alt="Utility Image"
								src="/image/utility/${u.utilitySaveFilename}">
						</td>
						<td>${u.utilityCategory}</td>
						<td>${u.utilityName}</td>
						<td>${u.utilityInfo}</td>
						<td>${u.createdate}</td>
						<td>${u.updatedate}</td>
						<td>
							<a href="${pageContext.request.contextPath}/reservation/addReservation?utilityNo=${u.utilityNo}&u.utilityCategory=${u.utilityCategory}">신청</a>
						</td>
						<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함  -->
						<td>
							<a href="${pageContext.request.contextPath}/utility/modifyUtility?utilityNo=${u.utilityNo}">수정</a>
						</td>
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
		<a href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${currentPage - 1}">이전</a>
	</c:if>
	
	<c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
    	<c:if test="${i == currentPage}">
        	${i}
        </c:if>
        <c:if test="${i != currentPage}">
        	<a  href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${i}">${i}</a>
    	</c:if>
    </c:forEach>
	
	<c:if test="${lastPage > currentPage }">
		<a href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${currentPage + 1}">다음</a>
	</c:if>
	<!-- [끝] 페이징 영역 -->
</body>
</html>