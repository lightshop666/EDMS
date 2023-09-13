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
	<title>tempDraft</title>
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
		// 체크박스 전체선택/해제
		let chkAll = $('#checkAll'); // 전체선택박스 버튼
		let chkList = $('input[name=approvalNo]'); // 체크박스 버튼
		let total = chkList.length; // 체크박스 전체 수
		// console.log(total + "<- total");
		let checked = 0; // 선택된 체크박스 수
		
		chkAll.click(function() { // 전체선택박스 버튼 클릭시
			if(chkAll.is(':checked')) { // 체크되어있으면 true 반환
				chkList.prop('checked', true); // 마찬가지로 체크되어있으면 true 반환 // 대신 prop는 값을 바꿀 수도 있다
			} else {
				chkList.prop('checked', false);
			}
			checked = chkList.filter(':checked').length; // filter(":checked") -> 체크되어있는 체크박스만 필터링해준다
			// console.log(checked + "<- checked");
		});

		chkList.click(function() { // 체크박스 버튼 클릭시
			checked = chkList.filter(':checked').length;
			if(total == checked) { // 선택된 체크박스 수가 체크박스 전체 수와 같다면
				chkAll.prop('checked', true); // 전체선택박스도 체크
			} else {
				chkAll.prop('checked', false);
			}
			// console.log(checked + "<- checked");
		});
		
		// 삭제 버튼 유효성 검사
		$('#delBtn').click(function(event) {
			if(checked == 0) { // 체크박스가 하나도 선택되지 않았을 경우
				alert('삭제할 내역을 선택해주세요');
				return;
			}
			let result = confirm('삭제 후 복구할 수 없습니다. 정말 삭제하시겠습니까?'); // 확인(true) or 취소(false) 반환
			if(result == true) {
				$('#deleteForm').submit(); // 삭제 폼 제출
				return;
			}
		});
	});
	
	</script>
	
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

			<h1 class="draftCategory">임시저장함</h1> <br>
		    
		    <!-- 검색 조건 영역 -->
		    <form method="get" action="${pageContext.request.contextPath}/draft/tempDraft">
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
		    <div style="text-align: right;">
		    	<button type="button" class="btn waves-effect waves-light btn-outline-dark" id="delBtn">삭제</button>
		    </div> <br>
		    
		    <!-- 문서 제출 목록 출력 -->
		    <form action="${pageContext.request.contextPath}/draft/tempDraft" method="post" id="deleteForm">
			    <table class="table border table-striped table-bordered text-nowrap">
			    	<thead>
				        <tr>
				        	<th><input type="checkbox" id="checkAll"></th>
				            <th>문서 양식</th>
				            <th>문서 제목</th>
				            <th>작성일</th>
				        </tr>
				     </thead>
				     <tbody>
				        <c:forEach var="draft" items="${tempDraftList}">
				            <tr>
				            	<td>
				            		<!-- 일괄 삭제 기능을 위해 배열로 넘깁니다. -->
				            		<input type="checkbox" name="approvalNo" value="${draft.approvalNo}">
				            	</td>
				                <td>${draft.documentCategory}</td>
				                <td>
				                    <c:choose>
				                        <c:when test="${draft.documentCategory eq '지출결의서'}">
				                            <a href="${pageContext.request.contextPath}/draft/modifyExpenseDraft?approvalNo=${draft.approvalNo}">
				                            	<c:if test="${empty draft.docTitle}">
				                            		제목이 없습니다.
				                            	</c:if>
				                            	${draft.docTitle}
				                            </a>
				                        </c:when>
				                        <c:when test="${draft.documentCategory eq '기안서'}">
				                            <a href="${pageContext.request.contextPath}/draft/modifyBasicDraft?approvalNo=${draft.approvalNo}">
				                            	<c:if test="${empty draft.docTitle}">
				                            		제목이 없습니다.
				                            	</c:if>
				                            	${draft.docTitle}
				                            </a>
				                        </c:when>
				                        <c:when test="${draft.documentCategory eq '매출보고서'}">
				                            <a href="${pageContext.request.contextPath}/draft/modifySalesDraft?approvalNo=${draft.approvalNo}">
				                            	<c:if test="${empty draft.docTitle}">
				                            		제목이 없습니다.
				                            	</c:if>
				                            	${draft.docTitle}
				                            </a>
				                        </c:when>
				                        <c:when test="${draft.documentCategory eq '휴가신청서'}">
				                            <a href="${pageContext.request.contextPath}/draft/modifyVacationDraft?approvalNo=${draft.approvalNo}">
				                            	<c:if test="${empty draft.docTitle}">
				                            		제목이 없습니다.
				                            	</c:if>
				                            	${draft.docTitle}
				                            </a>
				                        </c:when>
				                        <c:otherwise>
				                            <c:if test="${empty draft.docTitle}">
			                            		제목이 없습니다.
			                            	</c:if>
			                            	${draft.docTitle}
				                        </c:otherwise>
				                    </c:choose>
				                </td>
				                <td>${draft.createdate}</td>
				            </tr>
				        </c:forEach>
			        </tbody>
			    </table>
		    </form>
		    
		    <!-- 페이징 영역 -->
		    <c:if test="${minPage > 1 }">
		        <a href="${pageContext.request.contextPath}/draft/tempDraft?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">이전</a>
		    </c:if>
		    
		    <c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
		        <c:if test="${i == currentPage}">
		            ${i}
		        </c:if>
		        <c:if test="${i != currentPage}">
		            <a href="${pageContext.request.contextPath}/draft/tempDraft?currentPage=${i}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
		        </c:if>
		    </c:forEach>
		    
		    <c:if test="${lastPage > currentPage}">
		        <a href="${pageContext.request.contextPath}/draft/tempDraft?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
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