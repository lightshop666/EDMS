<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>vacationDraft</title>
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 추가 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
	
	<script>
		// 이벤트 스크립트 시작
		$(document).ready(function() {
			
			// 중간승인자 선택시
			$('#selectedMiddleBtn').click(function() {
				// 선택된 값 가져오기
				let selectedMiddleApprover = $("input[name='selectedMiddleApprover']:checked").val();
				console.log('선택한 중간승인자 : ' + selectedMiddleApprover);
				// 중간승인자 출력
				$('#mediateSpan').text(selectedMiddleApprover);
				// 중간승인자 hidden에 주입
				$('#mediateHidden').val(selectedMiddleApprover);
			});
			
			// 최종승인자 선택시
			$('#selectedFinalBtn').click(function() {
				// 선택된 값 가져오기
				let selectedFinalApprover = $("input[name='selectedFinalApprover']:checked").val();
				console.log('선택한 최종승인자 : ' + selectedFinalApprover);
				// 중간승인자 출력
				$('#finalSpan').text(selectedFinalApprover);
				// 중간승인자 hidden에 주입
				$('#finalHidden').val(selectedFinalApprover);
			});
			
			// 수신참조자 선택시
			$('#checkedRecipientsBtn').click(function() {
				// 선택된 값 가져오기
				// map() 함수를 이용하여 선택된 체크박스의 값을 배열에 매핑하고 get() 함수를 사용하여 배열로 변환합니다.
				// 체크박스의 값은 일반적으로 String타입이므로 parseInt() 메서드로 int배열로 변환합니다.
				let checkedRecipients = $("input[name='checkedRecipients']:checked").map(function() {return parseInt(this.value);}).get();
				console.log('선택한 수신참조자 배열 : ' + checkedRecipients);
				// 수신참조자 출력
				$('#recipientsSpan').text(checkedRecipients);
				// 수신참조자 hidden에 주입
				$('#recipientsHidden').val(checkedRecipients);
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
	<div class="container pt-5">
		<h1 style="text-align: center;">휴가신청서</h1>
		<form action="/draft/vacationDraft" method="post">
			<input type="hidden" name="empNo" value="${empNo}">
			<table>
				<tr>
					<th rowspan="3" colspan="2">휴가신청서</th>
					<th rowspan="3">결재</th>
					<th>기안자</th>
					<th>중간승인자</th>
					<th>최종승인자</th>
				</tr>
				<tr>
					<td rowspan="2"> <!-- 서명 이미지 출력 -->
						<img src="${sign.memberPath}${sign.memberSaveFileName}.${sign.memberFiletype}">
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
						<button type="button" data-bs-toggle="modal" data-bs-target="#middleApproverModal">
							검색 <!-- 중간승인자 검색 모달 버튼 -->
						</button>
					</td>
					<td>
						<button type="button" data-bs-toggle="modal" data-bs-target="#finalApproverModal">
							검색 <!-- 최종승인자 검색 모달 버튼 -->
						</button>
					</td>
				</tr>
				<tr>
					<th>
						수신참조자
						<button type="button" data-bs-toggle="modal" data-bs-target="#recipientsModal">
							검색 <!-- 수신참조자 검색 모달 버튼 -->
						</button>
					</th>
					<td colspan="5">
						<span id="recipientsSpan"></span> <!-- 모달에서 선택된 수신참조자 출력 -->
						<input type="hidden" name="recipients" id="recipientsHidden"> <!-- int 배열로 넘길 예정... -->
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
					<th>남은 휴가 일수</th>
					<td>
						<!-- ajax 방식으로 남은 휴가 일수 조회 예정.. -->
						<span id="remainDays"></span>개
					</td>
					<th>기간</th>
					<td colspan="3">
						<input type="date" name="vacationStart"> ~ <input type="date" name="vacationEnd">
						<!-- 휴가 종류 선택에 따른 메세지 출력 예정.. -->
						<span id="vacationMsg">휴가 종류를 선택해주세요.</span>
					</td>
				</tr>
				<tr>
					<th>비상연락망</th>
					<td colspan="5">
						<input type="text" name="phoneNumber" placeholder="ex) 010-1234-5678">
					</td>
				</tr>
				<tr>
					<th>제목</th>
					<td colspan="5">
						<input type="text" name="docTitle" placeholder="ex) 휴가 신청합니다 - 연차">
					</td>
				</tr>
				<tr>
					<th>사유</th>
					<td colspan="5">
						<!-- 웹에디터를 넣을지 고민..! -->
						<textarea rows="8" cols="70" name="docContent" placeholder="ex) 개인사정으로 인하여 연차 사용을 신청합니다."></textarea>
					</td>
				</tr>
				<tr>
					<th colspan="6">
						위와 같이 휴가를 신청하오니, 결재 바랍니다. <br>
						${year}년 ${month}월 ${day}일
					</th>
				</tr>
			</table>
			<button type="button" id="cancelBtn">취소</button>
			<button type="submit" id="tempSaveBtn">임시저장</button>
			<button type="submit" id="saveBtn">저장</button>
		</form>
	</div>
	
	<!-- 모달창 시작 -->
	
	<!-- 중간승인자 검색 모달 -->
	<div class="modal" id="middleApproverModal">
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
						</tr>
						<c:forEach var="employee" items="${employeeList}">
							<tr>
								<td>
									<input type="radio" value="${employee.empNo}" name="selectedMiddleApprover">
								</td>
								<td>
									${employee.empNo}
								</td>
								<td>
									${employee.empName}
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<!-- 모달 푸터 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					<button type="button" id="selectedMiddleBtn" data-bs-dismiss="modal">저장</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 중간승인자 검색 모달 끝 -->
	
	<!-- 최종승인자 검색 모달 -->
	<div class="modal" id="finalApproverModal">
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
						</tr>
						<c:forEach var="employee" items="${employeeList}">
							<tr>
								<td>
									<input type="radio" value="${employee.empNo}" name="selectedFinalApprover">
								</td>
								<td>
									${employee.empNo}
								</td>
								<td>
									${employee.empName}
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<!-- 모달 푸터 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					<button type="button" id="selectedFinalBtn" data-bs-dismiss="modal">저장</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 최종승인자 검색 모달 끝 -->
	
	<!-- 수신참조자 검색 모달 -->
	<div class="modal" id="recipientsModal">
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
						</tr>
						<c:forEach var="employee" items="${employeeList}">
							<tr>
								<td>
									<input type="checkbox" value="${employee.empNo}" name="checkedRecipients">
								</td>
								<td>
									${employee.empNo}
								</td>
								<td>
									${employee.empName}
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<!-- 모달 푸터 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					<button type="button" id="checkedRecipientsBtn" data-bs-dismiss="modal">저장</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 수신참조자 검색 모달 끝 -->
	
</body>
</html>