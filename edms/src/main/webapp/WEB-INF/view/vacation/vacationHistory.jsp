<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>휴가 내역</title>
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
		/* 테이블 중앙 정렬 */
		table, .draftCategory {
			text-align: center;
		}
		/* 탭 선택된 상태가 진하게 */
		.nav-link.active {
		    font-weight: bold;
		    color: white;
		    background-color: #007bff;
		}
		a:link, a:visited { 
			color: black;
			text-decoration: none;
		}
		a:hover { 
			color: blue;
			text-decoration: underline;
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
    <h1>휴가내역</h1>
	    <!-- 보상휴가 지급 버튼 -->
    <form method="get" action="${pageContext.request.contextPath}/vacation/vacationHistory">
	      		 	<input type="hidden" name="empNo" value="${empNo}">
	      		 <div class="date-area" style="display: flex; align-items: center;">
		 		<div class="form-group" style="width: 100px;">
			        <label class="date-label">검색 시작일</label>
		 		</div>
		 		<div class="form-group" style="width: 200px; margin-left: 20px; margin-right: 20px;">
			        <input type="date" name="startDate" value="${startDate}" class="form-control">
		        </div>
		        <div class="form-group" style="width: 100px;">
			        <label class="date-label">검색 종료일</label>
			    </div>
		        <div class="form-group" style="width: 200px; margin-left: 20px; margin-right: 20px;">
			        <input type="date" name="endDate" value="${endDate}" class="form-control">
		        </div>
		       
			</div>
        <br>
		
		<!-- 정렬조건 영역 -->
		    <div class="sort-area" style="display: flex; align-items: center;">
		    	<div class="form-group" style="width: 100px;">
		        	<label class="sort-label">정렬</label>
		        </div>
		        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
			        <select name="col" class="form-control">
			        	<!-- ${col eq 'createdate' ? 'selected' : ''}는 조건문을 통해 선택 여부를 결정하는 부분 
			        	col eq 'createdate' 는 col 변수의 값이 createdate와 같은지 비교 
			        	? 'selected' : '' 조건이 참일 경우 selected 속성을 추가하여 <option> 요소가 선택된 상태로 표시함. 
			        	조건이 거짓일 경우 빈 문자열('') -->
			            <option value="createdate" ${col eq 'createdate' ? 'selected' : ''}>등록일</option>
			        </select>
		        </div>
		        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
			        <select name="ascDesc" class="form-control">
			            <option value="ASC" ${ascDesc eq 'ASC' ? 'selected' : ''}>오름차순</option>
			            <option value="DESC" ${ascDesc eq 'DESC' ? 'selected' : ''}>내림차순</option>
			        </select>
		        </div>
		        <button type="submit" class="btn waves-effect waves-light btn-outline-dark" id="searchBtn" style="margin-right: 10px;">적용</button>
		        <a href="${pageContext.request.contextPath}/vacation/vacationHistory?empNo=${empNo}" class="btn waves-effect waves-light btn-outline-dark">초기화</a>
		    </div>
        
    </form>
    <div align="right">
	    <a type = "button" href="${pageContext.request.contextPath}/vacation/adminAddVacation?empNo=${empNo}" class="btn waves-effect waves-light btn-outline-dark">보상휴가 지급</a>
	</div>
	<br>
    <!--  
    <div align="center">
        <a href="${pageContext.request.contextPath}/vacationHistory?vacationName=연차">연차</a>
        <a href="${pageContext.request.contextPath}/vacationHistory?vacationName=보상">보상</a>
    </div>
    -->
    <table class="table border table-striped table-bordered text-nowrap">
         <thead>
            <tr>
                <th>휴가 번호</th>
                <th>사원 번호</th>
                <th>휴가 종류</th>
                <th>휴가 일수(+/-)</th>
                <th>휴가 일수</th>
                <th>발생 일자</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="history" items="${vacationHistoryList}">
				<tr>
				    <td>${history.vacationHistoryNo}</td>
				    <td>${history.empNo}</td>
				    <td>${history.vacationName}</td>
				    <td>${history.vacationPm}</td>
				    <td>${history.vacationDays}</td>
				    <td>${history.createdate}</td>
				</tr>
            </c:forEach>
        </tbody>
    </table>
    
    <!-- 페이징 영역 -->
    <c:if test="${minPage > 1 }">
        <a href="${pageContext.request.contextPath}/vacation/vacationHistory?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">이전</a>
    </c:if>
    
    <c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
        <c:if test="${i == currentPage}">
            ${i}
        </c:if>
        <c:if test="${i != currentPage}">
            <a href="${pageContext.request.contextPath}/vacation/vacationHistory?currentPage=${i}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
        </c:if>
    </c:forEach>
    
    <c:if test="${lastPage > currentPage}">
        <a href="${pageContext.request.contextPath}/vacation/vacationHistory?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
    </c:if>
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