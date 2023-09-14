<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>GoodeeFit 사원목록</title>
	<!-- jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- excel download api : sheetjs  -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>
	<!-- file download api : FileServer saveAs-->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
	<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 추가 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- emailjs 라이브러리 로드 -->
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
    <script type="text/javascript">
		(function() {
			// https://dashboard.emailjs.com/admin/account
            // emailjs 초기화. 서버에서 전달받은 publicKey 사용
            emailjs.init('${publicKey}'); 
        })();
    </script>
	<script>
		// 랜덤 비밀번호 생성 규칙을 정할 상수 선언
		const UPPERCASE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; // 영대문자
		const NUMBERS = '0123456789'; // 숫자
		const SPECIAL_CHARS = '!@#%'; // 특수문자
		const ALL_CHARACTERS = UPPERCASE + NUMBERS + SPECIAL_CHARS; // 영대문자, 숫자, 특수문자를 보유한 문자 집합 상수 선언
		const PW_LENGTH = 12; // 생성할 비밀번호의 길이 선언
		
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
			
			// 랜덤 비밀번호 생성 버튼 클릭시
		    $('#getPwBtn').click(function() {
				tempPw = getRandomPw(); // 랜덤 비밀번호 생성 함수 호출
				console.log('랜덤 비밀번호 생성 : ' + tempPw);
				$('#tempPw').text(tempPw); // view에 출력
		    });
		      
			let empNo = '';
			let empEmail = '';
			let empName = '';
			
			$('.getEmpNo').click(function() { // empNo가 전달되지 않아 모달창 열리지 X -> foreach문 안에 있는 empNo에 class 이름을 부여하여 값을 받아옴으로써 해결
				empNo = $(this).data("empno");
				empEmail = $(this).data("email");
				empName = $(this).data("name");
			});
		    
		    // 비밀번호 초기화 버튼 클릭시
		    $('#updatePwBtn').click(function() {
				if (tempPw == '') { // 비밀번호를 생성하지 않았을시
					alert('비밀번호를 생성해주세요.');
				} else { // 비밀번호를 생성했다면
					let result = confirm('생성한 임시 비밀번호로 초기화할까요?');
					// 사용자 선택 값에 따라 true or false 반환
		          
					if (result) { // 확인 선택 시 true 반환
		        	  
						$.ajax({ // 비밀번호 초기화 비동기 방식으로 실행
							url : '/adminUpdatePw',
							type : 'post',
							data : {tempPw : tempPw,
									empNo : empNo },
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
		    
		 	// 이메일 발송 클릭시
			$('#emailPwBtn').click(function() {
				if (tempPw == '') { // 비밀번호를 생성하지 않았을 시 알림
					alert('비밀번호를 생성해주세요.');
				} else { // 비밀번호를 생성했다면
					let result = confirm('생성한 임시 비밀번호를 이메일로 발송할까요?');
					// 사용자 선택 값에 따라 true or false 반환
					
					if (result) { // 확인 선택 시 true 반환
						// 템플릿으로 보낼 param 배열 생성
						let templateParams = {
							temp_pw : tempPw,
							to_email : empEmail,
							to_name : empName
						};
						// 이메일 전송 함수를 호출
						emailjs.send('${serviceId}', '${emailTemplateId2}', templateParams).then(function() { // .then() : Promise 객체의 메서드 중 하나
	                        console.log('SUCCESS!');
	                        $('#emailResult').text('이메일 전송 완료').css('color', 'green');
	                    }, function(error) {
	                        console.log('FAILED...', error);
	                        $('#emailResult').text('이메일 전송 실패').css('color', 'red');
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
		    
		    // 엑셀 업로드 버튼 클릭 시
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
			
			// 파라미터 값에 따른 알림 메세지
			const urlParams = new URLSearchParams(window.location.search); // 서버에서 전송한 결과 값 처리
			const resultParam = urlParams.get('result'); // result 파라미터 값 변수에 저장
			const errorParam = urlParams.get('error'); // error 파라미터 값 변수에 저장
			
			if (resultParam === 'fail') { // fail 파라미터
				if (errorParam === 'duplicate') { // 값이 duplicate 일 때 중복된 번호임을 알림
					alert('중복된 사원번호가 있습니다. 엑셀 파일을 수정해주세요.');
			    } else {
			        alert('엑셀 파일 업로드에 실패했습니다. 엑셀 파일을 확인해주세요.'); // 이외 오류에 대해 엑셀 파일 재확인 알림
			    }
			} else if (resultParam === 'success') { // success 파라미터 값이 있을 경우 성공 알림
				alert('엑셀 파일 업로드에 성공했습니다.');
			}
			
			// 사원 정보 행 클릭시 사원 상세로 이동
	        $('.enterOne').click(function () {
				empNo = $(this).data("empno");
	        	empName = $(this).data("name");
	        	console.log('empNo'+empNo); // 상세로 이동할때 사용할 사원 번호
	        	console.log('empName'+empName); // 알림 메세지에 사용할 사원 이름
	        	
	            let confirmMessage = empName + ` 사원 상세 페이지로 이동하시겠습니까?`;
	            let result = confirm(confirmMessage);
	            
	            if (result) { // 확인을 눌렀을 때 이동
	                window.location = `/emp/modifyEmp?empNo=`+empNo;
	            } else {
	            	return; // 취소를 눌렀을 때 함수를 빠져나옴
	            }
	        });
			
			// 회원가입 미진행 사원에게 이메일 발송
	        $("#sendEmail").click(function(e) {
	            e.preventDefault(); // 기본 링크 동작을 막음
	
	            // 경고창 표시
	            if (confirm("사원 초대 페이지로 이동하시겠습니까?")) {
	                // 확인을 클릭한 경우 페이지 이동
	                window.location.href = $(this).attr("href");
	            } else {
	            	return;
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
		table tr:hover {
		    font-weight: bold;
		    cursor: pointer;
		}
		table {
			text-align: center;
		}
		.center {
			text-align: center;
		}
		#uploadBtn {
		    display: inline-block;
		    padding: 6px 10px 11px 10px; /* 상, 우, 하, 좌 */
		    vertical-align: middle;
		    cursor: pointer;
		    height: 30px;
		    margin-left: 10px;
		    font-size: 14px;
		}
		.custom-upload-button {
			background-color: #999;
			color: white;
			border: none;
			padding: 5px 10px;
			cursor: pointer;
			display: inline-block;
		}
	</style>

</head>

<body>
<!-- ============================================================== -->
<!-- Preloader - style you can find in spinners.css -->
<!-- ============================================================== -->
<div class="preloader">
    <div class="lds-ripple">
        <div class="lds-pos"></div>
        <div class="lds-pos"></div>
    </div>
</div>
<!-- ============================================================== -->
<!-- Main wrapper - style you can find in pages.scss -->
<!-- ============================================================== -->
<div id="main-wrapper" data-theme="light" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
    data-sidebar-position="fixed" data-header-position="fixed" data-boxed-layout="full">
	<!-- ============================================================== -->
	<!-- Topbar header - style you can find in pages.scss -->
	<!-- ============================================================== -->
	<!-- 헤더 인클루드 -->
	
	<header class="topbar" data-navbarbg="skin6">
		<jsp:include page="/WEB-INF/view/inc/header.jsp" />
	</header>
	<!-- ============================================================== -->
	<!-- End Topbar header -->
	<!-- ============================================================== -->
	<!-- ============================================================== -->
	<!-- Left Sidebar - style you can find in sidebar.scss  -->
	<!-- ============================================================== -->
	
	<!-- 좌측 메인메뉴 인클루드 -->
	
	<aside class="left-sidebar" data-sidebarbg="skin6">
	
		<jsp:include page="/WEB-INF/view/inc/mainmenu.jsp" />
	
	</aside>
	
	<!-- ============================================================== -->
	<!-- End Left Sidebar - style you can find in sidebar.scss  -->
	<!-- ============================================================== -->
        
        
        
        <!-- ============================================================== -->
        <!-- Page wrapper  -->
        <!-- ============================================================== -->
        
        
        
	<div class="page-wrapper">
	<!-- ============================================================== -->
	<!-- Container fluid  -->
	<!-- ============================================================== -->
		<div class="container-fluid">
<!-----------------------------------------------------------------본문 내용 ------------------------------------------------------->    
<!-- 이 안에 각자 페이지 넣으시면 됩니다 -->

	<h1 class="center">사원 목록</h1>
	<br>
	
<!-- [시작] 검색 ------->
	<form action="/emp/empList" method="GET" id="employee-form">
		<!-- 1. 입사년도별 조회 -->
	    <div class="date-area" style="display: flex; align-items: center;">
			<div class="form-group" style="width: 100px;">
		        <label class="date-label">입사년도</label>
	 		</div>
	 		<div class="form-group" style="width: 200px; margin-left: 20px; margin-right: 20px;">
		        <input type="date" name="startDate" value="${param.startDate}" class="form-control">
	        </div>
	        ~
	        <div class="form-group" style="width: 200px; margin-left: 20px; margin-right: 20px;">
				<input type="date" name="endDate" value="${param.endDate}" class="form-control">
	        </div>
	    </div>
	    <br>
		<!-- 2. 재직/퇴직에 따른 정렬 -->
	    <div class="sort-area" style="display: flex; align-items: center;">
	    	<div class="form-group" style="width: 100px;">
	        	<label class="sort-label">정렬</label>
	        </div>
	        <div class="form-group" style="width: 200px; margin-left: 20px; margin-right: 30px;">
		        <select name="empDate" class="form-control">
			        <option value="employ_date" <c:if test="${param.empDate.equals('employ_date')}">selected</c:if>>입사일</option>
			        <option value="retirement_date" <c:if test="${param.empDate.equals('retirement_date')}">selected</c:if>>퇴사일</option>
			    </select>
	        </div>
		    <div class="form-group" style="width: 200px; margin-left: 20px; margin-right: 20px;">
		        <select name="ascDesc" class="form-control">
		            <option value="ASC" <c:if test="${param.ascDesc.equals('ASC')}">selected</c:if>>오름차순</option>
		            <option value="DESC" <c:if test="${param.ascDesc.equals('DESC')}">selected</c:if>>내림차순</option>
		        </select>
	        </div>
	    </div>
	    <br>
	    <!-- 3. 재직사항별 조회 -->
	    <div class="sort-area" style="display: flex; align-items: center;">
	    	<div class="form-group" style="width: 100px;">
	        	<label class="sort-label">재직사항</label>
	        </div>
		    <div class="form-group" style="width: 200px; margin-left: 20px; margin-right: 30px;">
		        <select name="col" class="form-control">
			        <option value="" <c:if test="${param.empState.equals('')}">selected</c:if>>전체</option>
			        <option value="재직" <c:if test="${param.empState.equals('재직')}">selected</c:if>>재직</option>
			        <option value="퇴직" <c:if test="${param.empState.equals('퇴직')}">selected</c:if>>퇴직</option>
			    </select>
		    </div>
		</div>
		<br>
		<!-- 4. 부서명, 팀명, 직급 -->
    	<div class="sort-area" style="display: flex; align-items: center;">		    
		    <div class="form-group" style="width: 90px;">
	        	<label class="sort-label">부서명</label>
	        </div>
	        <div class="form-group" style="width: 150px; margin-left: 30px; margin-right: 20px;">
			    <select name="deptName" class="form-control">
			        <option value="" <c:if test="${param.deptName.equals('')}">selected</c:if>>전체</option>
			        <option value="사업추진본부" <c:if test="${param.deptName.equals('사업추진본부')}">selected</c:if>>사업추진본부</option>
			        <option value="경영지원본부" <c:if test="${param.deptName.equals('경영지원본부')}">selected</c:if>>경영지원본부</option>
			        <option value="영업지원본부" <c:if test="${param.deptName.equals('영업지원본부')}">selected</c:if>>영업지원본부</option>
			    </select>
		    </div>
		    
		    <div class="form-group" style="width: 90px; margin-left: 30px;">
	        	<label class="sort-label">팀명</label>
	        </div>
	        <div class="form-group" style="width: 150px;">
				<select name="teamName" class="form-control">
				    <option value="" <c:if test="${param.teamName.equals('')}">selected</c:if>>전체</option>
				    <option value="기획팀" <c:if test="${param.teamName.equals('기획팀')}">selected</c:if>>기획팀</option>
				    <option value="경영팀" <c:if test="${param.teamName.equals('경영팀')}">selected</c:if>>경영팀</option>
				    <option value="영업팀" <c:if test="${param.teamName.equals('영업팀')}">selected</c:if>>영업팀</option>
				</select>
		    </div>
		    
		    <div class="form-group" style="width: 90px; margin-left: 30px;">
	        	<label class="sort-label">직급</label>
	        </div>
	        <div class="form-group" style="width: 150px;">
				<select name="empPosition" class="form-control">
				    <option value="" <c:if test="${param.empPosition.equals('')}">selected</c:if>>전체</option>
				    <option value="CEO" <c:if test="${param.empPosition.equals('CEO')}">selected</c:if>>CEO</option>
				    <option value="부서장" <c:if test="${param.empPosition.equals('부서장')}">selected</c:if>>부서장</option>
				    <option value="팀장" <c:if test="${param.empPosition.equals('팀장')}">selected</c:if>>팀장</option>
				    <option value="부팀장" <c:if test="${param.empPosition.equals('부팀장')}">selected</c:if>>부팀장</option>
				    <option value="사원" <c:if test="${param.empPosition.equals('사원')}">selected</c:if>>사원</option>
				</select>
			</div>
		</div>
		<br>
	    <!-- 5. 특정 사원의 정보 검색 -->
	    <div class="search-area" style="display: flex; align-items: center;">
	        <div class="form-group" style="width: 100px;">
	        	<label class="search-label">검색</label>
	        </div>
	        <div class="form-group" style="width: 200px; margin-left: 20px; margin-right: 20px;">
		        <select name="searchCol" class="form-control">
		            <option value="empNo" <c:if test="${param.searchCol.equals('empNo')}">selected</c:if>>사원번호</option>
		            <option value="empName" <c:if test="${param.searchCol.equals('empName')}">selected</c:if>>사원명</option>
		        </select>
	        </div>
	        <div class="form-group" style="width: 250px; margin-left: 20px; margin-right: 20px;">
	        	<input type="text" name="searchWord" class="form-control">
	        </div>
	        <button type="submit" value="${param.searchWord}" class="btn waves-effect waves-light btn-outline-dark" style="margin-left: 280px;">검색</button>
	    	<!-- 엑셀 다운로드 -->
			<a href="/emp/excelDownload?ascDesc=${param.ascDesc}&empState=${param.empState}&empDate=${param.empDate}&deptName=${param.deptName}&teamName=${param.teamName}&empPosition=${param.empPosition}&searchCol=${param.searchCol}&searchWord=${param.searchWord}&startDate=${param.startDate}&endDate=${param.endDate}" class="generateListBtn"><button type="button" class="btn waves-effect waves-light btn-outline-dark" style="margin-left: 98px;">검색 목록 다운로드</button></a>
	    </div>
    </form>
<!-- [끝] 검색 ------->

	<hr>
	
<!-- [시작] 엑셀 ----->

	
	<div style="display: flex; justify-content: space-between; align-items: center;">
		<!-- 엑셀 업로드 -->
		<div>
			<label>기존 사원 업로드</label>
			<form id="uploadForm" action="/excelUpload" method="post" enctype="multipart/form-data" style="margin-left: 15px; display: inline-block;">
				<input type="file" name="file" id="fileInput" style="display: inline-block; display: none;">
				<label for="fileInput" class="custom-upload-button">파일 선택</label>
				<button type="submit" id="uploadBtn" class="btn btn-primary" style="display: inline-block;">저장</button>
				<span id="msg" style="display: inline-block;"></span>
			</form>
		</div>
		<!-- 공통 양식 다운로드 -->
		<div>
			<a href="/file/defaultTemplate.xlsx" download="defaultTemplate.xlsx">
				<button type="button" class="btn waves-effect waves-light btn-outline-dark" style="margin-left: 15px;">공통 양식 다운로드</button>
			</a>
		</div>
	</div>	
	<br>
<!-- [끝] 엑셀 ------>
	
<!-- [시작] 관리자 리스트 출력 ------->	
	<table class="table">
		<tr class="table-primary"><!-- 관리자만 초기화 가능 -->
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
                    	<c:choose>
			                <c:when test="${e.isMember eq 'O'}">
		                        <button type="button" class="getEmpNo btn btn-primary" data-empno="${e.empNo}" data-name="${e.empName}" data-email="${e.email}" data-bs-toggle="modal" data-bs-target="#pwModal">
		                            초기화
		                        </button>
		                    </c:when>
		                </c:choose>        
                    </td>
                </c:if>
				<td data-empno="${e.empNo}" data-name="${e.empName}" class="enterOne">${e.empNo}</td>
				<td data-empno="${e.empNo}" data-name="${e.empName}" class="enterOne">${e.empName}</td>
				<td data-empno="${e.empNo}" data-name="${e.empName}" class="enterOne">${e.deptName}</td>
				<td data-empno="${e.empNo}" data-name="${e.empName}" class="enterOne">${e.teamName}</td>
				<td data-empno="${e.empNo}" data-name="${e.empName}" class="enterOne">${e.empPosition}</td>
				<td data-empno="${e.empNo}" data-name="${e.empName}" class="enterOne">${e.employDate}</td><!-- YYYY-MM-DD -->
				<td data-empno="${e.empNo}" data-name="${e.empName}" class="enterOne">${e.remainDays}</td>
				<c:choose>
	                <c:when test="${e.isMember eq 'X'}">
	                    <td><a href="/sendEmail?empNo=${e.empNo}" id="sendEmail">${e.isMember}</a></td>
	                </c:when>
	                <c:otherwise>
	                    <td>${e.isMember}</td>
	                </c:otherwise>
	            </c:choose>
				<td data-empno="${e.empNo}" data-name="${e.empName}" class="enterOne">${e.accessLevel}</td>
			</tr>
		</c:forEach>
	</table>
	
	<!-- [시작] 비밀번호 초기화 모달 -->
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
						<button type="button" id="getPwBtn" class="btn btn-secondary">비밀번호 생성</button>
						임시 비밀번호 : <span id="tempPw"></span> <!-- 비밀번호 생성시 출력 -->
					</div> <br>
					<div>
						<p style="color:red;">
							비밀번호 초기화 후 다시 되돌릴 수 없습니다. <br>
							생성한 임시 비밀번호를 사용자에게 반드시 전달하세요.
						</p>
						<button type="button" id="updatePwBtn" class="btn btn-secondary">비밀번호 초기화</button>
						<span id="updateResult"></span> <!-- 비밀번호 초기화 결과 출력 -->
					</div> <br>
					<div>
						<p>개인정보에 저장된 이메일로 임시 비밀번호를 발송 할까요?</p>
						<button type="button" id="emailPwBtn" class="btn btn-secondary">이메일 발송</button>
						<span id="emailResult"></span> <!-- 비밀번호 전송 결과 출력 -->
					</div>
				</div>
				<!-- 모달 푸터 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- [끝] 비밀번호 초기화 모달 끝 -->
	
<!-- [끝] 관리자 리스트 출력 ------->	
	
	<br>
	
<!-- [시작] 페이징 ------->
	<!-- 페이징 영역 -->
	<nav aria-label="Page navigation example" style="text-align: center;">
		<ul class="pagination justify-content-center">
	        <c:if test="${minPage > 1}">
	            <li class="page-item">
	                <a class="page-link" href="/emp/empList?currentPage=${currentPage-1}&startDate=${param.startDate}&endDate=${param.endDate}&empDate=${param.empDate}&ascDesc=${param.ascDesc}&col=${param.col}&deptName=${param.deptName}&teamName=${param.teamName}&empPosition=${param.empPosition}&searchCol=${param.searchCol}&searchWord=${param.searchWord}" aria-label="Previous">
	                    <span aria-hidden="true">&laquo;</span>
	                    <span class="sr-only">이전</span>
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
	                        <a class="page-link" href="/emp/empList?currentPage=${i}&startDate=${param.startDate}&endDate=${param.endDate}&empDate=${param.empDate}&ascDesc=${param.ascDesc}&col=${param.col}&deptName=${param.deptName}&teamName=${param.teamName}&empPosition=${param.empPosition}&searchCol=${param.searchCol}&searchWord=${param.searchWord}">${i}</a>
	                    </c:otherwise>
	                </c:choose>
	            </li>
	        </c:forEach>
	        
	        <c:if test="${lastPage > currentPage}">
	            <li class="page-item">
	                <a class="page-link" href="/emp/empList?currentPage=${currentPage+1}&startDate=${param.startDate}&endDate=${param.endDate}&empDate=${param.empDate}&ascDesc=${param.ascDesc}&col=${param.col}&deptName=${param.deptName}&teamName=${param.teamName}&empPosition=${param.empPosition}&searchCol=${param.searchCol}&searchWord=${param.searchWord}" aria-label="Next">
	                    <span aria-hidden="true">&raquo;</span>
	                    <span class="sr-only">다음</span>
	                </a>
	            </li>
	        </c:if>
	    </ul>
	</nav>
<!-- [끝] 페이징 ------->

<!-----------------------------------------------------------------본문 끝 ------------------------------------------------------->          

		</div>
		<!-- ============================================================== -->
		<!-- End Container fluid  -->
		<!-- ============================================================== -->
            
		<!-- ============================================================== -->
		<!-- footer -->
		<!-- ============================================================== -->
<!-- 푸터 인클루드 -->
		<footer class="footer text-center text-muted">
		
			<jsp:include page="/WEB-INF/view/inc/footer.jsp" />
			
		</footer>
		<!-- ============================================================== -->
		<!-- End footer -->
		<!-- ============================================================== -->
	</div>
<!-- ============================================================== -->
<!-- End Page wrapper  -->
<!-- ============================================================== -->        
</div>
<!-- ============================================================== -->
<!-- End Wrapper -->
<!-- ============================================================== -->
<!-- End Wrapper -->
<!-- ============================================================== -->

</body>

</html>