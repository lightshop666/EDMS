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
	<!--Morris JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/libs/raphael/raphael.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/morris.js/morris.min.js"></script>
    <script src="/homeChartFunction.js"></script>
	<!-- Morris CSS -->
    <link href="${pageContext.request.contextPath}/assets/libs/morris.js/morris.css" rel="stylesheet">
	
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
				<!-- 꺾은선 그래프 -->
		       	<div class="col-lg-6">
		           	<div class="card">
		               	<div class="card-body" style="text-align: center;">
		                   	<h4 id="card-title" class="card-title">최근 1년 품목별 매출현황</h4>
		                       <ul id="chart-legend" class="list-inline text-end"></ul>
		                   	<div id="morris-area-chart"></div>
		               	</div>
		           	</div>
		       	</div>
		       	<!-- 꺾은선 그래프 끝 -->
		       	<!-- 도넛 차트 -->
		       	<div class="col-lg-6">
		           	<div class="card">
		               	<div class="card-body" style="text-align: center;">
		                   	<h4 id="card-title" class="card-title">
		                   		<span id="tagetMonth"></span> 매출현황</h4>
		                       <ul id="chart-legend" class="list-inline text-end"></ul>
		                   	<div id="morris-donut-chart"></div>
		               	</div>
		           	</div>
		       	</div>
		       	<!-- 도넛 차트 끝 -->
		       	<!-- 바 차트 -->
		       	<div class="col-lg-12">
		       		<div class="card">
		               	<div class="card-body" style="text-align: center;">
		                   	<h4 id="card-title" class="card-title">최근 3개월 목표달성률</h4>
		                       <ul id="chart-legend" class="list-inline text-end"></ul>
		                   	<div id="morris-bar-chart"></div>
		               	</div>
		           	</div>
		       	</div>
		       	<!-- 바 차트 끝 -->
		       	<!------------ 봉사정보 ------------->
		       	<div class="col-lg-12">
		       		<script>
						function fetchDetails() {
							$.ajax({
								url: '/vltrDetailsList',
								type: 'GET',
								success: function(data) {
									$('#output').text(JSON.stringify(data, null, 4));
								},
								error: function(error) {
									alert("오류 발생: " + error.statusText);
								}
							});
						}
					</script>
		
					<button onclick="fetchDetails()">봉사정보리스트</button>
		       	</div>
		       	<!------------ 끝 봉사정보 끝 ------------->
		       	<!------------ 중요 공지 목록 시작 ------------->
				<div class="col-lg-12">
					<h4>공지사항</h4>
					<table class="table">
						<tr>
							<th>공지</th>
							<th>제목</th>
							<th>작성자</th>
							<th>등록일</th>
						</tr>
						<!-- 공지가 있을 경우/없을 경우를 분류 -->
						<c:choose>
					        <c:when test="${not empty board}">
					            <c:forEach var="b" items="${board}">
					                <tr>
					                    <td>
					                        <c:choose>
					                            <c:when test="${b.topExposure == 'Y'}">
					                                &#128227;
					                            </c:when>
					                            <c:otherwise>
					                                -
					                            </c:otherwise>
					                        </c:choose>
					                    </td>
					                    <td><a href="/board/boardOne?boardNo=${b.boardNo}">${b.boardTitle}</a></td>
					                    <td>${b.empName}</td>
					                    <td>${b.createdate}</td>
					                </tr>
					            </c:forEach>
					        </c:when>
					        <c:otherwise>
					            <tr>
					                <td colspan="4">공지 내용이 없습니다.</td>
					            </tr>
					        </c:otherwise>
				    	</c:choose>
					</table>
				</div>
				<!------------ 중요 공지 목록 끝 ------------->
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