<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지출결의서 작성</title>
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
	    /* 탭 선택된 상태가 진하게 */
		.nav-link.active {
		    font-weight: bold;
		    color: white;
		    background-color: #007bff;
		}
		a:link, a:visited { 
			color: black;
			text-decoration: none;
		}
		a:hover { 
			color: blue;
			text-decoration: underline;
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
	<script src="../dist/js/pages/dashboards/dashboard1.min.js"></script>
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
                    <tr style="border: 1px solid black;">
                        <td style="border: 1px solid black;">
                            <select style="border: 1px solid black;" name="expenseCategory[]" required>
                                <option value="교통비">교통비</option>
                                <option value="식비">식비</option>
                                <option value="통신비">통신비</option>
                                <option value="사무용품비">사무용품비</option>
                            </select>
                        </td>
                        <td style="border: 1px solid black;"><input style="border: 1px solid black;" type="number" name="expenseCost[]" required></td>
                        <td style="border: 1px solid black;"><input style="border: 1px solid black;" type="text" name="expenseInfo[]" required></td>
                        <td style="border: 1px solid black;"><button style="border: 1px solid black;" type="button" class="removeExpenseDetailBtn">-</button></td>
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
                    	 let url = '/draft/submitDraft'; // 리다이렉션할 URL로 변경
                         location.replace(url);
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
        <br>
	   <nav class="navbar navbar-expand-lg navbar-light">
	       <div class="collapse navbar-collapse" id="navbarNav">
	           <ul class="nav nav-tabs">
	               <li class="nav-item">
	                   <a class="nav-link" href="${pageContext.request.contextPath}/draft/basicDraft">기안서</a>
	               </li>
	               <li class="nav-item">
	                   <a class="nav-link active" href="${pageContext.request.contextPath}/draft/expenseDraft">지출결의서</a>
	               </li>
	               <li class="nav-item">
	                   <a class="nav-link" href="${pageContext.request.contextPath}/draft/salesDraft">매출보고서</a>
	               </li>
	               <li class="nav-item">
	                   <a class="nav-link" href="${pageContext.request.contextPath}/draft/vacationDraft">휴가신청서</a>
	               </li>
	           </ul>
	       </div>
	   </nav>
   <br>
   <div class="container pt-5">
	    <h1 style="text-align: center;">지출결의서 작성</h1> <br>
	        <table class="table-bordered">
	            <tr>
					<th rowspan="3" colspan="2">지출결의서</th>
					<th rowspan="3">결재</th>
					<th>기안자</th>
					<th>중간승인자</th>
					<th>최종승인자</th>
				</tr>
	         
	            <tr>
	                <td>
	                   <c:if test="${sign.memberSaveFileName != null}"> <!-- 서명 이미지 출력 -->
							<img src="${sign.memberPath}${sign.memberSaveFileName}">
						</c:if>
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
	            		${empName}_${deptName}_${empPosition}
	            	</td>
					<td>
						<button type="button" id="middleApproverBtn" class="btn btn-secondary">
							검색 <!-- 중간승인자 검색 모달 버튼 -->
						</button>
					</td>
					<td>
						<button type="button" id="finalApproverBtn" class="btn btn-secondary">
							검색 <!-- 최종승인자 검색 모달 버튼 -->
						</button>
					</td>
				</tr>
	            <tr>
	                <td>수신참조 <button type="button" id="recipientsBtn" class="btn btn-secondary">선택</button></td>
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
	                    <table id="expenseDetailsTable" class="table-bordered">
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
	            <tr>
					<th colspan="6">
						위와 같이 결재바랍니다. <br>
						${year}년 ${month}월 ${day}일
					</th>
				</tr>
	        </table>
	
	        <!-- 버튼 그룹 -->
	        <div class="buttons">
	            <button type="submit" class="btn btn-secondary" id="saveDraftBtn">임시저장</button>
	            <button type="submit" class="btn btn-primary" id="submitBtn">저장</button>
	        </div>
	   </div>

   <!-- 중간승인자 검색 모달 -->
   <div class="modal" id="middleApproverModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="primary-header-modalLabel" style="display: none;">
       <div class="modal-dialog">
           <div class="modal-content">
               <!-- 모달 헤더 -->
               <div class="modal-header modal-colored-header bg-primary">
                   <h4 class="modal-title">중간승인자 선택</h4>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button> <!-- x버튼 -->
               </div>
               <!-- 모달 본문 -->
               <div class="modal-body">
                   <table class="table-bordered">
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
                   <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
                   <button type="button" class="btn btn-primary" id="selectMiddleApproverBtn">저장</button>
               </div>
           </div>
       </div>
   </div>

    <!-- 최종승인자 검색 모달 -->
   <div class="modal" id="finalApproverModal"  class="modal fade" tabindex="-1" role="dialog" aria-labelledby="primary-header-modalLabel" style="display: none;">
       <div class="modal-dialog">
           <div class="modal-content">
               <!-- 모달 헤더 -->
               <div class="modal-header modal-colored-header bg-primary">
                   <h4 class="modal-title">최종승인자 선택</h4>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button> <!-- x버튼 -->
               </div>
               <!-- 모달 본문 -->
               <div class="modal-body">
                   <table class="table-bordered">
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
                   <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
                   <button type="button" class="btn btn-primary"  id="selectFinalApproverBtn">저장</button>
               </div>
           </div>
       </div>
   </div>
   <!-- 수신참조자 검색 모달 -->
   <div class="modal" id="recipientsModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="primary-header-modalLabel"  style="display: none;">
       <div class="modal-dialog">
           <div class="modal-content">
               <!-- 모달 헤더 -->
                <div class="modal-header modal-colored-header bg-primary">
                   <h4 class="modal-title">수신참조자 선택</h4>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button> <!-- x버튼 -->
               </div>
               <!-- 모달 본문 -->
               <div class="modal-body">
                  <table class="table-bordered">
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
               		
                   <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
                   <button type="button" class="btn btn-primary" id="selectRecipientsBtn">저장</button>
               </div>
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