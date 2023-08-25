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
	<!-- 공통 함수를 불러옵니다. -->
	<script src="/draftFunction.js"></script>
	
	<script>
		// 사원 목록 배열로 받는 변수 선언 (JSON)
		let employeeListJson = ${employeeListJson};
		
		// 휴가 종류 선택에 따라 동적으로 등장하는 input 태그 관련 함수들입니다.
		// 휴가 반차 선택 시 input 태그 출력
		function halfVactionInput(remainDays) {
			if (remainDays < 0.5) { // 남은 휴가 일수가 0.5일보다 작으면 신청 불가
				let InputMsg = '신청 가능한 반차 휴가 일수가 없습니다.';
				$('#vacationInput').html(InputMsg);
			} else {
				let InputTag = `
					<input type="date" name="vacationStart" id="vacationStart">
					<input type="hidden" name="vacationDays" value="0.5"> <!-- 반차는 0.5일이 고정값으로 들어간다 -->
					<input type="radio" name="vacationTime" value="오전반차">
						오전반차 9:00~13:00
					<input type="radio" name="vacationTime" value="오후반차">
						오후반차 14:00~18:00
				`;
				$('#vacationInput').html(InputTag);
			}
		}
			
		// 휴가 연차 또는 보상 선택 시 input 태그 출력
		function longVacationInput(vacationName, remainDays) {
			if (remainDays < 1) { // 남은 휴가 일수가 1보다 작으면 신청 불가
				let InputMsg = '신청 가능한 ' + vacationName + ' 휴가 일수가 없습니다.';
				$('#vacationInput').html(InputMsg);
			} else {
				let InputTag = `
					<label for="vacationDays"> 휴가일수 : </label>
					<select name="vacationDays" id="vacationDays">
					<!-- 옵션들은 vacationDaysSelect()를 호출하여 남은 휴가 일수만큼 동적으로 생성할 것입니다. -->
					</select>
							
					<label for="vacationStart"> 휴가 시작일 : </label>
					<input type="date" name="vacationStart" id="vacationStart">
							
					<label for="vacationEnd"> 휴가 종료일 : </label>
					<span id="vacationEndSpan"></span> <!-- 휴가 종료일은 수정이 불가능하며, 출력만 가능합니다. -->
					<input type="hidden" name="vacationEnd" id="vacationEndInput"> <!-- hidden 으로 값을 넘깁니다. -->
				`;
				$('#vacationInput').html(InputTag);
			}
		}
		
		// 휴가일수(vacationDays) selectbox의 옵션 출력
		// ajax로 조회한 남은 휴가 일수(remainDays)만큼 동적으로 옵션을 생성합니다.
		function vacationDaysSelect(remainDays) {
			$('#vacationDays').empty(); // 기존 옵션들을 초기화
			
			for (let i = 1; i <= remainDays; i++) {
				// append()를 이용하여 새로운 옵션 태그를 생성합니다.
				$('#vacationDays').append($('<option>', {
					value : i, // 옵션태그의 값
					text : i + '일' // 옵션태그의 출력부분
				}));
			}
		}
		
		// 휴가 종료일 지정
		// 선택한 휴가일수와 휴가 시작일에 따라 동적으로 휴가 종료일을 지정합니다.
		function vacationEndInput() {
			let selectedVacationDays = parseInt($('#vacationDays').val()); // 선택한 휴가일수를 정수로 반환
			console.log('선택한 휴가일수 : ' + selectedVacationDays);
			
			// 날짜 정보를 다루기 위한 JavaScript의 객체인 Date 객체를 사용합니다.
			let startDate = new Date( $('#vacationStart').val() ); // 선택한 휴가 시작일
			let endDate = new Date(startDate) // 휴가 종료일 선언
			// 휴가 종료일을 selectedVacationDays만큼 지정합니다.
			// selectedVacationDays가 1일 경우 당일(시작일과 종료일이 동일)이므로 selectedVacationDays-1을 해줍니다.
			endDate.setDate(startDate.getDate() + selectedVacationDays - 1);
			
			// Date 객체는 날짜와 시간 등 다양한 정보를 담고 있으므로 필요한 정보만 가져옵니다.
			// ex) Wed Aug 09 2023 09:00:00 GMT+0900 (한국 표준시)
			// toISOString()를 이용하여 해당 정보를 다루기 편한 문자열로 변환합니다. ex) 2023-08-09T00:00:00.000Z
			// substr()으로 날짜 정보만 가져옵니다. ex) 2023-08-09
			let endDateString = endDate.toISOString().substr(0, 10);
			
			$('#vacationEndSpan').text(endDateString);
			$('#vacationEndInput').val(endDateString);
			console.log('휴가 종료일 : ' + endDateString);
		}
		
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
			
			// 추후 상세페이지로 이동 예정..
			// 기안 성공 or 실패 결과에 따른 alert
			let result = '${param.result}'; // 기안 성공유무를 url의 매개값으로 전달
			if (result == 'fail') { // result의 값이 fail이면
			    console.log('휴가신청서 기안 실패');
			    alert('휴가신청서가 기안되지 않았습니다. 다시 시도해주세요.');
			} else if (result == 'success') { // result의 값이 success이면
				console.log('휴가신청서 기안 성공');
			    alert('휴가신청서가 기안되었습니다.');
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
				
				// 1. ajax로 선택한 휴가 종류의 남은 일수 출력
				$.ajax({
					url : '/getRemainDaysByVacationName',
					type : 'post',
					data : {vacationName : vacationName},
					success : function(response) {
						console.log('남은 휴가 일수 조회 성공 : ' + response + '개');
						$('#remainDays').text(response + '일');
						
						// 2. 휴가 종류에 따라 input 태그를 출력할 메서드 호출
						if (vacationName == '반차') {
							halfVactionInput(response); // 반차 input 출력
						} else { // 연차 또는 보상일 경우
							longVacationInput(vacationName, response); // 연차 or 보상 input 출력
							vacationDaysSelect(response); // 연차 or 보상의 남은 휴가일수 selectbox 출력
							
							// 휴가 시작일 지정시 이벤트 발생
							$('#vacationStart').change(function() {
								vacationEndInput(); // 휴가 종료일 지정
							});
							
							// 휴가 일수 변경시 이벤트 발생
							$('#vacationDays').change(function() {
								let vacationStart = $('#vacationStart').val();
								if (vacationStart != '') { // 휴가 시작일이 지정되어있다면
									vacationEndInput(); // 휴가 종료일 지정
								}
							});
						}
					},
					error : function(error) {
						console.error('남은 휴가 일수 조회 실패 : ' + error);
					}
				});
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
				let result = '작성중인 내용이 모두 사라집니다. 정말 취소하시겠습니까?';
				if (result) {
					location.reload(); // 현재 페이지 새로고침
				}
			})
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
		<!-- 공통 함수를 사용하기 위해 id명 draftForm로 지정 필요 -->
		<form action="/draft/vacationDraft" method="post" id="draftForm">
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
					<td rowspan="2"> 
						<c:if test="${sign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
							<img src="${sign.memberPath}${sign.memberSaveFileName}.${sign.memberFiletype}">
						</c:if>
						<c:if test="${sign.memberSaveFileName == null}"> <!-- 서명 이미지가 없으면 문구 출력 -->
							<!-- 해당 부분 문구가 아닌 다른 이미지로 출력할지 고민중.. -->
							${year}.${month}.${day}<br>
							결재승인
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
						<!-- 웹에디터를 넣을지 고민..! -->
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
			<button type="button" id="cancelBtn">취소</button>
			<button type="button" id="saveBtn">임시저장</button>
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