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
			<h2 class="draftCategory">결재함</h2> <br>
		    
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
				</div> <br>
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
			    </div> <br>
				<div class="search-area" style="display: flex; align-items: center;">
			    	<div class="form-group" style="width: 100px;">
			        	<label class="search-label">검색</label>
			        </div>
			        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
				        <select name="searchCol" class="form-control">
				            <option value="doc_title" ${searchCol eq 'docTitle' ? 'selected' : ''}>문서 제목</option>
				        </select>
			        </div>
			        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
			        	<input type="text" name="searchWord" value="${searchWord}" class="form-control">
			        </div>
			        <button type="submit" class="btn waves-effect waves-light btn-outline-dark" id="searchBtn" style="margin-right: 10px;">적용</button>
			        <a href="${pageContext.request.contextPath}/draft/approvalDraft" class="btn waves-effect waves-light btn-outline-dark">초기화</a>
			    </div> <br>
		    </form>
		    
		    <!-- 문서 제출 목록 출력 -->
		    <table class="table border table-striped table-bordered text-nowrap">
		    	<thead>
			        <tr>
			            <th>문서 양식</th>
			            <th>기안자</th>
			            <th>문서 제목</th>
			            <th>결재상태</th>
			            <th>기안일</th>
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
		    <nav aria-label="Page navigation example" style="text-align: center;">
		    	<ul class="pagination justify-content-center">
				    <c:if test="${minPage > 1 }">
				    	<li class="page-item">
				        	<a class="page-link" aria-label="Previous" href="${pageContext.request.contextPath}/draft/approvalDraft?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">
				        		<span aria-hidden="true">&lt;</span>
					            <span class="sr-only">Previous</span>
					         </a>
				    	</li>
				    </c:if>
		    
		    		<c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
		    		<li class="page-item">
		        		<c:if test="${i == currentPage}">
		            		<span class="page-link">${i}</span>
		        		</c:if>
		        		<c:if test="${i != currentPage}">
		            		<a class="page-link" href="${pageContext.request.contextPath}/draft/approvalDraft?currentPage=${i}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
		       			</c:if>
		       		</li>
		    		</c:forEach>
		    
		    		<c:if test="${lastPage > currentPage}">
		    			<li class="page-item">
					        <a class="page-link" aria-label="Next" href="${pageContext.request.contextPath}/draft/approvalDraft?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">
					        	<span aria-hidden="true">&gt;</span>
								<span class="sr-only">Next</span>
					        </a>
					    </li>
		    		</c:if>
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