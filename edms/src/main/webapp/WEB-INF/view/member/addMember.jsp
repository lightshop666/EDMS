<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addMember</title>
	<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- 다음 카카오 도로명 주소 API -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		$(document).ready(function() {
			// 회원가입 실패시 alert 띄우기
			let error = '${param.error}';
			if (error == 'true') {
			    console.log('회원가입 실패');
			    alert('회원가입에 실패했습니다. 다시 시도해주세요.');
			}
			
			// 사원번호 검사
			$('#empNo').blur(function() {
				if( $('#empNo').val().length < 11 ) { // Integer 타입의 최대 정수 범위 검사
					$.ajax({
						url : '/checkEmpNo',
						type : 'post',
						data : {empNo : $('#empNo').val()},
						success : function(response) {
							console.log('사원번호 검사 실행');
							alert(response);
						},
						error: function(error) {
		                	console.error('사원번호 검사 실패: ' + error);
		                }
					});
				} else {
					alert('사원번호는 7자리입니다.');
				}
			});
			
			// 비밀번호 정규식 검사
			$('#pw1').blur(function() {
				let pwPattern = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}:;<>,.?~[\]\-]).{8,}$/;
				// 정규식 패턴은 양 끝에 슬래시를 포함해야 한다
				
				if ( pwPattern.test( $('#pw1').val() ) ) {
					// test 메서드는 해당 문자열이 정규식과 패턴이 일치하면 true를 반환한다
					$('#pwMsg1').html('<span style="color: green;">사용 가능한 비밀번호입니다.</span>');
					console.log('비밀번호 정규식 일치');
				} else {
					$('#pwMsg1').html('<span style="color: red;">최소 8자 이상, 영문 대소문자, 숫자, 특수문자를 포함해주세요.</span>');
					console.log('비밀번호 정규식 불일치');
				}
			});
			
			// 비밀번호 일치불일치 검사
			$('#pw2').blur(function() { // 비밀번호 확인란에 입력 후 커서를 떼면 이벤트 발생
				if ( $('#pw1').val() != $('#pw2').val() ) {
					$('#pwMsg2').html('<span style="color: red;">비밀번호가 일치하지 않습니다.</span>');
					console.log('비밀번호 불일치');
				} else if ( $('#pw1').val() == $('#pw2').val() ) {
					$('#pwMsg2').html('<span style="color: green;">비밀번호가 일치합니다.</span>');
					console.log('비밀번호 일치');
				}
			});

			// 회원가입 버튼 클릭 시 이벤트 발생
		    $('#addMemberBtn').click(function() {
		        // 공백검사
		        // 주소값 가져오기
		        let postcode = $('#sample6_postcode').val();
		        let address = $('#sample6_address').val();
		        let detailAddress = $('#sample6_detailAddress').val();
		        // 한줄의 주소로 합치기
		        let fullAddress = postcode + " " + address + " " + detailAddress;
		        console.log('주소 : ' + fullAddress);
		        $('#fullAddress').val(fullAddress);
		    });			
		});
	</script>
</head>
<body>
	<form action="/member/addMember" method="post">
		<table border="1">
			<tr>
				<td colspan="3">
					<h1>회원가입</h1>
				</td>
			</tr>
			<tr>
				<td>사원번호</td>
				<td colspan="2">
					<input type="number" name="empNo" value="${empNo}" id="empNo"> <!-- empNo가 넘어올경우 출력 -->
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td colspan="2">
					<input type="text" name="memberName">
				</td>
			</tr>
			<tr>
				<td>PW</td>
				<td>
					<input type="password" name="pw" placeholder="비밀번호를 입력하세요" id="pw1">
				</td>
				<td>
					<span id="pwMsg1">최소 8자 이상, 영문 대소문자, 숫자, 특수문자를 포함해주세요.</span>
				</td>
			</tr>
			<tr>
				<td>PW확인</td>
				<td>
					<input type="password" name="pw2" placeholder="비밀번호를 한번 더 입력하세요" id="pw2">
				</td>
				<td>
					<span id="pwMsg2"></span>
				</td>
			</tr>
			<tr>
				<td>성별</td>
					<td colspan="2">
					<input type="radio" name="gender" value="M">남
					<input type="radio" name="gender" value="F">여
				</td>
			</tr>
			<tr>
				<td>e-mail</td>
				<td>
					<input type="email" name="email" id="email">
				</td>
				<td>
					<span id="emailMsg"></span>
				</td>
			</tr>
			<tr>
				<td>address</td>
				<td colspan="2">
					<!-- 도로명 주소 찾기 -->
					<input type="text" id="sample6_postcode" placeholder="우편번호">
					<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
					<input type="text" id="sample6_address" placeholder="주소"><br>
					<input type="text" id="sample6_detailAddress" placeholder="상세주소">
					<input type="text" id="sample6_extraAddress" placeholder="참고항목">
					<input type="hidden" name="address" id="fullAddress">
					
					<script>
					// 도로명 주소 찾기 API
					    function sample6_execDaumPostcode() {
					        new daum.Postcode({
					            oncomplete: function(data) {
					                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
					
					                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
					                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
					                var addr = ''; // 주소 변수
					                var extraAddr = ''; // 참고항목 변수
					
					                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
					                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					                    addr = data.roadAddress;
					                } else { // 사용자가 지번 주소를 선택했을 경우(J)
					                    addr = data.jibunAddress;
					                }
					
					                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
					                if(data.userSelectedType === 'R'){
					                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
					                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
					                        extraAddr += data.bname;
					                    }
					                    // 건물명이 있고, 공동주택일 경우 추가한다.
					                    if(data.buildingName !== '' && data.apartment === 'Y'){
					                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					                    }
					                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					                    if(extraAddr !== ''){
					                        extraAddr = ' (' + extraAddr + ')';
					                    }
					                    // 조합된 참고항목을 해당 필드에 넣는다.
					                    document.getElementById("sample6_extraAddress").value = extraAddr;
					                
					                } else {
					                    document.getElementById("sample6_extraAddress").value = '';
					                }
					
					                // 우편번호와 주소 정보를 해당 필드에 넣는다.
					                document.getElementById('sample6_postcode').value = data.zonecode;
					                document.getElementById("sample6_address").value = addr;
					                // 커서를 상세주소 필드로 이동한다.
					                document.getElementById("sample6_detailAddress").focus();
					            }
					        }).open();
					    }
					</script>
				</td>
			</tr>
		</table>
		<button type="button" id="addMemberBtn">취소</button><!-- 왼쪽 정렬 -->
		<button type="submit">저장</button><!-- 오른쪽 정렬 -->
	</form>
</body>
</html>