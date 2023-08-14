<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>    
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>


	<script>
		// 페이지가 로드될 때 실행
		$(document).ready(function() {
			// 쿠키에 "loginId" 존재할 경우 체크박스를 체크되도록 설정
			const loginId = getCookie('loginId');
			if (loginId) {
				//alert('쿠키가 존재합니다');
				$('#idSaveCheckbox').prop('checked', true);
			}
		});

		// 쿠키 가져오는 함수
		function getCookie(name) {
			// 쿠키 문자열을 가져옵니다.
			const value = '; ' + document.cookie;
			
			// 쿠키 문자열을 이름을 기준으로 분리합니다.
			const parts = value.split('; ' + name + '=');
			
			// 분리한 결과가 쿠키 이름 뒤에 실제 값이 있는 형태인지 확인합니다.
			if (parts.length === 2) {
				// 분리한 결과를 배열로 변환하고, 첫 번째 값(실제 쿠키 값)을 가져옵니다.
				const cookieValue = parts.pop().split(';').shift();				
				// 쿠키 값 반환
				return cookieValue;
			}
		}
    </script>
    
</head>
<body>
	<h1>Login</h1>
	<form action="${pageContext.request.contextPath}/login" method="post">
		<div>
			아이디 : <input type="text" name="memberId" value="${loginId}">
		</div>
		<div>
			비밀번호 : <input type="password" name="memberPw"><br>
			비밀번호 분실시 관리자에게 문의
		</div>
		<div>
			<input type="checkbox" name="idSave" value="y" id="idSaveCheckbox">ID저장
		</div>
		<div>
			<button type="submit">로그인</button>
		</div>
	</form>
</body>
</html>