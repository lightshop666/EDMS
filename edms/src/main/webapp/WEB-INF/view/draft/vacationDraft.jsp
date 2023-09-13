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
	<title>vacationDraft</title>
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
		// 사원 목록 배열로 받는 변수 선언 (JSON)
		let employeeListJson = ${employeeListJson};
		
		// 유효성 검사 함수
		function validateInputs() {
			let isValid = true;
			
			// 각 input 입력값 가져오기 // 수신참조는 필수값이 아니므로 제외합니다.
			let mediateHidden = $('#mediateHidden').val();
			let finalHidden = $('#finalHidden').val();
			let vacationName = $('input[name="vacationName"]:checked').val();
			let vacationStart = $('#vacationStart').val();
			let phoneNumber = $('#phoneNumber').val();
			let docTitle = $('#docTitle').val();
			let docContent = $('#docContent').val();
			
			// 각 입력값 검사 시작
			if (mediateHidden == '') {
				alert('중간승인자를 선택해주세요.');
				isValid = false;
				return isValid;
			}
			if (finalHidden == '') {
				alert('최종승인자를 선택해주세요.');
				isValid = false;
				return isValid;
			}
			if (vacationName == undefined) {
				alert('휴가종류를 선택해주세요.');
				isValid = false;
				return isValid;
			}
			if (vacationStart == '') {
				alert('휴가 시작일을 선택해주세요.');
				isValid = false;
				return isValid;
			}
			// 선택한 휴가 종류가 반차라면 시간을 추가로 검사합니다.
			if (vacationName == '반차') {
				let vacationTime = $('input[name="vacationTime"]:checked').val();
				if (vacationTime == undefined) {
					alert('반차 휴가를 사용할 시간을 선택해주세요.');
					isValid = false;
					return isValid;
				}
			}
			if (phoneNumber == '') {
				alert('비상연락망을 작성해주세요.');
				isValid = false;
				return isValid;
			}
			if (docTitle == '') {
				alert('제목을 작성해주세요.');
				isValid = false;
				return isValid;
			}
			if (docContent == '') {
				alert('사유를 작성해주세요.');
				isValid = false;
				return isValid;
			}
			
			return isValid;
		}
		function getSearchParam() {
			// 사용자가 모달 창 내에서 선택한 검색 조건을 가져옵니다.
			  let ascDesc = $('select[name="ascDesc"]').val();
			  let deptName = $('select[name="deptName"]').val();
			  let teamName = $('select[name="teamName"]').val();
			  let empPosition = $('select[name="empPosition"]').val();
			  let searchCol = $('select[name="searchCol"]').val();
			  let searchWord = $('input[name="searchWord"]').val();

			  // 가져온 검색 조건을 객체로 만듭니다.
			  let param = {
			    ascDesc: ascDesc,
			    deptName: deptName,
			    teamName: teamName,
			    empPosition: empPosition,
			    searchCol: searchCol,
			    searchWord: searchWord
			  };
			  
			  return param;
		}
		
		// 이벤트 스크립트 시작
		$(document).ready(function() {
			// 페이지 로드 후 서명 이미지 조회 메서드 실행
			alertAndRedirectIfNoSign(); // 공통 함수
			
			// 기안 실패시 alert
			let result = '${param.result}'; // 기안 성공유무를 url의 매개값으로 전달
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('휴가신청서 기안 실패');
			    alert('휴가신청서가 기안되지 않았습니다. 다시 시도해주세요.');
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
			
			// 휴가 종류 선택시
			$("input[name='vacationName']").change(function() {
				let vacationName = $(this).val(); // 선택한 휴가 종류
				getRemainDaysByVacationName(vacationName); // 공통 함수 호출 (AJAX)
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
			
			// 검색 조건에 따른 사원 목록 모달창에 출력
			let currentPage = 1;
			// 중간승인자 모달
			$('.getEmpInfoListBtnForMediate').click(function() {
				  // 검색 함수 호출
				  getEmpInfoListByPageForModalMediateApproval(getSearchParam());
			});
			// 최종승인자 모달
			$('.getEmpInfoListBtnForFinal').click(function() {
				  // 검색 함수 호출
				  getEmpInfoListByPageForModalFinalApproval(getSearchParam());
			});
			// 수신참조자 모달
			$('.getEmpInfoListBtnForRecipients').click(function() {
				  // 검색 함수 호출
				  getEmpInfoListByPageForModalRecipients(getSearchParam());
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
			                   <a class="nav-link" href="${pageContext.request.contextPath}/draft/basicDraft">기안서</a>
			               </li>
			               <li class="nav-item">
			                   <a class="nav-link" href="${pageContext.request.contextPath}/draft/expenseDraft">지출결의서</a>
			               </li>
			               <li class="nav-item">
			                   <a class="nav-link" href="${pageContext.request.contextPath}/draft/salesDraft">매출보고서</a>
			               </li>
			               <li class="nav-item">
			                   <a class="nav-link active" href="${pageContext.request.contextPath}/draft/vacationDraft">휴가신청서</a>
			               </li>
			           </ul>
			       </div>
			   </nav>
		   <br>
			<div class="container pt-5">
				<h1 style="text-align: center;">휴가신청서 작성</h1> <br>
				<!-- 공통 함수를 사용하기 위해 id명 draftForm로 지정 필요 -->
				<form action="/draft/vacationDraft" method="post" id="draftForm">
					<input type="hidden" name="empNo" value="${empNo}">
					<table class="table-bordered">
						<tr>
							<th rowspan="3" colspan="2">휴가신청서</th>
							<th rowspan="3">결재</th>
							<th>기안자</th>
							<th>중간승인자</th>
							<th>최종승인자</th>
						</tr>
						<tr>
							<td> 
								<c:if test="${sign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
									<img src="${sign.memberPath}${sign.memberSaveFileName}">
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
								<button type="button" data-bs-toggle="modal" data-bs-target="#mediateModal" class="btn btn-secondary getEmpInfoListBtnForMediate">
									검색 <!-- 중간승인자 검색 모달 버튼 -->
								</button>
							</td>
							<td>
								<button type="button" data-bs-toggle="modal" data-bs-target="#finalModal" class="btn btn-secondary getEmpInfoListBtnForFinal">
									검색 <!-- 최종승인자 검색 모달 버튼 -->
								</button>
							</td>
						</tr>
						<tr>
							<th>
								수신참조자
								<button type="button" data-bs-toggle="modal" data-bs-target="#receiveModal" class="btn btn-secondary getEmpInfoListBtnForRecipients">
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
							<th>휴가종류</th>
							<td>
								<input type="radio" name="vacationName" value="반차">반차
								<input type="radio" name="vacationName" value="연차">연차
								<input type="radio" name="vacationName" value="보상">보상
							</td>
						</tr>
						<tr><!-- 휴가종류 선택에 따라 남은 휴가 일수를 동적으로 출력 -->
							<th>잔여 휴가 일수</th>
							<td>
								<!-- ajax 방식으로 남은 휴가 일수 출력 -->
								<span id="remainDays"></span>
							</td>
							<th>기간</th>
							<td colspan="3">
								<!-- 선택한 휴가 종류와 잔여 휴가 일수에 따라 기간 선택 태그 출력 -->
								<div id="vacationInput"></div>
							</td>
						</tr>
						<tr>
							<th>비상연락망</th>
							<td colspan="5">
								<input type="text" name="phoneNumber" placeholder="ex) 010-1234-5678" id="phoneNumber">
							</td>
						</tr>
						<tr>
							<th>제목</th>
							<td colspan="5">
								<input type="text" name="docTitle" placeholder="ex) 휴가 신청합니다 - 연차" id="docTitle">
							</td>
						</tr>
						<tr>
							<th>사유</th>
							<td colspan="5">
								<!-- 웹에디터를 넣을지 고민! -->
								<textarea rows="8" cols="70" name="docContent" placeholder="ex) 개인사정으로 인하여 연차 사용을 신청합니다." id="docContent"></textarea>
							</td>
						</tr>
						<tr>
							<th colspan="6">
								위와 같이 휴가를 신청하오니, 결재 바랍니다. <br>
								${year}년 ${month}월 ${day}일
							</th>
						</tr>
					</table>
					<button type="button" id="cancelBtn" class="btn btn-secondary">취소</button>
					<button type="button" id="saveBtn" class="btn btn-secondary">임시저장</button>
					<button type="button" id="submitBtn" class="btn btn-primary">저장</button>
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
							<!-- 검색조건 -->
							<div class="sort-area" style="display: flex; align-items: center;">
						    	<div class="form-group" style="width: 100px;">
						        	<label class="sort-label">정렬</label>
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
							        직급
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
							        <select name="ascDesc" class="form-control">
							            <option value="ASC" ${ascDesc eq 'ASC' ? 'selected' : ''}>오름차순</option>
							            <option value="DESC" ${ascDesc eq 'DESC' ? 'selected' : ''}>내림차순</option>
							        </select>
						        </div>
						    </div> <br>
						    <div class="sort-area" style="display: flex; align-items: center;">		    
							    <div class="form-group" style="width: 90px;">
						        	<label class="sort-label">부서</label>
						        </div>
						        <div class="form-group" style="width: 150px; margin-left: 30px; margin-right: 20px;">
								    <select name="deptName" class="form-control">
								        <option value="" <c:if test="${param.deptName.equals('')}">selected</c:if>>전체</option>
								        <option value="사업추진본부" <c:if test="${param.deptName.equals('사업추진본부')}">selected</c:if>>사업추진본부</option>
								        <option value="경영지원본부" <c:if test="${param.deptName.equals('경영지원본부')}">selected</c:if>>경영지원본부</option>
								        <option value="영업지원본부" <c:if test="${param.deptName.equals('영업지원본부')}">selected</c:if>>영업지원본부</option>
								    </select>
							    </div>
							    
							    <div class="form-group" style="width: 90px; margin-left: 30px;">
						        	<label class="sort-label">팀</label>
						        </div>
						        <div class="form-group" style="width: 150px;">
									<select name="teamName" class="form-control">
									    <option value="" <c:if test="${param.teamName.equals('')}">selected</c:if>>전체</option>
									    <option value="기획팀" <c:if test="${param.teamName.equals('기획팀')}">selected</c:if>>기획팀</option>
									    <option value="경영팀" <c:if test="${param.teamName.equals('경영팀')}">selected</c:if>>경영팀</option>
									    <option value="영업팀" <c:if test="${param.teamName.equals('영업팀')}">selected</c:if>>영업팀</option>
									</select>
							    </div>
							    
							    <div class="form-group" style="width: 90px; margin-left: 30px;">
						        	<label class="sort-label">직급</label>
						        </div>
						        <div class="form-group" style="width: 150px;">
									<select name="empPosition" class="form-control">
									    <option value="" <c:if test="${param.empPosition.equals('')}">selected</c:if>>전체</option>
									    <option value="CEO" <c:if test="${param.empPosition.equals('CEO')}">selected</c:if>>CEO</option>
									    <option value="부서장" <c:if test="${param.empPosition.equals('부서장')}">selected</c:if>>부서장</option>
									    <option value="팀장" <c:if test="${param.empPosition.equals('팀장')}">selected</c:if>>팀장</option>
									    <option value="부팀장" <c:if test="${param.empPosition.equals('부팀장')}">selected</c:if>>부팀장</option>
									    <option value="사원" <c:if test="${param.empPosition.equals('사원')}">selected</c:if>>사원</option>
									</select>
								</div>
							</div>
							<div class="search-area" style="display: flex; align-items: center;">
						    	<div class="form-group" style="width: 100px;">
						        	<label class="search-label">검색</label>
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
							        <select name="searchCol" class="form-control">
							            <option value="empNo" ${searchCol eq 'empNo' ? 'selected' : ''}>사원번호</option>
							            <option value="empName" ${searchCol eq 'empName' ? 'selected' : ''}>성명</option>
							        </select>
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
						        	<input type="text" name="searchWord" value="${searchWord}" class="form-control">
						        </div>
						        <button type="button" class="btn waves-effect waves-light btn-outline-dark getEmpInfoListBtnForMediate" style="margin-right: 10px;">적용</button>
						    </div> <br>
							<div id="modalMediateApprovalResult">
							</div>
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
						<!-- 검색조건 -->
							<div class="sort-area" style="display: flex; align-items: center;">
						    	<div class="form-group" style="width: 100px;">
						        	<label class="sort-label">정렬</label>
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
							        직급
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
							        <select name="ascDesc" class="form-control">
							            <option value="ASC" ${ascDesc eq 'ASC' ? 'selected' : ''}>오름차순</option>
							            <option value="DESC" ${ascDesc eq 'DESC' ? 'selected' : ''}>내림차순</option>
							        </select>
						        </div>
						    </div> <br>
						    <div class="sort-area" style="display: flex; align-items: center;">		    
							    <div class="form-group" style="width: 90px;">
						        	<label class="sort-label">부서</label>
						        </div>
						        <div class="form-group" style="width: 150px; margin-left: 30px; margin-right: 20px;">
								    <select name="deptName" class="form-control">
								        <option value="" <c:if test="${param.deptName.equals('')}">selected</c:if>>전체</option>
								        <option value="사업추진본부" <c:if test="${param.deptName.equals('사업추진본부')}">selected</c:if>>사업추진본부</option>
								        <option value="경영지원본부" <c:if test="${param.deptName.equals('경영지원본부')}">selected</c:if>>경영지원본부</option>
								        <option value="영업지원본부" <c:if test="${param.deptName.equals('영업지원본부')}">selected</c:if>>영업지원본부</option>
								    </select>
							    </div>
							    
							    <div class="form-group" style="width: 90px; margin-left: 30px;">
						        	<label class="sort-label">팀</label>
						        </div>
						        <div class="form-group" style="width: 150px;">
									<select name="teamName" class="form-control">
									    <option value="" <c:if test="${param.teamName.equals('')}">selected</c:if>>전체</option>
									    <option value="기획팀" <c:if test="${param.teamName.equals('기획팀')}">selected</c:if>>기획팀</option>
									    <option value="경영팀" <c:if test="${param.teamName.equals('경영팀')}">selected</c:if>>경영팀</option>
									    <option value="영업팀" <c:if test="${param.teamName.equals('영업팀')}">selected</c:if>>영업팀</option>
									</select>
							    </div>
							    
							    <div class="form-group" style="width: 90px; margin-left: 30px;">
						        	<label class="sort-label">직급</label>
						        </div>
						        <div class="form-group" style="width: 150px;">
									<select name="empPosition" class="form-control">
									    <option value="" <c:if test="${param.empPosition.equals('')}">selected</c:if>>전체</option>
									    <option value="CEO" <c:if test="${param.empPosition.equals('CEO')}">selected</c:if>>CEO</option>
									    <option value="부서장" <c:if test="${param.empPosition.equals('부서장')}">selected</c:if>>부서장</option>
									    <option value="팀장" <c:if test="${param.empPosition.equals('팀장')}">selected</c:if>>팀장</option>
									    <option value="부팀장" <c:if test="${param.empPosition.equals('부팀장')}">selected</c:if>>부팀장</option>
									    <option value="사원" <c:if test="${param.empPosition.equals('사원')}">selected</c:if>>사원</option>
									</select>
								</div>
							</div>
							<div class="search-area" style="display: flex; align-items: center;">
						    	<div class="form-group" style="width: 100px;">
						        	<label class="search-label">검색</label>
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
							        <select name="searchCol" class="form-control">
							            <option value="empNo" ${searchCol eq 'empNo' ? 'selected' : ''}>사원번호</option>
							            <option value="empName" ${searchCol eq 'empName' ? 'selected' : ''}>성명</option>
							        </select>
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
						        	<input type="text" name="searchWord" value="${searchWord}" class="form-control">
						        </div>
						        <button type="button" class="btn waves-effect waves-light btn-outline-dark getEmpInfoListBtnForFinal" style="margin-right: 10px;">적용</button>
						    </div> <br>
							<div id="modalFinalApprovalResult"></div>
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
							<!-- 검색조건 -->
							<div class="sort-area" style="display: flex; align-items: center;">
						    	<div class="form-group" style="width: 100px;">
						        	<label class="sort-label">정렬</label>
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
							        직급
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
							        <select name="ascDesc" class="form-control">
							            <option value="ASC" ${ascDesc eq 'ASC' ? 'selected' : ''}>오름차순</option>
							            <option value="DESC" ${ascDesc eq 'DESC' ? 'selected' : ''}>내림차순</option>
							        </select>
						        </div>
						    </div> <br>
						    <div class="sort-area" style="display: flex; align-items: center;">		    
							    <div class="form-group" style="width: 90px;">
						        	<label class="sort-label">부서</label>
						        </div>
						        <div class="form-group" style="width: 150px; margin-left: 30px; margin-right: 20px;">
								    <select name="deptName" class="form-control">
								        <option value="" <c:if test="${param.deptName.equals('')}">selected</c:if>>전체</option>
								        <option value="사업추진본부" <c:if test="${param.deptName.equals('사업추진본부')}">selected</c:if>>사업추진본부</option>
								        <option value="경영지원본부" <c:if test="${param.deptName.equals('경영지원본부')}">selected</c:if>>경영지원본부</option>
								        <option value="영업지원본부" <c:if test="${param.deptName.equals('영업지원본부')}">selected</c:if>>영업지원본부</option>
								    </select>
							    </div>
							    
							    <div class="form-group" style="width: 90px; margin-left: 30px;">
						        	<label class="sort-label">팀</label>
						        </div>
						        <div class="form-group" style="width: 150px;">
									<select name="teamName" class="form-control">
									    <option value="" <c:if test="${param.teamName.equals('')}">selected</c:if>>전체</option>
									    <option value="기획팀" <c:if test="${param.teamName.equals('기획팀')}">selected</c:if>>기획팀</option>
									    <option value="경영팀" <c:if test="${param.teamName.equals('경영팀')}">selected</c:if>>경영팀</option>
									    <option value="영업팀" <c:if test="${param.teamName.equals('영업팀')}">selected</c:if>>영업팀</option>
									</select>
							    </div>
							    
							    <div class="form-group" style="width: 90px; margin-left: 30px;">
						        	<label class="sort-label">직급</label>
						        </div>
						        <div class="form-group" style="width: 150px;">
									<select name="empPosition" class="form-control">
									    <option value="" <c:if test="${param.empPosition.equals('')}">selected</c:if>>전체</option>
									    <option value="CEO" <c:if test="${param.empPosition.equals('CEO')}">selected</c:if>>CEO</option>
									    <option value="부서장" <c:if test="${param.empPosition.equals('부서장')}">selected</c:if>>부서장</option>
									    <option value="팀장" <c:if test="${param.empPosition.equals('팀장')}">selected</c:if>>팀장</option>
									    <option value="부팀장" <c:if test="${param.empPosition.equals('부팀장')}">selected</c:if>>부팀장</option>
									    <option value="사원" <c:if test="${param.empPosition.equals('사원')}">selected</c:if>>사원</option>
									</select>
								</div>
							</div>
							<div class="search-area" style="display: flex; align-items: center;">
						    	<div class="form-group" style="width: 100px;">
						        	<label class="search-label">검색</label>
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
							        <select name="searchCol" class="form-control">
							            <option value="empNo" ${searchCol eq 'empNo' ? 'selected' : ''}>사원번호</option>
							            <option value="empName" ${searchCol eq 'empName' ? 'selected' : ''}>성명</option>
							        </select>
						        </div>
						        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
						        	<input type="text" name="searchWord" value="${searchWord}" class="form-control">
						        </div>
						        <button type="button" class="btn waves-effect waves-light btn-outline-dark getEmpInfoListBtnForRecipients" style="margin-right: 10px;">적용</button>
						    </div> <br>
							<div id="modalRecipientsResult"></div>
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