<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- Tell the browser to be responsive to screen width -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">
	<!-- Favicon icon -->
	<link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon.png">
	<title>GoodeeFit 공지상세</title>
	<!-- Custom CSS -->
	<link href="${pageContext.request.contextPath}/assets/extra-libs/c3/c3.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/assets/libs/chartist/dist/chartist.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/assets/extra-libs/jvector/jquery-jvectormap-2.0.2.css" rel="stylesheet" />
	<!-- Custom CSS -->
	<link href="${pageContext.request.contextPath}/dist/css/style.min.css" rel="stylesheet">
	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->
	<!-- ============================================================== -->
	<!-- All Jquery -->
	<!-- ============================================================== -->
	<script src="${pageContext.request.contextPath}/assets/libs/jquery/dist/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<!-- apps -->
	<!-- apps -->
	<script src="${pageContext.request.contextPath}/dist/js/app-style-switcher.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/feather.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/sidebarmenu.js"></script>
	<!--Custom JavaScript -->
	<script src="${pageContext.request.contextPath}/dist/js/custom.min.js"></script>
	<!--This page JavaScript -->
	<script src="${pageContext.request.contextPath}/assets/extra-libs/c3/d3.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/extra-libs/c3/c3.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/chartist/dist/chartist.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/libs/chartist-plugin-tooltips/dist/chartist-plugin-tooltip.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/extra-libs/jvector/jquery-jvectormap-2.0.2.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/extra-libs/jvector/jquery-jvectormap-world-mill-en.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/pages/dashboards/dashboard1.min.js"></script>

	<!-- summernote 연결 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/summernote/summernote-lite.css">
	
	<script>
      $(document).ready(function() {
         // 1. summernote editor
         $('.summernote').summernote({
	        height: 700, // 에디터 높이
	     	// 읽기 전용으로 설정
	        disable: false,  // disable을 false로 설정
	        readOnly: true,  // 읽기 전용으로 설정
	        toolbar: false  // 툴바를 숨김
	      });
	
	    $('.summernote').summernote('disable'); // 에디터를 읽기 전용으로 설정
	 	
      	// 목록 버튼 클릭 시
         $('#list').click(function() {
            let result = confirm('목록으로 이동하시겠습니까?');
            if (result) {
               window.location.href = '/board/boardList'; // home으로 이동
            }
         });
         
         // 수정 버튼 클릭 시
         $('#modify').click(function() {
            let result = confirm('수정하시겠습니까?');
            if (result) {
               window.location.href = '/board/modifyBoard'; // home으로 이동
            }
         });
         
      	// 삭제 버튼 클릭 시
         $('#remove').click(function() {
            let result = confirm('삭제하시겠습니까?');
            if (result) {
               window.location.href = '/board/removeBoard'; // home으로 이동
            }
         });
      });
      
   </script>
   <style>
		#text-container {
			width: 990px;
			height: 700px;
			background-color: #ffffff;
			overflow-y: auto; /* 내용이 넘치면 스크롤바 생성 */
		}
   </style>
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
<!-- 이 안에 각자 페이지 넣으시면 됩니다 -->
	<h1>공지 상세</h1>
	<table class="table">
		<tr>
			<td colspan="2">${boardOne.boardTitle}</td>
		</tr>
		<tr>
			<td>작성자 | ${boardOne.deptName}, ${boardOne.empName} </td>
			<td>수정일 | ${boardOne.updatedate}</td>
		</tr>
		<tr>
			<td colspan="2">
				<script src="${pageContext.request.contextPath}/summernote/summernote-lite.js"></script>
				<script src="${pageContext.request.contextPath}/summernote/lang/summernote-ko-KR.js"></script>
				<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
			   
				<div class="text-container">
			       <textarea id="text-container" name="boardContent" class="summernote" readonly>${boardOne.boardContent}</textarea>
			    </div>
		    </td>
		</tr>
		<!-- 파일 미리보기 및 다운로드 -->
	    <c:forEach var="s" items="${saveFileName}">
            <tr>
            	<td colspan="2">
            		<span>&#128196;</span>
            		<a href="/file/board/${s.boardSaveFileName}">미리보기</a>
            		<a href="/file/board/${s.boardSaveFileName}" download="${s.boardSaveFileName}">다운로드</a>
            	</td>
            </tr>
	    </c:forEach>
	    <!-- 파일이 존재하지 않을 경우 메세지 표시 -->
	    <c:if test="${empty saveFileName}">
	        <tr>
	            <td colspan="2">파일이 존재하지 않습니다.</td>
            </tr>
        </c:if>
	</table>
	
	<hr>
	
	<a href="/board/boardList" id="list">목록</a>
	<a href="/board/modifyBoard?boardNo=${boardOne.boardNo}" id="modify">수정</a>
	<a href="/board/removeBoard?boardNo=${boardOne.boardNo}" id="remove">삭제</a>



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