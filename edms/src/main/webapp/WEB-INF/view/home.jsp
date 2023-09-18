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
	<style>
	    .wrap {position: absolute;left: 0;bottom: 40px;width: 288px;height: 132px;margin-left: -144px;text-align: left;overflow: hidden;font-size: 12px;font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;line-height: 1.5;}
	    .wrap * {padding: 0;margin: 0;}
	    .wrap .info {width: 286px;height: 120px;border-radius: 5px;border-bottom: 2px solid #ccc;border-right: 1px solid #ccc;overflow: hidden;background: #fff;}
	    .wrap .info:nth-child(1) {border: 0;box-shadow: 0px 1px 2px #888;}
	    .info .title {padding: 5px 0 0 10px;height: 30px;background: #eee;border-bottom: 1px solid #ddd;font-size: 18px;font-weight: bold;}
	    .info .close {position: absolute;top: 10px;right: 10px;color: #888;width: 17px;height: 17px;background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/overlay_close.png');}
	    .info .close:hover {cursor: pointer;}
	    .info .body {position: relative;overflow: hidden;}
	    .info .desc {position: relative;margin: 13px 0 0 90px;height: 75px;}
	    .desc .ellipsis {overflow: hidden;text-overflow: ellipsis;white-space: nowrap;}
	    .desc .jibun {font-size: 11px;color: #888;margin-top: -2px;}
	    .info .img {position: absolute;top: 6px;left: 5px;width: 73px;height: 71px;border: 1px solid #ddd;color: #888;overflow: hidden;}
	    .info:after {content: '';position: absolute;margin-left: -12px;left: 50%;bottom: 0;width: 22px;height: 12px;background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
	    .info .link {color: #5085BB;}
	    .center {text-align:center;}
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
			<div class="row">
				<!-- 꺾은선 그래프 -->
		       	<div class="col-lg-12">
		           	<div class="card">
		               	<div class="card-body" style="text-align: center;">
		                   	<h4 id="card-title" class="card-title">전체 품목 목표달성률 - 최근 1년</h4>
		                   		<ul class="list-inline text-end">
                                    <li class="list-inline-item">
                                        <h5><i class="fa fa-circle me-1 text-info"></i>평균 목표달성률</h5>
                                    </li>
                                </ul>
		                       <ul id="chart-legend" class="list-inline text-end"></ul>
		                   	<div id="morris-area-chart"></div>
		               	</div>
		           	</div>
		       	</div>
		       	<!-- 꺾은선 그래프 끝 -->
		       	<!-- 도넛 차트 -->
		       	<div class="col-lg-4">
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
		       	<div class="col-lg-8">
		       		<div class="card">
		               	<div class="card-body" style="text-align: center;">
		                   	<h4 id="card-title" class="card-title">품목별 목표달성률 - 최근 3개월</h4>
		                       <ul id="chart-legend" class="list-inline text-end"></ul>
		                   	<div id="morris-bar-chart"></div>
		               	</div>
		           	</div>
		       	</div>
		       	<!-- 바 차트 끝 -->
			</div>
			
			<div><br></div>
		       	<!------------ 봉사 정보 지도 시작 ------------->
		       	<div class="row">
				<div class="col-lg-6">
					<h3 class="center" style="color:black; text-align:center;">봉사 정보 지도</h3>
					<div id="map" style="width:100%; height:400px;"></div>
		
						<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${appkey}"></script>
						<script>
						    $(document).ready(function () {
						        var mapContainer = document.getElementById('map'), // 지도를 표시할 div  
						            mapOption = { 
						                center: new kakao.maps.LatLng(37.4765002,126.8799586), // 지도의 중심좌표
						                level: 6 // 지도의 확대 레벨
						            };
						
						        var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
						         
						        $.ajax({
						            url: '/vltrDetailsList',
						            type: 'GET',
						            dataType: 'json',
						            success: function (data) {
						                var markers = []; // 마커 배열
						                var overlays = []; // 오버레이 배열
						
						                $.each(data, function (index, item) {
						                    var title = item.progrmSj;
						                    var area = item.areaLalo1;
						                    var latlng = area.split(',');
						                    var latitude = parseFloat(latlng[0]);
						                    var longitude = parseFloat(latlng[1]);
						                    var nanmmbyNm = item.nanmmbyNm;
						                    var rcritNmpr = item.rcritNmpr;
						                    var email = item.email;
						
						                    var marker = new kakao.maps.Marker({
						                        map: map,
						                        position: new kakao.maps.LatLng(latitude, longitude),
						                        title: title,
						                    });
						
						                    markers.push(marker);
						
						                    var content = '<div class="wrap">' +
						                        '<div class="info">' +
						                        '<div class="title">' +
						                        title +
						                        '</div>' +
						                        '<div class="body">' +
						                        '<div class="img">' +
						                        '<img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/thumnail.png" width="73" height="70">' +
						                        '</div>' +
						                        '<div class="desc">' +
						                        '<div class="ellipsis">주소: ' + nanmmbyNm + '</div>' +
						                        '<div class="ellipsis">모집인원: ' + rcritNmpr + '</div>' +
						                        '<div class="ellipsis">이메일: ' + email + '</div>' +
						                        '</div>' +
						                        '</div>' +
						                        '</div>' +
						                        '</div>';
						
						                    var overlay = new kakao.maps.CustomOverlay({
						                        content: content,
						                        map: map,
						                        position: marker.getPosition(),
						                        yAnchor: 1.5, // 오버레이가 마커 아래에 표시되도록 조정
						                    });
						
						                    overlays.push(overlay);
						
						                    // 오버레이를 닫은 상태로 시작
						                    overlay.setMap(null);
						
						                    kakao.maps.event.addListener(marker, 'click', function () {
						                        // 모든 오버레이를 닫은 후 클릭한 마커에 대한 오버레이만 열도록 처리
						                        $.each(overlays, function (i, overlay) {
						                            overlay.setMap(null);
						                        });
						                        overlay.setMap(map); // 클릭한 마커의 오버레이를 표시
						                    });
						                });
						            },
						            error: function (error) {
						                console.error('데이터 요청 실패: ' + error.statusText);
						            }
						        });
						    });
						</script>
			    	</div>
				    <!------------ 봉사 정보 지도 끝 ------------->   	
				    <!------------ 중요 공지 목록 시작 ------------->   	
					<div class="col-lg-6">
						<h3 class="center" style="color:black; text-align:center;">공지사항</h3>
						<table class="table center">
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