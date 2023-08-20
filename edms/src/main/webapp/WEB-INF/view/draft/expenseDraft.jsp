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
    <form action="" method="post" enctype="multipart/form-data">
        <table>
            <tr>
                <td colspan="2"><h3>지출결의서</h3></td>
            </tr>
            <tr>
                <td>결재라인</td>
                <td>
                    기안자: <input type="text" name="applicantName" value="김부장" readonly>
                    중간승인자: <button type="button" onclick="openApproverModal('middle')">선택</button>
                    <span id="selectedMiddleApprover"></span>
                    최종승인자: <button type="button" onclick="openApproverModal('final')">선택</button>
                    <span id="selectedFinalApprover"></span>
                    <input type="hidden" id="selectedMiddleApproverId" name="selectedMiddleApproverId" value="">
					<input type="hidden" id="selectedFinalApproverId" name="selectedFinalApproverId" value="">
    
                </td>
            </tr>
            <tr>
                <td>수신참조</td>
                <td>
                    <button type="button" onclick="openRecipientModal()">선택</button>
                    <span id="selectedRecipients"></span>
                    <input type="hidden" id="selectedRecipientsIds" name="selectedRecipientsIds" value="">
                </td>
                
                
            </tr>
            <tr>
                <td>마감일</td>
                <td><input type="date" name="paymentDate" required></td>
            </tr>
            <tr>
                <td>제목</td>
                <td><input type="text" name="documentTitle" required></td>
            </tr>
            <tr>
                <td colspan="2">
                    <table id="expenseDetailsTable">
                        <tr>
                            <th>카테고리</th>
                            <th>금액</th>
                            <th>내용</th>
                            <th><button type="button" onclick="addExpenseDetail()">+</button></th>
                        </tr>
                        <!-- 내역 항목 -->
                        <tr>
                            <td><input type="text" name="expenseCategory[]" required></td>
                            <td><input type="number" name="expenseCost[]" required></td>
                            <td><input type="text" name="expenseInfo[]" required></td>
                            <td><button type="button" onclick="removeExpenseDetail(this)">-</button></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        
        <div>
            <label>파일첨부</label>
            <input type="file" name="documentFile">
        </div>
        
        
        
        <div class="buttons">
            <button type="button" onclick="saveDraft()">임시저장</button>
            <button type="submit" onclick="submitDraft()">기안하기</button>
        </div>
    </form>
    
    <!-- 중간승인자 모달 -->
	<div class="modal" id="middleApproverModal" style="display: none;">
	    <h3>중간승인자 선택</h3>
	    <ul id="employeeList">
	        <c:forEach var="employee" items="${employeeList}">
	            <li>
	                <label>
	                    <input type="radio" name="selectedApprover" value="${employee.empName}" onclick="selectApprover(this.value,${employee.empNo}, 'middle')">
	                    ${employee.empName}
	                </label>
	            </li>
	        </c:forEach>
	    </ul>
	    <button type="button" onclick="closeMiddleApproverModal()">닫기</button>
	</div>
    
    <!-- 최종승인자 모달 -->
    <div class="modal" id="finalApproverModal" style="display: none;">
        <h3>최종승인자 선택</h3>
        <ul id="employeeList">
            <c:forEach var="employee" items="${employeeList}">
                <li>
                    <label>
                        <input type="radio" name="selectedApprover" value="${employee.empName}" onclick="selectApprover(this.value,${employee.empNo}, 'final')">
                        ${employee.empName}
                    </label>
                </li>
            </c:forEach>
        </ul>
        <button type="button" onclick="closeFinalApproverModal()">닫기</button>
    </div>
    
	<div class="modal" id="recipientsModal" style="display: none;">
	    <h3>수신참조자 선택</h3>
	    <ul id="recipientsList">
	        <c:forEach var="employee" items="${employeeList}">
	            <li>
	                <input type="checkbox" name="recipients" value="${employee.empName}" data-empno="${employee.empNo}" onclick="addRecipient(this)">
	                ${employee.empName}
	            </li>
	        </c:forEach>
	    </ul>
	    <button type="button" onclick="selectRecipients()">선택</button>
	    <button type="button" onclick="closeModal('recipients')">닫기</button>
	</div>

 

    <script>
        var selectedMiddleApprover = "";
        var selectedFinalApprover = "";
        var selectedRecipients = [];
        
        function selectApprover(employeeName, employeeNo, approverType) {
            if (approverType === "middle") {
                selectedMiddleApprover = employeeName;
                document.getElementById("selectedMiddleApprover").textContent = employeeName;
                document.getElementById("selectedMiddleApproverId").value = employeeNo; // empNo 저장
            } else if (approverType === "final") {
                selectedFinalApprover = employeeName;
                document.getElementById("selectedFinalApprover").textContent = employeeName;
                document.getElementById("selectedFinalApproverId").value = employeeNo; // empNo 저장
            }

            closeModal(approverType);
        }

        function openApproverModal(approverType) {
            var modal = document.getElementById(approverType + "ApproverModal");
            modal.style.display = "block";
        }

        function openRecipientModal() {
            var modal = document.getElementById("recipientsModal");
            modal.style.display = "block";
        }

        function closeMiddleApproverModal() {
            closeModal("middle");
        }

        function closeFinalApproverModal() {
            closeModal("final");
        }

        function closeModal(approverType) {
            var modal = document.getElementById(approverType + "ApproverModal");
            modal.style.display = "none";
        }

        function addRecipient(checkbox) {
            var recipientName = checkbox.value;
            var recipientEmpNo = checkbox.getAttribute("data-empno"); // empNo 값 가져오기
            if (checkbox.checked) {
                selectedRecipients.push(recipientName);
                selectedRecipientsIds.push(recipientEmpNo); // empNo 배열에 추가
            } else {
                var index = selectedRecipients.indexOf(recipientName);
                if (index > -1) {
                    selectedRecipients.splice(index, 1);
                    selectedRecipientsIds.splice(index, 1); // empNo 배열에서 제거
                }
            }
        }

        function selectRecipients() {
            var recipientsElement = document.getElementById("selectedRecipients");
            recipientsElement.textContent = selectedRecipients.join(", ");
            closeModal("recipients");

            // 수신참조자의 empNo 배열을 저장
            var selectedRecipientsIdsInput = document.getElementById("selectedRecipientsIds");
            selectedRecipientsIdsInput.value = selectedRecipientsIds.join(","); // empNo 배열을 쉼표로 구분한 문자열로 저장
        }

        function addExpenseDetail() {
            var expenseDetailsTable = document.getElementById("expenseDetailsTable");
            var newRow = document.createElement("tr");
            newRow.innerHTML = `
                <td><input type="text" name="expenseCategory[]" required></td>
                <td><input type="number" name="expenseCost[]" required></td>
                <td><input type="text" name="expenseInfo[]" required></td>
                <td><button type="button" onclick="removeExpenseDetail(this)">-</button></td>
            `;
            expenseDetailsTable.appendChild(newRow);
        }

        function removeExpenseDetail(button) {
            var row = button.parentNode.parentNode;
            row.parentNode.removeChild(row);
        }
        
        // 기타 스크립트 코드
    </script>
</body>
</html>