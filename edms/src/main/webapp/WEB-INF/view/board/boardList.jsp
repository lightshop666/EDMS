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
	<title>goodeeFit 공지리스트</title>
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

	<script>
	$(document).ready(function() {
		// 파라미터 값에 따라 알림 메세지
	    const urlParams = new URLSearchParams(window.location.search); // 서버에서 전송한 결과 값 처리
	    const resultParam = urlParams.get('result'); // '?' 제외한 url에서 파라미터 추출
	    
	    if (resultParam === 'success') { // fail 파라미터 값이 들어올 경우
	       // 알림
		 	alert('게시 성공');
	    }
	});
	</script>
	<style>
		.center {
			text-align:center;
		}
		.right {
		    text-align: right;
		}
		.left {
		    text-align: left;
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

	<h1 class="center">공지사항</h1>
	<br>
	<br>
<!-- [시작] 정렬 및 검색 ------->
	<form action="/board/boardList" method="GET">
		<!-- 제목 검색 -->	
	    <div class="search-area" style="display: flex; align-items: center;">
	        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
		        <select name="searchCol" class="search-input form-control">
		            <option value="boardTitle" <c:if test="${searchCol.equals('boardTitle')}">selected</c:if>>제목</option>
		            <option value="empName" <c:if test="${searchCol.equals('empName')}">selected</c:if>>작성자</option>
		        </select>
	        </div>
	        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
	        	<input type="text" name="searchWord" class="search-input form-control" value="${searchWord}">
	        </div>
	        <input type="hidden" name="boardCategory" value="${boardCategory}"><!-- 검색 항목을 유지하기 위해 추가 -->
	        <button type="submit" class="btn waves-effect waves-light btn-outline-dark" style="margin-right: 10px;" id="search-button">검색</button>
	    </div>
	</form>
	<br>
	<!-- boardCategory 정렬 -->
	<div class="d-flex justify-content-between">
		<ul class="nav nav-tabs">
		    <li class="nav-item">
		        <a class="nav-link" data-toggle="tab" href="/board/boardList">전체</a>
		    </li>
		    <li class="nav-item">
		        <a class="nav-link" data-toggle="tab" href="/board/boardList?boardCategory=전사공지">전사공지</a>
		    </li>
		    <li class="nav-item">
		        <a class="nav-link" data-toggle="tab" href="/board/boardList?boardCategory=사업추진본부">사업추진본부</a>
		    </li>
		    <li class="nav-item">
		        <a class="nav-link" data-toggle="tab" href="/board/boardList?boardCategory=경영지원본부">경영지원본부</a>
		    </li>
		    <li class="nav-item">
		        <a class="nav-link" data-toggle="tab" href="/board/boardList?boardCategory=영업지원본부">영업지원본부</a>
		    </li>
		</ul>
		<c:choose>
	        <c:when test="${!accessLevel.equals('0')}">
	            <a href="/board/addBoard"><button type="button" class="btn waves-effect waves-light btn-outline-dark">추가</button></a>
	        </c:when>
	        <c:otherwise>
	            &nbsp;
	        </c:otherwise>
	    </c:choose>
	</div>
	<br>
	<table class="table">
		<tr>
			<th>공지</th>
			<th>제목</th>
			<th>작성자</th>
			<th>등록일</th>
		</tr>
		<c:choose>
	        <c:when test="${not empty board}">
				<c:forEach var="b" items="${board}">
				<tr>
					<td>
						<!-- 중요/일반 공지를 구분 -->
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
	                <td colspan="4" class="center">공지 내용이 없습니다.</td>
	            </tr>
	        </c:otherwise>
	    </c:choose>	
	</table>
	
	<!-- [시작] 페이징 ------->
	<nav aria-label="Page navigation" class="d-flex justify-content-center">
	    <ul class="pagination">
	        <c:if test="${minPage > 1}">
	            <li class="page-item">
	                <a class="page-link" href="${pageContext.request.contextPath}/board/boardList?boardCategory=${boardCategory}&currentPage=${currentPage - 1}" aria-label="Previous">
	                    <span aria-hidden="true">&laquo;</span>
	                    <span class="sr-only">이전</span>
	                </a>
	            </li>
	        </c:if>
	        
	        <c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
	            <li class="page-item">
	                <c:choose>
	                    <c:when test="${i == currentPage}">
	                        <span class="page-link current-page">${i}</span>
	                    </c:when>
	                    <c:otherwise>
	                        <a class="page-link" href="${pageContext.request.contextPath}/board/boardList?boardCategory=${boardCategory}&currentPage=${i}">${i}</a>
	                    </c:otherwise>
	                </c:choose>
	            </li>
	        </c:forEach>
	        
	        <c:if test="${lastPage > currentPage}">
	            <li class="page-item">
	                <a class="page-link" href="${pageContext.request.contextPath}/board/boardList?boardCategory=${boardCategory}&currentPage=${currentPage + 1}" aria-label="Next">
	                    <span aria-hidden="true">&raquo;</span>
	                    <span class="sr-only">다음</span>
	                </a>
	            </li>
	        </c:if>
	    </ul>
	</nav>
	<!-- [끝] 페이징 ------->

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