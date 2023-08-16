<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="/emp/modifyEmp" method="post">
		<table>
			<tr>
				<td>사원번호</td>
				<td>
					${empNo} <!-- 수정 불가, 단순 출력 -->
				</td>
			</tr>
			<tr>
				<td>사원명</td>
				<td>
					<input type="text" name="empName" value="${empName}">
				</td>
			</tr>
			<tr>
				<td>부서명</td>
				<td>
					<select>
						<option>예정</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>팀명</td>
				<td>
					<select>
						<option>예정</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>직급</td>
				<td>
					<select>
						<option>예정</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>권한</td>
				<td>
					<select>
						<option>예정</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>재직사항</td>
				<td>
					<select>
						<option>예정</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>입사일</td>
				<td>
					<input type="date" name="employDate" value="${employDate}">
				</td>
			</tr>
			<tr>
				<td>등록일</td>
				<td>
					${createdate} <!-- 수정 불가, 단순 출력 -->
				</td>
			</tr>
			<tr>
				<td>수정일</td>
				<td>
					${updatedate} <!-- 수정 불가, 단순 출력 -->
				</td>
			</tr>
		</table>
	</form>
</body>
</html>