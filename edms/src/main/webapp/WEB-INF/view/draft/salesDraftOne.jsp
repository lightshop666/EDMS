<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> <!-- 숫자 포맷팅을 위한 라이브러리 추가 -->
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
	<title>salesDraftOne</title>
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
	<!-- 공통 함수를 불러옵니다. -->
	<script src="/draftFunction.js"></script>
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
			
			// 기안 성공시 alert
			let result = '${param.result}'; // 기안 성공유무를 url의 매개값으로 전달
			if (result == 'success') { // result의 값이 success이면
				console.log('매출보고서 기안 성공');
			    alert('매출보고서가 기안되었습니다.');
			} else if (result == 'fail'){
				console.log('결재 업데이트 실패');
			    alert('결재정보 업데이트에 실패하였습니다. 다시 시도해주세요.');
			}
			
			// action 버튼 클릭시 이벤트 발생
			$('.actionBtn').click(function() {
				// 1. 서명 이미지 검사
				alertAndRedirectIfNoSign(); // 공통 함수 호출
				// 2. actionType
				let actionType = $(this).data("actiontype"); // HTML 데이터 속성은 소문자로 표기되기 때문에 대소문자 구분에 주의합니다.
				$('#actionTypeHidden').val(actionType); // hidden에 값 주입
				// 3. approvalReason
				let approvalReason = ''; // 반려사유 기본값
				if (actionType == 'reject') { // 반려 사유 입력 모달창의 저장 버튼 클릭시
					approvalReason = $('#approvalReason').val(); // 반려사유 입력값 가져오기
				}
				$('#approvalReasonHidden').val(approvalReason); // hidden에 값 주입
				// 4. role
				let role = '${approval.role}';
				handleApprovalAction(role, actionType); // 공통 함수 호출
			});
			
			// 수정 버튼 클릭시 이벤트 발생
			// 수정 form 페이지는 양식에 따라 이동하는 페이지가 다르므로 view단에서 페이지를 이동시킵니다.
			$('#modifyBtn').click(function() {
				let result = confirm('수정 페이지로 이동할까요?');
				if (result) {
					// 현재 문서의 문서번호 값
					let approvalNo = ${approval.approvalNo};
					window.location.href = "/draft/modifySalesDraft?approvalNo=" + approvalNo;
				}
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
		
			<!-- 모델값 변수에 할당 -->
			<c:set var="a" value="${approval}"></c:set>
			<c:set var="r" value="${receiveList}"></c:set>
			<c:set var="df" value="${documentFileList}"></c:set>
			<c:set var="s" value="${salesDraft}"></c:set>
			<c:set var="sc" value="${salesDraftContentList}"></c:set>
			<c:set var="m" value="${memberSignMap}"></c:set>
			<!--------------------->
			<div class="container pt-5">
				<h1 style="text-align: center;">매출보고서</h1>
				<!-- 결재상태 출력 -->
				<c:if test="${a.approvalState == '결재대기'}"> 
					<div class="alert alert-light">결재 대기중인 문서입니다.</div>
				</c:if>
				<c:if test="${a.approvalState == '결재중'}"> 
					<div class="alert alert-warning">결재 진행중인 문서입니다.</div>
				</c:if>
				<c:if test="${a.approvalState == '결재완료'}"> <!-- 결재일 출력 -->
					<div class="alert alert-success">최종 승인일 : ${fn:substring(a.approvalDate, 0, 11)}</div>
				</c:if>
				<c:if test="${a.approvalState == '반려'}"> <!-- 반려사유 출력 -->
					<div class="alert alert-danger">반려 사유 : ${a.approvalReason}</div>
				</c:if>
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
							<c:if test="${m.firstSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
								<img src="${m.firstSign.memberPath}${m.firstSign.memberSaveFileName}">
							</c:if>
						</td>
						<td>
							<c:if test="${m.mediateSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
								<img src="${m.mediateSign.memberPath}${m.mediateSign.memberSaveFileName}">
							</c:if>
						</td>
						<td>
							<c:if test="${m.finalSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
								<img src="${m.finalSign.memberPath}${m.finalSign.memberSaveFileName}">
							</c:if>
						</td>
					</tr>
					<tr>
						<td>
							${a.firstEmpName}_${a.firstDeptName}_${a.firstEmpPosition}
						</td>
						<td>
							${a.mediateEmpName}_${a.mediateDeptName}_${a.mediateEmpPosition}
						</td>
						<td>
							${a.finalEmpName}_${a.finalDeptName}_${a.finalEmpPosition}
						</td>
					</tr>
					<tr>
						<th>
							수신참조자
						</th>
						<td colspan="5">
							<c:if test="${r != null}"> <!-- 수신참조자 테이블 리스트가 존재하면 -->
								<c:forEach var="r" items="${r}" varStatus="status">
									<!-- varStatus 속성으로 현재 반복문의 상태를 알 수 있습니다. -->
									<!-- varStatus.last로 현재 항목이 마지막 항복인지 여부를 알 수 있습니다. -->
									<!-- 마지막 항목일 경우에는 쉼표를 출력하지 않습니다. -->
									${r.receiveEmpName}_${r.receiveDeptName}_${r.receiveEmpPosition}<c:if test="${!status.last}">, </c:if>
								</c:forEach>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>성명</th>
						<td>${a.firstEmpName}</td>
						<th>부서</th>
						<td>${a.firstDeptName}</td>
						<th>기준년월</th>
						<td>
							${s.salesDate}
						</td>
					</tr>
					<tr>
						<th>제목</th>
						<td colspan="5">
							${s.docTitle}
						</td>
					</tr>
					<tr>
						<th>내역</th>
						<td colspan="5">
							<table class="table-bordered">
								<tr>
									<th>상품 카테고리</th>
									<th>목표액</th>
									<th>매출액</th>
									<th>목표달성률</th> 
								</tr>
								<!-- 내역 항목 -->
								<c:forEach var="sc" items="${sc}">
									<tr>
										<td>
											${sc.productCategory}
										</td>
										<td>
											<!-- JSTL의 formatNumber 태그를 이용하여 숫자를 포맷팅할 수 있습니다.
												 또한, pattern 속성을 이용하여 원하는 형식을 지정할 수 있습니다. -->
											<fmt:formatNumber value="${sc.targetSales}" type="number" pattern="₩#,###"></fmt:formatNumber>
										</td>
										<td>
											<fmt:formatNumber value="${sc.currentSales}" type="number" pattern="₩#,###"></fmt:formatNumber>
										</td>
										<td>
											<!-- 소숫점 둘째자리까지만 출력 -->
											<fmt:formatNumber value="${sc.targetRate * 100}" type="number" pattern="#,##0.00"></fmt:formatNumber>%
										</td>
									</tr>
								</c:forEach>
							</table>
						</td>
					</tr>
					<tr>
						<th>파일첨부</th>
						<td colspan="5">
							<c:if test="${df.size() != 0}"> <!-- 파일을 등록했을 경우 -->
								<c:forEach var="df" items="${df}">
									<div>
										${df.docOriFilename}
										<a href="${df.docPath}${df.docSaveFilename}" target="_blank">
											미리보기
										</a>
										<a href="${df.docPath}${df.docSaveFilename}" download="${df.docOriFilename}">
											다운로드
										</a>
									</div>
								</c:forEach>
							</c:if>
							<c:if test="${df.size() == 0}"> <!-- 등록한 파일이 없을 경우 -->
								첨부된 파일이 없습니다
							</c:if>
						</td>
					</tr>
					<tr>
						<th colspan="6">
							위와 같이 결재바랍니다. <br>
							<!-- 기안일자에서 년,월,일을 추출하기 위해 substring 사용 -->
							${fn:substring(s.updatedate, 0, 4)}년 ${fn:substring(s.updatedate, 5, 7)}월 ${fn:substring(s.updatedate, 8, 10)}일
						</th>
					</tr>
				</table>
				<!-- 목록 버튼 --> <!-- 왼쪽 정렬 -->
				<button type="button" data-actiontype="list" class="actionBtn btn btn-secondary">목록</button>
				<!-- 버튼 분기 --> <!-- 오른쪽 정렬 -->
				<c:if test="${a.approvalField == 'A' && a.approvalState != '반려'}"> <!-- 결재대기 -->
					<c:if test="${a.role == '기안자'}">
						<button type="button" id="modifyBtn" class="btn btn-secondary">수정</button> <!-- 수정 페이지는 양식에 따라 다르므로 view단에서 분기합니다. -->
						<button type="button" data-actiontype="cancel" class="actionBtn btn btn-secondary">기안취소</button>
					</c:if>
					<c:if test="${a.role == '중간승인자' || a.role == '중간 및 최종승인자'}">
						<button type="button" data-actiontype="approve" class="actionBtn btn btn-secondary">승인</button>
						<!-- 반려 사유 입력 모달 열림 -->
						<button type="button" data-bs-toggle="modal" data-bs-target="#rejectModal" class="btn btn-secondary">반려</button>
					</c:if>
				</c:if>
				<c:if test="${a.approvalField == 'B'}"> <!-- 결재중 -->
					<c:if test="${a.role == '중간승인자'}">
						<button type="button" data-actiontype="CancelApprove" class="actionBtn btn btn-secondary">승인취소</button>
						<!-- 반려 사유 입력 모달 열림 -->
						<button type="button" data-bs-toggle="modal" data-bs-target="#rejectModal" class="btn btn-secondary">반려</button>
					</c:if>
					<c:if test="${a.role == '최종승인자'}">
						<button type="button" data-actiontype="approve" class="actionBtn btn btn-secondary">승인</button>
						<!-- 반려 사유 입력 모달 열림 -->
						<button type="button" data-bs-toggle="modal" data-bs-target="#rejectModal" class="btn btn-secondary">반려</button>
					</c:if>
					<c:if test="${a.role == '중간 및 최종승인자'}">
						<button type="button" data-actiontype="CancelApprove" class="actionBtn btn btn-secondary">승인취소</button>
						<button type="button" data-actiontype="approve" class="actionBtn btn btn-secondary">승인</button>
						<!-- 반려 사유 입력 모달 열림 -->
						<button type="button" data-bs-toggle="modal" data-bs-target="#rejectModal" class="btn btn-secondary">반려</button>
					</c:if>
				</c:if>
				<c:if test="${a.approvalField == 'C'}"> <!-- 결재완료 -->
					<c:if test="${a.role == '최종승인자' || a.role == '중간 및 최종승인자'}">
						<button type="button" data-actiontype="CancelApprove" class="actionBtn btn btn-secondary">승인취소</button>
						<!-- 반려 사유 입력 모달 열림 -->
						<button type="button" data-bs-toggle="modal" data-bs-target="#rejectModal" class="btn btn-secondary">반려</button>
					</c:if>
				</c:if>
				<!-- hidden input -->
				<form action="/draft/updateApprovalState" method="post" id="DraftOneForm">
					<input type="hidden" name="documentCategory" value="매출보고서">
					<input type="hidden" name="approvalNo" value="${a.approvalNo}">
					<input type="hidden" name="role" value="${a.role}">
					<input type="hidden" name="approvalField" value="${a.approvalField}">
					<input type="hidden" name="actionType" id="actionTypeHidden">
					<input type="hidden" name="approvalReason" id="approvalReasonHidden">
				</form>
			</div>
			
			<!-- 모달창 시작 -->
			
			<!-- 반려사유 입력 모달 -->
			<div class="modal" id="rejectModal">
				<div class="modal-dialog">
					<div class="modal-content">
						<!-- 모달 헤더 -->
						<div class="modal-header">
							<h4 class="modal-title">반려 사유 입력</h4>
							<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
						</div>
						<!-- 모달 본문 -->
						<div class="modal-body">
							<textarea rows="8" cols="70" id="approvalReason" placeholder="이곳에 반려 사유를 입력해주세요."></textarea>
						</div>
						<!-- 모달 푸터 -->
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
							<button type="button" class="actionBtn btn btn-secondary" data-actiontype="reject" data-bs-dismiss="modal">저장</button>
						</div>
					</div>
				</div>
			</div>
			<!-- 반려사유 입력 모달 끝 -->
	
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