<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminMemberOne</title>
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 추가 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
	
	<script>
		// 랜덤 비밀번호 생성 규칙을 정할 상수 선언
		const UPPERCASE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; // 영대문자
		const NUMBERS = '0123456789'; // 숫자
		const SPECIAL_CHARS = '!@#%'; // 특수문자
		const ALL_CHARACTERS = UPPERCASE + NUMBERS + SPECIAL_CHARS; // 영대문자, 숫자, 특수문자를 보유한 문자 집합 상수 선언
		const PW_LENGTH = 12; // 생성할 비밀번호의 길이 선언
		
		// 함수 선언 시작
		// 랜덤 비밀번호 생성 함수
		let tempPw = ''; // 임시 비밀번호 변수 선언
		
		function getRandomPw() {
			tempPw = ''; // 임시 비밀번호를 빈 문자열로 초기화
			
			while (tempPw.length < PW_LENGTH) { // 비밀번호 길이만큼 반복
				// ALL_CHARACTERS의 길이 내에서 랜덤한 인덱스 선택
				let index = Math.floor(Math.random() * ALL_CHARACTERS.length);
				// Math.random() -> 0과 1 사이의 무작위한 실수를 반환
				// ALL_CHARACTERS.length 를 곱하면 결과적으로 0이상 ALL_CHARACTERS.length 미만의 랜덤값을 가짐
				// Math.floor() -> 소숫점을 버려 정수화
				tempPw += ALL_CHARACTERS[index];
				// 랜덤한 인덱스 위치의 문자를 임시 비밀번호에 추가
			}
		
			return tempPw;
		}

		// 이벤트 스크립트 시작
		$(document).ready(function() {
			
			// 비밀번호 생성 버튼 클릭시 이벤트 발생
			$('#getPwBtn').click(function() {
				tempPw = getRandomPw(); // 랜덤 비밀번호 생성 함수 호출
				console.log('랜덤 비밀번호 생성 : ' + tempPw);
				$('#tempPw').text(tempPw); // view에 출력
			});
			
			// 모달창의 비밀번호 초기화 버튼 클릭시 이벤트 발생 // 비동기
			$('#updatePwBtn').click(function() {
				if (tempPw == '') { // 비밀번호를 생성하지 않았을시
					alert('비밀번호를 생성해주세요.');
				} else { // 비밀번호를 생성했다면
					let result = confirm('생성한 임시 비밀번호로 초기화할까요?');
					// 사용자 선택 값에 따라 true or false 반환
					
					if (result) { // 확인 선택 시 true 반환
						$.ajax({ // 비밀번호 초기화 비동기 방식으로 실행
							url : '/AdminUpdatePw',
							type : 'post',
							data : {tempPw : tempPw,
									empNo : ${member.empNo} },
							success : function(response) {
								if (response == 1) { // row 값이 1로 반환되면 성공
									console.log('비밀번호 초기화 완료');
									$('#updateResult').text('비밀번호 초기화 완료').css('color', 'green');	
								} else {
									console.log('비밀번호 초기화 실패');
									$('#updateResult').text('비밀번호 초기화 실패').css('color', 'red');
								}
							},
							error : function(error) {
								console.error('비밀번호 초기화 실패 : ' + error);
								$('#updateResult').text('비밀번호 초기화 실패').css('color', 'red');
							}
						});
					}
				}
			});
			
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
		.hover { /* 모달창이 열리는 것을 직관적으로 알리기 위해 커서 포인터를 추가 */
		  cursor: pointer;
		}
		.hover:hover { /* 호버 시 약간의 그림자와 배경색 변경 효과 추가 */
		  box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
		  background-color: #f5f5f5;
		}
	</style>
	
</head>
<body>
	<h1>개인정보 조회 - 관리자</h1>
	<table border="1">
		<tr>
			<td>사진</td>
			<td>
				<!-- 사진 클릭 시 사진 모달로 이미지 출력 -->
				<img src="${image.memberPath}${image.memberSaveFileName}.${image.memberFiletype}" width="200" height="200"
					data-bs-toggle="modal" data-bs-target="#imageModal" class="hover">
			</td>
		</tr>
		<tr>
			<td>사원명</td>
			<td>
				${member.empName}
			</td>
		</tr>
		<tr>
			<td>성별</td>
			<td>
				${member.gender}
			</td>
		</tr>
		<tr>
			<td>이메일</td>
			<td>
				${member.email}
			</td>
		</tr>
		<tr>
			<td>주소</td>
			<td>
				${member.address}
			</td>
		</tr>
		<tr>
			<td>저장된 서명</td>
			<td>
				<!-- 미리보기 클릭 시 사진 모달로 서명 출력 -->
				<span data-bs-toggle="modal" data-bs-target="#signModal" class="hover">미리보기</span>
			</td>
		</tr>
		<tr>
			<td>가입일</td>
			<td>
				${member.createdate}
			</td>
		</tr>
		<tr>
			<td>수정일</td>
			<td>
				${member.updatedate}
			</td>
		</tr>
	</table>
	<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
	<!-- 비밀번호 초기화 버튼 클릭시 모달창 출력 -->
	<button type="submit" data-bs-toggle="modal" data-bs-target="#pwModal">비밀번호 초기화</button> <!-- 오른쪽 정렬 -->
	
	<!-- 모달창 시작 -->
	
	<!-- 이미지 모달 -->
	<div class="modal" id="imageModal">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- 모달 헤더 -->
				<div class="modal-header">
					<h4 class="modal-title">사원 사진</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
				</div>

				<!-- 모달 본문 -->
				<div class="modal-body">
					<img src="${image.memberPath}${image.memberSaveFileName}.${image.memberFiletype}">
				</div>

				<!-- 모달 푸터 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 이미지 모달 끝 -->
	
	<!-- 서명 모달 -->
	<div class="modal" id="signModal">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- 모달 헤더 -->
				<div class="modal-header">
					<h4 class="modal-title">사원 서명</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
				</div>

				<!-- 모달 본문 -->
				<div class="modal-body">
					<img src="${sign.memberPath}${sign.memberSaveFileName}.${sign.memberFiletype}">
				</div>

				<!-- 모달 푸터 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 서명 모달 끝 -->
	
	<!-- 비밀번호 초기화 모달 -->
	<div class="modal" id="pwModal">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- 모달 헤더 -->
				<div class="modal-header">
					<h4 class="modal-title">비밀번호 초기화</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
				</div>

				<!-- 모달 본문 -->
				<div class="modal-body">
					<div>
						랜덤한 임시 비밀번호를 생성하여 초기화합니다.
					</div>
					<div>
						<button type="button" id="getPwBtn">비밀번호 생성</button>
						임시 비밀번호 : <span id="tempPw"></span>
					</div> <br>
					<div>
						<p style="color:red;">
							비밀번호 초기화 후 다시 되돌릴 수 없습니다. <br>
							생성한 임시 비밀번호를 사용자에게 반드시 전달하세요.
						</p>
						<button type="button" id="updatePwBtn">비밀번호 초기화</button>
						<span id="updateResult"></span>
					</div>
				</div>

				<!-- 모달 푸터 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 비밀번호 초기화 모달 끝 -->
	
	<!-- 모달창 끝 -->
</body>
</html>