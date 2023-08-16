<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Header</title>
</head>
<body>
<div>
<!-- 홈으로 -->
	<h1><a href="<%=request.getContextPath()%>/home">GoodeeFit</a></h1>	
</div>

<div>
<!-- 알림 이미지-->
</div>

<div>
<!-- 마이페이지 -->
	<a href="">${loginMemberId} 님</a>
	<a href="<%=request.getContextPath()%>/logout">로그아웃</a>
</div>


</body>
</html>