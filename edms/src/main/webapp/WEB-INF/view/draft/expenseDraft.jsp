<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지출결의서 작성</title>
    <style>
        /* 여기에 스타일을 추가하세요 */
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
                    중간승인자: <button type="button" onclick="openModal('middle')">선택</button>
                    <span id="selectedMiddleApprover"></span>
                    최종승인자: <button type="button" onclick="openModal('final')">선택</button>
                    <span id="selectedFinalApprover"></span>
                </td>
            </tr>
            <tr>
                <td>수신참조</td>
                <td>
                    <button type="button" onclick="openModal('recipients')">선택</button>
                </td>
            </tr>
            <tr>
                <td>마감일</td>
                <td><input type="date" name="dueDate" required></td>
            </tr>
            <tr>
                <td>제목</td>
                <td><input type="text" name="documentTitle" required></td>
            </tr>
            <tr>
                <td colspan="2">
                    <table id="expenseDetailsTable">
                        <!-- 내역 항목 -->
                    </table>
                    <button type="button" onclick="addExpenseDetail()">+</button>
                </td>
            </tr>
        </table>
        
        <div>
            <label>파일첨부</label>
            <input type="file" name="attachedFile">
        </div>
        
        <div class="buttons">
            <button type="button" onclick="cancel()">취소</button>
            <button type="button" onclick="saveDraft()">임시저장</button>
            <button type="submit" onclick="submitDocument()">기안하기</button>
        </div>
    </form>
    
    <div class="modal" id="approverModal">
        <!-- 모달 내용 (동적으로 생성한 사원 리스트 표시) -->
        <h3>승인자 선택</h3>
        <ul id="employeeList">
            <c:forEach var="employee" items="${employeeList}">
                <li><button type="button" onclick="selectApprover('${employee.empName}')">${employee.empName}</button></li>
            </c:forEach>
        </ul>
        <button type="button" onclick="closeModal()">닫기</button>
    </div>
    
    <div class="modal" id="recipientsModal">
        <!-- 모달 내용 (동적으로 생성한 사원 리스트 표시) -->
        <h3>수신참조자 선택</h3>
        <ul id="recipientsList">
            <c:forEach var="employee" items="${employeeList}">
                <li><input type="checkbox" name="recipients" value="${employee.empName}" onclick="addRecipient(this)">${employee.empName}</li>
            </c:forEach>
        </ul>
        <button type="button" onclick="closeModal()">닫기</button>
    </div>
    
    <input type="hidden" id="selectedApproverModal" value=""> <!-- 선택한 승인자 영역의 ID 저장 -->
    <input type="hidden" id="selectedRecipientModal" value=""> <!-- 선택한 수신참조자 영역의 ID 저장 -->
    
    <script>
        function selectApprover(employeeName) {
            var approverElementId = document.getElementById("selectedApproverModal").value;
            var approverElement = document.getElementById(approverElementId);
            if (approverElement) {
                approverElement.innerHTML = employeeName;
            }
            
            document.getElementById("selectedApproverModal").value = employeeName;
            closeModal();
        }
        
        function openModal(approverType) {
            var modal = document.getElementById(approverType + "Modal");
            modal.style.display = "block";
            document.getElementById("selectedApproverModal").value = "selected" + approverType.capitalize() + "Approver";
        }
        
        function closeModal() {
            var modals = document.querySelectorAll(".modal");
            modals.forEach(function(modal) {
                modal.style.display = "none";
            });
        }
        
        function addRecipient(checkbox) {
            var recipientsElement = document.getElementById("selectedRecipients");
            var recipientName = checkbox.value;
            if (checkbox.checked) {
                var existingRecipients = recipientsElement.innerHTML;
                if (existingRecipients === "") {
                    recipientsElement.innerHTML = recipientName;
                } else {
                    recipientsElement.innerHTML += ", " + recipientName;
                }
            }
        }
        
        String.prototype.capitalize = function() {
            return this.charAt(0).toUpperCase() + this.slice(1);
        }
    </script>
</body>
</html>