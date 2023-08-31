<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyMember</title>
	<!-- jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- 다음 카카오 도로명 주소 API 사용 -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<!--사인을 이미지로 바꾸는 라이브러리 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/signature_pad/1.5.3/signature_pad.min.js"></script>
	
	<script>
		// 도로명 주소 찾기 함수
		function sample6_execDaumPostcode() {
			new daum.Postcode({
				oncomplete: function(data) {
					// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
					// 각 주소의 노출 규칙에 따라 주소를 조합한다.
					// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
					var addr = ''; // 주소 변수
					var extraAddr = ''; // 참고항목 변수
		
					// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
					if (data.userSelectedType == 'R') { // 사용자가 도로명 주소를 선택했을 경우
						addr = data.roadAddress;
					} else { // 사용자가 지번 주소를 선택했을 경우(J)
						addr = data.jibunAddress;
					}
		
					// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
					if (data.userSelectedType == 'R') {
						// 법정동명이 있을 경우 추가한다. (법정리는 제외)
						// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
						if (data.bname != '' && /[동|로|가]$/g.test(data.bname)) {
							extraAddr += data.bname;
						}
						// 건물명이 있고, 공동주택일 경우 추가한다.
						if (data.buildingName != '' && data.apartment == 'Y') {
							extraAddr += (extraAddr != '' ? ', ' + data.buildingName : data.buildingName);
						}
						// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
						if (extraAddr != '') {
							extraAddr = ' (' + extraAddr + ')';
						}
						// 조합된 참고항목을 해당 필드에 넣는다.
						$('#sample6_extraAddress').val(extraAddr);
					} else {
						$('#sample6_extraAddress').val('');
					}
		
					// 우편번호와 주소 정보를 해당 필드에 넣는다.
					$('#sample6_postcode').val(data.zonecode);
					$('#sample6_address').val(addr);
					// 커서를 상세주소 필드로 이동한다.
					$('#sample6_detailAddress').focus();
				}
			}).open();
		}
		
		// 페이지 로드
		$(document).ready(function() {
		// 1. 폼 저장 버튼 클릭시
			$('#saveBtn').click(function(event) {
		    	// 1) 주소값 가져오기
				let postcode = $('#sample6_postcode').val(); // 우편번호
				let address = $('#sample6_address').val(); // 주소
				let detailAddress = $('#sample6_detailAddress').val(); // 상세주소
				// 한줄의 주소로 합치기
				let fullAddress = postcode + ' ' + address + ' ' + detailAddress;
				console.log('주소 : ' + fullAddress);
				// hidden input에 주소값 저장
				$('#address').val(fullAddress);
			});
			
		// 2. 폼 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('Home으로 이동하시겠습니까?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/home'; // 로그인 페이지로 이동
				}
			});
		
			// 점 하나, 하나를 변환하여 배열에 저장
			let goal = $('#goal')[0]; // 첫번째 배열값을 가져와서 goal 변수에 저장
			// SignaturePad 생성자
			let sign = new SignaturePad(goal, {minWidth:2, maxWidth:2, penColor:'rgb(0, 0, 0)'});
		
		// 3. [서명 모달] 서명 입력 및 수정
		
			// 3-1. 저장 버튼 클릭 시
			$('#save').click(function() {
				if(sign.isEmpty()) {
					alert("서명이 필요합니다.");
				} else {
					let data = sign.toDataURL("image/png"); // url 가져오기
					$('#target').attr('src', data); // data값을 src 값으로 채우기
				}
			});
		
			// 3-2. 삭제 버튼 클릭 시
			$('#clear').on("click", function() {
				sign.clear(); // 패드의 내용을 모두 삭제
			});
			
			// 3-3. 수정 버튼 클릭 시(제출)
			$('#send').click(function(){
				console.log("서명 send 버튼 클릭");
				if (sign.isEmpty()) {
					alert("서명 내용이 없습니다.");
				} else {
					console.log("send 전송");
					$.ajax({ // Ajax를 사용해 데이터 가져오기
						url : '/member/uploadSign',
						data : {sign : sign.toDataURL('image/png', 1.0)},
						type : 'POST',
						success : function(jsonData){ // 서버로부터 받은 응답 데이터 jsonData
							console.log("서명 업로드 성공 jsonData : " + jsonData);
							alert('서명이 수정되었습니다.');
							location.reload(); // 이미지 전송 성공 후 페이지 리로드
						}
					});
				}	
			});
		
			// 3-4. 닫기 버튼 클릭 시
	        $('#signModal').on('hide.bs.modal', function () { // 모달창이 사라질 때
	            sign.clear(); // 서명 초기화
	        });
			
		// 4. 파라미터 값에 따른 알림
			// 페이지 로딩 시 실행
			var urlParams = new URLSearchParams(window.location.search);
			var message = urlParams.get('file');
			
			if ( message === 'Success_Insert_Image' ) {
				console.log("이미지 업로드 성공");
		        alert('이미지 업로드 성공');
		    } else if ( message === 'Fail_Insert_Image' ) {
		    	console.log("이미지 업로드 실패");
		    	alert('이미지 업로드 실패');
		    }
		// 5. [비밀번호 수정 모달] 정규식 검사 및 일치/불일치 검사
			// 5-1. 현재 비밀번호 입력 필드의 blur 이벤트 처리
		    $('#currentPassword').on('blur', function() {
		    	// 현재 비밀번호 입력 값 가져오기
				let currentPassword = $('#currentPassword').val();
				let successMsg = '비밀번호 일치';
				let errorMsg = '비밀번호 불일치';
				
			    // AJAX 비동기 요청 실행
			    $.ajax({
			        type: 'POST',
			        url: '/member/existingPwCheck',
			        data: { pw: currentPassword },
			        success: function(pwResult) {
			            // 결과 처리
			            if (pwResult === 'success') {
			                $('#currentPasswordMsg').text(successMsg).css('color', 'green');
			            } else if (pwResult === 'fail') {
			                $('#currentPasswordMsg').text(errorMsg).css('color', 'red');
			            }
			        },
			        error: function() {
			            // 오류 처리
			            console.log('현재 비밀번호 확인 메서드 : 오류 발생');
			        }
			    });
		    });
		
		    // 5-2. 새 비밀번호 입력 필드의 blur 이벤트 처리
		    $('#newPassword').on('blur', function() {
		    	// 정규식 패턴은 양 끝에 슬래시를 포함해야 한다
				let pwPattern = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}:;<>,.?~[\]\-]).{8,}$/;
				let newPw = $('#newPassword').val();
				let successMsg = '사용 가능한 비밀번호입니다.';
				let errorMsg = '최소 8자 이상, 영문 대소문자, 숫자, 특수문자를 포함해주세요.';
				
				if ( pwPattern.test(newPw) ) { // test 메서드는 해당 문자열이 정규식과 패턴이 일치하면 true를 반환
					$('#pwMsg1').text(successMsg).css('color', 'green');
					console.log('비밀번호 정규식 일치');
					return true;
				} else {
					$('#pwMsg1').text(errorMsg).css('color', 'red');
					console.log('비밀번호 정규식 불일치');
					return false;
				}
		    });
		
		    // 5-3. 새 비밀번호 확인 입력 필드의 blur 이벤트 처리
		    $('#confirmNewPassword').on('blur', function() {
		    	let pw1 = $('#newPassword').val();
				let pw2 = $('#confirmNewPassword').val();
				let successMsg = '비밀번호가 일치합니다.';
				let errorMsg = '비밀번호가 일치하지 않습니다.';
				
				if ( pw1 == pw2 ) { 
					$('#pwMsg2').text(successMsg).css('color', 'green');
					console.log('비밀번호 일치');
					return true;
				} else { 
					$('#pwMsg2').text(errorMsg).css('color', 'red');
					console.log('비밀번호 불일치')
					return false;
				}
		    });
		
		});
		
		
	</script>
