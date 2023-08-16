<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyEmp</title>
	<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<script>
		
	</script>
</head>
<body>
	<form action="/emp/modifyEmp" method="post">
		<table border="1">
			<tr>
				<td>사원번호</td>
				<td>
					${emp.empNo} <!-- 수정 불가, 단순 출력 -->
				</td>
			</tr>
			<tr>
				<td>사원명</td>
				<td>
					<input type="text" name="empName" value="${emp.empName}">
				</td>
			</tr>
			<tr>
				<td>부서명</td>
				<td>
					<select name="deptName">
						<option value="" <c:if test="${emp.deptName.equals('')}">selected</c:if>>없음</option>
						<c:forEach var="d" items="${deptList}">
							<option value="${d.deptName}" <c:if test="${emp.deptName.equals(d.deptName)}">selected</c:if>>${d.deptName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td>팀명</td>
				<td>
					<select name="teamName">
						<option value="" <c:if test="${emp.teamName.equals('')}">selected</c:if>>없음</option>
						<c:forEach var="t" items="${teamList}">
							<option value="${t.teamName}" <c:if test="${emp.teamName.equals(t.teamName)}">selected</c:if>>${t.teamName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td>직급</td>
				<td>
					<select name="empPosition">
						<option value="CEO" <c:if test="${emp.empPosition.equals('CEO')}">selected</c:if>>CEO</option>
						<option value="부서장" <c:if test="${emp.empPosition.equals('부서장')}">selected</c:if>>부서장</option>
						<option value="팀장" <c:if test="${emp.empPosition.equals('팀장')}">selected</c:if>>팀장</option>
						<option value="부팀장" <c:if test="${emp.empPosition.equals('부팀장')}">selected</c:if>>부팀장</option>
						<option value="사원" <c:if test="${emp.empPosition.equals('사원')}">selected</c:if>>사원</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>권한</td>
				<td>
					<select name="accessLevel">
						<option value="0" <c:if test="${emp.accessLevel.equals('0')}">selected</c:if>>0레벨</option>
						<option value="1" <c:if test="${emp.accessLevel.equals('1')}">selected</c:if>>1레벨</option>
						<option value="2" <c:if test="${emp.accessLevel.equals('2')}">selected</c:if>>2레벨</option>
						<option value="3" <c:if test="${emp.accessLevel.equals('3')}">selected</c:if>>3레벨</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>재직사항</td>
				<td>
					<select name="empState">
						<option value="재직" <c:if test="${emp.empState.equals('재직')}">selected</c:if>>재직</option>
						<option value="퇴직" <c:if test="${emp.empState.equals('퇴직')}">selected</c:if>>퇴직</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>입사일</td>
				<td>
					<input type="date" name="employDate" value="${emp.employDate}">
				</td>
			</tr>
			<tr>
				<td>등록일</td>
				<td>
					${emp.createdate} <!-- 수정 불가, 단순 출력 -->
				</td>
			</tr>
			<tr>
				<td>수정일</td>
				<td>
					${emp.updatedate} <!-- 수정 불가, 단순 출력 -->
				</td>
			</tr>
		</table>
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
		<button type="submit" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
	</form>
</body>
</html>