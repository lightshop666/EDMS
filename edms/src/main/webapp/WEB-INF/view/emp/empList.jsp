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
	    
	 	// 서버에서 전송한 결과 값 처리
        const urlParams = new URLSearchParams(window.location.search);
        const failParam = urlParams.get('result'); // '?' 제외한 파라미터 이름만 사용
		
        if (failParam == 'success') { // success 파라미터 값이 있을 경우에만 알림 표시
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
	<form action="/emp/empList" method="POST">
		<label for="employmentPeriod">재직기간별:</label>
        <input type="date" name="startDate" id="startDate">
        ~
        <input type="date" name="endDate" id="endDate"><br>

        <label for="employmentStatus">재직상태:</label>
        <select name="employmentStatus" id="employmentStatus">
        	<option value="전체">전체</option>
            <option value="재직">재직</option>
            <option value="퇴직">퇴직</option>
        </select><br>

        <label for="department">부서별:</label>
        <select name="department" id="department">
        	<option value="전체">전체</option>
            <option value="기획추진본부">기획추진본부</option>
            <option value="경영지원본부">경영지원본부</option>
            <option value="영업지원본부">영업지원본부</option>
        </select><br>

        <label for="position">직급별:</label>
        <select name="position" id="position">
        	<option value="전체">전체</option>
            <option value="팀장">팀장</option>
            <option value="팀원">팀원</option>
        </select><br>

        <label for="gender">성별:</label>
        <input type="radio" name="gender" value="M">남
        <input type="radio" name="gender" value="F">여<br>
		
		<input type="submit" value="검색">
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
			<th>권한</th>
			<th>재직사항</th>
			<th>입사일</th>
		</tr>
		<c:forEach var="e" items="${selectEmpList}">
		<tr>
			<td><button type="button">초기화</button></td>
			<td>${e.empNo}</td>
			<td>${e.empName}</td>
			<td>${e.deptName}</td>
			<td>${e.teamName}</td>
			<td>${e.empPosition}</td>
			<td>${e.accessLevel}</td>
			<td>${e.empState}</td>
			<td>${e.employDate}</td><!-- YYYY-MM-DD -->
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