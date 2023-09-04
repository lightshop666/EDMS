<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지출결의서 작성</title>
         <style>
       table {
            border-collapse: collapse;
            width: 100%;
            border: 1px solid black;
            margin-top: 20px;
        }
        
        th, td {
            border: 1px solid black;
            padding: 10px;
            text-align: center;
        }
        
        th {
            vertical-align: middle;
        }
        
        td span {
            display: block;
            padding: 5px;
        }
	    input[type="text"], textarea {
	        width: 100%; /* input 요소와 textarea 요소가 셀의 너비에 맞게 꽉 차도록 설정 */
	        box-sizing: border-box; /* 내부 패딩과 경계선을 포함하여 너비 계산 */
	    }
	
    .modal {
        display: none;
        position: fixed;
        z-index: 1;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0,0,0,0.4);
    }

    .modal-content {
        background-color: #fefefe;
        margin: 15% auto;
        padding: 20px;
        border: 1px solid #888;
        width: 80%;
    }

    </style>
</head>
<body>
    <h2>지출결의서 작성</h2>
    <form action="${pageContext.request.contextPath}/expenseDraft" method="post">
        <table>
            <tr>
				<th rowspan="3" colspan="2">지출결의서</th>
				<th rowspan="3">결재</th>
				<th>기안자</th>
				<th>중간승인자</th>
				<th>최종승인자</th>
			</tr>
         
            <tr>
                <td rowspan="2">
                    ${empName}
                </td>
                <td>    
                    <span id="selectedMiddleApprover"></span> 
                </td>
                <td>    
                    <span id="selectedFinalApprover"></span>	
                    <input type="hidden" id="selectedMiddleApproverId" name="selectedMiddleApproverId" value="">
                    <input type="hidden" id="selectedFinalApproverId" name="selectedFinalApproverId" value="">
                </td>
            </tr>
            <tr>
					<td>
						<button type="button" id="middleApproverBtn">
							검색 <!-- 중간승인자 검색 모달 버튼 -->
						</button>
					</td>
					<td>
						<button type="button" id="finalApproverBtn">
							검색 <!-- 최종승인자 검색 모달 버튼 -->
						</button>
					</td>
			</tr>
            <tr>
                <td>수신참조 <button type="button" id="recipientsBtn">선택</button></td>
                <td colspan="5">
                    
                    <span id="selectedRecipients"></span>
                    <input type="hidden" id="selectedRecipientsIds" name="recipients[]" value="">
                </td>
            </tr>
            <!-- 마감일 -->
            <tr>
                <td>마감일</td>
                <td colspan="5"><input type="date" name="paymentDate" required></td>
            </tr>
            <!-- 제목 -->
            <tr>
                <td>제목</td>
                <td colspan="5"><input type="text" name="documentTitle" required></td>
            </tr>
            <!-- 내역 항목 -->
            <tr>
                <td>
                	내역
                </td>
                <td colspan="5">
                    <table id="expenseDetailsTable">
                        <tr>
                            <th>카테고리</th>
                            <th>금액</th>
                            <th>내용</th>
                            <th><button type="button" id="addExpenseDetailBtn">+</button></th>
                        </tr>
                        <tr>
                            <td>
                                <select name="expenseCategory[]" required>
                                    <option value="교통비">교통비</option>
                                    <option value="식비">식비</option>
                                    <option value="통신비">통신비</option>
                                    <option value="사무용품비">사무용품비</option>
                                </select>
                            </td>
                            <td><input type="number" name="expenseCost[]" required></td>
                            <td><input type="text" name="expenseInfo[]" required></td>
                            <td><button type="button" class="removeExpenseDetailBtn">-</button></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <!-- 버튼 그룹 -->
        <div class="buttons">
            <button type="submit" id="saveDraftBtn">임시저장</button>
            <button type="submit" id="submitBtn">기안하기</button>
        </div>
    </form>

   <!-- 중간승인자 검색 모달 -->
   <div class="modal" id="middleApproverModal" style="display: none;">
       <div class="modal-dialog">
           <div class="modal-content">
               <!-- 모달 헤더 -->
               <div class="modal-header">
                   <h4 class="modal-title">중간승인자 선택</h4>
                   <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
               </div>
               <!-- 모달 본문 -->
               <div class="modal-body">
                   <table>
                       <tr>
                           <th>선택</th>
                           <th>사원번호</th>
                           <th>성명</th>
                           <th>부서명</th>
                           <th>직급명</th>
                       </tr>
                       <c:forEach var="employee" items="${employeeList}">
                           <tr>
                               <td>
                                   <input type="radio" value="${employee.empNo}" name="selectedMiddleApprover">
                               </td>
                               <td>
                                   ${employee.empNo}
                               </td>
                               <td>
                                   ${employee.empName}
                               </td>
                               <td>
                                   ${employee.deptName}
                               </td>
                               <td>
                                   ${employee.empPosition}
                               </td>
                           </tr>
                       </c:forEach>
                   </table>
               </div>
               <!-- 모달 푸터 -->
               <div class="modal-footer">
                   <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                   <button type="button" id="selectMiddleApproverBtn">선택</button>
               </div>
           </div>
       </div>
   </div>

    <!-- 최종승인자 검색 모달 -->
   <div class="modal" id="finalApproverModal" style="display: none;">
       <div class="modal-dialog">
           <div class="modal-content">
               <!-- 모달 헤더 -->
               <div class="modal-header">
                   <h4 class="modal-title">최종승인자 선택</h4>
                   <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
               </div>
               <!-- 모달 본문 -->
               <div class="modal-body">
                   <table>
                       <tr>
                           <th>선택</th>
                           <th>사원번호</th>
                           <th>성명</th>
                           <th>부서명</th>
                           <th>직급명</th>
                       </tr>
                       <c:forEach var="employee" items="${employeeList}">
                           <tr>
                               <td>
                                   <input type="radio" value="${employee.empNo}" name="selectedFinalApprover">
                               </td>
                               <td>
                                   ${employee.empNo}
                               </td>
                               <td>
                                   ${employee.empName}
                               </td>
                               <td>
                                   ${employee.deptName}
                               </td>
                               <td>
                                   ${employee.empPosition}
                               </td>
                           </tr>
                       </c:forEach>
                   </table>
               </div>
               <!-- 모달 푸터 -->
               <div class="modal-footer">
                   <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                   <button type="button" id="selectFinalApproverBtn">선택</button>
               </div>
           </div>
       </div>
   </div>
   <!-- 수신참조자 검색 모달 -->
   <div class="modal" id="recipientsModal" style="display: none;">
       <div class="modal-dialog">
           <div class="modal-content">
               <!-- 모달 헤더 -->
               <div class="modal-header">
                   <h4 class="modal-title">수신참조자 선택</h4>
                   <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
               </div>
               <!-- 모달 본문 -->
               <div class="modal-body">
                   <table>
                       <tr>
                           <th>선택</th>
                           <th>사원번호</th>
                           <th>성명</th>
                       </tr>
                       <c:forEach var="employee" items="${employeeList}">
                           <tr>
                               <td>
                                   <input type="checkbox" value="${employee.empNo}" name="selectedRecipients">
                               </td>
                               <td>
                                   ${employee.empNo}
                               </td>
                               <td>
                                   ${employee.empName}
                               </td>
                           </tr>
                       </c:forEach>
                   </table>
               </div>
               <!-- 모달 푸터 -->
               <div class="modal-footer">
                   <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                   <button type="button" id="selectRecipientsBtn">선택</button>
               </div>
           </div>
       </div>
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
            
         // 수신자 모달 닫기
            function closeRecieveModal() {
                $("#recipientsModal").hide();
            }
            
            

            // 중간승인자 선택 처리
            function selectMiddleApprover() {
                var selectedApproverInput = $('input[name="selectedMiddleApprover"]:checked');
                if (selectedApproverInput.length > 0) {
                    var selectedEmployeeName = selectedApproverInput.parent().next().next().text().trim();
                    var selectedEmployeeNo = selectedApproverInput.val();

                    $("#selectedMiddleApprover").text(selectedEmployeeName); // 이름 표시
                    $("#selectedMiddleApproverId").val(selectedEmployeeNo);
                }
                closeMiddleApproverModal();
            }

            // 최종승인자 선택 처리
            function selectFinalApprover() {
                var selectedApproverInput = $('input[name="selectedFinalApprover"]:checked');
                if (selectedApproverInput.length > 0) {
                    var selectedEmployeeName = selectedApproverInput.parent().next().next().text().trim();
                    var selectedEmployeeNo = selectedApproverInput.val();

                    $("#selectedFinalApprover").text(selectedEmployeeName); // 이름 표시
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
                var selectedRecipients = [];
                $("#recipientsModal input:checked").each(function() {
                    var recipientEmpNo = parseInt($(this).val());
                    var recipientEmpName = $(this).parent().next().next().text().trim(); // 이름을 가져오는 부분 수정
                    selectedRecipients.push({ empNo: recipientEmpNo, empName: recipientEmpName });
                });

                var recipientsText = selectedRecipients.map(recipient => recipient.empName).join(", ");
                $("#selectedRecipients").text(recipientsText);
                // $("#recipientsBtn").text("선택 완료 (" + selectedRecipients.length + ")"); // 이 부분을 주석 처리

                // 새로 추가된 부분: 선택 완료 버튼의 내용을 변경합니다.
                if (selectedRecipients.length > 0) {
                    $("#recipientsBtn").text("선택 완료 (" + selectedRecipients.length + ")");
                } else {
                    $("#recipientsBtn").text("선택");
                }

                // 입력 필드에 선택한 수신참조자의 사원번호들을 설정합니다.
                var selectedRecipientsIds = selectedRecipients.map(recipient => recipient.empNo);
                $("#selectedRecipientsIds").val(selectedRecipientsIds);
                
                closeRecieveModal();
            }

            
         // 내역 항목 추가
            $("#addExpenseDetailBtn").click(function() {
                var newRow = `
                    <tr>
                        <td>
                            <select name="expenseCategory[]" required>
                                <option value="교통비">교통비</option>
                                <option value="식비">식비</option>
                                <option value="통신비">통신비</option>
                                <option value="사무용품비">사무용품비</option>
                            </select>
                        </td>
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
                
                var selectedRecipientsIds = [];
                $("#recipientsModal input:checked").each(function() {
                    var recipientEmpNo = parseInt($(this).val());
                    selectedRecipientsIds.push(recipientEmpNo);
                });
                
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

                

               // 내역 항목 데이터 가져오기
               var expenseDetails = [];
               $("#expenseDetailsTable tr:gt(0)").each(function() {
                   var category = $(this).find("select[name^='expenseCategory']").val();
                   var cost = $(this).find("input[name^='expenseCost']").val();
                   var info = $(this).find("input[name^='expenseInfo']").val();
                   expenseDetails.push({ category: category, cost: cost, info: info });
               });
                    
               // 기안하기 버튼 클릭 시에만 추가 데이터 수집
               if (!isSaveDraft) {


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
                    url: "${pageContext.request.contextPath}/draft/expenseDraft",
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