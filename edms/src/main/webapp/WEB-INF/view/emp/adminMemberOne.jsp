<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminMemberOne</title>
<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<script>
		// 이벤트 스크립트 시작
		$(document).ready(function() {
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('메인 페이지로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/home'; // home으로 이동
				}
			});
		});
	</script>
</head>
<body>
	<h1>개인정보 조회 - 관리자</h1>
	<table border="1">
		<tr>
			<td>사진</td>
			<td>
				${image.memberFileName}
			</td>
		</tr>
		<tr>
			<td>사원명</td>
			<td>
				${member.empName}
			</td>
		</tr>
		<tr>
			<td>성별</td>
			<td>
				${member.gender}
			</td>
		</tr>
		<tr>
			<td>이메일</td>
			<td>
				${member.email}
			</td>
		</tr>
		<tr>
			<td>주소</td>
			<td>
				${member.address}
			</td>
		</tr>
		<tr>
			<td>저장된 서명</td>
			<td>
				${sign.memberFileName}
			</td>
		</tr>
		<tr>
			<td>가입일</td>
			<td>
				${member.createdate}
			</td>
		</tr>
		<tr>
			<td>수정일</td>
			<td>
				${member.updatedate}
			</td>
		</tr>
	</table>
	<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
	<button type="submit" id="resetBtn">비밀번호 초기화</button> <!-- 오른쪽 정렬 -->
</body>
</html>