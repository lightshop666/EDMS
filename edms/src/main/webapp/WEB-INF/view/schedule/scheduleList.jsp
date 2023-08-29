<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<title>scheduleList</title>
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
	
	<script>
		$(document).ready(function() { // 웹 페이지가 모든 html 요소를 로드한 후에 내부(JQuery)의 코드를 실행하도록 보장
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('HOME으로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/home'; // Home으로 이동
				}
			});
		});
	</script>
	
	<style>
		/* 구분선 */
		hr {
		    border: solid 3px black;
		    width: 20%;
		    margin: 0; /* auto 가운데 정렬 */
		}
		/* 테이블 중앙 정렬 */
		table {
			text-align: center;
		}
		/* 제목 가운데 정렬 */
        #scheduleListForm .card-title {
            text-align: center;
        }
        /* 취소, 저장 왼/오른쪽 정렬 */
        #cancelBtn {
		    float: left;
		}
		
		#deleteBtn {
		    float: right;
		}
		
		#insertBtn {
		    float: right;
		}
		
		.btn-space {
		    margin-bottom: 20px;
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

	<h1 style="text-align: center">일정리스트</h1>
	
	<br>
	
	<!-- 검색 조건 영역 -->
	<form method="get" action="${pageContext.request.contextPath}/schedule/scheduleList">
	<!-- 날짜 조회 align-items: center; 속성은 해당 div안의 내용이 한 row에 출력되도록 함-->
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
	        <button type="submit" class="btn waves-effect waves-light btn-outline-dark" id="selectBtn">조회</button>
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
		            <option value="createdate" ${col eq 'createdate' ? 'selected' : ''}>신청일</option>
		        </select>
	        </div>
	        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
		        <select name="ascDesc" class="form-control">
		            <option value="ASC" ${ascDesc eq 'ASC' ? 'selected' : ''}>오름차순</option>
		            <option value="DESC" ${ascDesc eq 'DESC' ? 'selected' : ''}>내림차순</option>
		        </select>
	        </div>
	        <button type="submit" class="btn waves-effect waves-light btn-outline-dark" id="orderBtn">정렬</button>
	    </div>
	
	<br>
	    
   	<!-- 검색조건 영역 -->
	    <div class="search-area" style="display: flex; align-items: center;">
	    	<div class="form-group" style="width: 100px;">
	        	<label class="search-label">검색</label>
	        </div>
	        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
		        <select name="searchCol" class="form-control">
		            <option value="schedule_content" ${searchCol eq 'schedule_content' ? 'selected' : ''}>내용</option>
		        </select>
	        </div>
	        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
	        	<input type="text" name="searchWord" value="${searchWord}" class="form-control">
	        </div>
	        <button type="submit" class="btn waves-effect waves-light btn-outline-dark" id="searchBtn">검색</button>
	    </div>
	</form>
	<br>
				<!-- schedule table -->
                <div class="row">
                    <div class="col-12">
                        <div class="card" id="scheduleListForm">
                            <div class="card-body">
                                <h2 class="card-title center"></h2>
                                <h6 class="card-subtitle">&nbsp;</h6>
                                <div class="table-responsive">
                                <form method="post" action="${pageContext.request.contextPath}/schedule/delete">
                                	<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함-->
									<button type="button" onclick="window.location.href='${pageContext.request.contextPath}/schedule/addSchedule'"
							        	class="btn waves-effect waves-light btn-outline-dark btn-space" id="insertBtn">일정추가</button>
                                    <table id="zero_config_1" class="table border table-striped table-bordered text-nowrap">
                                        <thead>
                                            <tr>
                                                <th>선택</th>
												<th>일정번호</th>
												<th>시작시간</th>
												<th>종료시간</th>
												<th>내용</th>
												<th>등록일</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                           <c:forEach var="s" items="${scheduleList}">
												<tr>
													<!-- 각 리스트마다 체크박스를 생성 -->
													<td>
														<input type="checkbox" name="selectedItems" value="${s.scheduleNo}">
													</td>
													<td>${s.scheduleNo}</td>
													<td>${s.scheduleStartTime}</td>
													<td>${s.scheduleEndTime}</td>
													<td>${s.scheduleContent}</td>
													<td>${s.createdate}</td>
												</tr>
											</c:forEach>
                                        </tbody>
                                    </table>
                                    <button type="button"
                                    	class="btn waves-effect waves-light btn-outline-dark" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
									<!-- 관리자(권한 1~3)만 보이게끔 세팅해야 함-->
									<button type="submit"
                                    	class="btn waves-effect waves-light btn-outline-dark" id="deleteBtn">삭제</button> <!-- 오른쪽 정렬 -->
                                </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- [시작] 페이징 영역 -->
				<c:if test="${minPage > 1 }">
					<a href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">이전</a>
				</c:if>
				
				<c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
			    	<c:if test="${i == currentPage}">
			        	${i}
			        </c:if>
			        <c:if test="${i != currentPage}">
			        	<a  href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
			    	</c:if>
			    </c:forEach>
				
				<c:if test="${lastPage > currentPage}">
					<a href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
				</c:if>
				<!-- [끝] 페이징 영역 -->
	
	<%-- <form method="post" action="${pageContext.request.contextPath}/schedule/delete">
		<!-- [시작] 테이블 영역 -->
		<table border="1">
			<tr>
				<th>선택</th>
				<th>일정번호</th>
				<th>시작시간</th>
				<th>종료시간</th>
				<th>내용</th>
				<th>등록일</th>
			</tr>
			<c:forEach var="s" items="${scheduleList}">
				<tr>
					<!-- 각 리스트마다 체크박스를 생성 -->
					<td>
						<input type="checkbox" name="selectedItems" value="${s.scheduleNo}">
					</td>
					<td>${s.scheduleNo}</td>
					<td>${s.scheduleStartTime}</td>
					<td>${s.scheduleEndTime}</td>
					<td>${s.scheduleContent}</td>
					<td>${s.createdate}</td>
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
		<a href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">이전</a>
	</c:if>
	
	<c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
    	<c:if test="${i == currentPage}">
        	${i}
        </c:if>
        <c:if test="${i != currentPage}">
        	<a  href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">${i}</a>
    	</c:if>
    </c:forEach>
	
	<c:if test="${lastPage > currentPage}">
		<a href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">다음</a>
	</c:if>
	<!-- [끝] 페이징 영역 --> --%>

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
