<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jstl 사용 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleDay</title>
</head>
<body>
	<!-- fmt:parseDate 태그는 문자열로 된 날짜 날짜(${date})를 java.util.Date 객체로 변환 후 parsedDate라는 이름으로 저장
	fmt:formatDate 태그를 사용하여 이 날짜 객체를 원하는 형식(MMMM d, yyyy)으로 출력 -->
	<p>Date: 
		<fmt:setLocale value="en_US"/>
		<fmt:parseDate value="${date}" pattern="yyyy-MM-dd" var="parsedDate"/>
		<fmt:formatDate value="${parsedDate}" pattern="MMMM d, yyyy"/>
	</p>

	<div>
		<h1>일별 일정</h1>
	
		<table border="1">
			<thead>
				<tr>
					<th>시작시간</th>
					<th>종료시간</th>
					<th>내용</th>
					<th>생성일</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="s" items="${scheduleByDay}">
				<tr>
					<td>${s.scheduleStartTime}</td>
					<td>${s.scheduleEndTime}</td>
					<td>${s.scheduleContent}</td>
					<td>${s.createdate}</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>
	
	<div>
		<h1>일별 예약</h1>
	
		<table border="1">
			<thead>
				<tr>
					<th>예약번호</th>
					<th>사원번호</th>
					<th>사원명</th>
					<th>공용품번호</th>
					<th>공용품종류</th>
					<th>예약일</th>
					<th>예약시간</th>
					<th>생성일</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="r" items="${reservationByDay}">
				<tr>
					<td>${r.reservationNo}</td>
					<td>${r.empNo}</td>
					<td>${r.empName}</td>
					<td>${r.utilityNo}</td>
					<td>${r.utilityCategory}</td>
					<td>${r.reservationDate}</td>
					<td>${r.reservationTime}</td>
					<td>${r.createdate}</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>
	
</body>
</html>