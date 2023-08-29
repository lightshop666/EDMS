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
		
		// 페이지 로드 시
		$(document).ready(function() {
		    // 비밀번호 확인용 모달을 JavaScript로 제어
		    const passwordModal = new bootstrap.Modal(document.getElementById('passwordModal'));
	
		    // 비밀번호 확인 모달을 열기
		    passwordModal.show();
	
		 	// "확인" 버튼 클릭 시 비밀번호 확인 로직 처리
		    $('#confirmPasswordButton').click(function() {
		        const pw = $('#pw').val();
	
		     	// 비밀번호 확인 API 호출
		        $.post('/checkPw', { pw: pw })
		        .done(function(result) {
		            if (result) { // 서버에서 true 반환시 모달 닫기
		                passwordModal.hide(); // 모달 닫기
		            } else {
		                // 비밀번호가 일치하지 않다는 오류 메시지 표시
		                $('#passwordErrorMessage').text('비밀번호가 일치하지 않습니다.');
		            }
		        });
		    });
		    
			// "닫기" 버튼 클릭 시 홈으로 이동
	        $('.modal-footer .btn-secondary').click(function() {
	            window.location.href = '/home'; // 홈 페이지 주소로 변경
	        });
			
	     	
			// 저장 버튼 클릭시
			$('#saveBtn').click(function(event) {
		    	// 1) 주소값 가져오기
				let postcode = $('#sample6_postcode').val(); // 우편번호
				let address = $('#sample6_address').val(); // 주소
				let detailAddress = $('#sample6_detailAddress').val(); // 상세주소
				// 한줄의 주소로 합치기
				let fullAddress = postcode + ' ' + address + ' ' + detailAddress;
				console.log('주소 : ' + fullAddress);
				// hidden input에 주소값 저장
				$('#fullAddress').val(fullAddress);
			});
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('Home으로 이동하시겠습니까?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/home'; // 로그인 페이지로 이동
				}
			});
		
		});
	</script>
</head>
<body>
    <!-- 페이지 로드시 비밀번호 확인 모달창 -->
    <div class="modal fade" id="passwordModal" tabindex="-1" aria-labelledby="passwordModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="passwordModalLabel">비밀번호 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label for="passwordInput" class="form-label">비밀번호를 입력하세요:</label>
                            <input type="password" class="form-control" id="pw" name="pw">
                        </div>
                    </form>
                </div>
			    <div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
			        <button type="button" class="btn btn-primary" id="confirmPasswordButton">확인</button>
			    </div>
			    <div id="passwordErrorMessage" class="text-danger"></div>
            </div>
        </div>
    </div>

    <!-- 탭 네비게이션(개인정보 수정, 비밀번호 수정, 휴가정보) -->
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
				<img src="${image.memberPath}${image.memberSaveFileName}.${image.memberFiletype}" width="200" height="200"
					 data-bs-toggle="modal" data-bs-target="#imageModal" class="hover">
            </form>
            <!-- 사원번호와 사원명 변경 불가 -->
            	<p>사원번호 ${empNo}</p>
            	<p>사원명 ${empName}</p>
            <!-- 서명 수정 -->
            <form>
            	<label>서명</label>
            	<span data-bs-toggle="modal" data-bs-target="#signModal" class="hover">미리보기</span>
            </form>
            <!-- 개인정보 수정 폼 -->
            <form action="/member/modifyMember" method="post">
                <label>성별</label>
			    <input type="radio" id="M" name="gender" value="M" <c:if test="${member.gender == 'M'}">checked</c:if>>
			    <label for="male">남성</label>
			    <input type="radio" id="F" name="gender" value="F" <c:if test="${member.gender == 'F'}">checked</c:if>>
			    <label for="female">여성</label>
			    
			    <br>
			    
			    <label for="phoneNumber">전화번호</label>
                <input type="text" id="phoneNumber" name="phoneNumber" value="${member.phoneNumber}"><br>
                
			    <br>
			    
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" value="${member.email}"><br>
                
                <label for="address">주소</label>
                <input type="text" id="existingAddress" name="existingAddress" value="${member.address}"><br>
                <input type="text" id="sample6_postcode" placeholder="우편번호">
				<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
				<input type="text" id="sample6_address" placeholder="주소"><br>
				<input type="text" id="sample6_detailAddress" placeholder="상세주소">
				<input type="text" id="sample6_extraAddress" placeholder="참고항목">
				<input type="hidden" name="address" id="fullAddress"><br>
                
                <label for="createdate">가입일</label>
                <input type="date" id="createdate" name="createdate" value="${member.createdate}"><br>
                
                <label for="updatedate">수정일</label>
                <input type="date" id="updatedate" name="updatedate" value="${member.updatedate}"><br>
                
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
		
<!-- 2. 비밀번호 수정 탭 -->
        <div class="tab-pane fade" id="password" role="tabpanel" aria-labelledby="password-tab">
            <form>
                <label for="currentPassword">현재 비밀번호:</label>
                <input type="password" id="currentPassword" name="pw"><br>
                <label for="newPassword">새 비밀번호:</label>
                <input type="password" id="newPassword" name="newPw"><br>
                <label for="confirmNewPassword">새 비밀번호 확인:</label>
                <input type="password" id="confirmNewPassword" name="newPw2"><br>
                <div id="passwordMatchMessage" class="text-success"></div>
                <hr>
                <button type="button" class="btn btn-secondary">취소</button>
                <button type="button" class="btn btn-primary">저장</button>
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
		                <th>사원 번호</th>
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
						    <td>${history.empNo}</td>
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