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
		<!-- 필요한 정보들 hidden 타입으로 보내기 -->
		<input type="hidden" name="empNo" value="${empNo}">
	
		<h1>예약 신청</h1>
		<table>
			<!-- 세션을 통해 값을 가져와서 value 값으로 출력 및 readonly -->
			<tr>
				<td>사원명</td>
				<td><input type="text" name="empName" value="${empName}" readonly="readonly"></td>
			</tr>
			<tr>
			<!-- 해당 카테고리에 따라 출력 분기 -->
			<c:choose>
				<c:when test="${utilityCategory == '회의실'}">
					<td>공용품종류</td>
					<td><input type="text" name="utilityCategory" value="회의실" readonly="readonly"></td>
				</c:when>
				<c:when test="${utilityCategory == '차량'}">
					<td>공용품종류</td>
					<td><input type="text" name="utilityCategory" value="차량" readonly="readonly"></td>
				</c:when>
			</c:choose>
			</tr>
			<!-- 차량 or 회의실에 해당하는 공용품명들이 출력되고 해당 항목을 선택시 해당 공용품번호가 넘어간다. -->
			<tr>
				<td>공용품번호</td>
				<td>
			        <select name="utilityNo">
			            <option value="" selected>선택하세요</option>
			            <c:forEach var="u" items="${utilities}">
			          		<option value="${u.utilityNo}">${u.utilityName}</option>
			            </c:forEach>
			        </select>
			    </td>
			</tr>
			<tr>
				<td>예약일</td>
				<td><input type="date" name="reservationDate" ></td>
			</tr>
			<tr>
				<!-- 신청 공용품 카테고리가 회의실이면 예약시간 태그가 출력되도록 -->
				<!-- 확장성이 용이하게 choose와 when 태그 사용 -->
				<c:choose>
				    <c:when test="${utilityCategory == '회의실'}">
				    	<td>예약시간</td>
				        <td>
				            <select name="reservationTime">
				                <option value="" selected>예약시간을 선택하세요</option>
				                <option value="08:00 ~ 10:00">08:00 ~ 10:00</option>
				                <option value="10:00 ~ 12:00">10:00 ~ 12:00</option>
				                <option value="12:00 ~ 14:00">12:00 ~ 14:00</option>
				                <option value="14:00 ~ 16:00">14:00 ~ 16:00</option>
				                <option value="16:00 ~ 18:00">16:00 ~ 18:00</option>
				            </select>
				        </td>
				    </c:when>
				    <c:when test="${utilityCategory == '차량'}">
				    	<td>예약시간</td>
				        <td>
				            <select name="reservationTime">
				                <option value="" selected>예약시간을 선택하세요</option>
				                <option value="08:00 ~ 18:00">08:00 ~ 18:00</option>
				            </select>
				        </td>
				    </c:when>
				</c:choose>
			</tr>
		</table>
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
		<button type="submit" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
	</form>
</body>
</html>