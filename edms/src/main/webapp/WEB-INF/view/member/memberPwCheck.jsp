<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>checkPw</title>
	<!-- jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<script>
        $(document).ready(function() {
        	// 비밀번호 불일치 시 팝업 메세지
            var result = '${param.result}'; // result 파라미터 값을 가져옴
            if (result === 'fail') {
                alert("비밀번호가 일치하지 않습니다.");
            }
        	
        	// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				// 취소 버튼 클릭 시
		        $('#cancelBtn').click(function() {
		            let msg = confirm('Home으로 이동하시겠습니까?'); // 사용자 선택 값에 따라 true or false 반환
		            if (msg) { // 사용자가 확인을 누를 경우 true
		                window.location.href = '/home'; // Home 페이지로 이동
		            }
		        });
			});
        });
    </script>
</head>
<body>
	
	<h1>비밀번호 확인</h1>
    <form action="/member/memberPwCheck" method="post">
        <div class="mb-3">
            <label for="pw" class="form-label">비밀번호를 입력하세요: </label>
            <input type="password" class="form-control" id="pw" name="pw">
        </div>
        <a class="btn btn-secondary" id="cancelBtn" href="/home">취소</a>
        <button type="submit" class="btn btn-primary">확인</button>
    </form>
    
</body>
</html>