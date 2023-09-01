<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyMemberPw</title>
<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
<script>
	$(document).ready(function() {
		// [비밀번호 수정 모달] 정규식 검사 및 일치/불일치 검사
		// 1. 현재 비밀번호 입력 필드의 blur 이벤트 처리
		$('#currentPassword').on('blur', function() {
			// 현재 비밀번호 입력 값 가져오기
			let pw = $('#currentPassword').val();
			console.log( 'pw : ' + $('#currentPassword').val() );
			let successMsg = '비밀번호가 일치합니다.';
			let errorMsg = '비밀번호가 일치하지 않습니다.';
			
			// AJAX 비동기 요청 실행
		    $.ajax({
		        type: 'POST',
		        url: '/member/existingPwCheck',
		        data: { pw : pw },
		    }).done(function(pwResult) {
		        console.log('existingPwcheck 메서드 실행');
		        // 결과 처리
		        if (pwResult === 'success') {
		            console.log('현재 비밀번호와 일치');
		            $('#exsistingPwMsg').text(successMsg).css('color', 'green');
		        } else if (pwResult === 'fail') {
		            console.log('현재 비밀번호와 불일치');
		            $('#exsistingPwMsg').text(errorMsg).css('color', 'red');
		        }
		    }).fail(function() {
		        // 오류 처리
		        console.log('현재 비밀번호 확인 메서드 : 오류 발생');
		    });
		});
		
		// 2. 새 비밀번호 입력 필드의 blur 이벤트 처리
		$('#newPassword').on('blur', function() {
			// 정규식 패턴은 양 끝에 슬래시를 포함해야 한다
			let pwPattern = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}:;<>,.?~[\]\-]).{8,}$/;
			let newPw = $('#newPassword').val();
			let successMsg = '사용 가능한 비밀번호입니다.';
			let errorMsg = '최소 8자 이상, 영문 대소문자, 숫자, 특수문자를 포함해주세요.';
			
			if ( pwPattern.test(newPw) ) { // test 메서드는 해당 문자열이 정규식과 패턴이 일치하면 true를 반환
				$('#pwMsg1').text(successMsg).css('color', 'green');
				console.log('비밀번호 정규식 일치');
				return true;
			} else {
				$('#pwMsg1').text(errorMsg).css('color', 'red');
				console.log('비밀번호 정규식 불일치');
				return false;
			}
		});
		
		// 3. 새 비밀번호 확인 입력 필드의 blur 이벤트 처리
		$('#confirmNewPassword').on('blur', function() {
			let pw1 = $('#newPassword').val();
			let pw2 = $('#confirmNewPassword').val();
			let successMsg = '비밀번호가 일치합니다.';
			let errorMsg = '비밀번호가 일치하지 않습니다.';
			
			if ( pw1 == pw2 ) { 
				$('#pwMsg2').text(successMsg).css('color', 'green');
				console.log('비밀번호 일치');
				return true;
			} else { 
				$('#pwMsg2').text(errorMsg).css('color', 'red');
				console.log('비밀번호 불일치')
				return false;
			}
		});
		// 4. 비밀번호 수정 파라미터 값에 따른 알림
		$('#saveButton').click(function() {
		    let newPw2 = $('#confirmNewPassword').val();
		
		    // AJAX 비동기 요청 실행
		    $.ajax({
		        type: 'POST',
		        url: '/member/modifyPw',
		        data: { newPw2: newPw2 },
		        success: function(modifyPwResult) {
		            if (modifyPwResult === 'success') {
		                alert('비밀번호 수정 성공');
		             	// 비밀번호 수정 탭으로 이동
		                $('#password-tab').tab('show');
		             	// 입력 필드 내용 지우기
		                $('#currentPassword').val('');
		                $('#newPassword').val('');
		                $('#confirmNewPassword').val('');
		                // 경고 메시지도 초기화
		                $('#exsistingPwMsg').text('');
		                $('#pwMsg1').text('');
		                $('#pwMsg2').text('');
		            } else {
		                alert('비밀번호 수정 실패');
		            }
		        },
		        error: function() {
		            alert('비밀번호 수정 요청 중 오류 발생');
		        }
		    });
		});
	});
</script>
</head>
<body>
	<!--
        탭 네비게이션
         1. 개인정보 수정
         2. 비밀번호 수정
         3. 휴가정보
    -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
       <div class="collapse navbar-collapse" id="navbarNav">
           <ul class="navbar-nav">
               <li class="nav-item">
                   <a class="nav-link active" href="/member/modifyMember?result=success">개인정보 수정</a>
               </li>
               <li class="nav-item">
                   <a class="nav-link" href="/member/modifyMemberPw">비밀번호 수정</a>
               </li>
               <li class="nav-item">
                   <a class="nav-link" href="/member/memberVacationHistory">휴가정보</a>
               </li>
           </ul>
       </div>
   </nav>
   
	<!-- 현재 비밀번호 일치/불일치 검사 -->
	<label>현재 비밀번호:</label>
	<input type="password" id="currentPassword">
	<span id="exsistingPwMsg" class="validation-msg"></span><br>
	<!-- 새 비밀번호 정규식 검사 -->
	<label>새 비밀번호:</label>
	<input type="password" id="newPassword">
	<span id="pwMsg1" class="validation-msg"></span><br>
	<!-- 새 비밀번호 일치/불일치 검사 -->
	<label>새 비밀번호 확인:</label>
	<input type="password" id="confirmNewPassword" name="newPw2">
	<span id="pwMsg2" class="validation-msg"></span><br>
		
	<div id="passwordMatchMessage" class="text-success"></div>
		
	<hr>
		
	<button type="button" class="btn btn-secondary">취소</button>
	<button type="button" class="btn btn-primary" id="saveButton">저장</button>
    
</body>
</html>