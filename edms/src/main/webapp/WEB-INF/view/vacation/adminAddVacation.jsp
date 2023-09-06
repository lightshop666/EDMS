<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Vacation Payment/Deduction</title>
</head>
<body>
	<br>
	   <nav class="navbar navbar-expand-lg navbar-light">
	       <div class="collapse navbar-collapse" id="navbarNav">
	           <ul class="nav nav-tabs">
	               <li class="nav-item">
	                   <a class="nav-link" href="${pageContext.request.contextPath}/emp/modifyEmp?empNo=${empNo}">인사정보</a>
	               </li>
	               <li class="nav-item">
	                   <a class="nav-link" href="${pageContext.request.contextPath}/emp/adminMemberOne?empNo=${empNo}">개인정보</a>
	               </li>
	               <li class="nav-item">
	                   <a class="nav-link active" href="${pageContext.request.contextPath}/vacation/vacationHistory?empNo=${empNo}">휴가정보</a>
	               </li>
	           </ul>
	       </div>
	   </nav>
  	<br>
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
    
    <a href="${pageContext.request.contextPath}/vacation/vacationHistory?empNo=${empNo}">휴가 내역으로 돌아가기</a>
</body>
</html>