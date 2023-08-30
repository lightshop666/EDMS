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
	<title>salesDraft</title>
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
	<!-- 공통 함수를 불러옵니다. -->
	<script src="/draftFunction.js"></script>
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
		// 사원 목록 배열로 받는 변수 선언 (JSON)
		let employeeListJson = ${employeeListJson};
		
		// 유효성 검사 함수
		function validateInputs() {
			let isValid = true;
			
			// 수정예정..
			
			return isValid;
		}
		
		// 이벤트 스크립트 시작
		$(document).ready(function() {
			// 페이지 로드 후 서명 이미지 조회 메서드 실행
			alertAndRedirectIfNoSign(); // 공통 함수
			
			// 기안 실패시 alert
			let result = '${param.result}'; // 기안 성공유무를 url의 매개값으로 전달
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('매출보고서 기안 실패');
			    alert('매출보고서가 기안되지 않았습니다. 다시 시도해주세요.');
			}
			
			// 모달창에서 중간승인자 저장 버튼 클릭시
			$('#saveMediateBtn').click(function() {
				setMediateApproval(); // 공통 함수 호출
			});
			
			// 모달창에서 최종승인자 저장 버튼 클릭시
			$('#saveFinalBtn').click(function() {
				setFinalApproval(); // 공통 함수 호출
			});
			
			// 모달창에서 수신참조자 저장 버튼 클릭시
			$('#saveReceiveBtn').click(function() {
				setRecipients(); // 공통 함수 호출
			});
			
			// 임시저장 버튼 클릭시
			$('#saveBtn').click(function() {
				setDraftSave(); // 공통 함수 호출
			});
			
			// 저장 버튼 클릭시
			$('#submitBtn').click(function() {
				setDraftSubmit(); // 공통 함수 호출
			});
			
			// 취소 버튼 클릭시
			$('#cancelBtn').click(function() {
				let result = confirm('작성중인 내용이 모두 사라집니다. 정말 취소하시겠습니까?');
				if (result) {
					location.reload(); // 현재 페이지 새로고침
				}
			});
			
			// 내역 추가
			$('#addDetailBtn').click(function() { // + 버튼 클릭시 이벤트 발생
				let newRow = `
					<tr>
						<td>
							<select name="productCategory" required>
								<option value="스탠드">스탠드</option>
								<option value="무드등">무드등</option>
								<option value="실내조명">실내조명</option>
								<option value="실외조명">실외조명</option>
								<option value="포인트조명">포인트조명</option>
							</select>
						</td>
						<td><input type="number" name="previousSales[]" required></td>
						<td><input type="number" name="currentSalse[]" required></td>
						<td><input type="number" name="targetSales[]" required></td>
						<td><input type="number" name="targetRate[]" required></td>
						<td><button type="button" class="removeDetailBtn">-</button></td> <!-- id명 수정 핊요 -->
					</tr>
				`;
				$('#detailsTable').append(newRow); // 테이블에 내역(newRow) 추가
			});
			
			// 내역 제거
			$(document).on('click', '.removeDetailBtn', function() {
			    $(this).closest("tr").remove();
			});
		});
	</script>
	
	<!-- 테이블 스타일 추가 -->
	<style>
	    table {
	        border-collapse: collapse;
	        width: 100%;
	        border: 1px solid black;
	        text-align: center; /* 셀 내 텍스트 가운데 정렬 */
	    }
	    th, td {
	        border: 1px solid black;
	        padding: 8px;
	    }
	    input[type="text"], textarea {
	        width: 100%; /* input 요소와 textarea 요소가 셀의 너비에 맞게 꽉 차도록 설정 */
	        box-sizing: border-box; /* 내부 패딩과 경계선을 포함하여 너비 계산 */
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

			<div class="container pt-5">
				<h1 style="text-align: center;">매출보고서</h1>
				<!-- 공통 함수를 사용하기 위해 id명 draftForm로 지정 필요 -->
				<form action="/draft/salesDraft" method="post" id="draftForm">
					<input type="hidden" name="empNo" value="${empNo}">
					<table class="table-bordered">
						<tr>
							<th rowspan="3" colspan="2">매출보고서</th>
							<th rowspan="3">결재</th>
							<th>기안자</th>
							<th>중간승인자</th>
							<th>최종승인자</th>
						</tr>
						<tr>
							<td> 
								<c:if test="${sign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
									<img src="${sign.memberPath}${sign.memberSaveFileName}.${sign.memberFiletype}">
								</c:if>
								<input type="hidden" name="firstApproval" value="${empNo}"> <!-- 기안자 정보 hidden 주입 -->
							</td>
							<td>
								<span id="mediateSpan"></span> <!-- 모달에서 선택된 중간승인자 출력 -->
								<input type="hidden" name="mediateApproval" id="mediateHidden">
							</td>
							<td>
								<span id="finalSpan"></span> <!-- 모달에서 선택된 최종승인자 출력 -->
								<input type="hidden" name="finalApproval" id="finalHidden">
							</td>
						</tr>
						<tr>
							<td>
								${empName}_${deptName}_${empPosition}
							</td>
							<td>
								<button type="button" data-bs-toggle="modal" data-bs-target="#mediateModal" class="btn btn-secondary">
									검색 <!-- 중간승인자 검색 모달 버튼 -->
								</button>
							</td>
							<td>
								<button type="button" data-bs-toggle="modal" data-bs-target="#finalModal" class="btn btn-secondary">
									검색 <!-- 최종승인자 검색 모달 버튼 -->
								</button>
							</td>
						</tr>
						<tr>
							<th>
								수신참조자
								<button type="button" data-bs-toggle="modal" data-bs-target="#receiveModal" class="btn btn-secondary">
									검색 <!-- 수신참조자 검색 모달 버튼 -->
								</button>
							</th>
							<td colspan="5">
								<span id="receiveSpan"></span> <!-- 모달에서 선택된 수신참조자 출력 -->
								<input type="hidden" name="recipients" id="receiveHidden"> <!-- int 배열 -->
							</td>
						</tr>
						<tr>
							<th>성명</th>
							<td>${empName}</td>
							<th>부서</th>
							<td>${deptName}</td>
							<th>기준년월</th>
							<td>
								<select name="salesDate"> <!-- 전전월, 전월, 당월 출력 예정.. -->
									<option>YYYY년 MM월</option>
									<option>YYYY년 MM월</option>
									<option>YYYY년 MM월</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>제목</th>
							<td colspan="5">
								<input type="text" name="docTitle" placeholder="ex) 매출 보고서 - YYYY-MM-DD" id="docTitle">
							</td>
						</tr>
						<tr>
							<th>내역</th>
							<td colspan="5">
								<table id="detailsTable" class="table-bordered">
									<tr>
										<th>상품 카테고리</th>
										<th>전월매출액</th> <!-- 조회해서 뿌려줄지..? -->
										<th>당월매출액</th>
										<th>목표액</th>
										<th>목표달성률</th> <!-- 동적으로 계산 예정.. -->
										<th><button type="button" id="addDetailBtn">+</button></th>
									</tr>
									<!-- 내역 항목 -->
									<tr>
										<td>
											<select name="productCategory" required>
												<option value="스탠드">스탠드</option>
												<option value="무드등">무드등</option>
												<option value="실내조명">실내조명</option>
												<option value="실외조명">실외조명</option>
												<option value="포인트조명">포인트조명</option>
											</select>
										</td>
										<td><input type="number" name="previousSales[]" required></td>
										<td><input type="number" name="currentSalse[]" required></td>
										<td><input type="number" name="targetSales[]" required></td>
										<td><input type="number" name="targetRate[]" required></td>
										<td><button type="button" class="removeDetailBtn">-</button></td>
									</tr>
									
								</table>
							</td>
						</tr>
						<tr>
							<th>파일첨부</th>
							<td colspan="5">
								<input type="file" name="documentFile"> <!-- 파일 첨부 예정.. -->
							</td>
						</tr>
						<tr>
							<th colspan="6">
								위와 같이 결재바랍니다. <br>
								${year}년 ${month}월 ${day}일
							</th>
						</tr>
					</table>
					<button type="button" id="cancelBtn" class="btn btn-secondary">취소</button>
					<button type="button" id="saveBtn" class="btn btn-secondary">임시저장</button>
					<button type="button" id="submitBtn" class="btn btn-secondary">저장</button>
				</form>
			</div>
			
			<!-- 모달창 시작 -->
			
			<!-- 중간승인자 검색 모달 -->
			<div class="modal" id="mediateModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="primary-header-modalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<!-- 모달 헤더 -->
						<div class="modal-header modal-colored-header bg-primary">
							<h4 class="modal-title">중간승인자 선택</h4>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button> <!-- x버튼 -->
						</div>
						<!-- 모달 본문 -->
						<div class="modal-body">
							<table class="table-bordered">
								<tr>
									<th>선택</th>
									<th>사원번호</th>
									<th>성명</th>
									<th>부서명</th>
									<th>직급명</th>
								</tr>
								<c:forEach var="employee" items="${employeeList}">
									<tr>
										<td>
											<input type="radio" value="${employee.empNo}" name="modalMediateApproval">
										</td>
										<td>
											${employee.empNo}
										</td>
										<td>
											${employee.empName}
										</td>
										<td>
											${employee.deptName}
										</td>
										<td>
											${employee.empPosition}
										</td>
									</tr>
								</c:forEach>
							</table>
						</div>
						<!-- 모달 푸터 -->
						<div class="modal-footer">
							<button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
							<button type="button" class="btn btn-primary" id="saveMediateBtn" data-bs-dismiss="modal">저장</button>
						</div>
					</div>
				</div>
			</div>
			<!-- 중간승인자 검색 모달 끝 -->
			
			<!-- 최종승인자 검색 모달 -->
			<div class="modal" id="finalModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="primary-header-modalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<!-- 모달 헤더 -->
						<div class="modal-header modal-colored-header bg-primary">
							<h4 class="modal-title">최종승인자 선택</h4>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button> <!-- x버튼 -->
						</div>
						<!-- 모달 본문 -->
						<div class="modal-body">
							<table class="table-bordered">
								<tr>
									<th>선택</th>
									<th>사원번호</th>
									<th>성명</th>
									<th>부서명</th>
									<th>직급명</th>
								</tr>
								<c:forEach var="employee" items="${employeeList}">
									<tr>
										<td>
											<input type="radio" value="${employee.empNo}" name="modalFinalApproval">
										</td>
										<td>
											${employee.empNo}
										</td>
										<td>
											${employee.empName}
										</td>
										<td>
											${employee.deptName}
										</td>
										<td>
											${employee.empPosition}
										</td>
									</tr>
								</c:forEach>
							</table>
						</div>
						<!-- 모달 푸터 -->
						<div class="modal-footer">
							<button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
							<button type="button" class="btn btn-primary" id="saveFinalBtn" data-bs-dismiss="modal">저장</button>
						</div>
					</div>
				</div>
			</div>
			<!-- 최종승인자 검색 모달 끝 -->
			
			<!-- 수신참조자 검색 모달 -->
			<div class="modal" id="receiveModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="primary-header-modalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<!-- 모달 헤더 -->
						<div class="modal-header modal-colored-header bg-primary">
							<h4 class="modal-title">수신참조자 선택</h4>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button> <!-- x버튼 -->
						</div>
						<!-- 모달 본문 -->
						<div class="modal-body">
							<table class="table-bordered">
								<tr>
									<th>선택</th>
									<th>사원번호</th>
									<th>성명</th>
									<th>부서명</th>
									<th>직급명</th>
								</tr>
								<c:forEach var="employee" items="${employeeList}">
									<tr>
										<td>
											<input type="checkbox" value="${employee.empNo}" name="modalRecipients">
										</td>
										<td>
											${employee.empNo}
										</td>
										<td>
											${employee.empName}
										</td>
										<td>
											${employee.deptName}
										</td>
										<td>
											${employee.empPosition}
										</td>
									</tr>
								</c:forEach>
							</table>
						</div>
						<!-- 모달 푸터 -->
						<div class="modal-footer">
							<button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
							<button type="button" class="btn btn-primary" id="saveReceiveBtn" data-bs-dismiss="modal">저장</button>
						</div>
					</div>
				</div>
			</div>
			<!-- 수신참조자 검색 모달 끝 -->

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