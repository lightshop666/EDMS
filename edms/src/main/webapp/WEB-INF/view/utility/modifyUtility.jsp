<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jstl 사용 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyUtility</title>
</head>
<body>
	<c:set var="u" value="${utility}" />
	<form method="get" action="${pageContext.request.contextPath}/utility/modifyUtility?utilityNo=${u.utilityNo}" enctype="multipart/form-data">
		<h1>공용품 수정</h1>
		<table>
			<tr>
				<td>공용품종류</td>
			    <td>
			        <select name="utilityCategory">
			            <option value="${u.utilityCategory}" selected>${u.utilityCategory}</option>
			            <option value="차량">차량</option>
			            <option value="회의실">회의실</option>
			        </select>
			    </td>
			</tr>
			<tr>
				<td>공용품명</td>
				<td><input type="text" name="utilityName" placeholder="${u.utilityName}"></td>
			</tr>
			<tr>
				<td>공용품내용</td>
				<td><input type="text" name="utilityInfo" placeholder="${u.utilityInfo}"></td>
			</tr>
			<tr>
				<td>파일첨부</td>
				<td>
					<c:choose>
						<c:when test="${not empty u.utilitySaveFilename}">
							<p>기존 파일: ${u.utilitySaveFilename}</p>
						</c:when>
						<c:otherwise>
							<p>선택된 파일 없음</p>
						</c:otherwise>
					</c:choose>
					<input type="file" name="singlepartFile">
				</td>
			</tr>
		</table>
		<button type="button" id="cancelBtn">취소</button> <!-- 왼쪽 정렬 -->
		<button type="submit" id="saveBtn">저장</button> <!-- 오른쪽 정렬 -->
	</form>
</body>
</html>