<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jstl 사용 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
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
    <title>schedule</title>
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/libs/fullcalendar/dist/fullcalendar.min.css" rel="stylesheet" />
    
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

	
	<!-- 'defer' 속성이 추가된 스크립트 태그들입니다. -->
	<!-- 'defer'는 브라우저가 HTML 문서를 파싱하면서 동시에 스크립트를 비동기적으로 로드하도록 지시합니다. -->
	<!-- 이로 인해 페이지 렌더링이 차단되지 않고, 사용자에게 페이지 내용이 빠르게 표시됩니다. -->
	<!-- 그리고 모든 HTML 문서 파싱이 완료되고 DOM이 완전히 구성된 직후에, 로드된 스크립트가 실행됩니다. -->
	<!-- 따라서 이 스크립트들은 DOM 요소를 조작하는 코드를 포함하더라도 안전하게 실행할 수 있습니다. -->
	
	<!-- 기본 스크립트 외에 추가로 필요한 스크립트의 경우 defer 속성을 줘서 스크립트 파일의 충돌을 피한다. -->
	<!-- ============================================================== -->
    <!-- All Jquery -->
    <!-- ============================================================== -->
    <script src="${pageContext.request.contextPath}/assets/libs/jquery/dist/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/extra-libs/taskboard/js/jquery.ui.touch-punch-improved.js" defer></script>
    <script src="${pageContext.request.contextPath}/assets/extra-libs/taskboard/js/jquery-ui.min.js" defer></script>
    <script src="${pageContext.request.contextPath}/assets/libs/popper.js/dist/umd/popper.min.js" defer></script>
	
	<!-- apps -->
    <script src="${pageContext.request.contextPath}/dist/js/app-style-switcher.js"></script>
    <script src="${pageContext.request.contextPath}/dist/js/feather.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/dist/js/sidebarmenu.js"></script>
    <!--Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/dist/js/custom.min.js"></script>
    <!--This page JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/libs/moment/min/moment.min.js" defer></script>
    <script src="${pageContext.request.contextPath}/assets/libs/fullcalendar/dist/fullcalendar.min.js" defer></script>
    <!-- 사용자가 fullcalendar api를 설정하는 js 파일  -->
    <script src="${pageContext.request.contextPath}/dist/js/pages/calendar/cal-init.js" defer></script>
    <script src="${pageContext.request.contextPath}/assets/extra-libs/c3/d3.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/extra-libs/c3/c3.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/chartist/dist/chartist.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/chartist-plugin-tooltips/dist/chartist-plugin-tooltip.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/extra-libs/jvector/jquery-jvectormap-2.0.2.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/extra-libs/jvector/jquery-jvectormap-world-mill-en.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/pages/dashboards/dashboard1.min.js"></script>
	
	<!-- ScheduleController로부터 JSON 데이터를 전달받는다. -->
	<script>
	 	var scheduleEvents = ${scheduleEvents};
	    var reservationEvents = ${reservationEvents};
	</script>
	
	 <!-- Jquery 라이브러리가 추가된 후에 Jquery를 사용한다. -->
    <script>
		$(document).ready(function() { // 웹 페이지가 모든 html 요소를 로드한 후에 내부(JQuery)의 코드를 실행하도록 보장
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('HOME으로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '${pageContext.request.contextPath}/home'; // Home으로 이동
				}
			});
		});
	</script>
	
	<style>
	#cancelBtn {
	    float: left;  // 왼쪽 정렬
	}
	
	#addScheduleLink {
	    float: right;  // 오른쪽 정렬
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
    <div id="main-wrapper" data-theme="light" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full" data-sidebar-position="fixed" data-header-position="fixed" data-boxed-layout="full">
        <!-- ============================================================== -->
        <!-- Topbar header - style you can find in pages.scss -->
        <!-- ============================================================== -->
        
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
            <!-- Bread crumb and right sidebar toggle -->
            <!-- ============================================================== -->
            <div class="page-breadcrumb">
                <div class="row">
                    <div class="col-7 align-self-center">
                    
                    	<!-- 탭 형식으로 전체or일정or예약 리스트 조회 -->
						<ul class="nav nav-tabs" id="myTab" role="tablist">
						    <li class="nav-item" role="presentation">
						    <c:choose>
					            <c:when test="${empty param.tabCategory}">
					                <!-- tabCategory 파라미터가 없거나 빈 문자열일 때 탭 선택상태 -->
					                <a class="nav-link active category-tab" id="all-tab" data-category="" href="${pageContext.request.contextPath}/schedule/schedule?tabCategory=">전체</a>
					            </c:when>
					            <c:otherwise>
					                <!-- tabCategory 파라미터가 있을 때 탭 미선택상태 -->
					                <a class="nav-link category-tab" id='all-tab' data-category="" href="${pageContext.request.contextPath}/schedule/schedule?tabCategory=">전체</a>
					            </c:otherwise>
					        </c:choose>
						    </li>
						    <li class="nav-item" role="presentation">
						    <c:choose>
					            <c:when test="${param.tabCategory == '일정'}">
					                <!-- tabCategory 파라미터가 '회의실'일 때 탭 선택상태-->
					                <a class="nav-link active category-tab" id='schedule-tab' data-category='일정' href="${pageContext.request.contextPath}/schedule/schedule?tabCategory=일정">일정</a>
					            </c:when>
					            <c:otherwise>
					                <!-- utilityCategory 파라미터가 '회의실'이 아닐 때 탭 미선택상태-->
					                <a class="nav-link category-tab" id='schedule-tab' data-category='일정' href="${pageContext.request.contextPath}/schedule/schedule?tabCategory=일정">일정</a> 
					            </c:otherwise>   
					        </c:choose> 
						    </li>
						    <li class="nav-item" role="presentation">
						    <c:choose>
					            <c:when test="${param.tabCategory == '예약'}">
					                <!-- utilityCategory 파라미터가 '회의실'일 때 탭 선택상태-->
					                <a class="nav-link active category-tab" id='reservation-tab' data-category='예약' href="${pageContext.request.contextPath}/schedule/schedule?tabCategory=예약">예약</a>
					            </c:when>
					            <c:otherwise>
					                <!-- utilityCategory 파라미터가 '회의실'이 아닐 때 탭 미선택상태-->
					                <a class="nav-link category-tab" id='reservation-tab' data-category='예약' href="${pageContext.request.contextPath}/schedule/schedule?tabCategory=예약">예약</a> 
					            </c:otherwise>   
					        </c:choose> 
						    </li>
						</ul>
						
                        <h4 class="page-title text-truncate text-dark font-weight-medium mb-1"></h4>
                        <div class="d-flex align-items-center">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb m-0 p-0">
                                    <!-- <li class="breadcrumb-item text-muted active" aria-current="page"></li>
                                    <li class="breadcrumb-item text-muted" aria-current="page"></li> -->
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
            <!-- ============================================================== -->
            <!-- End Bread crumb and right sidebar toggle -->
            <!-- ============================================================== -->
            <!-- ============================================================== -->
            <!-- Container fluid  -->
            <!-- ============================================================== -->
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="">
                                <div class="row">
                                    <div class="col-lg-3 border-end pr-0">
                                        <div class="card-body border-bottom">
                                            <h4 class="card-title mt-2">Drag & Drop Event</h4>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div id="calendar-events" class="">
                                                        <div class="calendar-events mb-3" data-class="bg-info"><i
                                                                class="fa fa-circle text-info me-2"></i>Event One</div>
                                                        <div class="calendar-events mb-3" data-class="bg-success"><i
                                                                class="fa fa-circle text-success me-2"></i> Event Two
                                                        </div>
                                                        <div class="calendar-events mb-3" data-class="bg-danger"><i
                                                                class="fa fa-circle text-danger me-2"></i>Event Three
                                                        </div>
                                                        <div class="calendar-events mb-3" data-class="bg-warning"><i
                                                                class="fa fa-circle text-warning me-2"></i>Event Four
                                                        </div>
                                                    </div>
                                                    <!-- checkbox -->
                                                    <div class="custom-control custom-checkbox">
                                                        <input type="checkbox" class="custom-control-input"
                                                            id="drop-remove">
                                                        <label class="custom-control-label" for="drop-remove">Remove
                                                            after drop</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- [시작] 캘린더 출력부분 -->
                                    <div class="col-lg-9">
                                        <div class="card-body b-l calender-sidebar">
                                            <div id="calendar"></div>
                                            
                                        </div>
                                    </div>
                                    <!-- [끝] 캘린더 출력부분 -->
                                    
                                
                                    
                                </div>
                            </div>
                        </div>
                       
                       <button type="button" class="btn waves-effect waves-light btn-outline-dark" id="cancelBtn">뒤로</button> <!-- 왼쪽 정렬 -->
                       
                    </div>
                </div>
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
    
</body>
</html>