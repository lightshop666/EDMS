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
	<title>goodeeFit 공지 수정</title>
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
				['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
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
        
/* 2. 파일 관련 */
	
  	// 2-1. 파일 삭제
	$(document).on('click', '.removeFile', function() {
		console.log('삭제 버튼 실행');
		let parentDiv = $(this).parent();
		let boardFileNo = $('#exsistingFile').val(); // 삭제할 파일의 boardFileNo를 가져옴
		let intBoardFileNo = parseInt(boardFileNo, 10); // 문자열을 정수로 변환
		console.log(intBoardFileNo);
 		
		// 확인 메시지 표시
		let confirmDelete = confirm("한번 삭제한 파일은 다시 불러올 수 없습니다. 정말 삭제하시겠습니까?");
 			// 삭제 확인을 누르고
		if (confirmDelete) {
		        // AJAX 요청으로 파일 삭제 서버 API 호출
		        $.ajax({
		            url: '/removeBoardFile', // 서버 API 엔드포인트
		            type: 'POST',
		            data: { boardFileNo: intBoardFileNo }, // 삭제할 파일의 boardFileNo를 전송
		            success: function(response) {
		                // 서버에서 파일 삭제가 성공하면, 해당 파일 입력란을 제거
		                parentDiv.remove();
		                if(response == 'fail'){
		                	alert('파일 삭제에 실패했습니다.');
		                	location.reload();
		                } else if(response == 'success'){
		                	alert('기존 파일이 삭제되었습니다.');
		                	location.reload();
		                }
		                
		            },
		            error: function(error) {
		                console.error('파일 삭제 오류:', error);
		                alert('파일 삭제 중 오류가 발생했습니다.');
		            }
		        });
		    } else {
				return false;
			}
		});
		
		// 파일 선택 입력 필드를 3개로 제한
		$(document).on('change', 'input[name="multipartFile"]', function() {
			// 선택한 파일의 개수가 3개를 초과한 경우
		    if ($(this)[0].files.length > 3) {
				alert('최대 3개의 파일만 선택할 수 있습니다.');
		        // 선택한 파일을 초기화
		        $(this).val('');
		    } else {
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
		
/* 3. view */
		// 3-1. modifyBoard.jsp 파라미터 값 알림메세지
		const urlParams = new URLSearchParams(window.location.search); // 서버에서 전송한 결과 값 처리
		const resultParam = urlParams.get('result'); // '?' 제외한 url에서 파라미터 추출
		if (resultParam === '') {
			alert(''); // 알림
			$('#msg').text('').css('color', 'red'); // 빨간색 오류 메세지
		}
		
		// 3-2. modifyBoard.jsp 취소 버튼 클릭 시
        $('#cancelBtn').click(function() {
           let result = confirm('공지 상세로 이동할까요?');
           if (result) {
        	   // a 태그 클릭
        	   document.querySelector('a.cancelLink').click();
           }
        });
		
		// 3-3. 내용만 수정시
        $(document).ready(function() {
            // 저장 버튼 클릭 시 폼 제출
            $("#saveBtn").click(function() {
                // 폼을 선택하고 제출
                $("#modifyForm").submit();
            });
        });
	});
      
   </script>
   <style>
		.center{
			text-align:center;
		}
		.right {
		    text-align: right;
		}
		.left {
		    text-align: left;
		}
		#inline {
		    display: inline;
		    margin-right: 10px; /* 원하는 간격 값으로 조정 */
		}
		#diveder-bottom {
		    border-bottom: 6px solid rgba(0, 0, 0, 0.3) !important; /* 굵은 선 */
		    margin-top: 10px; /* 원하는 간격 값으로 조정 */
		    margin-bottom: 10px; /* 원하는 간격 값으로 조정 */
		}
		#diveder-top {
		    border-top: 6px solid rgba(0, 0, 0, 0.3) !important; /* 굵은 선 */
		    margin-top: 10px; /* 원하는 간격 값으로 조정 */
		    margin-bottom: 10px; /* 원하는 간격 값으로 조정 */
		}
		.buttons {
			display: flex; /* 컨테이너 내 요소를 가로로 배치 */
			justify-content: space-between; /* 요소 사이의 공간을 최대한 확보하여 왼쪽과 오른쪽으로 정렬 */
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

	<h2 class="center">공지글 수정</h2>
	
	<br>
	
	<form method="POST" action="/board/modifyBoard" id="modifyForm" enctype="multipart/form-data">
		<input type="hidden" name="empNo" value="${boardOne.empNo}">
		<input type="hidden" name="boardNo" id="boardNo" value="${boardOne.boardNo}">
		<table class="table">
			<tr>
				<td class="center table-active black">작성자</td>
				<td><input type="text" class="form-control" value="${boardOne.empName}" readonly></td>
				<td class="center table-active black">부서명</td>
				<td><input type="text" class="form-control" value="${boardOne.deptName}" readonly></td>
			</tr>
			<tr>
				<td class="center table-active black">카테고리</td>
				<td colspan="3">
					<select name="boardCategory" class="form-control">
						<option value="전사공지" <c:if test="${boardOne.boardCategory.equals('전사공지')}">selected</c:if>>전사공지</option>
						<option value="사업추진본부" <c:if test="${boardOne.boardCategory.equals('사업추진본부')}">selected</c:if>>사업추진본부</option>
						<option value="경영지원본부" <c:if test="${boardOne.boardCategory.equals('경영지원본부')}">selected</c:if>>경영지원본부</option>
						<option value="영업지원본부" <c:if test="${boardOne.boardCategory.equals('영업지원본부')}">selected</c:if>>영업지원본부</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="center table-active black">제목</td>
				<td colspan="3"><input type="text" class="form-control" name="boardTitle" value="${boardOne.boardTitle}"></td>
			</tr>
			<tr>
				<td class="center table-active black">중요공지 여부</td>
				<td colspan="3">
					<label><input type="radio" name="topExposure" value="Y" <c:if test="${boardOne.topExposure.equals('Y')}">checked</c:if>> 중요</label>
					<label><input type="radio" name="topExposure" value="N" <c:if test="${boardOne.topExposure.equals('N')}">checked</c:if>> 일반</label>
					<span id="msg"></span>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<script src="${pageContext.request.contextPath}/summernote/summernote-lite.js"></script>
					<script src="${pageContext.request.contextPath}/summernote/lang/summernote-ko-KR.js"></script>
					<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
					   
					<div class="container">
						<textarea id="summernote" name="boardContent" class="summernote">${boardOne.boardContent}</textarea>
					</div>
	        	</td>
			</tr>
			<c:if test="${!empty saveFileName}">
				<c:forEach var="s" items="${saveFileName}">
					<tr class="black">
						<td colspan="4">
							<input type="hidden" id="exsistingFile" value="${s.boardFileNo}">
							<span>&#128196; ${s.boardOriFileName} &nbsp;<button type="button" class="removeFile" value="${s.boardOriFileName}">삭제</button></span>
						</td>
					</tr>
				</c:forEach>
				<tr class="black">	
					<td>
						<input type="file" name="multipartFile" multiple>
					</td>
					<td colspan="3">
						<span id="selectedFileNames"></span>
					</td>
				</tr>
			</c:if>
			<!-- 파일이 존재하지 않을 경우 메세지 표시 -->
		    <c:if test="${empty saveFileName}">
		        <tr>
		            <td class="black" colspan="4">파일이 존재하지 않습니다.</td>
	            </tr>
	            <tr id="diveder-bottom">
	            	<td>
					    <input type="file" name="multipartFile" multiple>
	            	</td>
	            	<td colspan="3">
	            		<span id="selectedFileNames"></span>
	            	</td>
	            </tr>
	        </c:if>
	    </table>
	    <div class="buttons">
	       <a href="/board/boardOne?boardNo=${boardOne.boardNo}" class="cancelLink"><button type="button" class="btn btn-light" id="cancelBtn">취소</button></a>
	       <button type="submit" id="saveBtn" class="btn btn-primary">저장</button>
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