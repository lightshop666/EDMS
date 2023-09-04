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
    <title>GoodeeFit Login</title>
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/dist/css/style.min.css" rel="stylesheet">
    
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
<div class="main-wrapper">
<!-- ============================================================== -->
<!-- Login box.scss -->
<!-- ============================================================== -->
<div class="auth-wrapper d-flex no-block justify-content-center align-items-center position-relative" 
	style="background:url(${pageContext.request.contextPath}/assets/images/big/auth-bg.jpg) no-repeat center center;">
<div class="auth-box row">
	<div class="col-lg-7 col-md-5 modal-bg-img" style="background-image: url(${pageContext.request.contextPath}/assets/images/big/mainLogin-1.jpg);"> </div>
	<div class="col-lg-5 col-md-7 bg-white">
		<div class="p-3">
			<div class="text-center">
				<img src="${pageContext.request.contextPath}/assets/images/big/icon.png" alt="wrapkit">
			</div>
			<h2 class="mt-3 text-center">Sign In</h2>
			<p class="text-center">GoodeeFit 전자결재 시스템</p>
				<form class="mt-4" action="${pageContext.request.contextPath}/login" method="post">
					<div class="row">
						<div class="col-lg-12">
						<div class="form-group mb-3">
						    <label class="form-label text-dark" for="uname">사원번호</label>
						    <input class="form-control" name="memberId" value="${loginId}" type="text"
								placeholder="enter your username">
						</div>
						</div>
						<div class="col-lg-12">
						    <div class="form-group mb-3">
						        <label class="form-label text-dark" for="pwd">비밀번호</label>
						        <input class="form-control" id="pwd" name="memberPw" type="password"
									placeholder="enter your password">
						    </div>
						</div>
						<div class="col-lg-12 text-center">
							<div align="left">
								<input type="checkbox" name="idSave" value="y" id="idSaveCheckbox">ID저장
								<br>비밀번호 분실시 관리자에게 문의			
							</div>
						    <button type="submit" class="btn w-100 btn-dark">로그인</button>
						</div>
					</div>
				</form>
			</div>
<!-- ============================================================== -->
<!-- Login box.scss -->
<!-- ============================================================== -->
	</div>


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