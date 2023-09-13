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
	<title>adminMemberOne</title>
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
	<!-- emailjs 라이브러리 로드 -->
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
    <script type="text/javascript">
        (function() {
            // https://dashboard.emailjs.com/admin/account
            // emailjs 초기화. 서버에서 전달받은 publicKey 사용
            emailjs.init('${publicKey}'); 
        })();
    </script>
	<script>
		// 랜덤 비밀번호 생성 규칙을 정할 상수 선언
		const UPPERCASE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; // 영대문자
		const NUMBERS = '0123456789'; // 숫자
		const SPECIAL_CHARS = '!@#%'; // 특수문자
		const ALL_CHARACTERS = UPPERCASE + NUMBERS + SPECIAL_CHARS; // 영대문자, 숫자, 특수문자를 보유한 문자 집합 상수 선언
		const PW_LENGTH = 12; // 생성할 비밀번호의 길이 선언
		
		// 함수 선언 시작
		// 랜덤 비밀번호 생성 함수
		let tempPw = ''; // 임시 비밀번호 변수 선언
		
		function getRandomPw() {
			tempPw = ''; // 임시 비밀번호를 빈 문자열로 초기화
			
			while (tempPw.length < PW_LENGTH) { // 비밀번호 길이만큼 반복
				// ALL_CHARACTERS의 길이 내에서 랜덤한 인덱스 선택
				let index = Math.floor(Math.random() * ALL_CHARACTERS.length);
				// Math.random() -> 0과 1 사이의 무작위한 실수를 반환
				// ALL_CHARACTERS.length 를 곱하면 결과적으로 0이상 ALL_CHARACTERS.length 미만의 랜덤값을 가짐
				// Math.floor() -> 소숫점을 버려 정수화
				tempPw += ALL_CHARACTERS[index];
				// 랜덤한 인덱스 위치의 문자를 임시 비밀번호에 추가
			}
		
			return tempPw;
		}

		// 이벤트 스크립트 시작
		$(document).ready(function() {
			
			// 비밀번호 생성 버튼 클릭시 이벤트 발생
			$('#getPwBtn').click(function() {
				tempPw = getRandomPw(); // 랜덤 비밀번호 생성 함수 호출
				console.log('랜덤 비밀번호 생성 : ' + tempPw);
				$('#tempPw').text(tempPw); // view에 출력
			});
			
			// 모달창의 비밀번호 초기화 버튼 클릭시 이벤트 발생 // 비동기
			$('#updatePwBtn').click(function() {
				if (tempPw == '') { // 비밀번호를 생성하지 않았을시
					alert('비밀번호를 생성해주세요.');
				} else { // 비밀번호를 생성했다면
					let result = confirm('생성한 임시 비밀번호로 초기화할까요?');
					// 사용자 선택 값에 따라 true or false 반환
					
					if (result) { // 확인 선택 시 true 반환
						$.ajax({ // 비밀번호 초기화 비동기 방식으로 실행
							url : '/adminUpdatePw',
							type : 'post',
							data : {tempPw : tempPw,
									empNo : ${member.empNo} },
							success : function(response) {
								if (response == 1) { // row 값이 1로 반환되면 성공
									console.log('비밀번호 초기화 완료');
									$('#updateResult').text('비밀번호 초기화 완료').css('color', 'green');	
								} else {
									console.log('비밀번호 초기화 실패');
									$('#updateResult').text('비밀번호 초기화 실패').css('color', 'red');
								}
							},
							error : function(error) {
								console.error('비밀번호 초기화 실패 : ' + error);
								$('#updateResult').text('비밀번호 초기화 실패').css('color', 'red');
							}
						});
					}
				}
			});
			
			// 임시 비밀번호 이메일 발송
			$('#emailPwBtn').click(function() {
				if (tempPw == '') { // 비밀번호를 생성하지 않았을시
					alert('비밀번호를 생성해주세요.');
				} else { // 비밀번호를 생성했다면
					let result = confirm('생성한 임시 비밀번호를 이메일로 발송할까요?');
					// 사용자 선택 값에 따라 true or false 반환
					
					if (result) { // 확인 선택 시 true 반환
						// 템플릿으로 보낼 param 배열 생성
						let templateParams = {
							temp_pw : tempPw,
							to_email : '${member.email}',
							to_name : '${member.empName}'	
						};
						
						emailjs.send('${serviceId}', '${emailTemplateId2}', templateParams)
							.then(function() {
		                        console.log('SUCCESS!');
		                        $('#emailResult').text('이메일 전송 완료').css('color', 'green');
		                    }, function(error) {
		                        console.log('FAILED...', error);
		                        $('#emailResult').text('이메일 전송 실패').css('color', 'red');
		                    });
					}
				}
			});
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('사원목록으로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/emp/empList'; // empList로 이동
				}
			});
		});
	</script>
	
	<style>
		.hover { /* 모달창이 열리는 것을 직관적으로 알리기 위해 커서 포인터를 추가 */
		  cursor: pointer;
		}
		.hover:hover { /* 호버 시 약간의 그림자와 배경색 변경 효과 추가 */
		  box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
		  background-color: #f5f5f5;
		}
		.card-title {
            text-align: center;
        }
        /* 취소, 저장 왼/오른쪽 정렬 */
        #cancelBtn {
		    float: left;
		}
		
		#pwBtn {
		    float: right;
		}
		/* 탭 선택된 상태가 진하게 */
		.nav-link.active {
		    font-weight: bold;
		    color: white;
		    background-color: #007bff;
		}
		a:link, a:visited { 
			color: black;
			text-decoration: none;
		}
		a:hover { 
			color: blue;
			text-decoration: underline;
		}
	</style>
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
			<br>
			   <nav class="navbar navbar-expand-lg navbar-light">
			       <div class="collapse navbar-collapse" id="navbarNav">
			           <ul class="nav nav-tabs">
			               <li class="nav-item">
			                   <a class="nav-link" href="${pageContext.request.contextPath}/emp/modifyEmp?empNo=${empNo}">인사정보</a>
			               </li>
			               <li class="nav-item">
			                   <a class="nav-link active" href="${pageContext.request.contextPath}/emp/adminMemberOne?empNo=${empNo}">개인정보</a>
			               </li>
			               <li class="nav-item">
			                   <a class="nav-link" href="${pageContext.request.contextPath}/vacation/vacationHistory?empNo=${empNo}">휴가정보</a>
			               </li>
			           </ul>
			       </div>
			   </nav>
		  	<br>
		  	<div class="row">
            	<div class="col-8">
                	<div class="card">
                		<div class="card-body">
                		<h3 class="card-title center">개인정보 조회</h3>
                        <h6 class="card-subtitle"></h6>
                        <h6 class="card-title mt-5"><i
                                        class="me-1 font-18 mdi mdi-numeric-1-box-multiple-outline"></i></h6>
                        <div class="table-responsive">
							<!-- 회원가입 유무에 따라 분기 -->
							<c:if test="${member.empNo != null}">
								<table class="table">
									<tr>
										<td colspan="2" class="text-center">
											<!-- 사진 클릭 시 모달로 이미지 출력 -->
											<img src="${image.memberPath}${image.memberSaveFileName}" width="300" height="300"
												data-bs-toggle="modal" data-bs-target="#imageModal" class="hover">
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
										<td>전화번호</td>
										<td>
											${member.phoneNumber}
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
											<!-- 미리보기 클릭 시 모달로 서명 출력 -->
											<span data-bs-toggle="modal" data-bs-target="#signModal" class="hover">미리보기</span>
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
								<button type="button" id="cancelBtn" class="btn waves-effect waves-light btn-outline-dark">취소</button> <!-- 왼쪽 정렬 -->
								<!-- 비밀번호 초기화 버튼 클릭시 모달창 출력 -->
								<button type="button" data-bs-toggle="modal" data-bs-target="#pwModal" class="btn waves-effect waves-light btn-outline-dark" id="pwBtn">임시 비밀번호 발급</button> <!-- 오른쪽 정렬 -->
				
				<!-- 모달창 시작 -->
				
				<!-- 이미지 모달 -->
				<div class="modal" id="imageModal">
					<div class="modal-dialog">
						<div class="modal-content">
							<!-- 모달 헤더 -->
							<div class="modal-header">
								<h4 class="modal-title">사원 사진</h4>
								<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
							</div>
							<!-- 모달 본문 -->
							<div class="modal-body">
								<img src="${image.memberPath}${image.memberSaveFileName}">
							</div>
							<!-- 모달 푸터 -->
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
							</div>
						</div>
					</div>
				</div>
				<!-- 이미지 모달 끝 -->
				
				<!-- 서명 모달 -->
				<div class="modal" id="signModal">
					<div class="modal-dialog">
						<div class="modal-content">
							<!-- 모달 헤더 -->
							<div class="modal-header">
								<h4 class="modal-title">사원 서명</h4>
								<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
							</div>
							<!-- 모달 본문 -->
							<div class="modal-body">
								<img src="${sign.memberPath}${sign.memberSaveFileName}">
							</div>
							<!-- 모달 푸터 -->
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
							</div>
						</div>
					</div>
				</div>
				<!-- 서명 모달 끝 -->
				
				<!-- 비밀번호 초기화 모달 -->
				<div class="modal" id="pwModal">
					<div class="modal-dialog">
						<div class="modal-content">
							<!-- 모달 헤더 -->
							<div class="modal-header">
								<h4 class="modal-title">임시 비밀번호 발급</h4>
								<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
							</div>
							<!-- 모달 본문 -->
							<div class="modal-body">
								<div>
									랜덤한 임시 비밀번호를 생성하여 초기화합니다.
								</div>
								<div>
									<button type="button" id="getPwBtn" class="btn btn-secondary">비밀번호 생성</button>
									임시 비밀번호 : <span id="tempPw"></span> <!-- 비밀번호 생성시 출력 -->
								</div> <br>
								<div>
									<p style="color:red;">
										비밀번호 초기화 후 다시 되돌릴 수 없습니다. <br>
										생성한 임시 비밀번호를 사용자에게 반드시 전달하세요.
									</p>
									<button type="button" id="updatePwBtn" class="btn btn-secondary">비밀번호 초기화</button>
									<span id="updateResult"></span> <!-- 비밀번호 초기화 결과 출력 -->
								</div> <br>
								<div>
									<p>개인정보에 저장된 이메일로 임시 비밀번호를 발송 할까요?</p>
									<button type="button" id="emailPwBtn" class="btn btn-secondary">이메일 발송</button>
									<span id="emailResult"></span> <!-- 비밀번호 전송 결과 출력 -->
								</div>
							</div>
							<!-- 모달 푸터 -->
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
							</div>
						</div>
					</div>
				</div>
				<!-- 비밀번호 초기화 모달 끝 -->
				
				<!-- 모달창 끝 -->
			</c:if>
			<!-- 회원가입 유무에 따라 분기 -->
			<c:if test="${member.empNo == null}">
				<h4>아직 회원가입하지 않은 사원입니다</h4>
			</c:if>
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