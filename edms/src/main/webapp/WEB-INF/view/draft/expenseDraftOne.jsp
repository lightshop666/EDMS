<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지출결의서 작성</title>
<!-- 테이블 스타일 추가 -->
	<style>
		.actionBtn {
        margin-right: 10px; /* 원하는 간격(px)을 지정 */
    	}
    	
    	  .approval-button {
	        /* 모든 동적 버튼에 공통으로 적용할 스타일 */
	        padding: 8px 16px;
	        background-color: #6c757d;
	        color: #fff;
	        border: none;
	        cursor: pointer;
	        
	        margin-right: 10px; /* 버튼 간의 오른쪽 여백을 지정합니다. */
	    }
    	
    	#buttonArea {
        margin-top: 20px; /* 원하는 여백 크기(px)를 지정합니다. */
    }
    
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
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- Tell the browser to be responsive to screen width -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">
	<!-- Favicon icon -->
	<link rel="icon" type="image/png" sizes="16x16" href="../assets/images/favicon.png">
	<title>salesDraft</title>
	<!-- Custom CSS -->
	<link href="../assets/extra-libs/c3/c3.min.css" rel="stylesheet">
	<link href="../assets/libs/chartist/dist/chartist.min.css" rel="stylesheet">
	<link href="../assets/extra-libs/jvector/jquery-jvectormap-2.0.2.css" rel="stylesheet" />
	<!-- Custom CSS -->
	<link href="../dist/css/style.min.css" rel="stylesheet">
	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->
	<!-- ============================================================== -->
	<!-- All Jquery -->
	<!-- 공통 함수를 불러옵니다. -->
	<script src="/draftFunction.js"></script>
	<!-- ============================================================== -->
	<script src="../assets/libs/jquery/dist/jquery.min.js"></script>
	<script src="../assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<!-- apps -->
	<!-- apps -->
	<script src="../dist/js/app-style-switcher.js"></script>
	<script src="../dist/js/feather.min.js"></script>
	<script src="../assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
	<script src="../dist/js/sidebarmenu.js"></script>
	<!--Custom JavaScript -->
	<script src="../dist/js/custom.min.js"></script>
	<!--This page JavaScript -->
	<script src="../assets/extra-libs/c3/d3.min.js"></script>
	<script src="../assets/extra-libs/c3/c3.min.js"></script>
	<script src="../assets/libs/chartist/dist/chartist.min.js"></script>
	<script src="../assets/libs/chartist-plugin-tooltips/dist/chartist-plugin-tooltip.min.js"></script>
	<script src="../assets/extra-libs/jvector/jquery-jvectormap-2.0.2.min.js"></script>
	<script src="../assets/extra-libs/jvector/jquery-jvectormap-world-mill-en.js"></script>
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
                    addButton("modifyButton", "수정","modifyButton");
                    addButton("cancelButton", "기안 취소","cancelButton");
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

        // '반려 사유 입력' 모달 내부의 '반려' 버튼을 클릭할 때 작업을 수행합니다.
        $("#submitRejectionReason").click(function() {
            const action = "reject"; // 액션은 'reject'로 설정
            const rejectionReason = $("#rejectionReason").val(); // 입력된 반려 사유
            
            // 숨겨진 입력 필드에 액션과 반려 사유를 설정합니다.
            $("#action").val(action);
            $("#approvalReason").val(rejectionReason);
            
            // 폼을 제출합니다.
            $("form").submit();
            
            // '반려 사유 입력' 모달을 숨깁니다.
            $("#rejectionModal").hide();
        });
        
        $("#closeRejectionModal").click(function() {
            $("#rejectionModal").hide();
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
            }
        });
        
        
    });  
    </script>
</head>
<body>
<!-- ============================================================== -->
<!-- Preloader - style you can find in spinners.css -->
<!-- ============================================================== -->
<div class="preloader">
    <div class="lds-ripple">
        <div class="lds-pos"></div>
        <div class="lds-pos"></div>
    </div>
</div>
<!-- ============================================================== -->
<!-- Main wrapper - style you can find in pages.scss -->
<!-- ============================================================== -->
<div id="main-wrapper" data-theme="light" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
    data-sidebar-position="fixed" data-header-position="fixed" data-boxed-layout="full">
	<!-- ============================================================== -->
	<!-- Topbar header - style you can find in pages.scss -->
	<!-- ============================================================== -->
	<!-- 헤더 인클루드 -->
	
	<header class="topbar" data-navbarbg="skin6">
		<jsp:include page="/WEB-INF/view/inc/header.jsp" />
	</header>
	<!-- ============================================================== -->
	<!-- End Topbar header -->
	<!-- ============================================================== -->
	<!-- ============================================================== -->
	<!-- Left Sidebar - style you can find in sidebar.scss  -->
	<!-- ============================================================== -->
	
	<!-- 좌측 메인메뉴 인클루드 -->
	
	<aside class="left-sidebar" data-sidebarbg="skin6">
	
		<jsp:include page="/WEB-INF/view/inc/mainmenu.jsp" />
	
	</aside>
	
	<!-- ============================================================== -->
	<!-- End Left Sidebar - style you can find in sidebar.scss  -->
	<!-- ============================================================== -->
        
        
        
        <!-- ============================================================== -->
        <!-- Page wrapper  -->
        <!-- ============================================================== -->
        
        
        
	<div class="page-wrapper">
	<!-- ============================================================== -->
	<!-- Container fluid  -->
	<!-- ============================================================== -->
		<div class="container-fluid">
