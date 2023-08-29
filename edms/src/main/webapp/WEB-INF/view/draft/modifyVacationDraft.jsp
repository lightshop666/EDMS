<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyVacationDraft</title>
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 추가 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- 공통 함수를 불러옵니다. -->
	<script src="/draftFunction.js"></script>
	
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
		
		// 이벤트 스크립트 시작
		$(document).ready(function() {
			
			// 수정 실패시 alert
			let result = '${param.result}'; // 수정 성공유무를 url의 매개값으로 전달
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('휴가신청서 수정 실패');
			    alert('휴가신청서가 수정되지 않았습니다. 다시 시도해주세요.');
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
			
			// 휴가 종류 기존 선택값 조회
			let vacationName = $("input[name='vacationName']:checked").val();
			if (vacationName) {
				let vacationStart = '${vacationDraft.vacationStart}';
				let vacationDays = ${vacationDraft.vacationDays};
				let vacationTime = '${vacationTime}';
				getRemainDaysByVacationNameAndSet(vacationName, vacationStart, vacationDays, vacationTime); // 공통 함수 호출 (AJAX)
			}
			
			// 휴가 종류 변경시
			$("input[name='vacationName']").change(function() {
				let vacationName = $(this).val(); // 선택한 휴가 종류
				getRemainDaysByVacationName(vacationName); // 공통 함수 호출 (AJAX)
			});
			
			// 저장 버튼 클릭시
			$('#submitBtn').click(function() {
				setRecipients(); // 수신참조자 값 조회 및 주입
				setDraftSubmit(); // 공통 함수 호출
			});
			
			// 취소 버튼 클릭시
			$('#cancelBtn').click(function() {
				let result = confirm('작성중인 내용이 모두 사라집니다. 정말 취소하시겠습니까?');
				if (result) {
					let approvalNo = ${approval.approvalNo};
					window.location.href = "/draft/vacationDraftOne?approvalNo=" + approvalNo; // 상세페이지로 이동
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
	<!-- 모델값 변수에 할당 -->
	<c:set var="a" value="${approval}"></c:set>
	<c:set var="v" value="${vacationDraft}"></c:set>
	<c:set var="m" value="${memberSignMap}"></c:set>
	<!--------------------->
	<div class="container pt-5">
		<h1 style="text-align: center;">휴가신청서</h1>
		<!-- id명 수정 필요... -->
		<form action="/draft/modifyVacationDraft" method="post" id="draftForm">
		<input type="hidden" name="approvalNo" value="${a.approvalNo}">
			<table>
				<tr>
					<th rowspan="3" colspan="2">휴가신청서</th>
					<th rowspan="3">결재</th>
					<th>기안자</th>
					<th>중간승인자</th>
					<th>최종승인자</th>
				</tr>
				<tr>
					<td> 
						<c:if test="${m.firstSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
							<img src="${m.firstSign.memberPath}${m.firstSign.memberSaveFileName}.${m.firstSign.memberFiletype}">
						</c:if>
						<c:if test="${m.firstSign.memberSaveFileName == null}"> <!-- 서명 이미지가 없으면 문구 출력 -->
							<!-- 해당 부분 문구가 아닌 다른 이미지로 출력할지 고민중.. -->
							서명 이미지 미등록
						</c:if>
					</td>
					<td>
						<span id="mediateSpan"> <!-- 모달에서 선택된 중간승인자 출력 -->
							${a.mediateEmpName}_${a.mediateDeptName}_${a.mediateEmpPosition}
						</span> 
						<input type="hidden" name="mediateApproval" id="mediateHidden" value="${a.mediateApproval}">
					</td>
					<td>
						<span id="finalSpan"> <!-- 모달에서 선택된 최종승인자 출력 -->
							${a.finalEmpName}_${a.finalDeptName}_${a.finalEmpPosition}
						</span> 
						<input type="hidden" name="finalApproval" id="finalHidden" value="${a.finalApproval}">
					</td>
				</tr>
				<tr>
					<td>
						${a.firstEmpName}_${a.firstDeptName}_${a.firstEmpPosition}
					</td>
					<td>
						<button type="button" data-bs-toggle="modal" data-bs-target="#mediateModal">
							검색 <!-- 중간승인자 검색 모달 버튼 -->
						</button>
					</td>
					<td>
						<button type="button" data-bs-toggle="modal" data-bs-target="#finalModal">
							검색 <!-- 최종승인자 검색 모달 버튼 -->
						</button>
					</td>
				</tr>
				<tr>
					<th>
						수신참조자
						<button type="button" data-bs-toggle="modal" data-bs-target="#receiveModal">
							검색 <!-- 수신참조자 검색 모달 버튼 -->
						</button>
					</th>
					<td colspan="5">
						<span id="receiveSpan"> <!-- 모달에서 선택된 수신참조자 출력 -->
							<c:if test="${receiveList != null}"> <!-- 수신참조자 테이블 리스트가 존재하면 -->
								<c:forEach var="r" items="${receiveList}" varStatus="status">
									<!-- varStatus 속성으로 현재 반복문의 상태를 알 수 있습니다. -->
									<!-- varStatus.last로 현재 항목이 마지막 항복인지 여부를 알 수 있습니다. -->
									<!-- 마지막 항목일 경우에는 쉼표를 출력하지 않습니다. -->
									${r.receiveEmpName}_${r.receiveDeptName}_${r.receiveEmpPosition}<c:if test="${!status.last}">, </c:if>
								</c:forEach>
							</c:if>
						</span> 
						<input type="hidden" name="recipients" id="receiveHidden"> <!-- int 배열 -->
					</td>
				</tr>
				<tr>
					<th>성명</th>
					<td>${a.firstEmpName}</td>
					<th>부서</th>
					<td>${a.firstDeptName}</td>
					<th>휴가종류</th>
					<td>
						<input type="radio" name="vacationName" value="반차" <c:if test="${v.vacationName.equals('반차')}">checked</c:if>>반차
						<input type="radio" name="vacationName" value="연차" <c:if test="${v.vacationName.equals('연차')}">checked</c:if>>연차
						<input type="radio" name="vacationName" value="보상" <c:if test="${v.vacationName.equals('보상')}">checked</c:if>>보상
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
						<input type="text" name="phoneNumber" placeholder="ex) 010-1234-5678" id="phoneNumber" value="${v.phoneNumber}">
					</td>
				</tr>
				<tr>
					<th>제목</th>
					<td colspan="5">
						<input type="text" name="docTitle" placeholder="ex) 휴가 신청합니다 - 연차" id="docTitle" value="${v.docTitle}">
					</td>
				</tr>
				<tr>
					<th>사유</th>
					<td colspan="5">
						<!-- 웹에디터를 넣을지 고민..! -->
						<textarea rows="8" cols="70" name="docContent" placeholder="ex) 개인사정으로 인하여 연차 사용을 신청합니다." id="docContent">${v.docContent}</textarea>
					</td>
				</tr>
				<tr>
					<th colspan="6">
						위와 같이 휴가를 신청하오니, 결재 바랍니다. <br>
						<!-- 기안일자에서 년,월,일을 추출하기 위해 substring 사용 -->
					${fn:substring(v.createdate, 0, 4)}년 ${fn:substring(v.createdate, 5, 7)}월 ${fn:substring(v.createdate, 8, 10)}일
					</th>
				</tr>
			</table>
			<button type="button" id="cancelBtn">취소</button>
			<button type="button" id="submitBtn">저장</button>
		</form>
	</div>
	
	<!-- 모달창 시작 -->
	
	<!-- 중간승인자 검색 모달 -->
	<div class="modal" id="mediateModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- 모달 헤더 -->
				<div class="modal-header">
					<h4 class="modal-title">중간승인자 선택</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
				</div>
				<!-- 모달 본문 -->
				<div class="modal-body">
					<table>
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
									<input type="radio" value="${employee.empNo}" name="modalMediateApproval" <c:if test="${employee.empNo == a.mediateApproval}">checked</c:if>>
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
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					<button type="button" id="saveMediateBtn" data-bs-dismiss="modal">저장</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 중간승인자 검색 모달 끝 -->
	
	<!-- 최종승인자 검색 모달 -->
	<div class="modal" id="finalModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- 모달 헤더 -->
				<div class="modal-header">
					<h4 class="modal-title">최종승인자 선택</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
				</div>
				<!-- 모달 본문 -->
				<div class="modal-body">
					<table>
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
									<input type="radio" value="${employee.empNo}" name="modalFinalApproval" <c:if test="${employee.empNo == a.finalApproval}">checked</c:if>>
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
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					<button type="button" id="saveFinalBtn" data-bs-dismiss="modal">저장</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 최종승인자 검색 모달 끝 -->
	
	<!-- 수신참조자 검색 모달 -->
	<div class="modal" id="receiveModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- 모달 헤더 -->
				<div class="modal-header">
					<h4 class="modal-title">수신참조자 선택</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
				</div>
				<!-- 모달 본문 -->
				<div class="modal-body">
					<table>
						<tr>
							<th>선택</th>
							<th>사원번호</th>
							<th>성명</th>
							<th>부서명</th>
							<th>직급명</th>
						</tr>
						<c:forEach var="employee" items="${employeeList}">
							<!-- 기존 수심참조자 배열과 일치할 경우 체크합니다. -->
							<c:set var="isChecked" value="false"></c:set>
							<c:forEach var="r" items="${receiveList}">
								<c:if test="${r.empNo == employee.empNo}">
									<c:set var="isChecked" value="true"></c:set>
								</c:if>
							</c:forEach>
							<tr>
								<td>
									<input type="checkbox" value="${employee.empNo}" name="modalRecipients" <c:if test="${isChecked}">checked</c:if>>
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
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					<button type="button" id="saveReceiveBtn" data-bs-dismiss="modal">저장</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 수신참조자 검색 모달 끝 -->
	
</body>
</html>