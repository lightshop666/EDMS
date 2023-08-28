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
	<title>addReservation</title>
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

	<form method="post" action="${pageContext.request.contextPath}/reservation/addReservation">
		<!-- 필요한 정보들 hidden 타입으로 보내기 -->
		<input type="hidden" name="empNo" value="${empNo}">
	
		<h1>예약 신청</h1>
		<table>
			<!-- 세션을 통해 값을 가져와서 value 값으로 출력 및 readonly -->
			<tr>
				<td>사원명</td>
				<td><input type="text" name="empName" value="${empName}" readonly="readonly"></td>
			</tr>
			<tr>
			<!-- 해당 카테고리에 따라 출력 분기 -->
			<c:choose>
				<c:when test="${utilityCategory == '회의실'}">
					<td>공용품종류</td>
					<td><input type="text" name="utilityCategory" value="회의실" readonly="readonly"></td>
				</c:when>
				<c:when test="${utilityCategory == '차량'}">
					<td>공용품종류</td>
					<td><input type="text" name="utilityCategory" value="차량" readonly="readonly"></td>
				</c:when>
			</c:choose>
			</tr>
			<!-- 차량 or 회의실에 해당하는 공용품명들이 출력되고 해당 항목을 선택시 해당 공용품번호가 넘어간다. -->
			<tr>
				<td>공용품번호</td>
				<td>
			        <select name="utilityNo">
			            <option value="" selected>선택하세요</option>
			            <c:forEach var="u" items="${utilities}">
			          		<option value="${u.utilityNo}">${u.utilityName}</option>
			            </c:forEach>
			        </select>
			    </td>
			</tr>
			<tr>
				<td>예약일</td>
				<td><input type="date" name="reservationDate" ></td>
			</tr>
			<tr>
				<!-- 신청 공용품 카테고리가 회의실이면 예약시간 태그가 출력되도록 -->
				<!-- 확장성이 용이하게 choose와 when 태그 사용 -->
				<c:choose>
				    <c:when test="${utilityCategory == '회의실'}">
				    	<td>예약시간</td>
				        <td>
				            <select name="reservationTime">
				                <option value="" selected>예약시간을 선택하세요</option>
				                <option value="08:00 ~ 10:00">08:00 ~ 10:00</option>
				                <option value="10:00 ~ 12:00">10:00 ~ 12:00</option>
				                <option value="12:00 ~ 14:00">12:00 ~ 14:00</option>
				                <option value="14:00 ~ 16:00">14:00 ~ 16:00</option>
				                <option value="16:00 ~ 18:00">16:00 ~ 18:00</option>
				            </select>
				        </td>
				    </c:when>
				    <c:when test="${utilityCategory == '차량'}">
				    	<td>예약시간</td>
				        <td>
				            <select name="reservationTime">
				                <option value="" selected>예약시간을 선택하세요</option>
				                <option value="08:00 ~ 18:00">08:00 ~ 18:00</option>
				            </select>
				        </td>
				    </c:when>
				</c:choose>
			</tr>
		</table>
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
		<button type="submit" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
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
