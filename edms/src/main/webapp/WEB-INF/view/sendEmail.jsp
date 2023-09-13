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
	<title>sendEmail</title>
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
 		// 페이지 로드 완료 후 실행할 함수 정의
        window.onload = function() { 
        	// 'contact-form' 아이디를 가진 요소의 submit 이벤트 리스너 등록
            document.getElementById('contact-form').addEventListener('submit', function(event) {
            	// 기본 submit 동작 막기
                event.preventDefault();
             	// contact_number 필드에 랜덤 값 할당
                this.contact_number.value = Math.random() * 100000 | 0;
             	// 디버깅을 위한 로그 출력. 서버에서 전달받은 serviceId와 emailTemplateId 출력
                console.log('${serviceId}', '${emailTemplateId}');
                // sendForm에 서비스 id, 이메일 템플릿 id, 랜덤으로 생성된 contact_number 필드값 전달 후 성공유무 출력
                // -> https://dashboard.emailjs.com/admin 에서 확인
                emailjs.sendForm('${serviceId}', '${emailTemplateId}', this) 
                    .then(function() {
                        console.log('SUCCESS!');
                        /* 메일 보내기가 성공한 경우 사원 리스트로 이동 */
                        window.location.href = '${pageContext.request.contextPath}/emp/empList';
                    }, function(error) {
                        console.log('FAILED...', error);
                    });
            });
        }
    </script>
	
	<script>
		$(document).ready(function() { // 웹 페이지가 모든 html 요소를 로드한 후에 내부(JQuery)의 코드를 실행하도록 보장
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('HOME 페이지로 이동할까요?');
				if (result) {
					window.location.href = '${pageContext.request.contextPath}/home'; // HOME으로 이동
				}
			});
		});
	</script>
	
	<!-- 입력 태그중 필수 입력사항 미입력시 경고창 출력 -->
	<script>
	$(document).ready(function() {
	    $('#contact-form').submit(function(e) {
	        // 필수입력사항 선택되었는지 확인합니다.
	        var to_email = $('input[name="to_email"]').val();
	        var message = $('#sendMessage').val();

	        if (!to_email || !message) {
	            // 필수 항목이 비어 있다면 경고창을 보여주고, 폼 제출을 중단합니다.
	            alert('필수 입력 항목을 작성해주세요.');
	            e.preventDefault();
	        }
	    });
	});
	</script>
	
	 <style>
	 	/* 제목 가운데 정렬 */
        #addScheduleForm .card-title {
            text-align: center;
        }
        /* 취소, 저장 왼/오른쪽 정렬 */
        #cancelBtn {
		    float: left;
		}
		
		#sendBtn {
		    float: right;
		}
		/* 필수입력표시 오른쪽 정렬 */
		#markRequiredInput {
			float: right;
		}
		/* 구분선 */
		hr {
		    border: solid 3px black;
		    width: 100%;
		    margin: 0; /* auto 가운데 정렬 */
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

				<div class="row">
                    <div class="col-8">
                        <div class="card">
                            <div class="card-body" id="addScheduleForm">
                                <h3 class="card-title center" >사원초대</h3>
                                <h6 class="card-subtitle"></h6>
                                <h6 class="card-title mt-5">
                                		<i class="me-1 font-18 mdi mdi-numeric-1-box-multiple-outline"></i></h6>
                                <div class="table-responsive">
	                                <!-- 이메일 전달 폼 -->
									<form id="contact-form">
										<!-- 필수입력사항 표시 -->
										<div id="markRequiredInput">
											<label class="form-label">* 필수입력표시</label>
										</div>
								        <input type="hidden" name="contact_number">
										<table class="table">
											<tr>
												<td>받는사람</td>
												<td><input class="form-control" type="text" name="to_name"></td>
											</tr>
											<tr>
												<td>보내는사람</td>
												<td><input class="form-control" type="text" name="from_name"></td>
											</tr>
											<tr>
												<td>받는사람 Email *</td>
												<td><input class="form-control" type="email" name="to_email" placeholder="ex) example@email.com"></td>
											</tr>
											<c:if test="${empNo != 0}">	
												<tr>
													<td>사원번호</td>
													<td>${empNo}</td>
												</tr>								
											</c:if>
											<c:if test="${empNo == 0}">
												<tr>
													<td>사원번호 *</td>
													<td>
														<textarea class="form-control" id="sendMessage" name="empNo" cols="50" rows="3"></textarea>
														<small id="textHelp" class="form-text text-muted">회원가입을 할 수 있도록 사원번호를 7자리로 입력해주세요. ex)2000001</small>
													</td>
												</tr>
											</c:if>
								        </table>
								        <button type="button"
                                   			class="btn waves-effect waves-light btn-outline-dark" id="cancelBtn">취소</button>
										<button type="submit" 
											class="btn waves-effect waves-light btn-outline-dark" id="sendBtn">전송</button>
								    </form>
                                </div>
                            </div>
                        </div>
                    </div>
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
