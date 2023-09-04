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
	<title>reservationList</title>
	<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	
	<script type='text/javascript'>
	// 페이지가 완전히 로드된 후에 실행되는 함수를 정의, HTML 요소들이 모두 로드된 후에 자바스크립트 코드가 실행되어 에러를 방지
	$(document).ready(function(){
	  $(".reservationCancelBtn").click(function(){
		// 클릭한 버튼($(this))의 'data-reservation-no' 속성 값을 가져와서 reservationNo 변수에 저장
	    var reservationNo = $(this).data('reservation-no');
		// jQuery의 AJAX 기능을 사용하여 서버로 비동기 요청을 보냅니다. {} 안의 내용은 AJAX 요청의 세부 사항을 설정하는 곳
	    $.ajax({
	    // AJAX 요청이 보내질 URL을 설정
	      url : "${pageContext.request.contextPath}/reservation/delete",
	      method : "POST",
	    // 서버로 전송될 데이터를 설정
	      data : { reservationNo : reservationNo },
	    //  AJAX 호출이 성공했거나 실패했을 때 실행되는 콜백 함수
	      success : function(response) {
	         // 성공적으로 처리된 후 동작 
	         // 자바스크립트에서 현재 페이지를 새로고침하는 명령
	         location.reload();
	      },
	      // error 콜백: 서버 통신에 문제가 생겼거나 HTTP 에러 상태 코드(400번대, 500번대 등)가 반환될 경우 실행
	      error : function(request, status, error) {
	         // 에러 발생 시 동작
	         alert("Error : " + request.status);
	      }
	    });
	  });
	  
		// 변경 성공 or 실패 결과에 따른 alert
		let result = '${sessionScope.result}'; // 세션의 값 가져오기
		
		if (result == 'fail') { // result의 값이 fail이면
		    console.log('예약 변경사항 적용 실패');
		    alert('예약이 변경되지 않았습니다. 다시 시도해주세요.');
		    $.get('/clear-session'); // 알림 표시 후 정보 삭제 요청
		} else if (result == 'insert') { // result의 값이 insert이면
			console.log('예약 등록 성공');
		    alert('예약이 등록되었습니다.');
		    $.get('/clear-session'); // 알림 표시 후 정보 삭제 요청
		} else if (result == 'delete') { // result의 값이 delete이면
			console.log('예약 취소 성공');
		    alert('예약이 취소되었습니다.');
		    $.get('/clear-session'); // 알림 표시 후 정보 삭제 요청
		}
		
		// 취소 버튼 클릭 시
		$('#cancelBtn').click(function() {
			let result = confirm('HOME으로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
			if (result) {
				window.location.href = '/home'; // schedule으로 이동
			}
		});
	  
	});
	</script>
	
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
        #reservationListForm .card-title {
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

	<!-- 탭 메뉴 형식으로 회사일정 or 공용품리스트 형식으로 나누면서 확인해야함 템플릿 이용 -->
	<h1 style="text-align: center">예약리스트</h1>
	
	<br>
	
	<!-- 검색 조건 영역 -->
	<form method="get" action="${pageContext.request.contextPath}/reservation/reservationList">
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
		            <option value="emp_name" ${searchCol eq 'emp_name' ? 'selected' : ''}>사원명</option>
	            	<option value="utility_category" ${searchCol eq 'utility_category' ? 'selected' : ''}>공용품종류</option>
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
                        <div class="card" id="reservationListForm">
                            <div class="card-body">
                                <h2 class="card-title center"></h2>
                                <h6 class="card-subtitle">&nbsp;</h6>
                                <div class="table-responsive">
                                <form method="post" action="${pageContext.request.contextPath}/reservation/delete?reservationNo=${r.reservationNo}">
                                    <table id="zero_config_1" class="table border table-striped table-bordered text-nowrap">
                                        <thead>
                                            <tr>
                                                <th>공용품 종류</th>
												<th>사원명</th>
												<th>공용품 번호</th>
												<th>예약일</th>
												<th>예약시간</th>
												<th>신청일</th>
												<th>취소</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                           <c:forEach var="r" items="${reservationList}">
												<tr>
													<td>${r.utilityCategory}</td>
													<td>${r.empName}</td>
													<td>${r.utilityNo}</td>
													<td>${r.reservationDate}</td>
													<td>${r.reservationTime}</td>
													<td>${r.createdate}</td>
													
													<!-- 세션에서 멤버로그인ID(사원번호) 확인후 작성자사원번호와 일치할경우 취소태그가 보이도록 출력 비교할 값을 하나의 EL태그안에 넣어서 비교해줘야 조건식이 올바르게 작동한다. -->
													<c:if test="${empNo == r.empNo}">
														<td>
															<!-- 취소 버튼 클릭 시 postRequest 함수 호출 -->
								                			<!-- data-reservation-no 속성으로 예약 번호 저장 -->
															<button class='reservationCancelBtn btn waves-effect waves-light btn-outline-dark delete-link'  data-reservation-no='${r.reservationNo}'>예약취소</button>
														</td>
													</c:if> 
												</tr>
											</c:forEach>
                                        </tbody>
                                    </table>
                                    <button type="button"
                                    	class="btn waves-effect waves-light btn-outline-dark" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
                                </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
	
				<!-- [시작] 페이징 영역 가운데 정렬하기 위해 inline 속성적용 nav, ul 태그 -->
                <div class="col-lg-12 mb-4" >
                <h4 class="card-title"></h4>
                <h6 class="card-subtitle"></h6>
	                <nav aria-label="Page navigation example" style="text-align: center;">
					    <ul class="pagination justify-content-center">
					        <c:if test="${minPage > 1}">
					            <li class="page-item">
					                <a class="page-link"
					                   href="${pageContext.request.contextPath}/reservation/reservationList?currentPage=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${encodedSearchWord}&col=${col}&ascDesc=${ascDesc}"
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
					                           href="${pageContext.request.contextPath}/reservation/reservationList?currentPage=${i}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${encodedSearchWord}&col=${col}&ascDesc=${ascDesc}">
					                            ${i}
					                        </a>
					                    </c:otherwise>
					                </c:choose>
					            </li>
					        </c:forEach>
					        
					        <c:if test="${lastPage > currentPage}">
					            <li class="page-item">
					                <a class="page-link"
					                   href="${pageContext.request.contextPath}/reservation/reservationList?currentPage=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&searchCol=${searchCol}&searchWord=${encodedSearchWord}&col=${col}&ascDesc=${ascDesc}"
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
