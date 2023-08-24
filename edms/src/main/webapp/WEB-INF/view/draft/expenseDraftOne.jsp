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
    <form action="${pageContext.request.contextPath}/modifyExpenseDraft" method="post">
        <table>
            <tr>
                <td colspan="2"><h3>지출결의서</h3></td>
            </tr>
            <tr>
                <td>결재라인</td>
                <td>
                    기안자: <span id="firstApproval">${expenseDraftData.selectedFirstApproverId}</span>
                    중간승인자: 
                    <span id="selectedMiddleApprover">${expenseDraftData.selectedMiddleApproverId}</span>
                    최종승인자: 
                    <span id="selectedFinalApprover">${expenseDraftData.selectedFinalApproverId}</span>	
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
        
        <div class="buttons">
        </div>
    </form>
</body>
</html>