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
	<link rel="icon" type="image/png" sizes="16x16" href="../assets/images/favicon.png">
	<title>GoodeeFit Home</title>
	<!-- Custom CSS -->
	<link href="../assets/extra-libs/c3/c3.min.css" rel="stylesheet">
	<link href="../assets/libs/chartist/dist/chartist.min.css" rel="stylesheet">
	<link href="../assets/extra-libs/jvector/jquery-jvectormap-2.0.2.css" rel="stylesheet" />
	<!-- Custom CSS -->
	<link href="../dist/css/style.min.css" rel="stylesheet">
	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->
	<!-- ============================================================== -->
	<!-- All Jquery -->
	<!-- ============================================================== -->
	<script src="../assets/libs/jquery/dist/jquery.min.js"></script>
	<script src="../assets/libs/popper.js/dist/umd/popper.min.js"></script>
	<script src="../assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<!-- apps -->
	<script src="../dist/js/app-style-switcher.js"></script>
	<script src="../dist/js/feather.min.js"></script>
	<script src="../assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
	<script src="../dist/js/sidebarmenu.js"></script>
	<!--Custom JavaScript -->
	<script src="../dist/js/custom.min.js"></script>
	<!--This page JavaScript -->
	<script src="../assets/extra-libs/c3/d3.min.js"></script>
	<script src="../assets/extra-libs/c3/c3.min.js"></script>
	<script src="../assets/libs/chartist/dist/chartist.min.js"></script>
	<script src="../assets/libs/chartist-plugin-tooltips/dist/chartist-plugin-tooltip.min.js"></script>
	<script src="../assets/extra-libs/jvector/jquery-jvectormap-2.0.2.min.js"></script>
	<script src="../assets/extra-libs/jvector/jquery-jvectormap-world-mill-en.js"></script>
	<script src="../dist/js/pages/dashboards/dashboard1.min.js"></script>
	<script>
	    $(function () {
	        $(document).on('keypress', "#textarea1", function (e) {
	            if (e.keyCode == 13) {
	                var id = $(this).attr("data-user-id");
	                var msg = $(this).val();
	                msg = msg_sent(msg);
	                $("#someDiv").append(msg);
	                $(this).val("");
	                $(this).focus();
	            }
	        });
	    });
	</script>

	
	<!-- 웹소켓 -->
	<script src="/webjars/jquery/jquery.min.js"></script>
	<script src="/webjars/sockjs-client/sockjs.min.js"></script>
	<script src="/webjars/stomp-websocket/stomp.min.js"></script>
	<script src="/WebsocketScripts.js"></script>
	<script>