</head>
<body>
    <!--
    	 탭 네비게이션
    	  1. 개인정보 수정
    	  2. 비밀번호 수정
    	  3. 휴가정보
    -->
    <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
            <a class="nav-link active" id="profile-tab" data-bs-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="true">개인정보 수정</a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="password-tab" data-bs-toggle="tab" href="#password" role="tab" aria-controls="password" aria-selected="false">비밀번호 수정</a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="vacation-tab" data-bs-toggle="tab" href="#vacation" role="tab" aria-controls="vacation" aria-selected="false">휴가정보</a>
        </li>
    </ul>
	
    <!-- 탭 내용 -->
    <div class="tab-content" id="myTabContent">
    
<!-- 1. 개인정보 수정 탭 -->
        <div class="tab-pane fade show active" id="profile" role="tabpanel" aria-labelledby="profile-tab">
            <!-- 사진 수정-->
            <form>
            	<!-- 사진 클릭 시 모달로 이미지 출력 -->
            	<label>사진</label>
				<img src="${image.memberPath}${image.memberSaveFileName}" width="200" height="200"
					 data-bs-toggle="modal" data-bs-target="#imageModal" class="hover">
            </form>
            <!-- 사원번호와 사원명 변경 불가 -->
            	<p>사원번호 ${empNo}</p>
            	<p>사원명 ${empName}</p>
            	<p>성별 ${member.gender}</p>
            <!-- 서명 수정 -->
            <form>
            	<label>서명</label>
            	<span data-bs-toggle="modal" data-bs-target="#signModal" class="hover">미리보기</span>
            </form>
            <!-- 개인정보 수정 폼 -->
            <form action="/member/modifyMember" method="post">
            	<input type="hidden" name="empNo" value="${empNo}">
			    <label for="phoneNumber">전화번호</label>
                <input type="text" id="phoneNumber" name="phoneNumber" value="${member.phoneNumber}"><br>
                
			    <br>
			    
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" value="${member.email}"><br>
                
                <!-- 기존 주소 표시 -->
			    <label for="existingAddress">주소</label>
			    <input type="text" id="existingAddress" name="existingAddress" value="${member.address}" readonly><br>
			
			    <!-- 새 주소 입력 -->
			    <div>
			        <input type="text" id="sample6_postcode" placeholder="우편번호">
			        <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
			        <input type="text" id="sample6_address" placeholder="주소"><br>
			        <input type="text" id="sample6_detailAddress" placeholder="상세주소">
			        <input type="text" id="sample6_extraAddress" placeholder="참고항목">
			    </div>
			    <input type="hidden" name="address" id="address"><br>
    
                <label for="createdate">가입일</label>
                <input type="text" id="createdate" name="createdate" value="${member.createdate}" readonly><br>
                
                <label for="updatedate">최종 수정일</label>
                <input type="text" id="updatedate" name="updatedate" value="${member.updatedate}" readonly><br>
                
                <hr>
                
                <button type="button" class="btn btn-secondary" id="cancelBtn">취소</button>
                <button type="submit" class="btn btn-primary" id="saveBtn">저장</button>
            </form>
        </div>
     </div>  
        <!-- 이미지 모달 -->
		<div class="modal" id="imageModal">
			<div class="modal-dialog">
				<div class="modal-content">
					<!-- 모달 헤더 -->
					<div class="modal-header">
						<h4 class="modal-title">사진</h4>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
					</div>
					<!-- 모달 본문 -->
					<c:choose>
				        <c:when test="${empty image.memberPath}">
				            <p>이미지가 없습니다.</p>
				        </c:when>
				        <c:otherwise>
				            <img src="${image.memberPath}${image.memberSaveFileName}">
				        </c:otherwise>
				    </c:choose>
				    <!-- 모달 푸터 -->
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
			            <form action="/member/uploadImage" method="post" enctype="multipart/form-data">
			                <input type="hidden" name="empNo" value="${empNo}">
			                <input type="file" name="multipartFile">
			                <c:choose>
				                <c:when test="${empty image.memberSaveFileName}">
				                	<button type="submit" class="btn btn-primary">입력</button>
				                </c:when>
				                <c:otherwise>
				                	<button type="submit" class="btn btn-primary">수정</button>
				                </c:otherwise>
			                </c:choose>
			            </form>
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
						<c:choose>
					        <c:when test="${empty sign.memberPath}">
					            <p>이미지가 없습니다.</p>
					            <canvas id="goal" style="border: 1px solid black" width="200" height="200"></canvas>
				            	<div>
									<button id="save">저장</button>
									<button id="clear">삭제</button>
									<button id="send">수정</button>
								</div>
								<div>
									<img id="target" src = "" width=200, height=200>
								</div>
					        </c:when>
					        <c:otherwise>
				            	<img src="${sign.memberPath}${sign.memberSaveFileName}">
				            	<br>
				            	<canvas id="goal" style="border: 1px solid black" width="200" height="200"></canvas>
				            	<div>
									<button id="save">저장</button>
									<button id="clear">삭제</button>
									<button id="send">수정</button>
								</div>
								<div>
									<img id="target" src = "" width=200, height=200>
								</div>
				            </c:otherwise>
			            </c:choose>
					</div>
					<!-- 모달 푸터 -->
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" id="signModal" data-bs-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 서명 모달 끝 -->
		
