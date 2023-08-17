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
	<h1>게시판</h1>
	<div>
		<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함-->
		<a href="${pageContext.request.contextPath}/utility/addUtility">공용품추가</a>
	</div>	
	
	<!-- [시작] 테이블 영역 -->
	<table border="1">
		<tr>
			<th>공용품 번호</th>
			<th>공용품 이미지</th>
			<th>공용품 종류</th>
			<th>공용품 이름</th>
			<th>공용품 정보</th>
			<th>등록일</th>
			<th>수정일</th>
		</tr>
		<c:forEach var="u" items="${utilityList}">
				<tr>
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
				</tr>
		</c:forEach>
		<!-- [끝] 조건문 -->
	</table>
	<!-- [끝] 테이블 영역 -->
	
	<!-- [시작] 페이징 영역 -->
	<c:if test="${currentPage > 1 }">
		<a href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${currentPage - 1}">이전</a>
	</c:if>
	
	&nbsp;<span>${currentPage}</span>
	
	<c:if test="${lastPage > currentPage }">
		<a href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${currentPage + 1}">다음</a>
	</c:if>
	<!-- [끝] 페이징 영역 -->
</body>
</html>