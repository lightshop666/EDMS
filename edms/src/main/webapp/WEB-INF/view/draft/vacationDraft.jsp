<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>vacationDraft</title>
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 추가 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
	
	<script>
		// 예정..
	</script>
</head>
<body>
	<h1>휴가신청서 작성 폼</h1>
	<form action="" method="post"> <!-- url 수정 예정 -->
		<table>
			<tr>
				<td>휴가신청서</td>
			</tr>
			<tr>
				<td>휴가신청서</td>
				<td>결재</td>
				<td>기안자</td>
				<td>중간승인자</td>
				<td>최종승인자</td>
			</tr>
			<tr>
				<td>서명이미지 출력</td>
				<td>모달에서 선택된 중간승인자</td>
				<td>모달에서 선택된 최종승인자</td>
			</tr>
			<tr>
				<td>중간승인자 검색버튼</td>
				<td>최종승인자 검색버튼</td>
			</tr>
			<tr>
				<td>수신참조자</td>
				<td>수신참조자 검색 버튼</td>
				<td>모달에서 선택된 수신참조자 목록</td>
			</tr>
			<tr>
				<td>성명</td>
				<td>${empName}</td>
				<td>부서</td>
				<td>${deptName}</td>
				<td>휴가종류</td>
				<td>
					<input type="radio" name="vacationName" value="반차">반차
					<input type="radio" name="vacationName" value="연차">연차
					<input type="radio" name="vacationName" value="보상">보상
				</td>
			</tr>
			<tr>
				<td>남은 휴가 일수</td> <!-- 연차일수 또는 보상휴가일수 -->
				<td>휴가종류 선택에 따라 동적으로 출력 예정</td>
			</tr>
			<tr>
				<td>기간</td>
				<td>
					<input type="date" name="vacationStart"> ~ <input type="date" name="vacationEnd">
				</td>
			</tr>
			<tr>
				<td>비상연락망</td>
				<td>
					<input type="text" name="phoneNumber">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="docTitle">
				</td>
			</tr>
			<tr>
				<td>사유</td>
				<td>
					<textarea rows="4" cols="50" name="docContent"></textarea>
				</td>
			</tr>
			<tr>
				<td>
					위와 같이 휴가를 신청하오니, 결재 바랍니다. <br>
					${year}년 ${month}월 ${day}일
				</td>
			</tr>
		</table>
		<button type="button" id="cancelBtn">취소</button>
		<button type="submit" id="tempSaveBtn">임시저장</button>
		<button type="submit" id="saveBtn">저장</button>
	</form>
</body>
</html>