$(document).ready(function() {
	//웹 소켓 연결 함수 호출
	connect();
	console.log("웹소켓 연결 완료");
	
	//전송 버튼 클릭 시 메시지 전송 함수 호출
	$("#send").click(function() {
		sendMessage();
	});
	
	//'프라이빗 전송' 클릭 시 개인 메시지 전송 함수
	$("#sendPrivate").click(function() {
		sendPrivateMessage();
	});
	
	//'알림' 영역 클릭시 알림 횟수 초기화 함수 호출
	$("#notifications").click(function() {
		resetNotificationCount();
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
 <div class="page-breadcrumb">
    <div class="row">
        <div class="col-7 align-self-center">
            <h4 class="page-title text-truncate text-dark font-weight-medium mb-1">Chat</h4>
        </div>
    </div>
</div>
	
	
		<div class="container-fluid">
<!-----------------------------------------------------------------본문 내용 ------------------------------------------------------->    
<!-- 이 안에 각자 페이지 넣으시면 됩니다 -->
<div class="row">
<div class="col-md-12">
	<div class="card">
		<div class="row g-0">
			<div class="col-lg-3 col-xl-2 border-end">			
			<!-- 좌측 접속 인원 -->		
				<div class="scrollable position-relative" style="height: calc(100vh - 111px);">
					<ul class="mailbox list-style-none">
						<li>
							<div class="message-center">
								<!-- 좌측 접속인원 -->
								<a href="javascript:void(0)" class="message-item d-flex align-items-center border-bottom px-3 py-2">
								<!-- 유저이미지 -->
									<div class="user-img">
										<img src="../assets/images/users/1.jpg" alt="user" class="img-fluid rounded-circle" width="40px"> 
										<span class="profile-status online float-end"></span>
									</div>
								<!-- 유저네임 -->
									<div class="w-75 d-inline-block v-middle ps-2">
									    <h6 class="message-title mb-0 mt-1">${loginMemberId}</h6>
									</div>
								</a>
								
								
																
							</div>
						</li>
					</ul>
				</div>
			</div>
			
			
			
			
                <div class="col-lg-9  col-xl-10">
                    <div class="chat-box scrollable position-relative"
                        style="height: calc(100vh - 111px);">
                        <!--chat Row -->
                        <ul class="chat-list list-style-none px-3 pt-3">
                            <!--chat Row -->
                            <li class="chat-item list-style-none mt-3">
                                <div class="chat-img d-inline-block"><img
                                        src="../assets/images/users/1.jpg" alt="user"
                                        class="rounded-circle" width="45">
                                </div>
                                <div class="chat-content d-inline-block ps-3">
                                    <h6 class="font-weight-medium">James Anderson</h6>
                                    <div class="msg p-2 d-inline-block mb-1">Lorem
                                        Ipsum is simply
                                        dummy text of the
                                        printing &amp; type setting industry.</div>
                                </div>
                                <div class="chat-time d-block font-10 mt-1 mr-0 mb-3">10:56 am
                                </div>
                            </li>
                            <!--chat Row -->
                            <li class="chat-item list-style-none mt-3">
                                <div class="chat-img d-inline-block"><img
                                        src="../assets/images/users/2.jpg" alt="user"
                                        class="rounded-circle" width="45">
                                </div>
                                <div class="chat-content d-inline-block ps-3">
                                    <h6 class="font-weight-medium">Bianca Doe</h6>
                                    <div class="msg p-2 d-inline-block mb-1">It’s
                                        Great opportunity to
                                        work.</div>
                                </div>
                                <div class="chat-time d-block font-10 mt-1 mr-0 mb-3">10:57 am
                                </div>
                            </li>
                            <!--chat Row -->
                            <li class="chat-item odd list-style-none mt-3">
                                <div class="chat-content text-end d-inline-block ps-3">
                                    <div class="box msg p-2 d-inline-block mb-1">I
                                        would love to
                                        join the team.</div>
                                    <br>
                                </div>
                            </li>
                            <!--chat Row -->
                            <li class="chat-item odd list-style-none mt-3">
                                <div class="chat-content text-end d-inline-block ps-3">
                                    <div class="box msg p-2 d-inline-block mb-1 box">
                                        Whats budget
                                        of the new project.</div>
                                    <br>
                                </div>
                                <div class="chat-time text-end d-block font-10 mt-1 mr-0 mb-3">
                                    10:59 am</div>
                            </li>
                            <!--chat Row -->
                            <li class="chat-item list-style-none mt-3">
                                <div class="chat-img d-inline-block"><img
                                        src="../assets/images/users/3.jpg" alt="user"
                                        class="rounded-circle" width="45">
                                </div>
                                <div class="chat-content d-inline-block ps-3">
                                    <h6 class="font-weight-medium">Angelina Rhodes</h6>
                                    <div class="msg p-2 d-inline-block mb-1">Well we
                                        have good budget
                                        for the project
                                    </div>
                                </div>
                                <div class="chat-time d-block font-10 mt-1 mr-0 mb-3">11:00 am
                                </div>
                            </li>
                            <!--chat Row -->
                            <li class="chat-item odd list-style-none mt-3">
                                <div class="chat-content text-end d-inline-block ps-3">
                                    <div class="box msg p-2 d-inline-block mb-1">I
                                        would love to
                                        join the team.</div>
                                    <br>
                                </div>
                            </li>
                            <!--chat Row -->
                            <li class="chat-item odd list-style-none mt-3">
                                <div class="chat-content text-end d-inline-block ps-3">
                                    <div class="box msg p-2 d-inline-block mb-1 box">
                                        Whats budget
                                        of the new project.</div>
                                    <br>
                                </div>
                                <div class="chat-time text-end d-block font-10 mt-1 mr-0 mb-3">
                                    10:59 am</div>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body border-top">
                        <div class="row">
                            <div class="col-9">
                                <div class="input-field mt-0 mb-0">
                                    <input id="textarea1" placeholder="Type and enter"
                                        class="form-control border-0" type="text">
                                </div>
                            </div>
                            <div class="col-3">
                                <a class="btn-circle bg-cyan float-end text-white d-flex align-items-center justify-content-center"
                                    href="javascript:void(0)"><i class="fas fa-paper-plane"></i></a>
                            </div>
                        </div>
                    </div>
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