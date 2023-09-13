<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>휴가관리</title>
    <meta charset="UTF-8">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
    <!-- 모달을 띄우기 위한 부트스트랩 라이브러리 -->
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
     <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- Tell the browser to be responsive to screen width -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">
	<!-- Favicon icon -->
	<link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon.png">
	<title>approvalDraft</title>
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
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<style>
    /* Global styles */
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }
    
    /* Header styles */
    header {
        text-align: center;
    }
    
    /* Form styles */
    .form-group {
        margin-bottom: 20px;
    }
    
    /* Label styles */
    label {
        font-weight: bold;
    }
    
    /* Input and select styles */
    input[type="text"],
    select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-shadow: none;
        margin-bottom: 10px;
    }
    
    /* Submit button styles */
    button[type="submit"] {
        
        padding: 8px 15px;
        border: none;
        cursor: pointer;
    }
    
    /* Center-align form elements */
    .form-center {
        text-align: center;
    }
    
    .custom-link {
        display: inline-block;
        padding: 10px 20px; /* Adjust the padding to match the button size */
        background-color: #6c757d;
        color: #fff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none; /* Remove underlines from the link */
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
	<!--
        탭 네비게이션

    -->
	<br>
	   <nav class="navbar navbar-expand-lg navbar-light">
	       <div class="collapse navbar-collapse" id="navbarNav">
	           <ul class="nav nav-tabs">
	               <li class="nav-item">
	                   <a class="nav-link" href="${pageContext.request.contextPath}/emp/modifyEmp?empNo=${empNo}">인사정보</a>
	               </li>
	               <li class="nav-item">
	                   <a class="nav-link" href="${pageContext.request.contextPath}/emp/adminMemberOne?empNo=${empNo}">개인정보</a>
	               </li>
	               <li class="nav-item">
	                   <a class="nav-link active" href="${pageContext.request.contextPath}/vacation/vacationHistory?empNo=${empNo}">휴가정보</a>
	               </li>
	           </ul>
	       </div>
	   </nav>
  	<br>
    <h1>휴가 지급/차감</h1>
    
    <form method="post" action="${pageContext.request.contextPath}/vacation/adminAddVacation">
        <input type="hidden" name="empNo" value="${empNo}">
        <div class="form-group">
            <label for="vacationName">휴가 종류:</label>
            <select id="vacationName" name="vacationName" required>
                <option value="연차">연차</option>
                <option value="보상">보상</option>
            </select>
        </div>
        <div class="form-group">
            <label for="vacationPm">휴가 일수(+/-):</label>
            <select id="vacationPm" name="vacationPm" required>
                <option value="P">+</option>
                <option value="M">-</option>
            </select>
        </div>
        <div class="form-group">
            <label for="vacationDays">휴가 일수:</label>
            <input type="text" id="vacationDays" name="vacationDays" required>
        </div>
       <a class="btn btn-secondary custom-link" href="${pageContext.request.contextPath}/vacation/vacationHistory?empNo=${empNo}">취소</a>
        <button class="btn btn-primary" type="submit">저장</button>
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