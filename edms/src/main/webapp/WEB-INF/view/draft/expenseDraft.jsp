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
    <form action="${pageContext.request.contextPath}/expenseDraft" method="post">
        <table>
            <tr>
                <td colspan="2"><h3>지출결의서</h3></td>
            </tr>
            <tr>
                <td>결재라인</td>
                <td>
                    기안자: <input type="text" name="applicantName" value="김부장" readonly>
                    중간승인자: <button type="button" id="middleApproverBtn">선택</button>
                    <span id="selectedMiddleApprover"></span>
                    최종승인자: <button type="button" id="finalApproverBtn">선택</button>
                    <span id="selectedFinalApprover"></span>	
                    <input type="hidden" id="selectedMiddleApproverId" name="selectedMiddleApproverId" value="">
                    <input type="hidden" id="selectedFinalApproverId" name="selectedFinalApproverId" value="">
                </td>
            </tr>
            <tr>
                <td>수신참조</td>
                <td>
                    <button type="button" id="recipientsBtn">선택</button>
                    <span id="selectedRecipients"></span>
                    <input type="hidden" id="selectedRecipientsIds" name="recipients[]" value="">
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
                            <th><button type="button" id="addExpenseDetailBtn">+</button></th>
                        </tr>
                        <!-- 내역 항목 -->
                        <tr>
                            <td><input type="text" name="expenseCategory[]" required></td>
                            <td><input type="number" name="expenseCost[]" required></td>
                            <td><input type="text" name="expenseInfo[]" required></td>
                            <td><button type="button" class="removeExpenseDetailBtn">-</button></td>
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
            <button type="submit" id="saveDraftBtn">임시저장</button>
            <button type="submit" id="submitBtn">기안하기</button>
        </div>
    </form>

    <div class="modal" id="middleApproverModal" style="display: none;">
        <h3>중간승인자 선택</h3>
        <ul id="employeeList">
            <c:forEach var="employee" items="${employeeList}">
                <li>
                    <label>
                        <input type="radio" name="selectedMiddleApprover" value="${employee.empNo}">
                        ${employee.empName}
                    </label>
                </li>
            </c:forEach>
        </ul>
        <button type="button" id="selectMiddleApproverBtn">선택</button>
        <button type="button" onclick="closeMiddleApproverModal()">닫기</button>
    </div>

    <div class="modal" id="finalApproverModal" style="display: none;">
        <h3>최종승인자 선택</h3>
        <ul id="employeeList">
            <c:forEach var="employee" items="${employeeList}">
                <li>
                    <label>
                        <input type="radio" name="selectedFinalApprover" value="${employee.empNo}">
                        ${employee.empName}
                    </label>
                </li>
            </c:forEach>
        </ul>
        <button type="button" id="selectFinalApproverBtn">선택</button>
        <button type="button" onclick="closeFinalApproverModal()">닫기</button>
    </div>

	<div class="modal" id="recipientsModal" style="display: none;">
	    <h3>수신참조자 선택</h3>
	    <ul id="recipientsList">
	        <c:forEach var="employee" items="${employeeList}">
	            <li>
	                <input type="checkbox" name="recipients[]" value="${employee.empNo}">
	                ${employee.empName}
	            </li>
	        </c:forEach>
	    </ul>
	    <button type="button" id="selectRecipientsBtn">선택</button>
	    <button type="button" onclick="closeModal('recipients')">닫기</button>
	</div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // 중간승인자 모달 열기
            function openMiddleApproverModal() {
                $("#middleApproverModal").show();
            }

            // 최종승인자 모달 열기
            function openFinalApproverModal() {
                $("#finalApproverModal").show();
            }

            // 중간승인자 모달 닫기
            function closeMiddleApproverModal() {
                $("#middleApproverModal").hide();
            }

            // 최종승인자 모달 닫기
            function closeFinalApproverModal() {
                $("#finalApproverModal").hide();
            }

            // 중간승인자 선택 처리
            function selectMiddleApprover() {
                var selectedApproverInput = $('input[name="selectedMiddleApprover"]:checked');
                if (selectedApproverInput.length > 0) {
                    var selectedEmployeeName = selectedApproverInput.parent().text().trim();
                    var selectedEmployeeNo = selectedApproverInput.val();

                    selectedMiddleApprover = selectedEmployeeName;
                    $("#selectedMiddleApprover").text(selectedEmployeeName);
                    $("#selectedMiddleApproverId").val(selectedEmployeeNo);
                }
                closeMiddleApproverModal();
            }

            // 최종승인자 선택 처리
            function selectFinalApprover() {
                var selectedApproverInput = $('input[name="selectedFinalApprover"]:checked');
                if (selectedApproverInput.length > 0) {
                    var selectedEmployeeName = selectedApproverInput.parent().text().trim();
                    var selectedEmployeeNo = selectedApproverInput.val();

                    selectedFinalApprover = selectedEmployeeName;
                    $("#selectedFinalApprover").text(selectedEmployeeName);
                    $("#selectedFinalApproverId").val(selectedEmployeeNo);
                }
                closeFinalApproverModal();
            }

            // 수신참조자 모달 열기
            function openRecipientsModal() {
                $("#recipientsModal").show();
            }

            // 수신참조자 선택 처리
            function selectRecipients() {
                selectedRecipients = [];
                $("#recipientsList input:checked").each(function() {
                    var recipientEmpNo = parseInt($(this).val());
                    var recipientEmpName = $(this).parent().text().trim();
                    selectedRecipients.push({ empNo: recipientEmpNo, empName: recipientEmpName });
                });

                var recipientsText = selectedRecipients.map(recipient => recipient.empName).join(", ");
                $("#selectedRecipients").text(recipientsText);
                closeModal("recipientsModal");

               
                $("#recipientsBtn").text("선택 완료 (" + selectedRecipients.length + ")");
            }

            
            // 내역 항목 추가
            $("#addExpenseDetailBtn").click(function() {
                var newRow = `
                    <tr>
                        <td><input type="text" name="expenseCategory[]" required></td>
                        <td><input type="number" name="expenseCost[]" required></td>
                        <td><input type="text" name="expenseInfo[]" required></td>
                        <td><button type="button" class="removeExpenseDetailBtn">-</button></td>
                    </tr>
                `;
                $("#expenseDetailsTable").append(newRow);
            });

            // 내역 항목 제거
            $(document).on("click", ".removeExpenseDetailBtn", function() {
                $(this).closest("tr").remove();
            });

         // 공통적으로 사용하는 데이터 수집 및 전송 함수
            function sendData(isSaveDraft) {
                // 필요한 데이터 수집
                var selectedMiddleApproverId = $("#selectedMiddleApproverId").val();
                var selectedFinalApproverId = $("#selectedFinalApproverId").val();
                var paymentDate = $("input[name='paymentDate']").val();
                var documentTitle = $("input[name='documentTitle']").val();
                
                // 유효성 검사 - 기안하기와 임시저장 모두 결재라인 데이터가 필요함
                if (!selectedMiddleApproverId || !selectedFinalApproverId) {
                    alert("승인자를 선택해주세요.");
                    return false;
                }

                if (!paymentDate) {
                    alert("마감일을 입력해주세요.");
                    return false;
                }

                if (!documentTitle) {
                    alert("제목을 입력해주세요.");
                    return false;
                }

                // 기안하기 버튼 클릭 시에만 추가 데이터 수집
                if (!isSaveDraft) {
                    // 수신참조자 배열 수집
                    var selectedRecipientsIds = [];
                    $("#recipientsList input:checked").each(function() {
                        var recipientEmpNo = parseInt($(this).val());
                        selectedRecipientsIds.push(recipientEmpNo);
                    });

                    // 내역 항목 데이터 가져오기
                    var expenseDetails = [];
                    $("#expenseDetailsTable tr:gt(0)").each(function() {
                        var category = $(this).find("input[name^='expenseCategory']").val();
                        var cost = $(this).find("input[name^='expenseCost']").val();
                        var info = $(this).find("input[name^='expenseInfo']").val();
                        expenseDetails.push({ category: category, cost: cost, info: info });
                    });

                    if (expenseDetails.length === 0) {
                        alert("내역 항목을 추가해주세요.");
                        return false;
                    }
                }

                // JSON 형식으로 변환하여 전송할 데이터 생성
                var dataToSend = {
                    selectedMiddleApproverId: selectedMiddleApproverId,
                    selectedFinalApproverId: selectedFinalApproverId,
                    paymentDate: paymentDate,
                    documentTitle: documentTitle,
                    selectedRecipientsIds: selectedRecipientsIds,
                    expenseDetails: expenseDetails,
                    isSaveDraft: isSaveDraft
                    // 추가로 필요한 데이터 추가
                };

                // 폼 제출
                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/expenseDraft",
                    contentType: "application/json",
                    data: JSON.stringify(dataToSend),
                    success: function(response) {
                        if (isSaveDraft) {
                            console.log("임시저장 서버 응답: ", response);
                            // 임시저장 완료 메시지 등의 동작
                        } else {
                            console.log("기안하기 서버 응답: ", response);
                            // 기안하기 완료 메시지 등의 동작
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("에러 발생: ", error);
                        // 에러 메시지 표시 등의 동작
                    }
                });
            }

            // 기안하기 버튼 클릭 시
        $("#saveDraftBtn").click(function() {
            sendData(true);
        });

        // 기안하기 버튼 클릭 시 호출되는 함수
        $("#submitBtn").click(function() {
            sendData(false);
        });


            // 버튼 이벤트 핸들러 설정
            $("#middleApproverBtn").click(openMiddleApproverModal);
            $("#finalApproverBtn").click(openFinalApproverModal);
            $("#selectMiddleApproverBtn").click(selectMiddleApprover);
            $("#selectFinalApproverBtn").click(selectFinalApprover);
            $("#recipientsBtn").click(openRecipientsModal);
            $("#selectRecipientsBtn").click(selectRecipients);
            $("#addExpenseDetailBtn").click(addExpenseDetail);
        });
    </script>
</body>
</html>