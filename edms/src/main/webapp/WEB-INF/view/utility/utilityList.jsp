<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	<title>utilityList</title>
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
		$(document).ready(function() { // 웹 페이지가 모든 html 요소를 로드한 후에 내부(JQuery)의 코드를 실행하도록 보장
			
			// 변경 성공 or 실패 결과에 따른 alert
			let result = '${sessionScope.result}'; // 세션의 값 가져오기
			
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('공용품 변경사항 적용 실패');
			    alert('공용품이 변경되지 않았습니다. 다시 시도해주세요.');
			    $.get('/clear-session'); // 알림 표시 후 정보 삭제 요청
			    
			} else if (result == 'insert') { // result의 값이 insert이면
				console.log('공용품 추가 성공');
			    alert('공용품이 추가되었습니다.');
			    $.get('/clear-session'); // 알림 표시 후 정보 삭제 요청
			} else if (result == 'delete') { // result의 값이 delete이면
				console.log('공용품 삭제 성공');
			    alert('공용품이 삭제되었습니다.');
			    $.get('/clear-session'); // 알림 표시 후 정보 삭제 요청
			} else if (result == 'update') { // result의 값이 update이면
				console.log('공용품 수정 성공');
			    alert('공용품이 수정되었습니다.');
			    $.get('/clear-session'); // 알림 표시 후 정보 삭제 요청
			}
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('HOME으로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '${pageContext.request.contextPath}/home'; // Home으로 이동
				}
			});
		});
	</script>
	
	<!-- a태그와 button태그의 경우 세션의 권한을 비교하여 권한이 부족할 경우 동작을 멈추는 jQuery -->
	<script>
	$(document).ready(function() {
		$(".update-link, .delete-link, .insert-link").click(function(event) {
			console.log("Clicked!");
			event.preventDefault(); // 기본 링크 동작 취소
			
			let requiredAccessLevel = $(this).data("access-level");				// 이 링크의 엑세스 제한 레벨 가져오기
			let userAccessLevel = <%= session.getAttribute("accessLevel") %>;	// 세션에서 사용자의 엑세스 레벨 가져오기
			
			if (userAccessLevel < requiredAccessLevel) {
				alert("권한이 없는 사용자입니다."); // 팝업 메시지 띄우기
			} else {
	            if ($(this).hasClass('update-link') || $(this).hasClass('insert-link')) {
	                window.location.href = $(this).attr("href"); // 권한이 있을 경우 해당 링크로 이동
	            } else if ($(this).hasClass('delete-link')) {
	                $(this).closest('form').submit();  // 권한이 있을 경우 폼 제출
	            } 
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
		
		/* 탭 선택된 상태가 진하게 */
		.nav-link.active {
		    font-weight: bold;
		    color: white;
		    background-color: #007bff;
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
	<h1 style="text-align: center">공용품리스트</h1>
	
	<!-- 탭 형식으로 전체or회의실or차량 리스트 조회 -->
	<ul class="nav nav-tabs" id="myTab" role="tablist">
	    <li class="nav-item" role="presentation">
	    <c:choose>
            <c:when test="${empty param.utilityCategory}">
                <!-- utilityCategory 파라미터가 없거나 빈 문자열일 때 탭 선택상태 -->
                <a class="nav-link active category-tab" id="all-tab" data-category="" href="${pageContext.request.contextPath}/utility/utilityList?utilityCategory=">전체</a>
            </c:when>
            <c:otherwise>
                <!-- utilityCategory 파라미터가 있을 때 탭 미선택상태 -->
                <a class="nav-link category-tab" id='all-tab' data-category="" href="${pageContext.request.contextPath}/utility/utilityList?utilityCategory=">전체</a>
            </c:otherwise>
        </c:choose>
	    </li>
	    <li class="nav-item" role="presentation">
	    <c:choose>
            <c:when test="${param.utilityCategory == '회의실'}">
                <!-- utilityCategory 파라미터가 '회의실'일 때 탭 선택상태-->
                <a class="nav-link active category-tab" id='meetingRoom-tab' data-category='회의실' href="${pageContext.request.contextPath}/utility/utilityList?utilityCategory=회의실">회의실</a>
            </c:when>
            <c:otherwise>
                <!-- utilityCategory 파라미터가 '회의실'이 아닐 때 탭 미선택상태-->
                <a class="nav-link category-tab" id='meetingRoom-tab' data-category='회의실' href="${pageContext.request.contextPath}/utility/utilityList?utilityCategory=회의실">회의실</a> 
            </c:otherwise>   
        </c:choose> 
	    </li>
	    <li class="nav-item" role="presentation">
	    <c:choose>
            <c:when test="${param.utilityCategory == '차량'}">
                <!-- utilityCategory 파라미터가 '회의실'일 때 탭 선택상태-->
                <a class="nav-link active category-tab" id='car-tab' data-category='차량' href="${pageContext.request.contextPath}/utility/utilityList?utilityCategory=차량">차량</a>
            </c:when>
            <c:otherwise>
                <!-- utilityCategory 파라미터가 '회의실'이 아닐 때 탭 미선택상태-->
                <a class="nav-link category-tab" id='car-tab' data-category='차량' href="${pageContext.request.contextPath}/utility/utilityList?utilityCategory=차량">차량</a> 
            </c:otherwise>   
        </c:choose> 
	    </li>
	</ul>
	<br>
                
                <!-- utility table -->
                <div class="row">
                    <div class="col-12">
                        <div class="card" id="scheduleListForm">
                            <div class="card-body" id="addScheduleForm">
                                <!-- <h2 class="card-title center"></h2>
                                <h6 class="card-subtitle">&nbsp;</h6>
                                <h6 class="card-title mt-5"><i class="me-1 font-18 mdi mdi-numeric-1-box-multiple-outline"></i></h6> -->
                                <div class="table-responsive">
                                <form action="${pageContext.request.contextPath}/utility/delete" method="post">
                                
                                	<div style="float: right;">
										<!-- 예약신청폼에서 utilityCategory를 검사하므로 매개변수로 넣어서 웹 브라우저에서 각각 다른 입력폼이 보이도록 한다. -->
										<button type="button" class="btn waves-effect waves-light btn-outline-dark" 
											onclick="window.location.href ='${pageContext.request.contextPath}/reservation/addReservation?utilityCategory=차량'">차량 예약신청</button>
										<button type="button" class="btn waves-effect waves-light btn-outline-dark" 
											onclick="window.location.href ='${pageContext.request.contextPath}/reservation/addReservation?utilityCategory=회의실'">회의실 예약신청</button>
									</div>
									<div style="float: left; margin-bottom: 20px;">
										<!-- 관리자(권한 1~3)만 링크 이동이 가능함-->
										<%-- <button type="button" class="btn waves-effect waves-light btn-outline-dark insert-link" data-access-level="1"
											onclick="window.location.href ='${pageContext.request.contextPath}/utility/addUtility'">공용품추가</button> --%>
										<a class="btn waves-effect waves-light btn-outline-dark insert-link" data-access-level="1" href="${pageContext.request.contextPath}/utility/addUtility">공용품추가</a>
									</div>
                                
                                
                                    <table id="zero_config_1" class="table border table-striped table-bordered text-nowrap" >
                                        <tr>
											<th>선택</th>
											<th>공용품 번호</th>
											<th>공용품 이미지</th>
											<!-- <th>공용품 종류</th> -->
											<th>공용품 이름</th>
											<th>공용품 정보</th>
											<th>생성일</th>
											<th>수정일</th>
											<th>수정</th>
										</tr>
										<!-- [시작] 조건문 -->
										<c:forEach var="u" items="${utilityList}">
												<tr>
													<!-- 각 리스트마다 체크박스를 생성 -->
													<td>
														<input type="checkbox" name="selectedItems" value="${u.utilityNo}">
													</td>
													<td>${u.utilityNo}</td>
													<td>
														<!-- 공용품은 고정된 폴더에 저장되는것으로 생각하고 리스트에 사진을 출력한다. 조건절을 이용해서 공용품파일이 저장되지 않은 리스트가 있다면 기본이미지를 출력한다.-->
														<c:choose>
														    <c:when test="${empty u.utilitySaveFilename}">
														        <img class="thumbnail" src="${pageContext.request.contextPath}/image/utility/noImage.png" style="width: 150px; height: auto;">
														    </c:when>
														    <c:otherwise>
														        <img class="thumbnail" src="${pageContext.request.contextPath}/image/utility/${u.utilitySaveFilename}" style="width: 150px; height: auto;">
														    </c:otherwise>
														</c:choose>
													</td>
													<%-- <td>${u.utilityCategory}</td> --%>
													<td>${u.utilityName}</td>
													<td>${u.utilityInfo}</td>
													<!-- 생성일 출력 부분 -->
												    <fmt:parseDate value="${u.createdate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedCreatedate"/>
												    <td><fmt:formatDate value="${parsedCreatedate}" pattern="yyyy-MM-dd"/></td>
												    <!-- 수정일 출력 부분 -->
												    <fmt:parseDate value="${u.updatedate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedCreatedate"/>
												    <td><fmt:formatDate value="${parsedCreatedate}" pattern="yyyy-MM-dd"/></td>
													<!-- 관리자(권한 1~3)만 링크 이동이 가능함 -->
													<td>
														<a class="update-link" data-access-level="1" href="${pageContext.request.contextPath}/utility/modifyUtility?utilityNo=${u.utilityNo}">수정</a>
													</td>
												</tr>
										</c:forEach>
										<!-- [끝] 조건문 -->
                                    </table>
                                    <button type="button"
                                    	class="btn waves-effect waves-light btn-outline-dark" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
									<!-- 관리자(권한 1~3)만 동작이 가능함.-->
									<button type="submit"
                                    	class="btn waves-effect waves-light btn-outline-dark delete-link" data-access-level="1" id="deleteBtn">삭제</button> <!-- 오른쪽 정렬 -->
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
					                   href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${currentPage - 1}&utilityCategory=${param.utilityCategory}"
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
					                    	<!-- ${param.utilityCategory}는 현재 요청의 utilityCategory 파라미터 값을 가져온다. -> 페이지 이동시 선택한 카테고리가 유지되게끔 -->
					                        <a class="page-link"
					                           href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${i}&utilityCategory=${param.utilityCategory}">
					                            ${i}
					                        </a>
					                    </c:otherwise>
					                </c:choose>
					            </li>
					        </c:forEach>
					        
					        <c:if test="${lastPage > currentPage}">
					            <li class="page-item">
					                <a class="page-link"
					                   href="${pageContext.request.contextPath}/utility/utilityList?currentPage=${currentPage + 1}&utilityCategory=${param.utilityCategory}"
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