<!-----------------------------------------------------------------본문 내용 ------------------------------------------------------->
	<c:set var="m" value="${memberSignMap}"></c:set>
    <h2>지출결의서 상세</h2>
    <form action="${pageContext.request.contextPath}/draft/expenseDraftOne" method="post">
        <table class="table-bordered">
        	
            <tr>
                <th rowspan="3" colspan="2">
                    지출결의서
                    <input type="hidden" id="role" name="role" value="${expenseDraftData.role}">
                    <input type="hidden" id="status" name="status" value="${expenseDraftData.status}">
                    <input type="hidden" id="approvalNo" name="approvalNo" value="${expenseDraftData.approvalNo}">
                </th>
                <th rowspan="3">결재</th>
                <th>기안자</th>
                <th>중간승인자</th>
                <th>최종승인자</th>
            </tr>
            <tr>
				<td>
					<c:if test="${m.firstSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
						<img src="${m.firstSign.memberPath}${m.firstSign.memberSaveFileName}">
					</c:if>
				</td>
				<td>
					<c:if test="${m.mediateSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
						<img src="${m.mediateSign.memberPath}${m.mediateSign.memberSaveFileName}">
					</c:if>
				</td>
				<td>
					<c:if test="${m.finalSign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
						<img src="${m.finalSign.memberPath}${m.finalSign.memberSaveFileName}">
					</c:if>
				</td>
			</tr>
            <tr>
                <td >
                    <span id="firstApproval">${expenseDraftData.firstApprovalName}</span>
                </td>
                <td>
                    <span id="selectedMiddleApprover">${expenseDraftData.mediateApprovalName}</span>
                </td>
                <td>
                    <span id="selectedFinalApprover">${expenseDraftData.finalApprovalName}</span>	
                </td>
            </tr>
            <tr>
                <td>마감일</td>
                <td colspan="5">${expenseDraftData.paymentDate}</td>
            </tr>
                        <tr>
                <td>수신참조</td>
                <td colspan="5">
                    <span id="selectedRecipients">
                        <c:forEach items="${expenseDraftData.selectedRecipientsIds}" var="recipientId">
                            ${recipientId},
                        </c:forEach>
                    </span>
                </td>
            </tr>
            <tr>
                <td>제목</td>
                <td colspan="5">${expenseDraftData.docTitle}</td>
            </tr>
            <tr>
                <td>내역</td>
                <td colspan="5">
                
                    <table id="expenseDetailsTable" class="table-bordered">
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
		<input type="hidden" id="rejectionReason" name="rejectionReason" value="">
    </form>
    <div id="rejectionModal" class="modal">
	    <div class="modal-content">
	    	<div class="modal-header">
		        <h3>반려 사유 입력</h3>
		        <textarea id="rejectionReasonInput" rows="4" cols="50" placeholder="반려 사유를 입력하세요"></textarea>
		        
		        <button id="closeRejectionModal" class="btn btn-secondary">>취소</button>
		        <button id="submitApprovalReason" class="actionBtn btn btn-secondary"  data-action="reject">반려</button>
	    	</div>
	    </div>	
 	</div>
<!-----------------------------------------------------------------본문 끝 ------------------------------------------------------->          

</div>
<!-- ============================================================== -->
<!-- End Container fluid  -->
<!-- ============================================================== -->
          
<!-- ============================================================== -->
<!-- footer -->
<!-- ============================================================== -->
<!-- 푸터 인클루드 -->
<footer class="footer text-center text-muted">

	<jsp:include page="/WEB-INF/view/inc/footer.jsp" />
	
</footer>
<!-- ============================================================== -->
<!-- End footer -->
<!-- ============================================================== -->
</div>
<!-- ============================================================== -->
<!-- End Page wrapper  -->
<!-- ============================================================== -->        
</div>
<!-- ============================================================== -->
<!-- End Wrapper -->
<!-- ============================================================== -->
<!-- End Wrapper -->
<!-- ============================================================== --> 	
</body>
</html>