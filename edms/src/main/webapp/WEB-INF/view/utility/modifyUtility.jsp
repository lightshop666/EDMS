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
	<link rel="icon" type="image/png" sizes="16x16" href="../assets/images/favicon.png">
	<title>modifyUtility</title>
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
			
			// 수정 성공 or 실패 결과에 따른 alert
			let result = '${param.result}'; // 성공유무를 url의 매개값으로 전달
			
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('공용품 수정 실패');
			    alert('공용품이 수정되지 않았습니다. 다시 시도해주세요.');
			} else if (result == 'success') { // result의 값이 success이면
				console.log('공용품 수정 성공');
			    alert('공용품이 수정되었습니다.');
			}
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('공용품리스트 페이지로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/utility/utilityList'; // utilityList으로 이동
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
                                <h3 class="card-title center" >공용품수정</h3>
                                <h6 class="card-subtitle"></h6>
                                <h6 class="card-title mt-5"><i
                                        class="me-1 font-18 mdi mdi-numeric-1-box-multiple-outline"></i></h6>
                                <div class="table-responsive">
                                <!-- 컨트롤러로부터 공용품정보를 가져와서 출력한다. -->
								<c:set var="u" value="${utilityDto}" />
                                <form method="post" action="${pageContext.request.contextPath}/utility/modifyUtility" enctype="multipart/form-data">
                                	<!-- 히든값으로 해당되는 공용품 번호를 전송 -> 이름은 utility 객체에 해당하는 이름인 utilityNo로 맞춰서 보내야 컨트롤러에서 올바르게 받는다. -->
									<input type="hidden" name="utilityNo" value="${u.utilityNo}" class="form-control">
                                    <table class="table">
                                        <tr>
											<td>공용품번호</td>
											<td><input type="text" name="utilityNo" value="${u.utilityNo}" readonly="readonly" class="form-control"></td>
										</tr>
										<tr>
											<td>공용품종류</td>
										    <td>
										        <select name="utilityCategory" class="form-control">
										            <option value="${u.utilityCategory}" selected>${u.utilityCategory}</option>
										            <option value="차량">차량</option>
										            <option value="회의실">회의실</option>
										        </select>
										    </td>
										</tr>
										<tr>
											<td>공용품명</td>
											<td>
												<textarea rows="3" cols="50" name="utilityName" class="form-control">${u.utilityName}</textarea>
												<small id="textHelp_1" class="form-text text-muted"></small>
											</td>
										</tr>
										<tr>
											<td>공용품내용</td>
											<td>
												<textarea rows="3" cols="50" name="utilityInfo" class="form-control">${u.utilityInfo}</textarea>
												<small id="textHelp_2" class="form-text text-muted"></small>
											</td>
										</tr>
										<tr>
											<td>이미지첨부</td>
											<td>
												<!-- 해당 공용품 번호에 해당하는 저장파일이름이 있다면 그 파일의 오리지널 이름을 보여주겠다. -->
												<c:choose>
													<c:when test="${not empty u.utilitySaveFilename}">
														<p>기존 파일: ${u.utilityOriFilename}</p>
													</c:when>
													<c:otherwise>
														<p>선택된 파일 없음</p>
													</c:otherwise>
												</c:choose>
												<input type="file" name="singlepartFile" class="form-control">
											</td>
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
