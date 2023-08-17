<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addUtility</title>
</head>
<body>
	<form method="post" action="${pageContext.request.contextPath}/utility/addUtility" enctype="multipart/form-data">
		<h1>공용품 추가</h1>
		<table>
			<tr>
				<td>공용품종류</td>
			    <td>
			        <select name="utilityCategory">
			            <option value="" selected>종류를 선택하세요</option>
			            <option value="차량">차량</option>
			            <option value="회의실">회의실</option>
			        </select>
			    </td>
			</tr>
			<tr>
				<td>공용품명</td>
				<td><input type="text" name="utilityName" ></td>
			</tr>
			<tr>
				<td>공용품내용</td>
				<td><input type="text" name="utilityInfo" ></td>
			</tr>
			<tr>
				<td>파일첨부</td>
				<td><input type="file" name="singlepartFile"></td>
			</tr>
		</table>
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
		<button type="submit" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
	</form>
</body>
</html>