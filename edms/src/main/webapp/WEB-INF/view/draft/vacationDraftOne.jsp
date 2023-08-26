<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>vacationDraftOne</title>
	<!-- 테이블 스타일 추가 -->
	<style>
	    table {
	        border-collapse: collapse;
	        width: 100%;
	        border: 1px solid black;
	        text-align: center; /* 셀 내 텍스트 가운데 정렬 */
	    }
	    th, td {
	        border: 1px solid black;
	        padding: 8px;
	    }
	    input[type="text"], textarea {
	        width: 100%; /* input 요소와 textarea 요소가 셀의 너비에 맞게 꽉 차도록 설정 */
	        box-sizing: border-box; /* 내부 패딩과 경계선을 포함하여 너비 계산 */
	    }
	</style>
</head>
<body>
	휴가신청서 상세
</body>
	<!-- 모델값 변수에 할당 -->
	<c:set var="a" value="${approvalJoinDto}"></c:set>
	<c:set var="v" value="${vacationDraft}"></c:set>
	<c:set var="m" value="${memberSignMap}"></c:set>
	<!--------------------->
	<div class="container pt-5">
		<h1 style="text-align: center;">휴가신청서</h1>
		<table>
			<tr>
				<th rowspan="3" colspan="2">휴가신청서</th>
				<th rowspan="3">결재</th>
				<th>기안자</th>
				<th>중간승인자</th>
				<th>최종승인자</th>
			</tr>
			<tr>
				<td>
					<c:if test="${m.firstSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
						<img src="${m.firstSign.memberPath}${m.firstSign.memberSaveFileName}.${m.firstSign.memberFiletype}">
					</c:if>
					<c:if test="${m.firstSign.memberSaveFileName == null}"> <!-- 서명 이미지가 없으면 문구 출력 -->
						<!-- 해당 부분 문구가 아닌 다른 이미지로 출력할지 고민중.. -->
						서명 이미지 없음
					</c:if>
				</td>
				<td>
					<c:if test="${m.mediateSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
						<img src="${m.mediateSign.memberPath}${m.mediateSign.memberSaveFileName}.${m.mediateSign.memberFiletype}">
					</c:if>
					<!-- 이부분 다시 생각... -->
					<c:if test="${m.mediateSign.memberSaveFileName == null && a.approvalField == 'B'}"> <!-- 서명 이미지가 없으면 문구 출력 -->
						서명 이미지 없음
					</c:if>
					<c:if test="${m.mediateSign.memberSaveFileName == null && a.approvalField == 'C'}"> <!-- 서명 이미지가 없으면 문구 출력 -->
						서명 이미지 없음
					</c:if>
				</td>
				<td>
					<c:if test="${m.finalSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
						<img src="${m.finalSign.memberPath}${m.finalSign.memberSaveFileName}.${m.finalSign.memberFiletype}">
					</c:if>
					<c:if test="${m.finalSign.memberSaveFileName == null && a.approvalField == 'C'}"> <!-- 서명 이미지가 없으면 문구 출력 -->
						서명 이미지 없음
					</c:if>
				</td>
			</tr>
			<tr>
				<th>
					수신참조자
				</th>
				<td colspan="5">
					<c:if test="${a.receiveDraftList != null}"> <!-- 수신참조자 테이블 리스트가 존재하면 -->
						<c:forEach var="r" items="${a.receiveDraftList}">
							${r.empNo} <!-- 사원번호가 아니라 사원이름, 부서명, 직급이 출력되도록... 쉼표도 넣어야함 -->
						</c:forEach>
					</c:if>
				</td>
			</tr>
			<tr>
				<th>성명</th>
				<td>예정..</td>
				<th>부서</th>
				<td>예정..</td>
				<th>휴가종류</th>
				<td>
					${v.vacationName}
				</td>
			</tr>
			<tr>
				<th>기간</th>
				<td colspan="5">
					휴가일수 : ${v.vacationDays}일
					휴가시작일 : ${v.vacationStart}
					<c:if test="${v.vacationName == '반차'}">
						<c:if test="${v.vacationTime == '오전반차'}">
							오전반차 9:00~13:00
						</c:if>
						<c:if test="${v.vacationTime == '오후반차'}">
							오후반차 14:00~18:00
						</c:if>
					</c:if>
					<c:if test="${v.vacationName == '연차' || v.vacationName == '보상'}">
						휴가종료일 : ${v.vacationEnd}
					</c:if>
				</td>
			</tr>
			<tr>
				<th>비상연락망</th>
				<td colspan="5">
					${v.phoneNumber}
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td colspan="5">
					${v.docTitle}
				</td>
			</tr>
			<tr>
				<th>사유</th>
				<td colspan="5">
					${v.docContent}
				</td>
			</tr>
			<tr>
				<th colspan="6">
					위와 같이 휴가를 신청하오니, 결재 바랍니다. <br>
					<!-- 기안일자에서 년,월,일을 추출하기 위해 substring 사용 -->
					${fn:substring(v.createdate, 0, 4)}년 ${fn:substring(v.createdate, 5, 7)}월 ${fn:substring(v.createdate, 8, 10)}일
				</th>
			</tr>
		</table>
		<!-- 버튼 분기 예정... -->
		<!-- 
			role이 기안자이고, 결재상태가 A이면 .. 목록 / 기안취소 / 수정 출력
			이런식으로 분기 예정...
		 -->
	</div>
</html>