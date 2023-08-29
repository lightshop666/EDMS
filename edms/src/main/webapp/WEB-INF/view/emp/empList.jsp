<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>empList</title>
<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<!-- excel download api : sheetjs  -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>
<!-- file download api : FileServer saveAs-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 추가 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>

<script>
	//랜덤 비밀번호 생성 규칙을 정할 상수 선언
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
	$(document).ready(function() {
		
		// 1. 비밀번호 초기화
	    $('#getPwBtn').click(function() { // 비밀번호 생성 버튼 클릭시 이벤트 발생
	       tempPw = getRandomPw(); // 랜덤 비밀번호 생성 함수 호출
	       console.log('랜덤 비밀번호 생성 : ' + tempPw);
	       $('#tempPw').text(tempPw); // view에 출력
	    });
	      
	      let empNoTest = '';
	      
	      $('.getEmpNo').click(function() { // empNo가 전달되지 않아 모달창 열리지 X -> foreach문 안에 있는 empNo에 class 이름을 부여하여 값을 받아옴으로써 해결
	         empNoTest = $(this).data("empno");
	         console.log('번호 가져오기1 : ' + empNoTest);
	      });
	    
	    // 모달창의 비밀번호 초기화 버튼 클릭시 이벤트 발생 // 비동기
	    $('#updatePwBtn').click(function() {
	       if (tempPw == '') { // 비밀번호를 생성하지 않았을시
	          alert('비밀번호를 생성해주세요.');
	       } else { // 비밀번호를 생성했다면
	          let result = confirm('생성한 임시 비밀번호로 초기화할까요?');
	          // 사용자 선택 값에 따라 true or false 반환
	          
	          if (result) { // 확인 선택 시 true 반환
	             console.log('디버깅');
	             console.log('번호 가져오기2 : ' + empNoTest);
	             $.ajax({ // 비밀번호 초기화 비동기 방식으로 실행
	                url : '/adminUpdatePw',
	                type : 'post',
	                data : {tempPw : tempPw,
	                      empNo : empNoTest },
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
	    
	    // 2. 엑셀 업로드 버튼 클릭 시
	     $('#uploadBtn').click(function(event) {
	         const fileInput = $('#fileInput');
	
	         if (fileInput.get(0).files.length === 0) {
	             event.preventDefault(); // 기본 동작 중단
	             alert('파일을 선택해주세요.');
	             return false;
	         }
	      
	         const file = fileInput.get(0).files[0]; // 선택된 파일 가져오기
	         const fileName = file.name;
	         const fileExtension = fileName.split('.').pop().toLowerCase();
	      
	         // 엑셀 파일이 아닌 경우 업로드 막기
	         if (fileExtension !== 'xlsx' && fileExtension !== 'xls') {
	             event.preventDefault(); // 기본 동작 중단
	             alert('엑셀 파일(xlsx 또는 xls)만 선택해주세요.');
	             return false;
	         }
	     });
	   
	     // 3. 파라미터 값에 따라 알림 메세지
	     const urlParams = new URLSearchParams(window.location.search); // 서버에서 전송한 결과 값 처리
	     const resultParam = urlParams.get('result'); // '?' 제외한 파라미터 이름만 사용
	     const errorParam = urlParams.get('error'); // error 파라미터 값을 가져옴
	     
	     if (resultParam === 'fail') { // fail 파라미터 값이 있고
	         if (errorParam === 'duplicate') { // 그 값이 duplicate 일 때
	             alert('중복된 사원번호가 있습니다. 엑셀 파일을 수정해주세요.'); // 중복된 사원번호라는 것을 알림
	         } else {
	             alert('엑셀 파일 업로드에 실패했습니다. 엑셀 파일을 확인해주세요.'); // 이외 오류에 대해 엑셀 파일 재확인 알림
	         }
	     } else if (failParam == 'success') { // success 파라미터 값이 있을 경우에만 알림 표시
	         alert('엑셀 파일 업로드에 성공했습니다.');
	     }
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
	<h1>사원 목록</h1>
	
<!-- [시작] 검색 ------->
	<form action="/emp/empList" method="GET" id="employee-form">
		<!-- 1. 입사년도별 조회 -->
	    <div class="search-by-year-area">
	        <label class="search-by-year-label">입사년도</label>
	        <input type="date" name="startDate" class="search-by-year-input" value="${param.startDate}">
	        ~
	        <input type="date" name="endDate" class="search-by-year-input" value="${param.endDate}">
	    </div>
		<!-- 2. 재직/퇴직에 따른 정렬 -->
	    <div class="sort-area">
	    	<label class="sort-label">정렬</label>
		    <select name="empDate" class="sort-input">
		        <option value="employ_date" <c:if test="${param.empDate.equals('employ_date')}">selected</c:if>>입사일</option>
		        <option value="retirement_date" <c:if test="${param.empDate.equals('retirement_date')}">selected</c:if>>퇴사일</option>
		    </select>
	        <select name="ascDesc" class="sort-select">
	            <option value="ASC" <c:if test="${param.ascDesc.equals('ASC')}">selected</c:if>>오름차순</option>
	            <option value="DESC" <c:if test="${param.ascDesc.equals('DESC')}">selected</c:if>>내림차순</option>
	        </select>
	    </div>
	    <!-- 3. 재직사항별 조회 -->
	    <div class="sort-personnel-area">
	    	<label class="sort-label">재직사항</label>
		    <select name="empState" class="sort-input">
		        <option value="" <c:if test="${param.empState.equals('')}">selected</c:if>>전체</option>
		        <option value="재직" <c:if test="${param.empState.equals('재직')}">selected</c:if>>재직</option>
		        <option value="퇴직" <c:if test="${param.empState.equals('퇴직')}">selected</c:if>>퇴직</option>
		    </select>
		    <label class="sort-label">부서명</label>
		    <select name="deptName" class="sort-input">
		        <option value="" <c:if test="${param.deptName.equals('')}">selected</c:if>>전체</option>
		        <option value="사업추진본부" <c:if test="${param.deptName.equals('사업추진본부')}">selected</c:if>>사업추진본부</option>
		        <option value="경영지원본부" <c:if test="${param.deptName.equals('경영지원본부')}">selected</c:if>>경영지원본부</option>
		        <option value="영업지원본부" <c:if test="${param.deptName.equals('영업지원본부')}">selected</c:if>>영업지원본부</option>
		    </select>
		    
		    <label class="sort-label">팀명</label>
			<select name="teamName" class="sort-input">
			    <option value="" <c:if test="${param.teamName.equals('')}">selected</c:if>>전체</option>
			    <option value="기획팀" <c:if test="${param.teamName.equals('기획팀')}">selected</c:if>>기획팀</option>
			    <option value="경영팀" <c:if test="${param.teamName.equals('경영팀')}">selected</c:if>>경영팀</option>
			    <option value="영업팀" <c:if test="${param.teamName.equals('영업팀')}">selected</c:if>>영업팀</option>
			</select>
		    
		    <label class="sort-label">직급</label>
			<select name="empPosition" class="sort-input">
			    <option value="" <c:if test="${param.empPosition.equals('')}">selected</c:if>>전체</option>
			    <option value="CEO" <c:if test="${param.empPosition.equals('CEO')}">selected</c:if>>CEO</option>
			    <option value="부서장" <c:if test="${param.empPosition.equals('부서장')}">selected</c:if>>부서장</option>
			    <option value="팀장" <c:if test="${param.empPosition.equals('팀장')}">selected</c:if>>팀장</option>
			    <option value="부팀장" <c:if test="${param.empPosition.equals('부팀장')}">selected</c:if>>부팀장</option>
			    <option value="사원" <c:if test="${param.empPosition.equals('사원')}">selected</c:if>>사원</option>
			</select>
		</div>
	    <!-- 4. 특정 사원의 정보 검색 -->
	    <div class="search-area">
	        <label class="search-label">검색</label>
	        <select name="searchCol" class="search-input">
	            <option value="empNo" <c:if test="${param.searchCol.equals('empNo')}">selected</c:if>>사원번호</option>
	            <option value="empName" <c:if test="${param.searchCol.equals('empName')}">selected</c:if>>사원명</option>
	        </select>
	        <input type="text" name="searchWord" class="search-input">
	    </div>
	        <button type="submit" id="search-button">검색</button>
    </form>
<!-- [끝] 검색 ------->

	<hr><!-- 구분선 -->
	
<!-- 엑셀 공통 양식 다운로드 -->
	<a href="/file/defaultTemplate.xlsx" download="defaultTemplate.xlsx">사원 등록 공통 양식</a>


<!-- [시작] 파일 업로드 ------->
	<form id="uploadForm" action="/excelUpload" method="post" enctype="multipart/form-data">
		<input type="file" name="file" id="fileInput">
		<button type="submit" id="uploadBtn">저장</button>
		<span id="msg"></span>
	</form>
<!-- [끝] 파일 업로드 ------->
	<a href="/emp/excelDownload?ascDesc=${param.ascDesc}&empState=${param.empState}&empDate=${param.empDate}&deptName=${param.deptName}&teamName=${param.teamName}&empPosition=${param.empPosition}&searchCol=${param.searchCol}&searchWord=${param.searchWord}&startDate=${param.startDate}&endDate=${param.endDate}" class="generateListBtn">엑셀 다운로드</a>
	
<!-- [시작] 관리자 리스트 출력 ------->	
	<table border="1">
		<!-- 관리자의 경우, 비밀번호 초기화 가능 -->
		<tr>
			<c:if test="${accessLevel >= 3}">
                <th>비밀번호 초기화</th>
            </c:if>
			<th>사원번호</th>
			<th>사원명</th>
			<th>부서명</th>
			<th>팀명</th>
			<th>직급</th>
			<th>입사일</th>
			<th>잔여휴가일</th>
			<th>회원가입유무</th>
			<th>권한</th>
		</tr>
		<c:forEach var="e" items="${enrichedEmpList}">
	        <tr>
				<c:if test="${accessLevel >= 3}">
                    <td>
                        <button type="button" class="getEmpNo" data-empno="${e.empNo}" data-bs-toggle="modal" data-bs-target="#pwModal">
                            초기화
                        </button>
                    </td>
                </c:if>
				<td>${e.empNo}</td>
				<td onclick="window.location='/emp/modifyEmp?empNo=${e.empNo}';">${e.empName}</td>
				<td>${e.deptName}</td>
				<td>${e.teamName}</td>
				<td>${e.empPosition}</td>
				<td>${e.employDate}</td><!-- YYYY-MM-DD -->
				<th>${e.remainDays}</th>
				<td>${e.isMember}</td>
				<td>${e.accessLevel}</td>
			</tr>
		</c:forEach>
	</table>
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
							임시 비밀번호 : <span id="tempPw"></span> <!-- 비밀번호 생성시 출력 -->
						</div> <br>
						<div>
							<p style="color:red;">
								비밀번호 초기화 후 다시 되돌릴 수 없습니다. <br>
								생성한 임시 비밀번호를 사용자에게 반드시 전달하세요.
							</p>
							<button type="button" id="updatePwBtn">비밀번호 초기화</button>
							<span id="updateResult"></span> <!-- 비밀번호 초기화 결과 출력 -->
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
<!-- [끝] 관리자 리스트 출력 ------->	

<!-- [시작] 페이징 ------->
<nav aria-label="Page navigation">
    <ul class="pagination">
        <c:if test="${minPage > 1}">
            <li class="page-item">
                <a class="page-link" href="${pageContext.request.contextPath}/emp/empList?currentPage=${currentPage - 1}" aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                    <span class="sr-only">Previous</span>
                </a>
            </li>
        </c:if>
        
        <c:forEach var="i" begin="${minPage}" end="${maxPage}" step="1">
            <li class="page-item">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="page-link current-page">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a class="page-link" href="${pageContext.request.contextPath}/emp/empList?currentPage=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </li>
        </c:forEach>
        
        <c:if test="${lastPage > currentPage}">
            <li class="page-item">
                <a class="page-link" href="${pageContext.request.contextPath}/emp/empList?currentPage=${currentPage + 1}" aria-label="Next">
                    <span aria-hidden="true">&raquo;</span>
                    <span class="sr-only">Next</span>
                </a>
            </li>
        </c:if>
    </ul>
</nav>
<!-- [끝] 페이징 ------->
</body>
</html>