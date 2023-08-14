<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addMember</title>
</head>
<body>
	<form action="/addMember" method="post">
	<table border="1">
		<tr>
			<td colspan="3">
				<h1>사원번호</h1>
			</td>
		</tr>
		<tr>
			<td>사원번호</td>
			<td colspan="2">
				<input type="number" name="empNo">
			</td>
		</tr>
		<tr>
			<td>이름</td>
			<td colspan="2">
				<input type="text" name="empName">
			</td>
		</tr>
		<tr>
			<td>PW</td>
			<td colspan="2">
				<input type="text" name="pw" placeholder="비밀번호를 입력하세요">
			</td>
		</tr>
		<tr>
			<td>PW확인</td>
			<td>
				<input type="text" name="pw2" placeholder="비밀번호를 한번 더 입력하세요">
			</td>
		</tr>
		<tr>
			<td>성별</td>
            <td colspan="2">
                <label><input type="radio" name="gender" value="남">남</label>
                <label><input type="radio" name="gender" value="여">여</label>
            </td>
		</tr>
		<tr>
			<td>e-mail</td>
			<td colspan="2">
				<input type="text" name="email">
			</td>
		</tr>
		<tr>
			<td>address</td>
			<td>
				<input type="text" name="address" placeholder="배송지를 입력하세요">
			</td>
			<td>
				배송지 검색				
			</td>
		</tr>	
	</table>
	<button type="submit">저장</button><!-- 오른쪽 정렬 -->
	</form>
</body>
</html>