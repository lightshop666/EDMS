<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main Menu</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Tell the browser to be responsive to screen width -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- Favicon icon -->
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon.png">
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
<script>

$(document).ready(function() {
	$(".sidebar-link").click(function(event) {
		event.preventDefault(); // 기본 링크 동작 취소
		
		let requiredAccessLevel = $(this).data("access-level");				// 이 링크의 엑세스 제한 레벨 가져오기
		let userAccessLevel = <%= session.getAttribute("accessLevel") %>;	// 세션에서 사용자의 엑세스 레벨 가져오기
		
		if (userAccessLevel < requiredAccessLevel) {
			alert("권한이 없는 사용자입니다."); // 팝업 메시지 띄우기
		} else {
			window.location.href = $(this).attr("href"); // 권한이 있을 경우 해당 링크로 이동
		}
	});
});

</script>
</head>
<body>
<!-- ============================================================== -->
<!-- Left Sidebar - style you can find in sidebar.scss  -->
<!-- ============================================================== -->
	<!-- Sidebar scroll-->
	<div class="scroll-sidebar" data-sidebarbg="skin6">
		<!-- Sidebar navigation-->
		<nav class="sidebar-nav">
			<ul id="sidebarnav">	
				<!-- 
					구분선
				    <li class="list-divider"></li>
				 -->
<!-- 전자결재 -->
				<li class="nav-small-cap">
					<span class="hide-menu">전자결재</span>
				</li>
			
				<li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/draft/basicDraft" aria-expanded="false"  data-access-level="0">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">새 결재</span>
					</a>
			    </li>
			    	<li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/draft/submitDraft " aria-expanded="false" data-access-level="0">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">내 문서함</span>
					</a>
			    </li>	
			    <li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/draft/tempDraft" aria-expanded="false" data-access-level="0">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">임시 저장함</span>
					</a>
			    </li>
			    
<!-- 일정관리 -->	<li class="list-divider"></li>
				<li class="nav-small-cap">
					<span class="hide-menu">일정관리</span>
				</li>
			
				<li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/schedule/schedule" aria-expanded="false" data-access-level="0">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">달력</span>
					</a>
			    </li>
			    	<li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/schedule/scheduleList" aria-expanded="false" data-access-level="1">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">일정관리</span>
					</a>
			    </li>	
			    <li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/utility/utilityList" aria-expanded="false" data-access-level="0">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">예약신청</span>
					</a>
			    </li>
				<li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/reservation/reservationList" aria-expanded="false" data-access-level="0">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">예약조회</span>
					</a>
			    </li>				    
<!-- 인사관리 -->	<li class="list-divider"></li>
				<li class="nav-small-cap">
					<span class="hide-menu">인사관리</span>
				</li>
						
				<li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/emp/empList" aria-expanded="false" data-access-level="1">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">사원목록</span>
					</a>
			    </li>
			    <li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/emp/registEmp" aria-expanded="false" data-access-level="2">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">사원등록</span>
					</a>
			    </li>	
			    <li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/sendEmail" aria-expanded="false" data-access-level="2">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">사원초대</span>
					</a>
			    </li>
<!-- 게시판 -->	<li class="list-divider"></li>
				<li class="nav-small-cap">
					<span class="hide-menu">게시판</span>
				</li>
			
				<li class="sidebar-item"> 
					<a class="sidebar-link" href="${pageContext.request.contextPath}/board/boardList" aria-expanded="false" data-access-level="0">
						<i data-feather="grid" class="feather-icon"></i>
							<span class="hide-menu">공지사항</span>
					</a>
			    </li>   
			</ul>
		</nav>
		<!-- End Sidebar navigation -->
	</div>
<!-- ============================================================== -->
<!-- End Left Sidebar - style you can find in sidebar.scss  -->
<!-- ============================================================== -->


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

</body>
</html>