<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- Tell the browser to be responsive to screen width -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">
	<!-- Favicon icon -->
	<link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon.png">
	<title>modifyMemberPw</title>
	<!-- Custom CSS -->
	<link href="${pageContext.request.contextPath}/assets/extra-libs/c3/c3.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/assets/libs/chartist/dist/chartist.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/assets/extra-libs/jvector/jquery-jvectormap-2.0.2.css" rel="stylesheet" />
	<!-- Custom CSS -->
	<link href="${pageContext.request.contextPath}/dist/css/style.min.css" rel="stylesheet">
	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->
	<!-- ============================================================== -->
	<!-- All Jquery -->
	<!-- ============================================================== -->
	<script src="${pageContext.request.contextPath}/assets/libs/jquery/dist/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<!-- apps -->
	<!-- apps -->
	<script src="${pageContext.request.contextPath}/dist/js/app-style-switcher.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/feather.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/sidebarmenu.js"></script>
	<!--Custom JavaScript -->
	<script src="${pageContext.request.contextPath}/dist/js/custom.min.js"></script>
	<!--This page JavaScript -->
	<script src="${pageContext.request.contextPath}/assets/extra-libs/c3/d3.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/extra-libs/c3/c3.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/chartist/dist/chartist.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/chartist-plugin-tooltips/dist/chartist-plugin-tooltip.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/extra-libs/jvector/jquery-jvectormap-2.0.2.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/extra-libs/jvector/jquery-jvectormap-world-mill-en.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/pages/dashboards/dashboard1.min.js"></script>

	<script>
		$(document).ready(function() {
			// 초기에 다음 입력 필드를 비활성화
		    $('#newPassword, #confirmNewPassword').prop('disabled', true);
	
			// 1. 비밀번호 일치/불일치 검사
			$('#currentPassword').on('blur', function() {
				// 현재 비밀번호 입력 값 가져오기
				let pw = $('#currentPassword').val();
				// 디버깅으로 확인
				console.log( 'modifyMember.jsp pw 입력값 : ' + $('#currentPassword').val() );
				
				// 성공/실패 시 보낼 메세지
				let successMsg = '비밀번호가 일치합니다.';
				let errorMsg = '비밀번호가 일치하지 않습니다.';
				
				// AJAX 비동기 요청 실행
			    $.ajax({
			        type: 'POST',
			        url: '/member/existingPwCheck',
			        data: { pw : pw },
			    }).done(function(pwResult) {
			    	console.log('modifyMember.jsp 비밀번호 확인 Ajax 실행');
			        
			        // 결과 처리
			        if (pwResult === 'success') {
			            console.log('현재 비밀번호와 일치');
			            $('#newPassword').prop('disabled', false);
			            $('#exsistingPwMsg').text(successMsg).css('color', 'green');
			        } else if (pwResult === 'fail') {
			            console.log('현재 비밀번호와 불일치');
			            $('#newPassword').prop('disabled', true);
			            $('#exsistingPwMsg').text(errorMsg).css('color', 'red');
			        }
			        
			    }).fail(function() {
			        // 오류 처리
			        console.log('modifyMember.jsp 비밀번호 확인 Ajax 오류 발생');
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
					console.log('비밀번호 정규식 일치');
					$('#confirmNewPassword').prop('disabled', false);
					$('#pwMsg1').text(successMsg).css('color', 'green');
					return true;
				} else {
					console.log('비밀번호 정규식 불일치');
					$('#confirmNewPassword').prop('disabled', true);
					$('#pwMsg1').text(errorMsg).css('color', 'red');
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
				// 수정에 사용할 새 비밀번호 값
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
			                location.reload();
			             	// 입력 필드 내용 지우기
			                $('#currentPassword').val('');
			                $('#newPassword').val('');
			                $('#confirmNewPassword').val('');
			                // 경고 메시지도 초기화
			                $('#exsistingPwMsg').text('');
			                $('#pwMsg1').text('');
			                $('#pwMsg2').text('');
			            } else {
			                alert('비밀번호 수정에 실패했습니다.');
			            }
			        },
			        error: function() {
			            alert('비밀번호 수정 중 오류가 발생했습니다.');
			        }
			    });
			});
			
		});
	</script>
