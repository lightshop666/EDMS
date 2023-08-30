<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>tempDraft</title>
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	
	<script>
	$(document).ready(function() {
		
		// 기안 성공시 alert
		let result = '${param.result}'; // 기안 성공유무를 url의 매개값으로 전달
		if (result == 'success') { // result의 값이 success이면
			console.log('임시저장 성공');
		    alert('임시저장 되었습니다.');
		}
	});
	</script>
</head>
<body>
	<h1>임시저장함</h1>
</body>
</html>