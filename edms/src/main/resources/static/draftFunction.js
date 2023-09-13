	/*
		전자결재 작성시 공통적으로 사용되는 공통 함수를 모아두었습니다.
		공통 함수의 목록은 다음과 같습니다.
		1. 사원목록(JSON)을 조회하여 선택한 결재자의 정보(이름, 부서명, 직급) 출력
		2. 중간승인자 정보 출력 및 hidden에 값 주입
		3. 최종승인자 정보 출력 및 hidden에 값 주입
		4. 수신참조자(int 배열) 정보 출력 및 hidden에 값 주입
		5. 서명 이미지 조회 -> 유효성 검사, 서명이미지가 없으면 메세지창을 띄운 뒤 내 프로필 수정 페이지로 보내기
		6. 임시저장 -> 유효성 검사, 임시저장 유무(isSaveDraft) hidden 주입(true), 폼 제출
		7. 저장(기안) -> 유효성 검사, 임시저장 유무(isSaveDraft) hidden 주입(false), 폼 제출
		8. 문서 상세 페이지에서 클릭한 버튼에 따라 액션 분기 (결재 상태 업데이트)
		
		주의할점
		- getApproverDetails() 에서 조회할 사원 목록 배열(JSON)을 해당 페이지에서 전역 스코프 변수(employeeListJson)로 선언해주세요.
		- 공통 함수를 호출할 양식의 유효성 검사 메서드의 이름은 validateInputs() 이어야 합니다.
		- 제출할 form의 id는 draftForm 이어야 합니다.
		- 값을 가져올 중간/최종승인자, 수신참조자의 name명과 값을 주입할 태그의 id명은 다음과 같아야 합니다.
		중간승인자 -> name : modalMediateApproval, id : mediateHidden, mediateSpan
		최종승인자 -> name : modalFinalApproval, id : finalHidden, finalSpan
		수신참조자 -> name : modalRecipients, id : receiveHidden, receiveSpan
		- handleApprovalAction() 메서드는 매개값으로 role, actionType을 받습니다. actionType은 다음과 같습니다.
		목록 -> list, 기안취소 -> cancel, 승인 -> approve, 반려 -> reject, 승인취소 -> CancelApprove
	*/
	
	// 모달창에서 검색 조건에 따른 사원 목록 조회 (중간승인자)
	function getEmpInfoListByPageForModalMediateApproval(param) {
		$.ajax({
			url : '/getEmpInfoListByPage',
			method : 'post',
			data : {
				ascDesc : param.ascDesc,
				deptName : param.deptName,
				teamName : param.teamName,
				empPosition : param.empPosition,
				searchCol : param.searchCol,
				searchWord : param.searchWord,
				currentPage : param.currentPage
			},
			success : function(data) {
				let tableRows = '';
			    $.each(data.resultList, function (index, employee) {
			        tableRows += '<tr>';
			        tableRows += '<td><input type="radio" value="' + employee.empNo + '" name="modalMediateApproval"></td>';
			        tableRows += '<td>' + employee.empNo + '</td>';
			        tableRows += '<td>' + employee.empName + '</td>';
			        tableRows += '<td>' + employee.deptName + '</td>';
			        tableRows += '<td>' + employee.empPosition + '</td>';
			        tableRows += '</tr>';
			    });
			    
			    $('#modalMediateApprovalResult').html(tableRows);
			},
			error : function(error) {
				console.error('사원 목록 검색 조회 실패 : ' + error);
			}
		});
	}
	
	// 모달창에서 검색 조건에 따른 사원 목록 조회 (최종승인자)
	function getEmpInfoListByPageForModalFinalApproval(param) {
		console.log('실행');
		$.ajax({
			url : '/getEmpInfoListByPage',
			method : 'post',
			data : {
				ascDesc : param.ascDesc,
				deptName : param.deptName,
				teamName : param.teamName,
				empPosition : param.empPosition,
				searchCol : param.searchCol,
				searchWord : param.searchWord,
				currentPage : param.currentPage
			},
			success : function(data) {
				let tableRows = '';
			    $.each(data.resultList, function (index, employee) {
			        tableRows += '<tr>';
			        tableRows += '<td><input type="radio" value="' + employee.empNo + '" name="modalFinalApproval"></td>';
			        tableRows += '<td>' + employee.empNo + '</td>';
			        tableRows += '<td>' + employee.empName + '</td>';
			        tableRows += '<td>' + employee.deptName + '</td>';
			        tableRows += '<td>' + employee.empPosition + '</td>';
			        tableRows += '</tr>';
			    });
			    
			    $('#modalFinalApprovalResult').html(tableRows);
			},
			error : function(error) {
				console.error('사원 목록 검색 조회 실패 : ' + error);
			}
		});
	}
	
	// 모달창에서 검색 조건에 따른 사원 목록 조회 (수신참조자)
	function getEmpInfoListByPageForModalRecipients(param) {
		console.log('실행');
		$.ajax({
			url : '/getEmpInfoListByPage',
			method : 'post',
			data : {
				ascDesc : param.ascDesc,
				deptName : param.deptName,
				teamName : param.teamName,
				empPosition : param.empPosition,
				searchCol : param.searchCol,
				searchWord : param.searchWord,
				currentPage : param.currentPage
			},
			success : function(data) {
				let tableRows = '';
			    $.each(data.resultList, function (index, employee) {
			        tableRows += '<tr>';
			        tableRows += '<td><input type="checkbox" value="' + employee.empNo + '" name="modalRecipients"></td>';
			        tableRows += '<td>' + employee.empNo + '</td>';
			        tableRows += '<td>' + employee.empName + '</td>';
			        tableRows += '<td>' + employee.deptName + '</td>';
			        tableRows += '<td>' + employee.empPosition + '</td>';
			        tableRows += '</tr>';
			    });
			    
			    $('#modalRecipientsResult').html(tableRows);
			},
			error : function(error) {
				console.error('사원 목록 검색 조회 실패 : ' + error);
			}
		});
	}
	
	// 선택한 결재자의 정보 구하기// 모달창에서 선택한 결재자의 정보를 출력하기 위해 리스트를 조회합니다.
	function getApproverDetails(selectedApproverNo) {
		let empName = ''; // 이름
		let deptName = ''; // 부서명
		let empPosition = ''; // 직급
		
		// JSON 배열로 받은 사원 목록을 for문을 이용하여 empNo가 일치하는 정보를 찾습니다.
		for (let i = 0; i < employeeListJson.length; i++) {
			if (employeeListJson[i].empNo == selectedApproverNo) {
				empName = employeeListJson[i].empName;
				deptName = employeeListJson[i].deptName;
				empPosition = employeeListJson[i].empPosition;
				break; // 원하는 사원 정보를 찾았다면 반복문을 중지합니다.
			}
		}
	
		return empName + '_' + deptName + '_' + empPosition;
	}
	
	// 중간승인자 출력 및 값 주입
	function setMediateApproval() {
		// 선택된 값 가져오기
		let modalMediateApproval = $("input[name='modalMediateApproval']:checked").val();
		console.log('선택한 중간승인자 사원번호 : ' + modalMediateApproval);
		// 중간승인자 사원번호 hidden에 주입
		$('#mediateHidden').val(modalMediateApproval);
		
		// 중간승인자의 정보를 구하는 메서드 호출
		let mediateDetails = getApproverDetails(modalMediateApproval);
		console.log('선택한 중간승인자 정보 : ' + mediateDetails);
		// 중간승인자 정보 출력
		$('#mediateSpan').text(mediateDetails);
	}
	
	// 최종승인자 출력 및 값 주입
	function setFinalApproval() {
		// 선택된 값 가져오기
		let modalFinalApproval = $("input[name='modalFinalApproval']:checked").val();
		console.log('선택한 최종승인자 사원번호 : ' + modalFinalApproval);
		// 최종승인자 사원번호 hidden에 주입
		$('#finalHidden').val(modalFinalApproval);
		
		// 최종승인자의 정보를 구하는 메서드 호출
		let finalDetails = getApproverDetails(modalFinalApproval);
		console.log('선택한 최종승인자 정보 : ' + finalDetails);
		// 최종승인자 정보 출력
		$('#finalSpan').text(finalDetails);
	}
	
	// 수신참조자 출력 및 값 주입
	function setRecipients() {
		// 선택된 값 가져오기
		// 체크박스의 값은 일반적으로 String타입이므로 int타입의 정수배열로 변환하는 과정이 필요합니다.
		// Array.from()를 이용하여 선택된 체크박스 요소들로 새로운 배열을 생성할 것입니다.
		// 화살표 함수(=>)로 파라미터값(item)의 value 속성을 parseInt() 메서드로 정수로 변환합니다.
		let modalRecipients = Array.from(
									$("input[name='modalRecipients']:checked"),
									item => parseInt(item.value)
								);
		console.log('선택한 수신참조자 정수 배열 : ' + modalRecipients);
		// 수신참조자 정수 배열을 hidden에 주입
		$('#receiveHidden').val(modalRecipients);
		
		// 수신참조자의 정보 구하기
		let recipientsDetails = '';
		// 수신참조자는 배열이므로 반복문 안에서 메서드를 호출합니다.
		for (let i = 0; i < modalRecipients.length; i++) {
			if (i == 0) {
				recipientsDetails = getApproverDetails(modalRecipients[i]);
			} else { // 쉼표를 이용하여 한줄의 문자열을 생성합니다.
				recipientsDetails += ', ' + getApproverDetails(modalRecipients[i]);
			}
		}
		console.log('선택한 수신참조자 정보 : ' + recipientsDetails);
		// 수신참조자 출력
		$('#receiveSpan').text(recipientsDetails);
	}
	
	// 서명 이미지 조회
	// 서명 이미지를 조회하여 존재하지 않으면 alert창 띄운 후 내 프로필 수정 페이지로 이동
	function alertAndRedirectIfNoSign() {
		// ajax로 서명 이미지 조회
		$.ajax({
			url : '/alertAndRedirectIfNoSign',
			type : 'post',
			success : function(response) {
				console.log('서명 이미지 조회 결과 : ' + response);
				
				if (response == false) {
					alert('등록된 서명 이미지가 없습니다. 서명 이미지 등록 페이지로 이동합니다.');
					window.location.href = '/member/modifyMember'; // 내 프로필 수정 폼으로 이동
				}
			},
			error : function(error) {
				console.error('서명 이미지 조회 실패 : ' + error);
			}
		});
	}
	
	// 임시저장 프로세스 // 임시저장 시 isSaveDraft 값을을 true로 주입합니다.
	function setDraftSave() {
		// 1. 유효성 검사
		// 임시저장 시에는 중간승인자와 최종승인자의 값만 검사합니다.
		let mediateHidden = $('#mediateHidden').val();
		let finalHidden = $('#finalHidden').val();
		
		if (mediateHidden == '') {
			alert('중간승인자를 선택해주세요.');
		} else if (finalHidden == '') {
			alert('최종승인자를 선택해주세요.');
		} else {
			// 2. 임시저장 유무 hidden input 추가
			$('<input>').attr({
				type : 'hidden',
				name : 'isSaveDraft',
				value : 'true' // 임시저장 유무 true
			}).appendTo('#draftForm');
			
			// 3. 폼 전송
			$('#draftForm').submit(); // draftForm -> 제출할 form의 id
		}
	}
	
	// 저장(기안) 프로세스 // 저장 시 isSaveDraft 값을을 false로 주입합니다.
	function setDraftSubmit() {
		// 1. 유효성검사
		if ( validateInputs() ) { // validateInputs() -> 유효성 검사 함수
			// 2. 임시저장 유무 hidden input 추가
			$('<input>').attr({
				type : 'hidden',
				name : 'isSaveDraft',
				value : 'false' // 임시저장 유무 false
			}).appendTo('#draftForm');
			
			// 3. 폼 전송
			$('#draftForm').submit(); // draftForm -> 제출할 form의 id
		}
	}
	
	// 결재 상태 업데이트 로직 분기
	function handleApprovalAction(role, actionType) {
		console.log('handleApprovalAction() role param : '+ role);
		console.log('handleApprovalAction() actionType param : '+ actionType);
		
		// actionType에 따라 로직을 분기합니다.
		// 목록 -> list, 기안취소 -> cancel, 승인 -> approve, 반려 -> reject, 승인취소 -> CancelApprove
		let result = ''; // confirm창 메세지
		if (actionType == 'list') { // 목록
			result = confirm('목록으로 이동할까요?');
			if (result) {
				if (role == '기안자') {
					window.location.href = '/draft/submitDraft'; 
				} else if (role == '수신참조자') {
					window.location.href = '/draft/receiveDraft'; 
				} else {
					window.location.href = '/draft/approvalDraft'; 
				}
			}
		} else {
			if (actionType == 'approve') {
				result = confirm('승인하시겠습니까?');
			} else if (actionType == 'reject') {
				result = confirm('반려하시겠습니까?');
			} else if (actionType == 'CancelApprove') {
				result = confirm('승인을 취소하시겠습니까?');
			} else {
				result = confirm('기안을 취소하시겠습니까? 취소 시 임시저장함으로 이동합니다.');
			}
			if (result) {
				$('#DraftOneForm').submit(); // 폼제출
			}
		}
	}
	
	// Date 객체의 날짜 정보를 YYYY-MM-01 형식으로 포맷팅하는 함수
	function formatDateToYYYYMM(date) {
		let year = date.getFullYear(); // 년도를 가져옵니다.
		let month = date.getMonth() + 1; // 자바의 월은 0부터 시작하므로 +1 해줍니다.
		let formattedMonth = month < 10 ? `0${month}` : `${month}`; // 월이 10미만일 경우 앞에 0을 붙여 MM형식을 유지합니다.
		let formattedDate = `${year}-${formattedMonth}-01`; // DD는 01로 표시합니다.
		console.log('formatDateToYYYYMM() : ' + formattedDate);
		
		return formattedDate;
	}
	
	// Date 객체의 날짜 정보를 YYYY년 MM월 형식으로 포맷팅하는 함수
	function formatDateToKorean(date) {
		let formattedDate = formatDateToYYYYMM(date);
	    // 날짜를 '-'를 기준으로 분할
	    let dateParts  = formattedDate.split('-');
	    
	    // 년, 월 부분 추출
	    let year = dateParts [0];
	    let month = dateParts [1];
	    
	    // "년"과 "월"을 포함한 문자열 생성
	    var transformedString  = year + "년 " + month + "월";
	    console.log('formatDateToKorean() : ' + transformedString);
	    
	    return transformedString;
	}
	
	// 기존 파일(document_file)을 삭제하는 함수 (AJAX)
	function deleteDocumentFile(docFileNo, docSaveFilename) {
		let result = confirm('삭제 시 복구할 수 없습니다. 파일을 삭제할까요?');
		
		if (result) {
			console.log('docFileNo : ' + docFileNo);
			console.log('docSaveFilename : ' + docSaveFilename);
			
			$.ajax({
				url : '/deleteDocumentFile',
				type : 'post',
				data : {
					docFileNo : docFileNo,
					docSaveFilename : docSaveFilename
				},
				success : function(response) {
					if (response != 0) {
						// 삭제 성공시 해당 파일을 view에서 삭제합니다.
						// 해당 docFileNo의 값을 가지고 있는 div(file-item)를 통째로 제거합니다.
						$('.file-item[data-docFileNo="' + docFileNo + '"]').remove();
						console.log(docFileNo + '번 파일 삭제 성공');
					}
				},
				error : function(error) {
					console.log('error : ' + error);
				}
			});	
		}
	}
	
	// -------------- 매출보고서 함수 -----------------
	// 매출보고서에서 동적으로 생성 또는 제거되는 input 태그 관련 함수들입니다.
	function generateOptionsForSelect(today) {
		/*
			해당 함수는 현재 날짜를 기준으로 이전 3개월의 옵션을 동적으로 생성하여 selectbox에 주입합니다.
			단, ajax로 데이터를 조회하여 이미 데이터가 존재하는 기준년월일 경우 주입을 생략합니다.
		*/
		// -1월 Date 객체 생성
		let previousMonth = new Date(today); 
		previousMonth.setMonth(today.getMonth() - 1);
		console.log('previousMonth : ' + previousMonth);
		// -2월 Date 객체 생성
		let previousMonthBefore = new Date(today); 
		previousMonthBefore.setMonth(today.getMonth() - 2);
		console.log('previousMonthBefore : ' + previousMonthBefore);
		// -3월 Date 객체 생성
		let previousMonthBefore2 = new Date(today); 
		previousMonthBefore2.setMonth(today.getMonth() - 3);
		console.log('previousMonthBefore2 : ' + previousMonthBefore2);
		// formatDateToYYYYMM() 공통 함수 호출
		let previousMonthString = formatDateToYYYYMM(previousMonth);
		let previousMonthBeforeString = formatDateToYYYYMM(previousMonthBefore);
		let previousMonthBefore2String = formatDateToYYYYMM(previousMonthBefore2);
		
		// 1. ajax로 해당 기준년월의 데이터가 존재하는지 조회
		$.ajax({
			url : '/getExistingSalesDates',
			type : 'post',
			data : {
				previousMonthBefore2 : previousMonthBefore2String, 
				previousMonthBefore : previousMonthBeforeString,
				previousMonth : previousMonthString
			},
			success : function(response) {
				// 2. YYYY년 MM월 형식으로 포맷팅하여 옵션 생성 
				let selectElement = $('#salesDateSelect'); // selectbox
				let options = [ // formatDateToKorean() 공통 함수 호출
					{ value : previousMonthBefore2String, text : formatDateToKorean(previousMonthBefore2) },
					{ value : previousMonthBeforeString, text : formatDateToKorean(previousMonthBefore) },
					{ value : previousMonthString, text : formatDateToKorean(previousMonth) }
				]; // option 배열 생성
				
				let optionsCreated = false; // 옵션 생성 여부 확인
				
				// 3. ajax로 조회한 결과를 기반으로 생성한 옵션을 주입 또는 생략
				$.each(options, function(index, option) {
					/*
						includes() 메서드는 자바스트립트에서 사용되는 배열(Array)의 메서드입니다.
						해당 배열에 특정 요소가 존재하는지 여부를 확인할 수 있습니다.
						존재하면 true, 존재하지 않으면 false를 반환합니다.
					*/
					if (response.includes(option.value)) {
						/*
							response 즉, 반환된 List에 해당 옵션의 value가 포함되어 있으면
							이미 데이터에 존재하는 기준년월이므로 옵션을 주입하지 않고 return 합니다.
						*/
						return;
					}
					// 위 조건에 해당되지 않는다면, 해당 옵션을 selectbox에 주입.
					selectElement.append($('<option>', {
						value : option.value,
						text : option.text
					}));
					optionsCreated = true; // 옵션 생성
				});
				
				if (!optionsCreated) { // 옵션이 생성되지 않았을 경우
					$('#salesDateArea').empty(); // 기존 요소 제거
					$('#salesDateArea').text('최근 3개월의 매출보고서가 이미 작성되었습니다.');
				}
			},
			error : function(error) {
				console.log('error : ' + error);
			}
		});
	}
	
	// 목표달성률 동적 계산
	// 목표달성률을 계산하여 hidden에 주입하고, 백분율로 환산하여 출력합니다.
	function updateSalesRate() {
		let row = $(this).closest('tr'); // 현재 이벤트가 발생한 요소, 즉 입력한 'input'요소의 가장 가까운 'tr' 요소를 선택합니다.
		// find()로 해당 요소의 currentSales 입력값과 targetSales 입력값을 찾아옵니다.
		let currentSales = row.find('input[name="currentSales"]').val();
		let targetSales = row.find('input[name="targetSales"]').val();
		// 목표달성률을 계산
		let targetRate = (currentSales / targetSales);
		// 값이 NaN 또는 Infinity인 경우 0으로 설정
		if (isNaN(targetRate) || !isFinite(targetRate)) {
			targetRate = 0;
		}
		// 계산된 목표달성률을 해당 요소의 targetRate에 주입합니다.
		row.find('input[name="targetRate"]').val(targetRate);
		// 목표달성률을 백분율(%)로 환산하여 출력 // toFixed()로 소숫점 아래 2자리로 자를 수 있습니다.
		let rate = (targetRate * 100).toFixed(2);
		row.find('.rate').text(rate);
	}
	
	// 내역 추가
	function addNewRowForSalesDraft() {
		let newRow = `
			<tr style="border: 1px solid black;">
				<td style="border: 1px solid black;">
					<select name="productCategory" style="border: 1px solid black;">
						<option value="스탠드">스탠드</option>
						<option value="무드등">무드등</option>
						<option value="실내조명">실내조명</option>
						<option value="실외조명">실외조명</option>
						<option value="포인트조명">포인트조명</option>
					</select>
				</td>
				<td style="border: 1px solid black;">₩ <input type="number" name="targetSales" style="border: 1px solid black;"></td>
				<td style="border: 1px solid black;">₩ <input type="number" name="currentSales" style="border: 1px solid black;"></td>
				<td style="border: 1px solid black;"><span class="rate"></span><input type="hidden" name="targetRate"> %</td>
				<td style="border: 1px solid black;"><button type="button" class="removeDetailBtn btn btn-secondary btn-sm" style="border: 1px solid black;">-</button></td>
			</tr>
		`;
		$('#detailsTable').append(newRow); // 테이블에 내역(newRow) 추가
	}
	
	
	// -------------- 휴가신청서 함수 -----------------
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
				<input type="radio" name="vacationTime" value="오전반차" id="amHalfDay">
					오전반차 09:00~13:00
				<input type="radio" name="vacationTime" value="오후반차" id="pmHalfDay">
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
		
		// 휴가 종료일 포맷팅
		let endDateFomatted = formatDateToYYYYMM(endDate); // 기존 함수 사용 -> YYYY-MM-01 형식으로 포맷팅하는 기존 함수를 호출합니다.
		let endDateDay = endDate.getDate(endDate); // 휴가종료일의 '일'정보를 가져옵니다.
		let endDateString = endDateFomatted.slice(0, -2) + endDateDay; // slice()로 01을 잘라내고 '일'정보를 합칩니다.
		
		$('#vacationEndSpan').text(endDateString);
		$('#vacationEndInput').val(endDateString);
		console.log('휴가 종료일 : ' + endDateString);
	}
	
	// 선택한 휴가 종류의 남은 일수 출력 (AJAX)
	function getRemainDaysByVacationName(vacationName) {
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
	}
	
	// 휴가 종류 기존 선택값 조회 및 셋팅 (ajax)
	function getRemainDaysByVacationNameAndSet(vacationName, vacationStart, vacationDays, vacationTime) {
		console.log('getRemainDaysByVacationNameAndSet() vacationName : ' + vacationName);
		console.log('getRemainDaysByVacationNameAndSet() vacationStart : ' + vacationStart);
		console.log('getRemainDaysByVacationNameAndSet() vacationDays : ' + vacationDays);
		console.log('getRemainDaysByVacationNameAndSet() vacationTime : ' + vacationTime);
		
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
					
					// 기존값 주입
					if (vacationTime == '오전반차') {
						$('#amHalfDay').prop("checked", true);
					} else if (vacationTime == '오후반차') {
						$('#pmHalfDay').prop("checked", true);
					}
					
					if (vacationStart != '0000-00-00 00:00:00') {
						$('#vacationStart').val(vacationStart.substr(0, 10));
					}
				} else { // 연차 또는 보상일 경우
					longVacationInput(vacationName, response); // 연차 or 보상 input 출력
					vacationDaysSelect(response); // 연차 or 보상의 남은 휴가일수 selectbox 출력
					
					// 기존값 주입
					if (vacationStart != '0000-00-00 00:00:00') {
						$('#vacationStart').val(vacationStart.substr(0, 10));
						$('#vacationDays').val(vacationDays);
						vacationEndInput();
					}
					
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
	}
