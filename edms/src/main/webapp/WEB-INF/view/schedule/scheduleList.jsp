<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
			
			// 삭제 성공 or 실패 결과에 따른 alert
			let result = '${param.result}'; // 수정 성공유무를 url의 매개값으로 전달
			
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('일정 삭제 실패');
			    alert('일정이 삭제되지 않았습니다. 다시 시도해주세요.');
			} else if (result == 'success') { // result의 값이 success이면
				console.log('일정 삭제 성공');
			    alert('일정이 삭제되었습니다.');
			}
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('HOME으로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/home'; // Home으로 이동
				}
			});
		});
	</script>
	
	<!-- 페이지네이션 버튼을 누를경우 매개변수를 컨트롤러로 POST 방식으로 보내는 폼이 활성화된다.-->
	<!-- <script>
	$(document).ready(function() {
	    $('.prev-page, .next-page, .page-number').click(function(e) {
	    	
	        e.preventDefault();
	        
	     	// 클릭된 요소의 클래스 확인
	        var isPrev = $(this).hasClass('prev-page');
	        var isNext = $(this).hasClass('next-page');
	        
	        if (isPrev) { // 이전 버튼 클릭 시
	            $('#currentPage').val($('#currentPage').val() - 1);
	        } else if (isNext) { // 다음 버튼 클릭 시
	            $('#currentPage').val(Number($('#currentPage').val()) + 1);
	        } else { // 특정 페이지 번호 클릭 시
	            $('#currentPage').val($(this).text());
	        }
	        
	        $('#postParamForm').submit();
	    });
	});
	</script> -->
	
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
		            <option value="createdate" ${col eq 'createdate' ? 'selected' : ''}>등록일</option>
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
                            <div class="card-body" id="addScheduleForm">
                                <!-- <h2 class="card-title center"></h2>
                                <h6 class="card-subtitle">&nbsp;</h6>
                                <h6 class="card-title mt-5"><i class="me-1 font-18 mdi mdi-numeric-1-box-multiple-outline"></i></h6> -->
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
               	
               	<!-- 페이징 및 검색조건 적용시 POST 방식으로 컨트롤러로 데이터를 보내기 위함 -->
              <%--  	<form id="postParamForm" method="post" action="${pageContext.request.contextPath}/schedule/scheduleList">
				    <input type="hidden" name="currentPage" value="${i}" />
				    <input type="hidden" name="startDate" value="${startDate}" />
				    <input type="hidden" name="endDate" value="${endDate}" />
				    <input type="hidden" name="searchCol" value="${searchCol}" />
				    <input type="hidden" name="searchWord"value="${searchWord}"/>
				    <input type="hidden" name ="col"value = "${col}"/>
					<input type ="hidden"name ="ascDesc"value = "${ascDesc}"/>
				
				</form> --%>
               	
                <!-- [시작] 페이징 영역 가운데 정렬하기 위해 inline 속성적용 nav, ul 태그 -->
                <div class="col-lg-12 mb-4" >
                <h4 class="card-title"></h4>
                <h6 class="card-subtitle"></h6>
	                <nav aria-label="Page navigation example" style="text-align: center;">
					    <ul class="pagination justify-content-center">
					        <c:if test="${minPage > 1}">
					            <li class="page-item">
					                <a class="page-link"
					                   href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}"
					                   aria-label="Previous">
					                    <span aria-hidden="true">&lt;</span>
					                    <span class="sr-only">Previous</span>
					                </a>
					            </li>
					        </c:if>
					        
					        <c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
					            <li class="page-item">
					                <c:choose>
					                    <c:when test="${i == currentPage}">
					                        <span class="page-link">${i}</span>
					                    </c:when>
					                    <c:otherwise>
					                        <a class="page-link"
					                           href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${i}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}">
					                            ${i}
					                        </a>
					                    </c:otherwise>
					                </c:choose>
					            </li>
					        </c:forEach>
					        
					        <c:if test="${lastPage > currentPage}">
					            <li class="page-item">
					                <a class="page-link"
					                   href="${pageContext.request.contextPath}/schedule/scheduleList?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${searchWord}&col=${col}&ascDesc=${ascDesc}"
					                   aria-label="Next">
					                    <span aria-hidden="true">&gt;</span>
					                    <span class="sr-only">Next</span>
					                </a>
					            </li>
					        </c:if>
					    </ul>
					</nav>
                </div>
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
