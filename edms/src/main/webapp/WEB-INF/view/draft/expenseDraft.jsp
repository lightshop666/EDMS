<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>지출결의서 작성</title>
</head>
<body>
    <h2>지출결의서 작성</h2>
    <form action="/expense/save" method="post" enctype="multipart/form-data">
        <table>
            <tr>
                <th>지출결의서</th>
                <th>결재라인</th>
            </tr>
            <tr>
                <td rowspan="2">
                    <label>기안자</label>
                    <input type="text" name="applicantName" value="김부장" readonly>
                </td>
                <td>중간승인자<button type="button" onclick="openModal('approver', 'middle')">선택</button></td>
            </tr>
            <tr>
                <td>최종승인자<button type="button" onclick="openModal('approver', 'final')">선택</button></td>
            </tr>
            <tr>
                <td>수신참조<button type="button" onclick="openModal('recipients')">선택</button></td>
                <td>마감일<input type="date" name="dueDate" required></td>
            </tr>
            <tr>
                <td colspan="2">제목<input type="text" name="documentTitle" required></td>
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
        
        <div>
            <button type="button" onclick="cancel()">취소</button>
            <button type="button" onclick="saveDraft()">임시저장</button>
            <button type="submit" onclick="submitDocument()">기안하기</button>
        </div>
    </form>
    
    <script>
        // JavaScript 코드 (모달 및 동적 추가/삭제 기능 구현)
    </script>
</body>
</html>