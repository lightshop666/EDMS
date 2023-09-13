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
    <!-- Custom CSS -->
    <link href="../assets/extra-libs/c3/c3.min.css" rel="stylesheet">
    <link href="../assets/libs/chartist/dist/chartist.min.css" rel="stylesheet">
    <link href="../assets/extra-libs/jvector/jquery-jvectormap-2.0.2.css" rel="stylesheet" />
    <!-- Custom CSS -->
    <link href="../dist/css/style.min.css" rel="stylesheet">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->

	<!-- ============================================================== -->
	<!-- All Jquery -->
	<!-- ============================================================== -->
	<script src="../assets/libs/jquery/dist/jquery.min.js"></script>
	<script src="../assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<!-- apps -->
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
	
	<script src="${pageContext.request.contextPath}/webjars/sockjs-client/sockjs.min.js"></script>
	<script src="${pageContext.request.contextPath}/webjars/stomp-websocket/stomp.min.js"></script>
	<script src="${pageContext.request.contextPath}/WebsocketScripts.js"></script>
	
	<!-- 웹소켓 JS -->
	<script src="../WebsocketScripts.js"></script>
	
<script>
//세션에 담긴 아이디 JS로 저장
var loginMemberId = '<%= request.getSession().getAttribute("loginMemberId") %>';
console.log("JS로 받아온 loginMemberId : " + loginMemberId);
var userName;

$(document).ready(function() {
	//웹 소켓 연결 함수 호출
	connect();
	console.log("웹소켓 연결 완료");
	
	//'알림' 영역 클릭시 알림 횟수 초기화 함수 호출
	$("#bell").click(function() {
		resetNotificationCount();
	});
	
});



</script>
	
</head>

<body>        
<!-- ============================================================== -->
<!-- Topbar header - style you can find in pages.scss -->
<!-- ============================================================== -->
<nav class="navbar top-navbar navbar-expand-lg">
	<div class="navbar-header" data-logobg="skin6">
        <!-- This is for the sidebar toggle which is visible on mobile only -->
		<a class="nav-toggler waves-effect waves-light d-block d-lg-none" href="javascript:void(0)">
			<i class="ti-menu ti-close"></i>
		</a>
		
		<!-- ============================================================== -->
		<!-- Logo -->
		<!-- ============================================================== -->
		<div class="navbar-brand">
		    <!-- Logo icon -->
			<a href="../home">
				<img src="../assets/images/logo.png" alt="" class="img-fluid">
			</a>
		</div>
		<!-- ============================================================== -->
		<!-- End Logo -->
		<!-- ============================================================== -->
		
		<!-- ============================================================== -->
		<!-- Toggle which is visible on mobile only -->
		<!-- ============================================================== -->
		<a class="topbartoggler d-block d-lg-none waves-effect waves-light" href="javascript:void(0)" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
			<i class="ti-more"></i>
		</a>
	</div>
		<!-- ============================================================== -->
		<!-- End Logo -->
		<!-- ============================================================== -->
	<div class="navbar-collapse collapse" id="navbarSupportedContent">
	
	    <!-- ============================================================== -->
		<!-- toggle and nav items -->
		<!-- ============================================================== -->
		<ul class="navbar-nav float-left me-auto ms-3 ps-1">
	<!-- 푸시 알림 Notification -->
			<li class="nav-item dropdown">
	<!-- 종 모양 -->
				<a class="nav-link dropdown-toggle pl-md-3 position-relative" href="javascript:void(0)" 
					id="bell" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					<span><i data-feather="bell" class="svg-icon"></i></span>
	<!-- 알림 개수 -->
					<span class="badge text-bg-primary notify-no rounded-circle" id="notifications"></span>
				</a>
				
			</li>
		</ul>	
		<!-- End Notification -->
		
		
		<!-- ============================================================== -->
		<!-- Right side toggle and nav items -->
		<!-- ============================================================== -->
		<ul class="navbar-nav float-end">
	
		<!-- ============================================================== -->
		<!-- User profile and search -->
		<!-- ============================================================== -->
		<li class="nav-item dropdown">
			<a class="nav-link dropdown-toggle" href="javascript:void(0)" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			
				<!-- 이미지가 있는 경우와 없는 경우를 처리 -->
				<c:choose>
				    <c:when test="${not empty image.memberPath and not empty image.memberSaveFileName}">
				        <img src="${image.memberPath}${image.memberSaveFileName}" alt="user" class="rounded-circle" width="40">
				    </c:when>
				    <c:otherwise>
				        <img src="/assets/images/users/1.jpg" alt="user" class="rounded-circle" width="40">
				    </c:otherwise>
				</c:choose>

				
				<span class="ms-2 d-none d-lg-inline-block">
					<span>Hello,</span>
					<span class="text-dark">${loginMemberId}</span> 
					<i data-feather="chevron-down" class="svg-icon"></i>
				</span>
			</a>
			<div class="dropdown-menu dropdown-menu-end dropdown-menu-right user-dd animated flipInY">
				<a class="dropdown-item" href="../member/modifyMember">
					<i data-feather="user" class="svg-icon me-2 ms-1"></i>
					내 프로필
				</a>
				<a class="dropdown-item" href="../chatMessage">
					<i data-feather="mail" class="svg-icon me-2 ms-1"></i>
					채팅
				</a>
				
		<!-- 구분선 -->
				<div class="dropdown-divider"></div>
				
				<a class="dropdown-item" href="../logout"><i data-feather="power" class="svg-icon me-2 ms-1"></i>
					Logout
				</a>
			</div>
		</li>
		<!-- ============================================================== -->
		<!-- User profile and search -->
		<!-- ============================================================== -->
        </ul>
    </div>
</nav>
<!-- ============================================================== -->
<!-- End Topbar header -->
<!-- ============================================================== -->
</body>

</html>