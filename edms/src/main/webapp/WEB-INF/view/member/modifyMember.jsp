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
	<title>GoodeeFit Home</title>
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
	
	<!-- 다음 카카오 도로명 주소 API 사용 -->
   <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
   <!--사인을 이미지로 바꾸는 라이브러리 -->
   <script src="https://cdnjs.cloudflare.com/ajax/libs/signature_pad/1.5.3/signature_pad.min.js"></script>
   
   <script>
      // 도로명 주소 찾기 함수
      function sample6_execDaumPostcode() {
         new daum.Postcode({
            oncomplete: function(data) {
               // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
               // 각 주소의 노출 규칙에 따라 주소를 조합한다.
               // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
               var addr = ''; // 주소 변수
               var extraAddr = ''; // 참고항목 변수
      
               // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
               if (data.userSelectedType == 'R') { // 사용자가 도로명 주소를 선택했을 경우
                  addr = data.roadAddress;
               } else { // 사용자가 지번 주소를 선택했을 경우(J)
                  addr = data.jibunAddress;
               }
      
               // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
               if (data.userSelectedType == 'R') {
                  // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                  // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                  if (data.bname != '' && /[동|로|가]$/g.test(data.bname)) {
                     extraAddr += data.bname;
                  }
                  // 건물명이 있고, 공동주택일 경우 추가한다.
                  if (data.buildingName != '' && data.apartment == 'Y') {
                     extraAddr += (extraAddr != '' ? ', ' + data.buildingName : data.buildingName);
                  }
                  // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                  if (extraAddr != '') {
                     extraAddr = ' (' + extraAddr + ')';
                  }
                  // 조합된 참고항목을 해당 필드에 넣는다.
                  $('#sample6_extraAddress').val(extraAddr);
               } else {
                  $('#sample6_extraAddress').val('');
               }
      
               // 우편번호와 주소 정보를 해당 필드에 넣는다.
               $('#sample6_postcode').val(data.zonecode);
               $('#sample6_address').val(addr);
               // 커서를 상세주소 필드로 이동한다.
               $('#sample6_detailAddress').focus();
            }
         }).open();
      }
      
      // 페이지 로드
      $(document).ready(function() {
      // 1. 폼 저장 버튼 클릭시
         $('#saveBtn').click(function(event) {
             // 1) 주소값 가져오기
            let postcode = $('#sample6_postcode').val(); // 우편번호
            let address = $('#sample6_address').val(); // 주소
            let detailAddress = $('#sample6_detailAddress').val(); // 상세주소
            // 한줄의 주소로 합치기
            let fullAddress = postcode + ' ' + address + ' ' + detailAddress;
            console.log('주소 : ' + fullAddress);
            // hidden input에 주소값 저장
            $('#address').val(fullAddress);
         });
         
      // 2. 폼 취소 버튼 클릭 시
         $('#cancelBtn').click(function() {
            let result = confirm('Home으로 이동하시겠습니까?'); // 사용자 선택 값에 따라 true or false 반환
            if (result) {
               window.location.href = '/home'; // 로그인 페이지로 이동
            }
         });
      
         // 점 하나, 하나를 변환하여 배열에 저장
         let goal = $('#goal')[0]; // 첫번째 배열값을 가져와서 goal 변수에 저장
         // SignaturePad 생성자
         let sign = new SignaturePad(goal, {minWidth:2, maxWidth:2, penColor:'rgb(0, 0, 0)'});
      
      // 3. [서명 모달] 서명 입력 및 수정
      
         // 3-1. 저장 버튼 클릭 시
         $('#save').click(function() {
            if(sign.isEmpty()) {
               alert("서명이 필요합니다.");
            } else {
               let data = sign.toDataURL("image/png"); // url 가져오기
               $('#target').attr('src', data); // data값을 src 값으로 채우기
            }
         });
      
         // 3-2. 삭제 버튼 클릭 시
         $('#clear').on("click", function() {
            sign.clear(); // 패드의 내용을 모두 삭제
         });
         
         // 3-3. 수정 버튼 클릭 시(제출)
         $('#send').click(function(){
            console.log("서명 send 버튼 클릭");
            if (sign.isEmpty()) {
               alert("서명 내용이 없습니다.");
            } else {
               console.log("send 전송");
               $.ajax({ // Ajax를 사용해 데이터 가져오기
                  url : '/member/uploadSign',
                  data : {sign : sign.toDataURL('image/png', 1.0)},
                  type : 'POST',
                  success : function(jsonData){ // 서버로부터 받은 응답 데이터 jsonData
                     console.log("서명 업로드 성공 jsonData : " + jsonData);
                     alert('서명이 수정되었습니다.');
                     window.location.href = '/member/modifyMember?result=success'; // 이미지 전송 성공 후 페이지 리로드
                  }
               });
            }   
         });
      
         // 3-4. 닫기 버튼 클릭 시
           $('#signModal').on('hide.bs.modal', function () { // 모달창이 사라질 때
               sign.clear(); // 서명 초기화
           });
         
      // 4. 파라미터 값에 따른 알림
         var urlParams = new URLSearchParams(window.location.search);
         var message = urlParams.get('file');
         
         if ( message === 'Success_Insert_Image' ) {
            console.log("이미지 업로드 성공");
              alert('이미지 업로드 성공');
          } else if ( message === 'Fail_Insert_Image' ) {
             console.log("이미지 업로드 실패");
             alert('이미지 업로드 실패');
          }
      
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
<!-- 이 안에 각자 페이지 넣으시면 됩니다 -->

	<!--
        탭 네비게이션
         1. 개인정보 수정
         2. 비밀번호 수정
         3. 휴가정보
    -->
	<div class="d-flex justify-content-between">
		<ul class="nav nav-tabs">
		    <li class="nav-item">
                <a class="nav-link active" href="/member/modifyMember?result=success">개인정보 수정</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/member/modifyMemberPw">비밀번호 수정</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/member/memberVacationHistory">휴가정보</a>
            </li>
        </ul>
    </div>
	<br>
<!-- 개인정보 수정 폼 -->
	<!-- 사진 수정-->
	<h1 style="text-align:center;">개인정보 수정</h1>
	<br>
    <table>
    	<tr>
    		<td><label>사진</label></td><!-- 사진 클릭 시 모달로 이미지 출력 -->
    		<td>
    			<img src="${image.memberPath}${image.memberSaveFileName}" width="200" height="200"
					data-bs-toggle="modal" data-bs-target="#imageModal" class="hover">
			</td>
    	</tr>
    	<tr><td>&nbsp;</td></tr>
    	<!-- 조회할 정보 -->
    	<tr>
    		<td><label>사원번호&nbsp;</label></td>
    		<td><input type="text" value="${empNo}" readonly class="form-control"></td>
    	</tr>
    	<tr><td>&nbsp;</td></tr>
    	<tr>	
    		<td><label>사원명</label></td>
    		<td><input type="text" value="${empName}" readonly class="form-control"></td>
    	</tr>
    	<tr><td>&nbsp;</td></tr>
    	<tr>	
    		<td><label>성별</label></td>
    		<td><input type="text" value="${member.gender}" readonly class="form-control"></td>
    	</tr>
    	<tr><td>&nbsp;</td></tr>
    	<!-- 서명 수정 -->
    	<tr>
    		<td><label>서명</label></td>
    		<td><span data-bs-toggle="modal" data-bs-target="#signModal" class="hover">미리보기</span></td>
    	</tr>
    	<tr><td>&nbsp;</td></tr>
    </table>

	<form action="/member/modifyMember" method="post">
		<input type="hidden" name="empNo" value="${empNo}">
		<table >
		<!-- 수정할 정보 -->
		<tr>
			<td><label for="phoneNumber">전화번호</label></td>
			<td><input type="text" id="phoneNumber" name="phoneNumber" class="form-control" value="${member.phoneNumber}"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><label for="email">이메일</label></td>
			<td><input type="email" id="email" name="email" class="form-control" value="${member.email}"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	    <tr><!-- 기존 주소 표시 -->
	    	<td><label for="existingAddress">주소</label></td>
	    	<td><textarea id="existingAddress" name="existingAddress" class="form-control" readonly>${member.address}</textarea></td>
	    </tr>
	    <tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2">
				<!-- 새 주소 입력 -->
			    <input type="text" id="sample6_postcode" placeholder="우편번호">
			    <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
			    <input type="text" id="sample6_address" placeholder="주소"><br>
			    <input type="text" id="sample6_detailAddress" placeholder="상세주소">
			    <input type="text" id="sample6_extraAddress" placeholder="참고항목">
			    <input type="hidden" name="address" id="address">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><label for="createdate">가입일</label></td>
			<td><input type="text" id="createdate" name="createdate" class="form-control" value="${member.createdate}" readonly></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><label for="updatedate">최종 수정일</label></td>
			<td><input type="text" id="updatedate" name="updatedate" class="form-control" value="${member.updatedate}" readonly></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		</table>
		<hr>
		<div style="display: flex; justify-content: space-between;">
			<button type="button" class="btn btn-secondary" id="cancelBtn" style="text-align:left;">취소</button>
			<button type="submit" class="btn btn-primary" id="saveBtn" style="text-align:right;">저장</button>
		</div>
	</form>
        
	<!-- [시작] 이미지 모달 -->
	<div class="modal" id="imageModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- 모달 헤더 -->
				<div class="modal-header">
					<h4 class="modal-title">사진</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
				</div>
				<!-- 모달 본문 -->
				<c:choose>
					<c:when test="${empty image.memberPath}">
						<p>이미지가 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <img src="${image.memberPath}${image.memberSaveFileName}">
                    </c:otherwise>
                </c:choose>
                <!-- 모달 푸터 -->
               <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                     <form action="/member/uploadImage" method="post" enctype="multipart/form-data">
                         <input type="hidden" name="empNo" value="${empNo}">
                         <input type="file" name="multipartFile">
                         <c:choose>
                            <c:when test="${empty image.memberSaveFileName}">
                               <button type="submit" class="btn btn-primary">입력</button>
                            </c:when>
                            <c:otherwise>
                               <button type="submit" class="btn btn-primary">수정</button>
                            </c:otherwise>
                         </c:choose>
                     </form>
               </div>
            </div>
         </div>
      </div>
	<!-- [끝] 이미지 모달 -->
      
	<!-- [시작] 서명 모달 -->
	<div class="modal" id="signModal">
	   <div class="modal-dialog">
	      <div class="modal-content">
	         <!-- 모달 헤더 -->
	         <div class="modal-header">
	            <h4 class="modal-title">사원 서명</h4>
	            <button type="button" class="btn-close" data-bs-dismiss="modal"></button> <!-- x버튼 -->
	         </div>
	         <!-- 모달 본문 -->
	         <div class="modal-body">
	            <c:choose>
	                 <c:when test="${empty sign.memberPath}">
	                     <p>이미지가 없습니다.</p>
	                     <canvas id="goal" style="border: 1px solid black" width="200" height="200"></canvas>
	                     <div>
	                     <button id="save">임시저장</button>
	                     <button id="clear">삭제</button>
	                     <button id="send">저장</button>
	                  </div>
	                  <div>
	                     <img id="target" src = "" width=200, height=200>
	                  </div>
	                 </c:when>
	                 <c:otherwise>
	                     <img src="${sign.memberPath}${sign.memberSaveFileName}">
	                     <br>
	                     <canvas id="goal" style="border: 1px solid black" width="200" height="200"></canvas>
	                     <div>
	                     <button id="save">임시저장</button>
	                     <button id="clear">삭제</button>
	                     <button id="send">저장</button>
	                  </div>
	                  <div>
	                     <img id="target" src = "" width=200, height=200>
	                  </div>
	                  </c:otherwise>
	               </c:choose>
	         </div>
	         <!-- 모달 푸터 -->
	         <div class="modal-footer">
	            <button type="button" class="btn btn-secondary" id="signModal" data-bs-dismiss="modal">닫기</button>
	         </div>
	      </div>
	   </div>
	</div>
	<!-- [끝] 서명 모달 -->


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