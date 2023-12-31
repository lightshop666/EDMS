<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- Tell the browser to be responsive to screen width -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">
	<!-- Favicon icon -->
	<link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon.png">
	<title>goodeeFit 공지 추가</title>
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
	         
		/* 1. summernote editor */
			$('.summernote').summernote({
				// 에디터 높이
				height: 700,
				// 에디터 한글 설정
				lang: "ko-KR",
				// 에디터에 커서 이동 (input창의 autofocus라고 생각하시면 됩니다.)
				focus : true,
				toolbar: [
							// 글꼴 설정
							['fontname', ['fontname']],
							// 글자 크기 설정
							['fontsize', ['fontsize']],
							// 굵기, 기울임꼴, 밑줄,취소 선, 서식지우기
							['style', ['italic', 'underline', 'strikethrough', 'clear']],
							// 글자색
							['color', ['forecolor','color']],
							// 표만들기
							['table', ['table']],
							// 글머리 기호, 번호매기기, 문단정렬
							['para', ['ul', 'ol', 'paragraph']],
							// 줄간격
							['height', ['height']],
							// 그림첨부, 링크만들기, 동영상첨부
							['insert',['link']],
							// 코드보기, 확대해서보기, 도움말
							['view', ['codeview', 'help']]
						],
					// 추가한 글꼴
					fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋음체','바탕체'],
					// 추가한 폰트사이즈
					fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
					focus : true
	            });
		
		/* 파일 관련 */
			// 파일 선택 입력 필드를 3개로 제한
			$(document).on('change', 'input[name="multipartFile"]', function() {
				// 선택한 파일의 개수가 3개를 초과한 경우
			    if ($(this)[0].files.length > 3) {
					alert('최대 3개의 파일만 선택할 수 있습니다.');
			        // 선택한 파일을 초기화
			        $(this).val('');
			    } else if ($(this)[0].files.length > 1){
					// 파일 개수가 3개 이하일 때
				    let fileNames = []; // 선택한 파일 이름을 저장할 배열
			
			        // 선택한 파일들의 이름을 추출하여 배열에 추가
			        for (let i = 0; i < this.files.length; i++) {
			            fileNames.push(this.files[i].name);
			        }
			
			        // 추출한 파일 이름을 화면에 나열
			       	$('#selectedFileNames').text(fileNames.join(', '));
			    }
			});
		
		/* 2. view */
			// 2-1. 저장 버튼 클릭 시
			$('form').on('submit', function(e) {
			    // 제목 검증
			    const title = $("input[name='boardTitle']").val().trim();
			    if (title === '') {
			        alert("제목을 입력해주세요.");
			        e.preventDefault();
			        return false;
			    }
			
			    // 내용 검증 (summernote 내용)
			    const content = $('#summernote').summernote('code').trim();
			    if (content === '') {
			        alert("내용을 입력해주세요.");
			        e.preventDefault();
			        return false;
			    }
			
			    // 중요도 검증
			    const topExposure = $("input[name='topExposure']:checked").val();
			    if (!topExposure) {
			        alert("중요도를 체크해주세요.");
			        $('#msg').text('중요도를 체크해주세요.').css('color', 'red');
			        e.preventDefault();
			        return false;
			    }
			
			    // 여기까지 왔다면 모든 검증을 통과한 것임
			    return true;
			});
			
			// 2-2. 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('목록으로 이동할까요?');
				if (result) {
					window.location.href = '/board/boardList'; // home으로 이동
				}
			});
	         
			// 2-3. 파라미터 값에 따라 알림 메세지
			const urlParams = new URLSearchParams(window.location.search); // 서버에서 전송한 결과 값 처리
			const resultParam = urlParams.get('result'); // '?' 제외한 url에서 파라미터 추출
			    
			if (resultParam === 'fail') { // fail 파라미터 값이 들어올 경우
				// 알림
		  	 	alert('중요 공지는 3개까지 설정 가능합니다.');
		   		// 텍스트 출력
		        $('#msg').text('중요 공지는 3개까지 설정 가능합니다.').css('color', 'red'); // 빨간색 오류 메세지
			} else if (resultParam === 'duplicate'){
				// 알림
		  	 	alert('한 개의 공지에는 최대 3개의 파일만 게시할 수 있습니다.');
			}
			
		});
   </script>
   <style>
	   	#diveder-bottom {
		    border-bottom: 6px solid rgba(0, 0, 0, 0.3) !important; /* 굵은 선 */
		    margin-top: 10px; /* 원하는 간격 값으로 조정 */
		    margin-bottom: 10px; /* 원하는 간격 값으로 조정 */
		}
		.center{
			text-align:center;
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

<h1 style="text-align:center;">공지글 추가</h1>
<br>
<form method="POST" action="/board/addBoard" enctype="multipart/form-data">
   <input type="hidden" name="empNo" value="${empNo}">
	<table class="table">
		<tr>
			<td class="table-active center">작성자</td>
			<td><input type="text" value="${empName}" class="form-control" readonly></td>
			<td class="table-active center">부서명</td>
			<td><input type="text" value="${deptName}" class="form-control" readonly></td>
		</tr>
		<tr>
			<td class="table-active center">카테고리</td>
			<td colspan="3">
			    <select name="boardCategory" id="category" class="form-control">
			        <option value="전사공지">전사공지</option>
			        <option value="사업추진본부">사업추진본부</option>
			        <option value="경영지원본부">경영지원본부</option>
			        <option value="영업지원본부">영업지원본부</option>
			    </select>
			</td>
		</tr>
		<tr>
		   <td class="table-active center">제목</td>
		   <td colspan="3"><input id="title" type="text" name="boardTitle" class="form-control"></td>
		</tr>
		<tr>
			<td class="table-active center">중요공지 여부</td>
			<td colspan="3">
			    <label><input type="radio" name="topExposure" value="Y"> 중요</label>
			    <label><input type="radio" name="topExposure" value="N"> 일반</label>
			    <span id="msg"></span>
			</td>
		</tr>
		<tr>
			<td colspan="4">
				<script src="${pageContext.request.contextPath}/summernote/summernote-lite.js"></script>
				<script src="${pageContext.request.contextPath}/summernote/lang/summernote-ko-KR.js"></script>
				<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
			    
				<div class="container">
			       <textarea id="summernote" name="boardContent" class="summernote"></textarea>
			    </div>
			</td>
		</tr>
		<tr id="diveder-bottom">
			<td>
	      		<input type="file" name="multipartFile" multiple>
			</td>
			<td colspan="3">
				<div id="selectedFileNames"></div>
			</td>
		</tr>
	</table>
	<div style="display: flex; justify-content: space-between;">
       <button type="button" id="cancelBtn" class="btn btn-secondary" style="text-algin:left">취소</button>
       <button type="submit" id="saveBtn" class="btn btn-primary" style="text-align:right">저장</button>
   </div>
</form>
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