<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jstl 사용 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addReservation</title>
</head>
<body>
	
	<form method="post" action="${pageContext.request.contextPath}/reservation/addReservation">
		<h1>예약 신청</h1>
		<table>
			<tr>
				<td>사원번호</td>
				<td><input type="text" name="empNo" ></td>
				<td>공용품번호</td>
				<td><input type="text" name="utilityNo" ></td>
				<!-- 신청 공용품 카테고리가 차량이면 예약일 태그가 출력되도록 -->
				<c:choose>
				    <c:when test="${u.utilityCategory == '회의실'}">
						<td>예약일</td>
						<td><input type="date" name="reservationDate" ></td>
				 	</c:when>
				 </c:choose>
				<!-- 신청 공용품 카테고리가 회의실이면 예약시간 태그가 출력되도록 -->
				<!-- 확장성이 용이하게 choose와 when 태그 사용 -->
				<c:choose>
				    <c:when test="${u.utilityCategory == '회의실'}">
				        <td>
				            <select name="reservationTime">
				                <option value="" selected>예약시간을 선택하세요</option>
				                <option value="1">08:00 ~ 10:00</option>
				                <option value="2">10:00 ~ 12:00</option>
				                <option value="3">12:00 ~ 14:00</option>
				                <option value="4">14:00 ~ 16:00</option>
				                <option value="5">16:00 ~ 18:00</option>
				            </select>
				        </td>
				    </c:when>
				    <!-- 다른 경우에 대한 처리도 추가할 수 있음 -->
				</c:choose>
			</tr>
		</table>
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
		<button type="submit" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
	</form>
</body>
</html>