<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Vacation Payment/Deduction</title>
</head>
<body>
    <h1>Vacation Payment/Deduction</h1>
    
    <form method="post" action="${pageContext.request.contextPath}/adminAddVacation">
        <input type="hidden" name="empNo" value="${empNo}">
        <div class="form-group">
            <label for="vacationName">휴가 종류:</label>
            <select id="vacationName" name="vacationName" required>
                <option value="연차">연차</option>
                <option value="보상">보상</option>
            </select>
        </div>
        <div class="form-group">
            <label for="vacationPm">휴가 일수(+/-):</label>
            <select id="vacationPm" name="vacationPm" required>
                <option value="P">+</option>
                <option value="M">-</option>
            </select>
        </div>
        <div class="form-group">
            <label for="vacationDays">휴가 일수:</label>
            <input type="text" id="vacationDays" name="vacationDays" required>
        </div>
        <button type="submit">휴가 지급/차감</button>
    </form>
    
    <a href="${pageContext.request.contextPath}/vacationHistory">휴가 내역으로 돌아가기</a>
</body>
</html>