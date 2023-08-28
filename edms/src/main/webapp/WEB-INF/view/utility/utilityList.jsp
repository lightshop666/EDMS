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
	<title>utilityList</title>
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

	<!-- 탭 메뉴 형식으로 회사일정 or 공용품리스트 형식으로 나누면서 확인해야함 템플릿 이용 -->
	<h1>공용품리스트</h1>
	<div>
		<!-- 예약신청폼에서 utilityCategory를 검사하므로 매개변수로 넣어서 웹 브라우저에서 각각 다른 입력폼이 보이도록 한다. -->
		<a href="${pageContext.request.contextPath}/reservation/addReservation?utilityCategory=차량">차량 예약신청</a>
		<a href="${pageContext.request.contextPath}/reservation/addReservation?utilityCategory=회의실">회의실 예약신청</a>
	</div>
	<div>
		<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함-->
		<a href="${pageContext.request.contextPath}/utility/addUtility">공용품추가</a>
	</div>	
	<form action="${pageContext.request.contextPath}/utility/delete" method="post">
		<!-- [시작] 테이블 영역 -->
		<table border="1">
			<tr>
				<th>선택</th>
				<th>공용품 번호</th>
				<th>공용품 이미지</th>
				<th>공용품 종류</th>
				<th>공용품 이름</th>
				<th>공용품 정보</th>
				<th>등록일</th>
				<th>수정일</th>
				<th>수정</th>
			</tr>
			<c:forEach var="u" items="${utilityList}">
					<tr>
						<!-- 각 리스트마다 체크박스를 생성 -->
						<td>
							<input type="checkbox" name="selectedItems" value="${u.utilityNo}">
						</td>
						<td>${u.utilityNo}</td>
						<td>
							<!-- 공용품은 고정된 폴더에 저장되는것으로 생각하고 리스트에 사진을 출력한다. -->
							<img class="thumbnail" alt="Utility Image"
								src="/image/utility/${u.utilitySaveFilename}">
						</td>
						<td>${u.utilityCategory}</td>
						<td>${u.utilityName}</td>
						<td>${u.utilityInfo}</td>
						<td>${u.createdate}</td>
						<td>${u.updatedate}</td>
						<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함  -->
						<td>
							<a href="${pageContext.request.contextPath}/utility/modifyUtility?utilityNo=${u.utilityNo}">수정</a>
						</td>
					</tr>
			</c:forEach>
			<!-- [끝] 조건문 -->
		</table>
		<!-- [끝] 테이블 영역 -->
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
		<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함-->
		<button type="submit" id="deleteBtn">삭제</button> <!-- 오른쪽 정렬 -->
	</form>
	
	<!-- [시작] 페이징 영역 -->
	<c:if test="${minPage > 1 }">
		<a href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${currentPage - 1}">이전</a>
	</c:if>
	
	<c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
    	<c:if test="${i == currentPage}">
        	${i}
        </c:if>
        <c:if test="${i != currentPage}">
        	<a  href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${i}">${i}</a>
    	</c:if>
    </c:forEach>
	
	<c:if test="${lastPage > currentPage }">
		<a href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${currentPage + 1}">다음</a>
	</c:if>
	<!-- [끝] 페이징 영역 -->

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
