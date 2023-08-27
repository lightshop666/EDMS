<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addSchedule</title>
</head>
<body>
	<form method="post" action="${pageContext.request.contextPath}/schedule/addSchedule">
		<h1>일정 추가</h1>
		<table>
			<tr>
				<td>시작시간</td>
			    <td>
			    	<input type="datetime-local" id="start" name="scheduleStartTime"> 
			    </td>
			</tr>
			<tr>
				<td>종료시간</td>
				<td><input type="datetime-local" id="end" name="scheduleEndTime"></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea rows="3" cols="50" name="scheduleContent"></textarea></td>
			</tr>
		</table>
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
		<button type="submit" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
	</form>
</body>
</html>