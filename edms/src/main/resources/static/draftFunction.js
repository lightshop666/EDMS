	/*
		전자결재 작성시 공통적으로 사용되는 공통 함수를 모아두었습니다.
		공통 함수의 목록은 다음과 같습니다.
		1. 사원목록(JSON)을 조회하여 선택한 결재자의 정보(이름, 부서명, 직급) 출력
		2. 중간승인자 정보 출력 및 hidden에 값 주입
		3. 최종승인자 정보 출력 및 hidden에 값 주입
		4. 수신참조자(int 배열) 정보 출력 및 hidden에 값 주입
		5. 임시저장 -> 유효성 검사, 임시저장 유무(isSaveDraft) hidden 주입(true), 폼 제출
		5. 저장(기안) -> 유효성 검사, 임시저장 유무(isSaveDraft) hidden 주입(false), 폼 제출
		6. 문서 상세 페이지에서 클릭한 버튼에 따라 액션 분기 (결재 상태 업데이트)
		
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
	
	// 결재 상태 업데이트 메서드
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
					window.location.href = ''; // 내 문서함의 기안탭으로.. 구현예정
				} else if (role == '중간승인자' || role == '최종승인자') {
					window.location.href = ''; // 내 문서함의 결재탭으로.. 구현예정
				} // 수신함으로 이동시키기 구현예정..
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