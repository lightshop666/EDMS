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
		   	<br>
			    <nav class="navbar navbar-expand-lg navbar-light">
			       <div class="collapse navbar-collapse" id="navbarNav">
			           <ul class="nav nav-tabs">
			               <li class="nav-item">
			                   <a class="nav-link" href="${pageContext.request.contextPath}/draft/submitDraft">기안함</a>
			               </li>
			               <li class="nav-item">
			                   <a class="nav-link" href="${pageContext.request.contextPath}/draft/receiveDraft">수신함</a>
			               </li>
			               <li class="nav-item">
			                   <a class="nav-link active" href="${pageContext.request.contextPath}/draft/approvalDraft">결재함</a>
			               </li>
			           </ul>
			       </div>
			   </nav>
		   <br>
			<h2>결재함</h2>
		    
		    <!-- 결재상태별 갯수 조회 -->
			<div class="card-group text-center">
	            <div class="card">
	                <div class="card-body">
	                    <h2 class="card-title">결재대기</h2>
	                    <h2 class="card-title">${approvalDraftCount}건</h2>
	                </div>
	            </div>
	            <div class="card">
	                <div class="card-body">
	                    <h2 class="card-title">결재중</h2>
	                    <h2 class="card-title">${approvalInProgressCount}건</h2>
	                </div>
	            </div>
	            <div class="card">
	                <div class="card-body">
	                    <h2 class="card-title">결재완료</h2>
	                    <h2 class="card-title">${approvalCompletCount}건</h2>
	                </div>
	            </div>
	            <div class="card">
	                <div class="card-body">
	                    <h2 class="card-title">반려</h2>
	                    <h2 class="card-title">${approvalRejectCount}건</h2>
	                </div>
	            </div>
	        </div>
		    
		    <!-- 검색 조건 영역 -->
		    <form method="get" action="${pageContext.request.contextPath}/draft/approvalDraft">
		        <div class="date-area">
		            <label class="date-label">검색 시작일</label>
		            <input type="date" name="startDate" value="${startDate}">
		            
		            <label class="date-label">검색 종료일</label>
		            <input type="date" name="endDate" value="${endDate}">
		            
		            <button type="submit" class="btn btn-secondary btn-sm">조회</button>
		        </div>
		
		        <div class="sort-area">
		            <label class="sort-label">정렬</label>
		            <select name="col">
		                <option value="createdate" ${col eq 'createdate' ? 'selected' : ''}>작성일</option>
		            </select>
		            <select name="ascDesc">
		                <option value="ASC" ${ascDesc eq 'ASC' ? 'selected' : ''}>오름차순</option>
		                <option value="DESC" ${ascDesc eq 'DESC' ? 'selected' : ''}>내림차순</option>
		            </select>
		            <button type="submit" class="btn btn-secondary btn-sm">정렬</button>
		        </div>
		        
		        <div class="search-area">
		            <label class="search-label">검색</label>
		            <select name="searchCol">
		                <option value="doc_title" ${searchCol eq 'docTitle' ? 'selected' : ''}>문서 제목</option>
		            </select>
		            <input type="text" name="searchWord" value="${searchWord}">
		            <button type="submit" class="btn btn-secondary btn-sm">검색</button>
		            <a href="${pageContext.request.contextPath}/draft/approvalDraft" class="btn btn-secondary btn-sm">초기화</a>
		        </div> <br>
		    </form>
		    
		    <!-- 문서 제출 목록 출력 -->
		    <table class="table table-hover table-primary">
		    	<thead class="text-white">
			        <tr>
			            <th class="bg-primary">문서 양식</th>
			            <th class="bg-primary">기안자</th>
			            <th class="bg-primary">문서 제목</th>
			            <th class="bg-primary">결재상태</th>
			            <th class="bg-primary">기안일</th>
			        </tr>
			     </thead>
			     <tbody>
		        <c:forEach var="draft" items="${approvalDraftList}">
		            <tr>
		                <td>${draft.documentCategory}</td>
		                <td>${draft.firstApprovalName}</td>
		                <td>
		                    <c:choose>
		                        <c:when test="${draft.documentCategory eq '지출결의서'}">
		                            <a href="${pageContext.request.contextPath}/draft/expenseDraftOne?approvalNo=${draft.approvalNo}">${draft.docTitle}</a>
		                        </c:when>
		                        <c:when test="${draft.documentCategory eq '기안서'}">
		                            <a href="${pageContext.request.contextPath}/draft/basicDraftOne?approvalNo=${draft.approvalNo}">${draft.docTitle}</a>
		                        </c:when>
		                        <c:when test="${draft.documentCategory eq '매출보고서'}">
		                            <a href="${pageContext.request.contextPath}/draft/salesDraftOne?approvalNo=${draft.approvalNo}">${draft.docTitle}</a>
		                        </c:when>
		                        <c:when test="${draft.documentCategory eq '휴가신청서'}">
		                            <a href="${pageContext.request.contextPath}/draft/vacationDraftOne?approvalNo=${draft.approvalNo}">${draft.docTitle}</a>
		                        </c:when>
		                        <c:otherwise>
		                            ${draft.docTitle}
		                        </c:otherwise>
		                    </c:choose>
		                </td>
		                <td>${draft.approvalState}</td>
		                <td>${draft.createdate}</td>
		            </tr>
		        </c:forEach>
		        </tbody>
		    </table>
		    
		    <!-- 페이징 영역 -->
		    <c:if test="${minPage > 1 }">
		        <a href="${pageContext.request.contextPath}/draft/approvalDraft?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">이전</a>
		    </c:if>
		    
		    <c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
		        <c:if test="${i == currentPage}">
		            ${i}
		        </c:if>
		        <c:if test="${i != currentPage}">
		            <a href="${pageContext.request.contextPath}/draft/approvalDraft?currentPage=${i}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
		        </c:if>
		    </c:forEach>
		    
		    <c:if test="${lastPage > currentPage}">
		        <a href="${pageContext.request.contextPath}/draft/approvalDraft?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
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