<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	<title>scheduleDay</title>
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
	
	<!--This page plugins -->
	<!-- 사용하는 리스트에 rowPerPage와 검색조건 및 페이징을 자동으로 수행해줌 -->
    <!-- <script src="../assets/extra-libs/datatables.net/js/jquery.dataTables.min.js" defer></script>
    <script src="../assets/extra-libs/datatables.net-bs4/js/dataTables.responsive.min.js" defer></script>
    <script src="../dist/js/pages/datatable/datatable-basic.init.js" defer></script> -->
    
    <script>
		$(document).ready(function() { // 웹 페이지가 모든 html 요소를 로드한 후에 내부(JQuery)의 코드를 실행하도록 보장
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('달력으로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/schedule/schedule'; // schedule으로 이동
				}
			});
		});
	</script>
    
    <style>
	 	/* 제목 가운데 정렬 */
        #scheduleDayForm .card-title {
            text-align: center;
        }
        /* 취소, 저장 왼/오른쪽 정렬 */
        #cancelBtn {
		    float: left;
		}
		
		#saveBtn {
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

				<!-- fmt:parseDate 태그는 문자열로 된 날짜 날짜(${date})를 java.util.Date 객체로 변환 후 parsedDate라는 이름으로 저장
				fmt:formatDate 태그를 사용하여 이 날짜 객체를 원하는 형식(MMMM d, yyyy)으로 출력 -->
				<div style="text-align: center">
					<h1>
						<fmt:parseDate value="${date}" pattern="yyyy-MM-dd" var="parsedDate"/>
						<fmt:formatDate value="${parsedDate}" pattern="MMMM d, yyyy"/>
					</h1>
				</div>
				
				<br>
				
				<!-- schedule table -->
                <div class="row">
                    <div class="col-12">
                        <div class="card" id="scheduleDayForm">
                            <div class="card-body">
                                <h2 class="card-title center">일별일정</h2>
                                <h6 class="card-subtitle">&nbsp;</h6>
                                <div class="table-responsive">
                                    <table id="zero_config_1" class="table border table-striped table-bordered text-nowrap">
                                        <thead>
                                            <tr>
                                                <th>시작시간</th>
												<th>종료시간</th>
												<th>내용</th>
												<th>생성일</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                           <c:forEach var="s" items="${scheduleByDay}">
												<tr>
													<td>${s.scheduleStartTime}</td>
													<td>${s.scheduleEndTime}</td>
													<td>${s.scheduleContent}</td>
													<td>${s.createdate}</td>
												</tr>
											</c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- reservation table -->
                <div class="row">
                    <div class="col-12">
                        <div class="card" id="scheduleDayForm">
                            <div class="card-body">
                                <h2 class="card-title center">일별예약</h2>
                                <h6 class="card-subtitle">&nbsp;</h6>
                                <div class="table-responsive">
                                    <table id="zero_config_2" class="table border table-striped table-bordered text-nowrap">
                                        <thead>
                                            <tr>
                                                <th>예약번호</th>
												<th>사원번호</th>
												<th>사원명</th>
												<th>공용품번호</th>
												<th>공용품종류</th>
												<th>예약일</th>
												<th>예약시간</th>
												<th>생성일</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                           <c:forEach var="r" items="${reservationByDay}">
												<tr>
													<td>${r.reservationNo}</td>
													<td>${r.empNo}</td>
													<td>${r.empName}</td>
													<td>${r.utilityNo}</td>
													<td>${r.utilityCategory}</td>
													<td>${r.reservationDate}</td>
													<td>${r.reservationTime}</td>
													<td>${r.createdate}</td>
												</tr>
											</c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

				<hr>
				
				<button type="button" class="btn waves-effect waves-light btn-outline-dark" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->

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
