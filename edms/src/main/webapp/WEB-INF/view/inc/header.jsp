<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Header</title>
<!-- 템플릿 정보 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Tell the browser to be responsive to screen width -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- Favicon icon -->
    <link rel="icon" type="image/png" sizes="16x16" href="../assets/images/favicon.png">
    <title>Freedash Template - The Ultimate Multipurpose admin template</title>
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
</head>
<body>
<header class="topbar" data-navbarbg="skin6">
	<nav class="navbar top-navbar navbar-expand-lg">
		<div class="navbar-header" data-logobg="skin6">
<!-- This is for the sidebar toggle which is visible on mobile only -->
			<a class="nav-toggler waves-effect waves-light d-block d-lg-none" href="javascript:void(0)"><i class="ti-menu ti-close"></i></a>
<!-- ============================================================== -->
<!-- Logo -->
<!-- ============================================================== -->
			<div class="navbar-brand">
				<a href="index.html">
					<!-- Logo icon -->
					<img src="${pageContext.request.contextPath}/assets/images/freedashDark.svg" alt="" class="img-fluid">
				</a>
			</div>
<!-- ============================================================== -->
<!-- End Logo -->
<!-- ============================================================== -->
<!-- ============================================================== -->
<!-- Toggle which is visible on mobile only -->
<!-- ============================================================== -->
			<a class="topbartoggler d-block d-lg-none waves-effect waves-light" href="javascript:void(0)"
				data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><i
				class="ti-more"></i>
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
                <!-- Notification -->
				<li class="nav-item dropdown">
<!-- 벨(푸시알림) 모양 -->
					<a class="nav-link dropdown-toggle pl-md-3 position-relative" href="javascript:void(0)"
							id="bell" role="button" data-bs-toggle="dropdown" aria-haspopup="true"
							aria-expanded="false">
						<span><i data-feather="bell" class="svg-icon"></i></span>
						<span class="badge text-bg-primary notify-no rounded-circle">5</span>
					</a>
					<div class="dropdown-menu dropdown-menu-left mailbox animated bounceInDown">
						<ul class="list-style-none">
							<li>
								<div class="message-center notifications position-relative">
									<!-- Message -->
								<a href="javascript:void(0)" class="message-item d-flex align-items-center border-bottom px-3 py-2">
									<div class="btn btn-danger rounded-circle btn-circle">
										<i data-feather="airplay" class="text-white"></i>
									</div>
									<div class="w-75 d-inline-block v-middle ps-2">
										<h6 class="message-title mb-0 mt-1">Luanch Admin</h6>
										<span class="font-12 text-nowrap d-block text-muted">Just see the my new admin!</span>
										<span class="font-12 text-nowrap d-block text-muted">9:30 AM</span>
									</div>
								</a>
								<!-- Message -->
								<a href="javascript:void(0)" class="message-item d-flex align-items-center border-bottom px-3 py-2">
									<span class="btn btn-success text-white rounded-circle btn-circle">
										<i data-feather="calendar" class="text-white"></i>
									</span>
									<div class="w-75 d-inline-block v-middle ps-2">
										<h6 class="message-title mb-0 mt-1">Event today</h6>
										<span class="font-12 text-nowrap d-block text-muted text-truncate">Just
											a reminder that you have event</span>
										<span class="font-12 text-nowrap d-block text-muted">9:10 AM</span>
									</div>
								</a>
								</div>
							</li>
							<li>
								<a class="nav-link pt-3 text-center text-dark" href="javascript:void(0);">
									<strong>Check all notifications</strong>
									<i class="fa fa-angle-right"></i>
								</a>
							</li>
						</ul>
					</div>
				</li>
			<!-- End Notification -->           
			
<!-- ============================================================== -->
<!-- 마이페이지-->
<!-- ============================================================== -->
			<li class="nav-item dropdown">
			    <a class="nav-link dropdown-toggle" href="javascript:void(0)" data-bs-toggle="dropdown"
			        aria-haspopup="true" aria-expanded="false">
			        <img src="${pageContext.request.contextPath}/assets/images/users/profile-pic.jpg" alt="user" class="rounded-circle"
			            width="40">
			        <span class="ms-2 d-none d-lg-inline-block">
			        	<span>Hello,</span>
			        	<span class="text-dark">Jason Doe</span>
			        	<i data-feather="chevron-down" class="svg-icon"></i>
			        </span>
			    </a>
			    <div class="dropdown-menu dropdown-menu-end dropdown-menu-right user-dd animated flipInY">
			        <a class="dropdown-item" href="javascript:void(0)"><i data-feather="user"
			                class="svg-icon me-2 ms-1"></i>
			            My Profile</a>
			        <a class="dropdown-item" href="javascript:void(0)"><i data-feather="credit-card"
			                class="svg-icon me-2 ms-1"></i>
			            My Balance</a>
			        <a class="dropdown-item" href="javascript:void(0)"><i data-feather="mail"
			                class="svg-icon me-2 ms-1"></i>
			            Inbox</a>
			        <div class="dropdown-divider"></div>
			        <a class="dropdown-item" href="javascript:void(0)"><i data-feather="settings"
			                class="svg-icon me-2 ms-1"></i>
			            Account Setting</a>
			        <div class="dropdown-divider"></div>
			        <a class="dropdown-item" href="javascript:void(0)"><i data-feather="power"
			                class="svg-icon me-2 ms-1"></i>
			            Logout</a>
			        <div class="dropdown-divider"></div>
			        <div class="pl-4 p-3"><a href="javascript:void(0)" class="btn btn-sm btn-info">View
			                Profile</a></div>
			    </div>
			</li>
                <!-- ============================================================== -->
                <!-- User profile and search -->
                <!-- ============================================================== -->
            </ul>
        </div>
    </nav>
</header>

<div>
<!-- 홈으로 -->
	<h1><a href="${pageContext.request.contextPath}/home">GoodeeFit</a></h1>	
</div>

<div>
<!-- 알림 이미지-->
</div>

<div>
<!-- 마이페이지 -->
	<a href="">${loginMemberId} 님</a>
	<a href="${pageContext.request.contextPath}/chatMessage">랜덤채팅</a>
	<a href="${pageContext.request.contextPath}/logout">로그아웃</a>
</div>


</body>
</html>