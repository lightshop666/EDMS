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
	<title>addReservation</title>
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
	
	<!-- 입력 태그중 필수 입력사항 미입력시 경고창 출력 -->
	<script>
	$(document).ready(function() {
	    $('#addReservationForm').submit(function(e) {
	        // 필수입력사항 선택되었는지 확인합니다.
	        var utilityNo = $('select[name="utilityNo"]').val();
	        var reservationDate = $('input[name="reservationDate"]').val();
	
	        if (!utilityNo || !reservationDate) {
	            // 필수 항목이 비어 있다면 경고창을 보여주고, 폼 제출을 중단합니다.
	            alert('필수 입력 항목을 작성해주세요.');
	            e.preventDefault();
	        }
	    });
	    
	    $("#reservationDateField").change(function() {
	        var selectedDate = new Date($(this).val()); // 선택된 날짜
	        var currentDate = new Date(); // 현재 날짜

	        if (selectedDate < currentDate) {
	          alert("당일 및 이전의 날짜는 선택할 수 없습니다.");
	          $(this).val(""); // 값 초기화
	        }
      	});
	});
	</script>
	
	<script>
		$(document).ready(function() { // 웹 페이지가 모든 html 요소를 로드한 후에 내부(JQuery)의 코드를 실행하도록 보장
			
			// 입력 성공 or 실패 결과에 따른 alert
			let result = '${param.result}'; // 성공유무를 url의 매개값으로 전달
			
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('예약 등록 실패');
			    alert('예약이 등록되지 않았습니다. 다시 시도해주세요.');
			} else if (result == 'success') { // result의 값이 success이면
				console.log('예약 등록 성공');
			    alert('예약이 등록되었습니다.');
			}
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('예약신청 페이지로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '${pageContext.request.contextPath}/utility/utilityList'; // utilityList으로 이동
				}
			});
		});
	</script>
	
	 <style>
	 	/* 제목 가운데 정렬 */
        #addScheduleForm .card-title {
            text-align: center;
        }
        /* 취소, 저장 왼/오른쪽 정렬 */
        #cancelBtn {
		    float: left;
		}
		
		#saveBtn {
		    float: right;
		}
		/* 필수입력표시 오른쪽 정렬 */
		#markRequiredInput {
			float: right;
		}
		/* 구분선 */
		hr {
		    border: solid 3px black;
		    width: 100%;
		    margin: 0; /* auto 가운데 정렬 */
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

				<div class="row">
                    <div class="col-8">
                        <div class="card">
                            <div class="card-body" id="addScheduleForm">
                                <h3 class="card-title center" >예약추가</h3>
                                <h6 class="card-subtitle"></h6>
                                <h6 class="card-title mt-5"><i
                                        class="me-1 font-18 mdi mdi-numeric-1-box-multiple-outline"></i></h6>
                                <div class="table-responsive">
                                <form id="addReservationForm" method="post" action="${pageContext.request.contextPath}/reservation/addReservation">
                                	<!-- 필요한 정보들 hidden 타입으로 보내기 -->
									<input type="hidden" name="empNo" value="${empNo}" class="form-control">
									<!-- 필수입력사항 표시 -->
									<div id="markRequiredInput">
										<label class="form-label">* 필수입력표시</label>
									</div>
                                    <table class="table">
                                        <!-- 세션을 통해 값을 가져와서 value 값으로 출력 및 readonly -->
										<tr>
											<td>사원명</td>
											<td><input type="text" name="empName" value="${empName}" readonly="readonly" class="form-control"></td>
										</tr>
										<tr>
										<!-- 해당 카테고리에 따라 출력 분기 -->
										<c:choose>
											<c:when test="${utilityCategory == '회의실'}">
												<td>공용품종류</td>
												<td><input type="text" name="utilityCategory" value="회의실" readonly="readonly" class="form-control"></td>
											</c:when>
											<c:when test="${utilityCategory == '차량'}">
												<td>공용품종류</td>
												<td><input type="text" name="utilityCategory" value="차량" readonly="readonly" class="form-control"></td>
											</c:when>
										</c:choose>
										</tr>
										<!-- 차량 or 회의실에 해당하는 공용품명들이 출력되고 해당 항목을 선택시 해당 공용품번호가 넘어간다. -->
										<tr>
											<td>공용품 *</td>
											<td>
										        <select name="utilityNo" class="form-control">
										            <option value="" selected>선택하세요</option>
										            <c:forEach var="u" items="${utilities}">
										          		<option value="${u.utilityNo}">${u.utilityName}, ${u.utilityNo}</option>
										            </c:forEach>
										        </select>
										    </td>
										</tr>
										<tr>
											<td>예약일 *</td>
											<td><input type="date" name="reservationDate" id="reservationDateField" class="form-control"></td>
										</tr>
										<tr>
											<!-- 신청 공용품 카테고리가 회의실이면 예약시간 태그가 출력되도록 -->
											<!-- 확장성이 용이하게 choose와 when 태그 사용 -->
											<c:choose>
											    <c:when test="${utilityCategory == '회의실'}">
											    	<td>예약시간</td>
											        <td>
											            <select name="reservationTime" class="form-control">
											                <option value="" selected>예약시간을 선택하세요</option>
											                <option value="08:00 ~ 10:00">08:00 ~ 10:00</option>
											                <option value="10:00 ~ 12:00">10:00 ~ 12:00</option>
											                <option value="12:00 ~ 14:00">12:00 ~ 14:00</option>
											                <option value="14:00 ~ 16:00">14:00 ~ 16:00</option>
											                <option value="16:00 ~ 18:00">16:00 ~ 18:00</option>
											            </select>
											        </td>
											    </c:when>
											    <c:when test="${utilityCategory == '차량'}">
											    	<td>예약시간</td>
											        <td>
											            <select name="reservationTime" class="form-control">
											                <option value="08:00 ~ 18:00" selected>08:00 ~ 18:00</option>
											            </select>
											        </td>
											    </c:when>
											</c:choose>
										</tr>
                                    </table>
                                    <button type="button"
                                        class="btn waves-effect waves-light btn-outline-dark" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
                                    <button type="submit"
                                        class="btn waves-effect waves-light btn-outline-dark" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
                                </form>
                                </div>
                            </div>
                        </div>
                    </div>
               	</div>	


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
