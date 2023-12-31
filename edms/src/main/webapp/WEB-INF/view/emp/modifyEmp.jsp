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
	<title>modifyEmp</title>
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
	<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
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
		// 이벤트 스크립트 시작
		$(document).ready(function() {
			
			// 수정 성공 or 실패 결과에 따른 alert
			let result = '${param.result}'; // 수정 성공유무를 url의 매개값으로 전달
			
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('인사정보 수정 실패');
			    alert('인사정보가 수정되지 않았습니다. 다시 시도해주세요.');
			} else if (result == 'success') { // result의 값이 success이면
				console.log('인사정보 수정 성공');
			    alert('인사정보가 수정되었습니다.');
			}
			
			// 상위 카테고리 선택에 따른 하위 카테고리 선택${pageContext.request.contextPath} 보류중
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('사원목록으로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/emp/empList'; // empList로 이동
				}
			});
		});
	</script>
	
	<style>
		.card-title {
            text-align: center;
        }
        /* 취소, 저장 왼/오른쪽 정렬 */
        #cancelBtn {
		    float: left;
		}
		
		#saveBtn {
		    float: right;
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
			                   <a class="nav-link active" href="${pageContext.request.contextPath}/emp/modifyEmp?empNo=${emp.empNo}">인사정보</a>
			               </li>
			               <li class="nav-item">
			                   <a class="nav-link" href="${pageContext.request.contextPath}/emp/adminMemberOne?empNo=${emp.empNo}">개인정보</a>
			               </li>
			               <li class="nav-item">
			                   <a class="nav-link" href="${pageContext.request.contextPath}/vacation/vacationHistory?empNo=${emp.empNo}">휴가정보</a>
			               </li>
			           </ul>
			       </div>
			   </nav>
		  	<br>
		  	<div class="row">
            	<div class="col-8">
                	<div class="card">
                		<div class="card-body">
                		<h3 class="card-title center">인사정보 수정</h3>
                        <h6 class="card-subtitle"></h6>
                        <h6 class="card-title mt-5"><i
                                        class="me-1 font-18 mdi mdi-numeric-1-box-multiple-outline"></i></h6>
                        <div class="table-responsive">
                        	<form action="/emp/modifyEmp" method="post">
								<input type="hidden" name="empNo" value="${emp.empNo}">
								<table class="table">
									<tr>
										<td>사원번호</td>
										<td>
											${emp.empNo} <!-- 수정 불가, 단순 출력 -->
										</td>
									</tr>
									<tr>
										<td>사원명</td>
										<td>
											<input type="text" name="empName" value="${emp.empName}" class="form-control">
										</td>
									</tr>
									<tr>
										<td>부서명</td>
										<td>
											<select name="deptName" class="form-control">
												<option value="" <c:if test="${emp.deptName.equals('')}">selected</c:if>>없음</option>
												<c:forEach var="d" items="${deptList}">
													<option value="${d.deptName}" <c:if test="${emp.deptName.equals(d.deptName)}">selected</c:if>>${d.deptName}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td>팀명</td>
										<td>
											<select name="teamName" class="form-control">
												<option value="" <c:if test="${emp.teamName.equals('')}">selected</c:if>>없음</option>
												<c:forEach var="t" items="${teamList}">
													<option value="${t.teamName}" <c:if test="${emp.teamName.equals(t.teamName)}">selected</c:if>>${t.teamName}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td>직급</td>
										<td>
											<select name="empPosition" class="form-control">
												<option value="CEO" <c:if test="${emp.empPosition.equals('CEO')}">selected</c:if>>CEO</option>
												<option value="부서장" <c:if test="${emp.empPosition.equals('부서장')}">selected</c:if>>부서장</option>
												<option value="팀장" <c:if test="${emp.empPosition.equals('팀장')}">selected</c:if>>팀장</option>
												<option value="부팀장" <c:if test="${emp.empPosition.equals('부팀장')}">selected</c:if>>부팀장</option>
												<option value="사원" <c:if test="${emp.empPosition.equals('사원')}">selected</c:if>>사원</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>권한</td>
										<td>
											<select name="accessLevel" class="form-control">
												<option value="0" <c:if test="${emp.accessLevel.equals('0')}">selected</c:if>>0레벨</option>
												<option value="1" <c:if test="${emp.accessLevel.equals('1')}">selected</c:if>>1레벨</option>
												<option value="2" <c:if test="${emp.accessLevel.equals('2')}">selected</c:if>>2레벨</option>
												<option value="3" <c:if test="${emp.accessLevel.equals('3')}">selected</c:if>>3레벨</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>재직사항</td>
										<td>
											<select name="empState" class="form-control">
												<option value="재직" <c:if test="${emp.empState.equals('재직')}">selected</c:if>>재직</option>
												<option value="퇴직" <c:if test="${emp.empState.equals('퇴직')}">selected</c:if>>퇴직</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>입사일</td>
										<td>
											<input type="date" name="employDate" value="${emp.employDate}" class="form-control">
										</td>
									</tr>
									<tr>
										<td>퇴사일</td>
										<td>
											<input type="date" name="employDate" value="${emp.retirementDate}" class="form-control">
										</td>
									</tr>
									<tr>
										<td>등록일</td>
										<td>
											${emp.createdate} <!-- 수정 불가, 단순 출력 -->
										</td>
									</tr>
									<tr>
										<td>수정일</td>
										<td>
											${emp.updatedate} <!-- 수정 불가, 단순 출력 -->
										</td>
									</tr>
								</table>
								<button type="button" class="btn waves-effect waves-light btn-outline-dark" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
								<button type="submit" class="btn waves-effect waves-light btn-outline-dark" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
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