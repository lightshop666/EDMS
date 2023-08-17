<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mainmenu</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
	$(".access-level-link").click(function(event) {
		event.preventDefault(); // 기본 링크 동작 취소
		
		let requiredAccessLevel = $(this).data("access-level");				// 이 링크의 엑세스 제한 레벨 가져오기
		let userAccessLevel = <%= session.getAttribute("accessLevel") %>;	// 세션에서 사용자의 엑세스 레벨 가져오기
		
		if (userAccessLevel < requiredAccessLevel) {
			alert("권한이 없는 사용자입니다."); // 팝업 메시지 띄우기
		} else {
			window.location.href = $(this).attr("href"); // 권한이 있을 경우 해당 링크로 이동
		}
	});
});
</script>
</head>
<body>
	<div>
	<!-- 전자결재 -->
		<h4>전자결재</h4>
		<a href="${pageContext.request.contextPath}/home">새 결재</a>
		<a href="${pageContext.request.contextPath}/home">내 문서함</a>
		<a href="${pageContext.request.contextPath}/home">임시 저장함</a>
	</div>
	
	<div>
	<!-- 일정관리 -->
		<h4>일정관리</h4>
		<a href="${pageContext.request.contextPath}/home">달력</a>
		<!-- 레벨1 제한 -->
		<a href="${pageContext.request.contextPath}/home" class="access-level-link" data-access-level="1">일정관리</a>
		<a href="${pageContext.request.contextPath}/home">예약신청</a>
		<a href="${pageContext.request.contextPath}/home">예약조회</a>
	
	</div>

	<div>
	<!-- 인사관리 -->
		<h4>인사관리</h4>
		<!-- 레벨0은 사용자용, 레벨1 이상은 관리자용 분기 -->
		<c:if test="${accessLevel >= 1}">
			<!-- 관리자용 링크 -->
			<a href="${pageContext.request.contextPath}/admin/home">사원목록 (관리자용)</a>
		</c:if>
		<c:if test="${accessLevel < 1}">
			<!-- 사용자용 링크 -->
			<a href="${pageContext.request.contextPath}/home">사원목록 (사용자용)</a>
		</c:if>
		
		<!-- 레벨2 제한 -->
		<a href="${pageContext.request.contextPath}/home" class="access-level-link" data-access-level="2">사원등록</a>
	
	</div>

	<div>
	<!-- 게시판 -->
		<h4>게시판</h4>
		<a href="${pageContext.request.contextPath}/home">공지사항</a>
	
	</div>
</body>
</html>