<!-- 2. 비밀번호 수정 탭 -->
        <div class="tab-pane fade" id="password" role="tabpanel" aria-labelledby="password-tab">
            <form>
            	<!-- 현재 비밀번호 일치/불일치 검사 -->
                <label for="currentPassword">현재 비밀번호:</label>
		        <input type="password" id="currentPassword" name="pw">
		        <span id="currentPasswordMsg" class="validation-msg"></span><br>
				<!-- 새 비밀번호 정규식 검사 -->
		        <label for="newPassword">새 비밀번호:</label>
		        <input type="password" id="newPassword" name="newPw">
		        <span id="pwMsg1" class="validation-msg"></span><br>
				<!-- 새 비밀번호 일치/불일치 검사 -->
		        <label for="confirmNewPassword">새 비밀번호 확인:</label>
		        <input type="password" id="confirmNewPassword" name="newPw2">
		        <span id="pwMsg2" class="validation-msg"></span><br>
		
		        <div id="passwordMatchMessage" class="text-success"></div>
		
		        <hr>
		
		        <button type="button" class="btn btn-secondary">취소</button>
		        <button type="button" class="btn btn-primary" id="saveButton">저장</button>

            </form>
        </div>
        
<!-- 3. 휴가정보 탭 -->
        <div class="tab-pane fade" id="vacation" role="tabpanel" aria-labelledby="vacation-tab">
		    <h1>휴가정보</h1>
            <h4>남은 휴가일수 : ${remain_days} 일</h4>
		    <form method="post" action="${pageContext.request.contextPath}/vacationHistory">
		        <div class="search-area">
		            <label class="search-label">기간검색</label>
		            <input type="date" name="startDate">
		            <input type="date" name="endDate">
		            <button type="submit">검색</button>
		        </div>      
				<div class="sort-area">
				    <label class="sort-label">정렬</label>
				    <select name="col">
				        <option value="createdate">발생 일자</option>
				        <option value="vacationHistoryNo">휴가 번호</option>
				    </select>
				    <select name="ascDesc">
				        <option value="ASC">오름차순</option>
				        <option value="DESC">내림차순</option>
				    </select>
				    <button type="submit">정렬</button>
				</div>
		    </form>
		    
		    <div align="center">
		        <a href="${pageContext.request.contextPath}/vacationHistory?vacationName=연차">연차</a>
		        <a href="${pageContext.request.contextPath}/vacationHistory?vacationName=보상">보상</a>
		    </div>
		    
		    <table class="table">
		        <thead class="table-active">
		            <tr>
		                <th>휴가 번호</th>
		                <th>휴가 종류</th>
		                <th>휴가 일수(+/-)</th>
		                <th>휴가 일수</th>
		                <th>발생 일자</th>
		            </tr>
		        </thead>
		        <tbody>
		            <c:forEach var="history" items="${vacationHistoryList}">
						<tr>
						    <td>${history.vacationHistoryNo}</td>
						    <td>${history.vacationName}</td>
						    <td>${history.vacationPm}</td>
						    <td>${history.vacationDays}</td>
						    <td>${history.createdate}</td>
						</tr>
		            </c:forEach>
		        </tbody>
		    </table>
		    <nav class="pagination justify-content-center">
		        <ul class="pagination">
		            <c:forEach var="page" begin="${minPage}" end="${maxPage}">
		                <li class="page-item ${currentPage eq page ? 'active' : ''}">
		                    <a class="page-link" href="${pageContext.request.contextPath}/vacationHistory?currentPage=${page}&empNo=${empNo}&startDate=${startDate}&endDate=${endDate}&vacationName=${vacationName}&ascDesc=${ascDesc}">
		                        ${page}
		                    </a>
		                </li>
		            </c:forEach>
		        </ul>
		    </nav>
    	</div>
</body>
</html>