</head>

<body>
<!-- ============================================================== -->
<!-- Preloader - style you can find in spinners.css -->
<!-- ============================================================== -->
<div class="preloader">
    <div class="lds-ripple">
        <div class="lds-pos"></div>
        <div class="lds-pos"></div>
    </div>
</div>
<!-- ============================================================== -->
<!-- Main wrapper - style you can find in pages.scss -->
<!-- ============================================================== -->
<div id="main-wrapper" data-theme="light" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
    data-sidebar-position="fixed" data-header-position="fixed" data-boxed-layout="full">
	<!-- ============================================================== -->
	<!-- Topbar header - style you can find in pages.scss -->
	<!-- ============================================================== -->
	<!-- 헤더 인클루드 -->
	
	<header class="topbar" data-navbarbg="skin6">
		<jsp:include page="/WEB-INF/view/inc/header.jsp" />
	</header>
	<!-- ============================================================== -->
	<!-- End Topbar header -->
	<!-- ============================================================== -->
	<!-- ============================================================== -->
	<!-- Left Sidebar - style you can find in sidebar.scss  -->
	<!-- ============================================================== -->
	
	<!-- 좌측 메인메뉴 인클루드 -->
	
	<aside class="left-sidebar" data-sidebarbg="skin6">
	
		<jsp:include page="/WEB-INF/view/inc/mainmenu.jsp" />
	
	</aside>
	
	<!-- ============================================================== -->
	<!-- End Left Sidebar - style you can find in sidebar.scss  -->
	<!-- ============================================================== -->
        
        
        
        <!-- ============================================================== -->
        <!-- Page wrapper  -->
        <!-- ============================================================== -->
        
        
        
	<div class="page-wrapper">
	<!-- ============================================================== -->
	<!-- Container fluid  -->
	<!-- ============================================================== -->
		<div class="container-fluid">
<!-----------------------------------------------------------------본문 내용 ------------------------------------------------------->    
<!-- 이 안에 각자 페이지 넣으시면 됩니다 -->

	<!--
        탭 네비게이션
         1. 개인정보 수정
         2. 비밀번호 수정
         3. 휴가정보
    -->
    <nav class="navbar navbar-expand-lg navbar-light">
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
	<input type="password" id="newPassword" disabled>
	<span id="pwMsg1" class="validation-msg"></span><br>
	<!-- 새 비밀번호 일치/불일치 검사 -->
	<label>새 비밀번호 확인:</label>
	<input type="password" id="confirmNewPassword" name="newPw2" disabled>
	<span id="pwMsg2" class="validation-msg"></span><br>
		
	<div id="passwordMatchMessage" class="text-success"></div>
		
	<hr>
		
	<button type="button" class="btn btn-secondary">취소</button>
	<button type="button" class="btn btn-primary" id="saveButton">저장</button>
    





<!-----------------------------------------------------------------본문 끝 ------------------------------------------------------->          

		</div>
		<!-- ============================================================== -->
		<!-- End Container fluid  -->
		<!-- ============================================================== -->
            
		<!-- ============================================================== -->
		<!-- footer -->
		<!-- ============================================================== -->
<!-- 푸터 인클루드 -->
		<footer class="footer text-center text-muted">
		
			<jsp:include page="/WEB-INF/view/inc/footer.jsp" />
			
		</footer>
		<!-- ============================================================== -->
		<!-- End footer -->
		<!-- ============================================================== -->
	</div>
<!-- ============================================================== -->
<!-- End Page wrapper  -->
<!-- ============================================================== -->        
</div>
<!-- ============================================================== -->
<!-- End Wrapper -->
<!-- ============================================================== -->
<!-- End Wrapper -->
<!-- ============================================================== -->

</body>

</html>