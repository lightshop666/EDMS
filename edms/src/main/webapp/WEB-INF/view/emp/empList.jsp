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
	
	        if (selectedEmpNos.length > 0) {
	            // 서버로 선택된 사원의 empNos를 전달하여 엑셀 다운로드 수행
	            window.location.href = '/emp/empList?empNos=' + selectedEmpNos.join(',');
	        } else {
	            alert('선택된 사원이 없습니다.');
	        }
	    });
	});
</script>
</head>
<body>
	<button id="excelBtn">엑셀 다운로드</button>
	<table border="1">
		<tr>
			<th>엑셀 다운로드</th>
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
			<td><input type="checkbox" class="checkbox" data-empNo="${e.empNo}"></td>
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
</body>
</html>