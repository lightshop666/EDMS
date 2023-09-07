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
	<title>GoodeeFit Home</title>
	<!-- Custom CSS -->
	<link href="${pageContext.request.contextPath}/assets/extra-libs/c3/c3.min.css" rel="stylesheet">
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
	<script src="${pageContext.request.contextPath}/assets/libs/popper.js/dist/umd/popper.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
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
	
	<!-- 웹소켓 -->
	<script src="${pageContext.request.contextPath}/webjars/sockjs-client/sockjs.min.js"></script>
	<script src="${pageContext.request.contextPath}/webjars/stomp-websocket/stomp.min.js"></script>
	<script src="${pageContext.request.contextPath}/WebsocketScripts.js"></script>

<script>
//세션에 담긴 아이디 JS로 저장
var loginMemberId = '<%= request.getSession().getAttribute("loginMemberId") %>';
console.log("JS로 받아온 loginMemberId : " + loginMemberId);
var userName;

$(document).ready(function() {
	// 웹 소켓 연결 함수 호출
	connect();	
	console.log("웹소켓 연결 완료");
	console.log("JS로 받아온 loginMemberId : " + loginMemberId);
	

	// 웹 소켓 연결 상태를 주기적으로 체크
	var intervalId = setInterval(function() {
		
	    if (isConnected) {  // 웹소켓이 연결되었다면
	        clearInterval(intervalId);  // 인터벌을 정지
	        
	        $.ajax({
                type: "GET",
                url: "/userList",
                success: function(data) {
                    console.log("웹소켓 연결 후 userList 아작스 안에 들어옴");
                    let userList = data;
                    console.log('아작스가 받아온 userList: ' + JSON.stringify(userList, null, 2));

                    $('.message-center').empty();  // div를 비움

                    // userList를 반복하여 div에 이름을 추가
                    for (let sessionId in userList) {
                        console.log('아작스에서 for문 안에 들어옴 sessionId : ' + sessionId );

                        if (userList.hasOwnProperty(sessionId)) {
                            console.log('userList.hasOwnProperty(sessionId) 안에 들어옴 : ' + userList.hasOwnProperty(sessionId));
                            let userName = userList[sessionId].name;
                            
                            console.log('아작스 안의 안의 안에서 userName : ' + userName );
                            let userTemplate = 
                                '<a href="javascript:void(0)" class="message-item d-flex align-items-center border-bottom px-3 py-2">' +
                                    '<div class="user-img">'+
                                       '<img src="/assets/images/users/1.jpg" alt="user" class="img-fluid rounded-circle" width="40px">'+
                                        '<span class="profile-status online float-end"></span>'+
                                    '</div>'+
                                    '<div class="w-75 d-inline-block v-middle ps-2">'+
    									'<h6 class="message-title mb-0 mt-1">' + userName+ '</h6>'+                            
                                    '</div>'+
                                '</a>';
                  
                            $('.message-center').append(userTemplate);
                        }
                    }
                },
                error: function(error) {
                    console.error("유저 리스트를 가져오는 데 실패했습니다: ", error);
                }
            });
	        
	    }
	}, 500);  // 500ms 마다 체크

	
	
	
	// 전송 버튼 클릭 시 메시지 전송 함수 호출
	$("#send").click(function() {
	    sendMessage();
	});
	
	// 엔터키 눌렀을 때의 이벤트
	$("#message").keypress(function(e) {
		if (e.keyCode == 13) { // 13은 엔터키의 키코드
			e.preventDefault(); // 엔터키의 기본 동작을 막습니다.
			sendMessage(); // 메시지 전송 함수를 호출합니다.
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
						<li><div class="message-center"></div></li>
					</ul>
				</div>
			</div>
			
			
			
			<!-- 채팅 내용 출력부분 -->
			<div class="col-lg-9  col-xl-10">
				<div class="chat-box scrollable position-relative" style="height: calc(100vh - 111px);">			
					 <ul class="chat-list list-style-none px-3 pt-3"></ul>				    
				</div>
				
				<!-- 타이핑 부분 -->
				<div class="card-body border-top">
					<div class="row">
						<div class="col-9">
							<div class="input-field mt-0 mb-0">
								<input id="message" placeholder="Type and enter" class="form-control border-0" type="text">
							</div>
						</div>
						<div class="col-3">
							<a id="send" class="btn-circle bg-cyan float-end text-white d-flex align-items-center justify-content-center" href="javascript:void(0)">
								<i class="fas fa-paper-plane"></i>
							</a>
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