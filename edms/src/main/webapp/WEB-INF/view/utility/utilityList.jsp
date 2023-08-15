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
		<a href="${pageContext.request.contextPath}/utility/utilityList">공용품추가</a>
	</div>	
	<!-- 조건문 -->
	<div>
		<c:forEach var="m" items="${utilityList}">
			<a herf="${pageContext.request.contextPath}/utility/utilityList"></a>
		</c:forEach>
	</div>
	
	<!-- [시작] 테이블 영역 -->
	<table border="1">
		<tr>
			<th>공용품 번호</th>
			<th>공용품 종류</th>
			<th>공용품 이름</th>
			<th>공용품 정보</th>
			<th>등록일</th>
			<th>수정일</th>
		</tr>
		<c:forEach var="u" items="${utilityList}">
			<tr>
				<td>${u.utilityNo}</td>
				<td>${u.utilityCategory}</td>
				<td>${u.utilityName}</td>
				<td>${u.utilityInfo}</td>
				<td>${u.createdate}</td>
				<td>${u.updatedate}</td>
			</tr>
		</c:forEach>
	</table>
	<!-- [끝] 테이블 영역 -->
	
	<!-- [시작] 페이징 영역 -->
	<c:if test="${currentPage > 1 }">
		<a href="${pageContext.request.contextPath}/utilityList?currentPage=${currentPage - 1}">이전</a>
	</c:if>
	&nbsp;<span>${currentPage}</span>
	<c:if test="${lastPage > currentPage }">
		<a href="${pageContext.request.contextPath}/utilityList?currentPage=${currentPage + 1}">다음</a>
	</c:if>
</body>
</html>