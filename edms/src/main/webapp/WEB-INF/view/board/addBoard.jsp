<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <title>addBoard</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
	<!-- jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	
	<!-- summernote 연결 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	
	<!-- 서머노트를 위해 추가해야할 부분 -->
	<script src="${pageContext.request.contextPath}/summernote/summernote-lite.js"></script>
	<script src="${pageContext.request.contextPath}/summernote/lang/summernote-ko-KR.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/summernote/summernote-lite.css">
  
	<script>
		$(document).ready(function() {
			
			// 1. summernote editor
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
						    ['insert',['picture','link','video']],
						    // 코드보기, 확대해서보기, 도움말
						    ['view', ['codeview','fullscreen', 'help']]
						  ],
				  	// 추가한 글꼴
					fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋음체','바탕체'],
					// 추가한 폰트사이즈
					fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
				    focus : true,
				    callbacks: {	// 에디터에 이미지를 끼웠을때 그 이미지에 대한 파일을 넘겨주는 역할
						onImageUpload : function(files) {
							uploadSummernoteImageFile(files[0],this);
						},
						onPaste: function (e) {
							var clipboardData = e.originalEvent.clipboardData;
							if (clipboardData && clipboardData.items && clipboardData.items.length) {
								var item = clipboardData.items[0];
								if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
									e.preventDefault();
								}
							}
						}
					}
				});
			
			// 2. 이미지 업로드 감지 후 controller 호출
			function uploadSummernoteImageFile(file, editor) {
		  		// 파일을 담을수 있는 형 생성
				data = new FormData();
		  		data.append("file", file);
		  		$.ajax({
		  			data : data,
		  		  dataType: 'json',
		  			type : "POST",
		  			url : "/uploadSummernoteImageFile",
		  			contentType : false,
		  			processData : false,
		  			success : function(data) {
		  				// 1. 서버에서 받은 값을 변수에 할당
		  	            var boardFileNo = data.boardFileNo;
		  	            var savePath = data.savePath;
		  	            
		  				// 2. boardFileNo 값을 가져와서 hidden input 필드를 생성
						var input = $('<input>').attr({
							type: 'hidden',
							name: 'boardFileNo[]',
							value: data.boardFileNo // 백엔드에서 반환된 boardFileNo
						}).appendTo('form'); // form 태그에 추가
						
						// 3. image 값을 가져와서 hidden input 필드를 생성
							// 이미지 태그를 생성
				            var imgTag = '<img src="' + savePath + '" data-boardFileNo="' + boardFileNo + '">';
	
				            // 에디터의 컨텐츠에 이미지 태그를 추가
				            $(editor).summernote('pasteHTML', imgTag);
	
				            // 이미지 태그가 삽입된 컨텐츠 가져오기
				            var updatedContent = $(editor).summernote('code');
	
				            // 가져온 컨텐츠를 숨겨진 input 필드에 설정
				            $('#boardContent').val(updatedContent);
		  				}
		  		});
		  	}
			
			// 3. 이미지 삭제 감지 후 controller 호출
			$(".summernote").on("summernote.media.delete", function(we, target, editor) {
			    // target에서 필요한 정보를 추출 (예를 들어, 파일 아이디)
			    var boardFileNo = $(target).data("boardFileNo");
			    
			    // 서버에 삭제 요청
			    $.ajax({
			        url: "/removeSummernoteImageFile", // 백엔드에서 파일을 삭제하는 URL
			        type: "POST",
			        data: { "boardFileNo": boardFileNo }, // 필요한 데이터
			        success: function(response) {
			            // 서버에서 파일 삭제가 성공하면 이곳에서 처리
			            if(response.status === 'success') {
			                console.log( boardFileNo + "파일 삭제 완료");
			            }
			        },
			        error: function(e) {
			            console.log(e);
			        }
			    });
			});
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
			   let result = confirm('HOME으로 이동할까요?');
			   if (result) {
			      window.location.href = '/home'; // home으로 이동
			   }
			});
		});
		
	</script>
</head>
<body>
<h1>공지글 추가</h1>
<form method="POST" id="addBoardFileNo" action="/board/addBoard" enctype="multipart/form-data">
	<input type="hidden" name="empNo" value="${empNo}">
	<table>
		<tr>
			<td>작성자</td>
			<td><input type="text" name="empName" value="${empName}" readonly></td>
			<td>부서명</td>
			<td><input type="text" name="deptName" value="${deptName}" readonly></td>
		</tr>
		<tr>
			<td>카테고리</td>
			<td colspan="3"><input type="text" name="boardCategory"></td>
		</tr>
		<tr>
			<td>제목</td>
			<td colspan="3"><input type="text" name="boardTitle"></td>
		</tr>
		<tr>
		    <td>중요공지 여부</td>
		    <td colspan="4">
		        <label><input type="radio" name="topExposure" value="Y"> 중요</label>
		        <label><input type="radio" name="topExposure" value="N"> 일반</label>
		    </td>
		</tr>

	</table>
	<br>
	<div class="container">
    	<textarea id="summernote" name="boardContent" class="summernote"></textarea>
    </div>
    <hr>
    <div class="buttons">
	    <button type="button" id="cancelBtn">취소</button>
	    <button type="submit" id="saveBtn">저장</button>
	</div>
</form>
</body>
</html>