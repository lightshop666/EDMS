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
	<title>addMember</title>
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
	<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- 다음 카카오 도로명 주소 API 사용 -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
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
		// 함수 선언 시작
		// 도로명 주소 찾기 함수
		function sample6_execDaumPostcode() {
			new daum.Postcode({
				oncomplete: function(data) {
					// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
					// 각 주소의 노출 규칙에 따라 주소를 조합한다.
					// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
					var addr = ''; // 주소 변수
					var extraAddr = ''; // 참고항목 변수
		
					// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
					if (data.userSelectedType == 'R') { // 사용자가 도로명 주소를 선택했을 경우
						addr = data.roadAddress;
					} else { // 사용자가 지번 주소를 선택했을 경우(J)
						addr = data.jibunAddress;
					}
		
					// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
					if (data.userSelectedType == 'R') {
						// 법정동명이 있을 경우 추가한다. (법정리는 제외)
						// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
						if (data.bname != '' && /[동|로|가]$/g.test(data.bname)) {
							extraAddr += data.bname;
						}
						// 건물명이 있고, 공동주택일 경우 추가한다.
						if (data.buildingName != '' && data.apartment == 'Y') {
							extraAddr += (extraAddr != '' ? ', ' + data.buildingName : data.buildingName);
						}
						// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
						if (extraAddr != '') {
							extraAddr = ' (' + extraAddr + ')';
						}
						// 조합된 참고항목을 해당 필드에 넣는다.
						$('#sample6_extraAddress').val(extraAddr);
					} else {
						$('#sample6_extraAddress').val('');
					}
		
					// 우편번호와 주소 정보를 해당 필드에 넣는다.
					$('#sample6_postcode').val(data.zonecode);
					$('#sample6_address').val(addr);
					// 커서를 상세주소 필드로 이동한다.
					$('#sample6_detailAddress').focus();
				}
			}).open();
		}
	
		// 비밀번호 정규식 검사 함수
		function validatePassword() {
			// 정규식 패턴은 양 끝에 슬래시를 포함해야 한다
			let pwPattern = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}:;<>,.?~[\]\-]).{8,}$/;
			let pw1 = $('#pw1').val();
			let successMsg = '사용 가능한 비밀번호입니다.';
			let errorMsg = '최소 8자 이상, 영문 대소문자, 숫자, 특수문자를 포함해주세요.';
			
			if ( pwPattern.test(pw1) ) { // test 메서드는 해당 문자열이 정규식과 패턴이 일치하면 true를 반환
				$('#pwMsg1').text(successMsg).css('color', 'green');
				console.log('비밀번호 정규식 일치');
				return true;
			} else {
				$('#pwMsg1').text(errorMsg).css('color', 'red');
				console.log('비밀번호 정규식 불일치');
				return false;
			}
		}
		
		// 비밀번호 일치불일치 검사 함수
		function checkPasswordMatch() {
			let pw1 = $('#pw1').val();
			let pw2 = $('#pw2').val();
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
		}
		
		// 사원번호 비동기 검사 함수
		let empNoValid = false; // 사원번호 검사 결과 변수 선언
		
		function checkEmpNo() {
			let empNo = $('#empNo').val();
			
			if ( empNo != '' ) { // 사원번호가 입력되어 있을 시
				if ( empNo.length < 11 ) { // Integer 타입의 최대 정수 범위 검사
					// 비동기 검사 실행
					$.ajax({
						url : '/checkEmpNo',
						type : 'post',
						data : {empNo : empNo},
						success : function(response) {
							console.log('사원번호 검사 실행');
							
							// 검사 결과에 따라 분기
							if (response.empInfoCnt == 0 || response.memberInfoCnt != 0) {
								$('#empNoMsg').text(response.resultMsg).css('color', 'red'); // 반환된 메세지를 출력
								console.log('사원번호 검사 결과 -> 가입 불가능');
								empNoValid = false;
							} else {
								$('#empNoMsg').text(response.resultMsg).css('color', 'green'); // 반환된 메세지를 출력
								console.log('사원번호 검사 결과 -> 가입 가능');
								empNoValid = true;
							}
						},
						error : function(error) {
		                	console.error('사원번호 검사 실패 : ' + error);
		                	empNoValid = false;
		                }
					});
				} else { // 사원번호를 11자리 이상 입력할 경우
					$('#empNoMsg').text('사원번호는 7자리입니다.').css('color', 'red');
					empNoValid = false;
				}
			} else { // 사원번호 미입력 시
				$('#empNoMsg').text('사원번호를 입력해주세요.').css('color', 'red');
				empNoValid = false;
			}
		}
		
		// 공백 검사 함수
		function validateInputs() {
			let isValid = true;
			
			// 각 input 입력값 가져오기
			let empNo = $('#empNo').val();
			let pw1 = $('#pw1').val();
			let pw2 = $('#pw2').val();
			let gender = $('input[name="gender"]:checked').val();
			let phoneNumber = $('#phoneNumber').val();
			let email = $('#email').val();
			let postcode = $('sample6_postcode').val();
			let address = $('#sample6_address').val();
			let detailAddress = $('#sample6_detailAddress').val();
		
			// 각 입력값 검사시작
			// 사원번호 비동기 검사는 이미 진행
			if (empNo == '') {
				alert('사원번호를 입력하세요.');
				isValid = false;
				return isValid;
			}
			// 비밀번호 정규식 검사 및 비밀번호 일치여부 검사는 이미 진행
			if (pw1 == '') {
				alert('비밀번호를 입력하세요.');
				isValid = false;
				return isValid;
			}
			if (pw2 == '') {
				alert('비밀번호 확인을 입력하세요.');
				isValid = false;
				return isValid;
			}
			if (gender == undefined) {
				alert('성별을 선택하세요.');
				isValid = false;
				return isValid;
			}
			if (phoneNumber == '') {
				alert('전화번호를 입력하세요.');
				isValid = false;
				return isValid;
			}
			if (email == '') {
				alert('이메일을 입력하세요.');
				isValid = false;
				return isValid;
			}
			if (postcode == '' || address == '' || detailAddress == '') {
				alert('주소를 입력하세요.');
				isValid = false;
				return isValid;
			}
		
			return isValid;
		}

		// 이벤트 스크립트 시작
		$(document).ready(function() {
			// 페이지 로드 시 사원번호 검사를 최초 1번 실행
			checkEmpNo();
			
			// 회원가입 실패시 alert
			let result = '${param.result}'; // 회원가입 실패시 url의 매개값으로 result=fail 전달
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('회원가입 실패');
			    alert('회원가입에 실패했습니다. 다시 시도해주세요.');
			}
			
			// 사원번호 입력 후 커서를 떼면 이벤트 발생
			$('#empNo').blur(function() {
				checkEmpNo(); // 사원번호 비동기 검사 함수 호출
			});

			// 비밀번호 입력 후 커서를 떼면 이벤트 발생
			$('#pw1').blur(function() { 
				validatePassword(); // 정규식 검사 함수 호출
				checkPasswordMatch(); // 일치불일치 검사 함수 호출
			});
			
			// 비밀번호 확인란 입력 후 커서를 떼면 이벤트 발생
			$('#pw2').blur(function() { 
				checkPasswordMatch(); // 일치불일치 검사 함수 호출
			});

			// 회원가입 버튼 클릭 시
			$('#saveBtn').click(function(event) {
		    	// 1) 주소값 가져오기
				let postcode = $('#sample6_postcode').val(); // 우편번호
				let address = $('#sample6_address').val(); // 주소
				let detailAddress = $('#sample6_detailAddress').val(); // 상세주소
				// 한줄의 주소로 합치기
				let fullAddress = postcode + ' ' + address + ' ' + detailAddress;
				console.log('주소 : ' + fullAddress);
				// hidden input에 주소값 저장
				$('#fullAddress').val(fullAddress);
				
				// 2) 유효성 및 공백 검사
				let allFieldsValid = empNoValid && validatePassword() && checkPasswordMatch() && validateInputs();	
		
				if (allFieldsValid) { // 모든 항목이 유효하면
					$('form').submit(); // 폼 제출
				} else if (!empNoValid) { // 사원번호 검사가 false이면
					alert('사원번호를 확인해주세요.');
					event.preventDefault(); // 폼 제출 막기
				} else if ( !validatePassword() || !checkPasswordMatch() ) { // 비밀번호 검사가 false이면
					alert('비밀번호를 확인해주세요.');
					event.preventDefault(); // 폼 제출 막기
				} else { // !validateInputs() // 공백 검사가 false이면
					event.preventDefault(); // 폼 제출 막기
				}
			});

			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('로그인 페이지로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/login'; // 로그인 페이지로 이동
				}
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
			<h1>회원가입</h1>
			<form action="/member/addMember" method="post">
				<table class="table-bordered">
					<tr>
						<td>사원번호</td>
						<td>
							<input type="number" name="empNo" value="${empNo}" id="empNo"> <!-- empNo가 넘어올경우 출력 -->
						</td>
						<td>
							<span id="empNoMsg"></span>
						</td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td>
							<input type="password" name="pw" placeholder="비밀번호를 입력하세요" id="pw1">
						</td>
						<td>
							<span id="pwMsg1">최소 8자 이상, 영문 대소문자, 숫자, 특수문자를 포함해주세요.</span>
						</td>
					</tr>
					<tr>
						<td>비밀번호 확인</td>
						<td>
							<input type="password" name="pw2" placeholder="비밀번호를 한번 더 입력하세요" id="pw2">
						</td>
						<td>
							<span id="pwMsg2"></span>
						</td>
					</tr>
					<tr>
						<td>성별</td>
							<td colspan="2">
							<input type="radio" name="gender" value="M">남
							<input type="radio" name="gender" value="F">여
						</td>
					</tr>
					<tr>
						<td>전화번호</td>
						<td>
							<input type="text" name="phoneNumber" id="phoneNumber" placeholder="ex) 010-1234-5678">
						</td>
					</tr>
					<tr>
						<td>이메일</td>
						<td>
							<input type="email" name="email" id="email" placeholder="ex) example@email.com">
						</td>
						<td>
							<span id="emailMsg"></span>
						</td>
					</tr>
					<tr>
						<td>주소</td>
						<td colspan="2">
							<!-- 도로명 주소 찾기 input -->
							<input type="text" id="sample6_postcode" placeholder="우편번호">
							<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
							<input type="text" id="sample6_address" placeholder="주소"><br>
							<input type="text" id="sample6_detailAddress" placeholder="상세주소">
							<input type="text" id="sample6_extraAddress" placeholder="참고항목">
							<input type="hidden" name="address" id="fullAddress">
						</td>
					</tr>
				</table>
				<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
				<button type="submit" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
			</form>
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