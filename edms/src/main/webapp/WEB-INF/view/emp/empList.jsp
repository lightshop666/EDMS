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
<script>
	//페이지 로드 후 실행
	$(document).ready(function() {
	    // 엑셀 다운로드 버튼 클릭 시
	    $('#excelBtn').click(function() {
	        var selectedEmpNos = [];
	        $('.checkbox:checked').each(function() {
	            selectedEmpNos.push($(this).data('empNo'));
	        });
		
	        // 선택된 사원 번호 배열 출력
	        console.log("Total selected checkboxes:", $('.checkbox:checked').length);
		    $('.checkbox:checked').each(function() {
		        console.log("Data-empNo:", $(this).data('empNo'));
		    });
    
	        if (selectedEmpNos.length > 0) {
	            // 서버로 선택된 사원의 empNos를 전달하여 엑셀 다운로드 수행
	            window.location.href = '/emp/downloadExcel?empNos=' + selectedEmpNos.join(',');
	        } else {
	            alert('선택된 사원이 없습니다.');
	            return false;
	        }
	    });
	    
	 	// 업로드 버튼 클릭 시
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
		
     	// 페이지 로딩 시 주소창 파라미터 확인 후 알림 표시
        const urlParams = new URLSearchParams(window.location.search); // 서버에서 전송한 결과 값 처리
        const resultParam = urlParams.get('result'); // '?' 제외한 파라미터 이름만 사용
        const errorParam = urlParams.get('error'); // error 파라미터 값을 가져옴
        
        if (resultParam === 'fail') { // fail 파라미터 값이 있고
            if (errorParam === 'duplicate') { // 그 값이 duplicate 일 때
                alert('중복된 사원번호가 있습니다. 엑셀 파일을 수정해주세요.'); // 중복된 사원번호 알림
            } else { // 이외 오류에 대해
                alert('엑셀 파일 업로드에 실패했습니다. 엑셀 파일을 확인해주세요.'); // 엑셀 파일 확인 알림
            }
        } else if (failParam == 'success') { // success 파라미터 값이 있을 경우에만 알림 표시
            alert('엑셀 파일 업로드에 성공했습니다.');
        }
        
        const newEmpNos = '<%= request.getAttribute("newEmpNos") %>';
		const newEmpNosArray = newEmpNos.split(','); // 새로 등록된 사원번호 배열
		
		$('.checkbox').each(function() {
			const empNo = $(this).data('empNo');
			if (newEmpNosArray.includes(empNo.toString())) {
				$(this).parent().parent().css('background-color', 'yellow'); // 노란색 스타일 추가
			}
		});
	});
</script>
</head>
<body>
	<form action="/emp/empList" method="POST" enctype="multipart/form-data" id="employee-form">
	    
	    
	    <div class="search-by-year-area">
	        <label class="search-by-year-label">입사년도별 조회</label>
	        <input type="date" name="startDate" class="search-by-year-input">
	        ~
	        <input type="date" name="endDate" class="search-by-year-input">
	        <button type="submit" class="search-by-year-button">조회</button>
	    </div>
	
	    <div class="sort-area">
	        <label class="sort-label">정렬</label>
	        <select name="col" class="sort-select">
	            <option value="employDate">입사일</option>
	            <option value="retireDate">퇴사일</option>
	        </select>
	        <select name="ascDesc" class="sort-select">
	            <option value="ASC">오름차순</option>
	            <option value="DESC">내림차순</option>
	        </select>
	        <button type="button" class="sort-button" id="sort-button">조회</button>
	    </div>
	    
	    <div class="sort-personnel-area">
		    <label class="sort-label">재직사항</label>
		    <select name="employmentStatus" class="sort-input">
		        <option value="all">전체</option>
		        <option value="재직">재직</option>
		        <option value="퇴직">퇴직</option>
		    </select>
		    
		    <label class="sort-label">부서</label>
		    <select name="department" class="sort-input">
		        <option value="all">전체</option>
		        <option value="기획추진본부">기획추진본부</option>
		        <option value="경영지원본부">경영지원본부</option>
		        <option value="영업지원본부">영업지원본부</option>
		    </select>
		    
		    <label class="sort-label">팀</label>
			<select name="team" class="sort-input">
			    <option value="all">전체</option>
			    <option value="기획팀">기획팀</option>
			    <option value="경영팀">경영팀</option>
			    <option value="영업팀">영업팀</option>
			</select>
		    
		    <button type="button" class="sort-button" id="personnel-sort-button">조회</button>
		</div>
	    
	    
	    
	    <div class="search-area">
	        <label class="search-label">검색</label>
	        <select name="searchCol" class="search-input">
	            <option value="empNo">사원번호</option>
	            <option value="empName">사원명</option>
	        </select>
	        <input type="text" name="searchWord" class="search-input">
	        <button type="button" class="search-button" id="search-button">검색</button>
	    </div>
	    
    </form>
	
	<hr>
	
	<!-- 엑셀 공통 양식 다운로드 버튼 추가 -->
	<a href="/file/defaultTemplate.xlsx" download="defaultTemplate.xlsx">사원 등록 공통 양식</a>
	
	<!-- 파일 업로드 -->
	<form id="uploadForm" action="/excelUpload" method="post" enctype="multipart/form-data">
		<input type="file" name="file" id="fileInput">
		<button type="submit" id="uploadBtn">저장</button>
		<span id="msg"></span>
	</form>

	<button type="button" id="excelBtn">엑셀 다운로드</button>
	<table border="1">
		<tr>
			<th>비밀번호 초기화</th>
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
		<tr onclick="window.location='/emp/modifyEmp?empNo=${e.empNo}';">
			<td><button type="button">초기화</button></td>
			<td>${e.empNo}</td>
			<td>${e.empName}</td>
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
	<c:if test="${currentPage > 1}">
		<a href="/emp/empList?localName=${localName}&currentPage=${currentPage - 1}">이전</a>
	</c:if>
	<p>${currentPage}</p>
	<c:if test="${currentPage < lastPage}">
		<a href="/board/boardList?localName=${localName}&currentPage=${currentPage + 1}">다음</a>
	</c:if>
</body>
</html>