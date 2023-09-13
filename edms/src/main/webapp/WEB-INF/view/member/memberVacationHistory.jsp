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
	<title>memberVacationHistory</title>
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
	<style>
		.table{
			text-align:center;
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

	<!--
        탭 네비게이션
         1. 개인정보 수정
         2. 비밀번호 수정
         3. 휴가정보
    -->
    <div class="d-flex justify-content-between">
		<ul class="nav nav-tabs">
		    <li class="nav-item">
		        <a class="nav-link" href="/member/modifyMember?result=success">개인정보 수정</a>
		    </li>
			<li class="nav-item">
				<a class="nav-link" href="/member/modifyMemberPw">비밀번호 수정</a>
			</li>
			<li class="nav-item">
				<a class="nav-link active" href="/member/memberVacationHistory">휴가정보</a>
			</li>
		</ul>
	</div>
	
	<br>
	<br>
	
    <h1 style="text-align:center;">휴가정보</h1>
    
	<br>
	<br>
	
	<!-- 휴가 정보 카드 조회 -->
	<div class="row">
	    <div class="col-md-4">
			<div class="card-group text-center">
				<div class="card">
					<div class="card-body">
						<h2 class="card-title">지급연차</h2>
						<h2 class="card-title">${vacationByPeriod}일</h2>
					</div>
				</div>
			</div>
		</div>	
		<div class="col-md-4">
			<div class="card-group text-center">
				<div class="card">
					<div class="card-body">
						<h2 class="card-title">남은연차</h2>
						<h2 class="card-title">${remainDays}일</h2>
					</div>
				</div>
			</div>
		</div>
		<div class="col-md-4">
			<div class="card-group text-center">
				<div class="card">
					<div class="card-body">
						<h2 class="card-title">남은보상휴가</h2>
						<h2 class="card-title">${remainRewardDays}일</h2>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="search-area">
	    <form method="GET" action="/member/memberVacationHistory">
			<div class="form-group" style="display: flex;">
		        <label class="date-label" style="padding-top: 5px; width: 50px;">기간</label>
	 		
	 		
	           	<input type="date" name="startDate" value="${param.startDate}" class="form-control" style="width: 200px; margin-left: 20px; margin-right: 20px;">
	           ~
	           	<input type="date" name="endDate" value="${param.endDate}" class="form-control" style="width: 200px; margin-left: 20px; margin-right: 20px;">
	       		<button type="submit" class="btn waves-effect waves-light btn-outline-dark" style="margin-left: 50px;">검색</button>
	       	</div>
		</form>
	</div>
	<br>
	<br>
   	<div class="text-center">
        <a href="/member/memberVacationHistory?vacationName=연차"><button type="button" class="btn btn-primary">연차</button></a>
        <a href="/member/memberVacationHistory?vacationName=보상"><button type="button" class="btn btn-primary">보상</button></a>
    </div>
    <br>
    <table class="table">
        <thead class="table-active">
            <tr>
                <th>휴가종류</th>
                <th>휴가일수(+/-)</th>
                <th>휴가일수</th>
                <th>발생일</th>
            </tr>
        </thead>
        <tbody>
	        <c:choose>
		        <c:when test="${empty vacationHistoryList}">
		        	<tr>
		            	<td colspan="5" style="text-align:center;">휴가정보가 없습니다.</td>
		            </tr>
	            </c:when>
	        </c:choose>    
            <c:forEach var="history" items="${vacationHistoryList}">
				<tr>
				    <td>${history.vacationName}</td>
				    <td>${history.vacationPm}</td>
				    <td>${history.vacationDays}</td>
				    <td>${history.createdate}</td>
				</tr>
            </c:forEach>
        </tbody>
    </table>
     
    <nav class="pagination justify-content-center">
        <ul class="pagination">
            <c:forEach var="page" begin="${minPage}" end="${maxPage}">
                <li class="page-item ${currentPage eq page ? 'active' : ''}">
                    <a class="page-link" href="/member/memberVacationHistory?currentPage=${page}&startDate=${startDate}&endDate=${endDate}&vacationName=${vacationName}&col=${col}&ascDesc=${ascDesc}">
                        ${page}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </nav>





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