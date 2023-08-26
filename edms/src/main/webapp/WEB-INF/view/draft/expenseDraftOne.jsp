<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지출결의서 작성</title>
    <style>
        
    </style>
</head>
<body>
    <h2>지출결의서 작성</h2>
    <form action="${pageContext.request.contextPath}/expenseDraftOne" method="post">
        <table>
        	
            <tr>
                <td colspan="2"><h3>지출결의서</h3></td>
                <!-- 히든 필드로 role, status, approvalNo 추가 -->
		       	<td>
		        	<input type="hidden" id="role" name="role" value="${expenseDraftData.role}">
		        	<input type="hidden" id="status" name="status" value="${expenseDraftData.status}">
		        	<input type="hidden" id="approvalNo" name="approvalNo" value="${expenseDraftData.approvalNo}">
		        </td>	
            </tr>
            <tr>
                <td>결재라인</td>
                <td>
                    기안자: <span id="firstApproval">${expenseDraftData.firstApprovalName}</span>
                    중간승인자: 
                    <span id="selectedMiddleApprover">${expenseDraftData.mediateApprovalName}</span>
                    최종승인자: 
                    <span id="selectedFinalApprover">${expenseDraftData.finalApprovalName}</span>	
                </td>
            </tr>
            <tr>
                <td>수신참조</td>
                <td>                 
                    <span id="selectedRecipients">
                        <c:forEach items="${expenseDraftData.selectedRecipientsIds}" var="recipientId">
                            ${recipientId},
                        </c:forEach>
                    </span>
                </td>
            </tr>
            <tr>
                <td>마감일</td>
                <td>${expenseDraftData.paymentDate}</td>
            </tr>
            <tr>
                <td>제목</td>
                <td>${expenseDraftData.docTitle}</td>
            </tr>
            <tr>
                <td colspan="2">
                    <table id="expenseDetailsTable">
                        <tr>
                            <th>카테고리</th>
                            <th>금액</th>
                            <th>내용</th>
                           
                        </tr>
                        <!-- 내역 항목 -->
                        <c:forEach items="${expenseDraftData.expenseDraftContentList}" var="expenseDetail">
                            <tr>
                                <td>${expenseDetail.expenseCategory}</td>
                                <td>${expenseDetail.expenseCost}</td>
                                <td>${expenseDetail.expenseInfo}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </td>
            </tr>
        </table>
        
        <div>
            <label>파일첨부</label>
        </div>
        
		<div id="buttonArea">
		    <!-- 여기에 동적으로 생성된 버튼들이 나열됨 -->
		</div>
		<input type="hidden" id="action" name="action" value="">
    </form>
 <!-- 버튼 클릭 시 폼 제출 -->

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // 예시 데이터 (실제 데이터에 맞게 수정해야 함)
            const role = "${expenseDraftData.role}"; // 기안자, 중간승인자, 최종승인자 등의 역할 정보
            const status = "${expenseDraftData.status}"; // 결재 상태 정보 (A: 기안, B: 중간승인, C: 최종승인 등)
            const approvalNo = "${expenseDraftData.approvalNo}"; // 결재 번호 등의 정보

            // 버튼 추가 함수
            function addButton(buttonId, buttonText,actionValue) {
                const button = $("<button>", {
                    id: buttonId,
                    text: buttonText,
                    class: "approval-button",
                    "data-action": actionValue
                });
                $("#buttonArea").append(button);
            }

            // 각 상태에 따라 버튼을 추가하고 해당 영역을 보여주는 코드
            if (status === "A") {
                if (role === "drafter") {
                    addButton("cancelButton", "기안 취소","cancelButton");
                    addButton("modifyButton", "수정","modifyButton");
                } else if (role === "middleApprover") {
                    addButton("rejectButton", "반려","rejectButton");
                    addButton("approveButton", "승인","approveButton");
                } // 다른 역할에 따른 조건 추가
            } else if (status === "B") {
                if (role === "middleApprover") {
                	 addButton("rejectButton", "반려","rejectButton");
                	 addButton("cancelApproval", "승인 취소","cancelApproval");
                }  else if (role === "finalApprover") {
                	  addButton("rejectButton", "반려","rejectButton");
                      addButton("approveButton", "승인","approveButton");
                }
            } else if (status === "C") {
                if (role === "finalApprover") {
                	addButton("rejectButton", "반려","rejectButton");
               	 addButton("cancelApproval", "승인 취소","cancelApproval");
                } // 다른 역할에 따른 조건 추가
            } // 다른 상태에 따른 조건 추가

            // 버튼 영역을 보여줄 필요가c 있는지 확인하고 보여주는 코드
            if ($("#buttonArea").children().length > 0) {
                $("#buttonArea").show();
            }
        });
        
        $(document).on("click", ".approval-button", function() {
            const action = $(this).data("action"); // 클릭한 버튼의 action 값을 가져옵니다.
            
            // hidden input 태그에 버튼의 action 값을 설정
            $("#action").val(action);

            // 폼 제출
            $("form").submit();
        });
    </script>
</body>
</html>