<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기안서 상세</title>
    <head>
    <meta charset="UTF-8">
    <title>기안서 상세</title>
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
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }
        
        #buttonArea {
            margin-top: 20px;
        }

    </style>
</head>
<body>
	<c:set var="m" value="${memberSignMap}"></c:set>
    <h2>기안서 상세</h2>
    <form action="${pageContext.request.contextPath}/draft/basicDraftOne" method="post">
        <table>
            <tr>
                <th rowspan="3" colspan="2">
                    기안서
                    <input type="hidden" id="role" name="role" value="${basicDraftData.role}">
                    <input type="hidden" id="status" name="status" value="${basicDraftData.status}">
                    <input type="hidden" id="approvalNo" name="approvalNo" value="${basicDraftData.approvalNo}">
                </th>
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
				</td>
				<td>
					<c:if test="${m.mediateSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
						<img src="${m.mediateSign.memberPath}${m.mediateSign.memberSaveFileName}.${m.mediateSign.memberFiletype}">
					</c:if>
				</td>
				<td>
					<c:if test="${m.finalSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
						<img src="${m.finalSign.memberPath}${m.finalSign.memberSaveFileName}.${m.finalSign.memberFiletype}">
					</c:if>
				</td>
			</tr>
            <tr>
                <td >
                    <span id="firstApproval">${basicDraftData.firstApprovalName}</span>
                </td>
                <td>
                    <span id="selectedMiddleApprover">${basicDraftData.mediateApprovalName}</span>
                </td>
                <td>
                    <span id="selectedFinalApprover">${basicDraftData.finalApprovalName}</span>	
                </td>
            </tr>
            <tr>
                <td>수신참조</td>
                <td colspan="5">
                    <span id="selectedRecipients">
                        <c:forEach items="${basicDraftData.selectedRecipientsIds}" var="recipientId">
                            ${recipientId},
                        </c:forEach>
                    </span>
                </td>
            </tr>
            <tr>
                <td>제목</td>
                <td colspan="5">${basicDraftData.docTitle}</td>
            </tr>
            <tr>
                <td>내용</td>
                <td colspan="5">${basicDraftData.docContent}</td>
            </tr>
        </table>
        
        <div>
            <label>파일첨부</label>
        </div>
        
        <div id="buttonArea">
            <!-- 여기에 동적으로 생성된 버튼들이 나열됨 -->
        </div>
        <input type="hidden" id="action" name="action" value="">
        <input type="hidden" id="rejectionReason" name="rejectionReason" value="">
    </form>
    <div id="rejectionModal" class="modal">
    <div class="modal-content">
        <h3>반려 사유 입력</h3>
        <textarea id="rejectionReasonInput" rows="4" cols="50" placeholder="반려 사유를 입력하세요"></textarea>
        
        <button id="closeRejectionModal">취소</button>
        <button id="submitApprovalReason" class="approval-button" data-action="reject">반려</button>
    </div>
</div>
 <!-- 버튼 클릭 시 폼 제출 -->

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // 예시 데이터 (실제 데이터에 맞게 수정해야 함)
            const role = "${basicDraftData.role}"; // 기안자, 중간승인자, 최종승인자 등의 역할 정보
            const status = "${basicDraftData.status}"; // 결재 상태 정보 (A: 기안, B: 중간승인, C: 최종승인 등)
            const approvalNo = "${basicDraftData.approvalNo}"; // 결재 번호 등의 정보

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
        
        $("#closeRejectionModal").click(function() {
            $("#rejectionModal").hide();
        });

        // '반려 사유 입력' 모달 내부의 '반려' 버튼을 클릭할 때 작업을 수행합니다.
        $("#submitRejectionReason").click(function() {
        	const action = "reject"; // 액션은 'reject'로 설정
            const rejectionReason = $("#rejectionReasonInput").val(); // 입력된 반려 사유

            // 숨겨진 입력 필드에 액션과 반려 사유를 설정합니다.
            $("#action").val(action);
            $("#rejectionReason").val(rejectionReason);
            
         // '반려 사유 입력' 모달을 숨깁니다.
            $("#rejectionModal").hide();
            
            // 폼을 제출합니다.
            $("form").submit();
           
        });
        
        $(document).on("click", ".approval-button", function() {
            const action = $(this).data("action"); // 클릭한 버튼의 action 값을 가져옵니다.

            if (action !== "rejectButton") {
                // 'rejectButton'이 아닌 경우에만 실행
                $("#action").val(action);
                $("form").submit();
            } else {
                // 'rejectButton'인 경우에는 '반려 사유 입력' 모달을 표시
                $("#rejectionModal").show();
                
                event.preventDefault();
            }
        });
    </script>
</body>
</html>