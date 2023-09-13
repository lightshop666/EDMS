<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<link rel="icon" type="image/png" sizes="16x16" href="../assets/images/favicon.png">
	<title>GoodeeFit 사원등록</title>
	<!-- Custom CSS -->
	<link href="../assets/extra-libs/c3/c3.min.css" rel="stylesheet">
	<link href="../assets/libs/chartist/dist/chartist.min.css" rel="stylesheet">
	<link href="../assets/extra-libs/jvector/jquery-jvectormap-2.0.2.css" rel="stylesheet" />
	<!-- Custom CSS -->
	<link href="../dist/css/style.min.css" rel="stylesheet">
	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->
	<!-- ============================================================== -->
	<!-- All Jquery -->
	<!-- ============================================================== -->
	<script src="../assets/libs/jquery/dist/jquery.min.js"></script>
	<script src="../assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
	<!-- apps -->
	<!-- apps -->
	<script src="../dist/js/app-style-switcher.js"></script>
	<script src="../dist/js/feather.min.js"></script>
	<script src="../assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
	<script src="../dist/js/sidebarmenu.js"></script>
	<!--Custom JavaScript -->
	<script src="../dist/js/custom.min.js"></script>
	<!--This page JavaScript -->
	<script src="../assets/extra-libs/c3/d3.min.js"></script>
	<script src="../assets/extra-libs/c3/c3.min.js"></script>
	<script src="../assets/libs/chartist/dist/chartist.min.js"></script>
	<script src="../assets/libs/chartist-plugin-tooltips/dist/chartist-plugin-tooltip.min.js"></script>
	<script src="../assets/extra-libs/jvector/jquery-jvectormap-2.0.2.min.js"></script>
	<script src="../assets/extra-libs/jvector/jquery-jvectormap-world-mill-en.js"></script>
	<script src="../dist/js/pages/dashboards/dashboard1.min.js"></script>
	
	<!-- xls 형식을 파싱하기 위해 SheetJS 라이브러리의 xls 모듈을 사용 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.9/xlsx.full.min.js"></script>
	<script>
		$(document).ready(function() { // 웹 페이지가 모든 html 요소를 로드한 후에 내부(JQuery)의 코드를 실행하도록 보장
			
			// 부서명 선택에 따라 팀명 드롭다운 옵션을 업데이트하는 함수
            function updateTeamOptions() {
                var selectedDept = $('select[name="deptName"]').val();
                var teamSelect = $('select[name="teamName"]');
                var empPositionSelect = $('select[name="empPosition"]');
                teamSelect.find('option').remove(); // 기존 옵션 지우기
                if (selectedDept === "사업추진본부") {
                	// 부서명이 "사업추진본부"인 경우, 기획팀만 표시
                    teamSelect.append('<option value="기획팀">기획팀</option>');
                } else if (selectedDept === "경영지원본부") {
                	// 부서명이 "경영지원본부"인 경우, 경영팀만 표시
                    teamSelect.append('<option value="경영팀">경영팀</option>');
                } else if (selectedDept === "영업지원본부") {
                	// 부서명이 "영업지원본부"인 경우, 영업팀만 표시
                    teamSelect.append('<option value="영업팀">영업팀</option>');
                } else {
                	// 부서명이 선택되지 않았거나 일치하는 부서가 없는 경우 기본 옵션 표시
                    teamSelect.append('<option value="">없음</option>');
                }
            }


         	// 초기 선택에 기반하여 팀명 옵션을 업데이트하는 초기 호출
            updateTeamOptions();

         	// 직급에 따라 권한 드롭다운 옵션을 업데이트하는 함수
            function updateAccessLevelOptions() {
                var selectedPosition = $('select[name="empPosition"]').val();
                var accessSelect = $('select[name="accessLevel"]');
                accessSelect.find('option').remove(); // 기존 옵션 지우기
                if (selectedPosition === "CEO") {
                	// 직급이 "CEO"인 경우, 3레벨만 표시
                    accessSelect.append('<option value="3">3레벨</option>');
                } else if (selectedPosition === "부서장") {
                	// 직급이 "부서장"인 경우, 3레벨만 표시
                    accessSelect.append('<option value="3">3레벨</option>');
                } else if (selectedPosition === "팀장") {
                	// 직급이 "팀장"인 경우, 2레벨만 표시
                    accessSelect.append('<option value="2">2레벨</option>');
                } else if (selectedPosition === "부팀장") {
                	// 직급이 "부팀장"인 경우, 1레벨만 표시
                    accessSelect.append('<option value="1">1레벨</option>');
                } else if (selectedPosition === "사원") {
                	// 직급이 "사원"인 경우, 0레벨만 표시
                    accessSelect.append('<option value="0">0레벨</option>');
                } else {
                	// 직급이 선택되지 않았거나 일치하는 직급이 없는 경우 기본 옵션 표시
                    accessSelect.append('<option value="">권한 선택</option>');
                }
            }

         	// 초기 선택에 기반하여 권한 옵션을 업데이트하는 초기 호출
            updateAccessLevelOptions();

         	// 선택 사항이 변경될 때 옵션을 업데이트하기 위한 이벤트 리스너
            $('select[name="deptName"]').change(updateTeamOptions);
            $('select[name="empPosition"]').change(updateAccessLevelOptions);

        	// 취소 버튼 클릭 이벤트
            $('#cancelBtn').click(function() {
                let result = confirm('HOME으로 이동할까요?');
                if (result) {
                    window.location.href = '/home';
                }
            });
        	
        	
			//사원번호 생성
			$("#empNoMaker").click(function(){
				$.ajax({
					type: "POST",
					url: "/generateEmpNo",
					success: function(data) {
						$("input[name='empNo']").val(data.newEmpNo);  // 응답으로 받은 새로운 사원번호를 input 필드에 설정
					},
					error: function(error) {
						console.error("사원번호 생성 실패: ", error);
					}
				});
			});
        	
        	
		});
	</script>
<style>
	/* 구분선 */
	hr {
	    border: solid 3px black;
	    width: 100%;
	    margin: 0; /* auto 가운데 정렬 */
	}
	/* 테이블 중앙 정렬 */
	table {
		text-align: center;
	}
	/* body 중앙 정렬 */
	body {
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
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
<div class="container">
	<h1 class="text-center">사원 등록</h1>
	<br>
	<!-- 사원 정보 등록 -->
	<form action="${pageContext.request.contextPath}/emp/registEmp" method="post"><!-- 성공 시 사원목록 페이지로 -->
		<!-- 재직과, 남은휴가일수는 고정되어있으므로 hidden 타입으로 제출 -->
		<input type="hidden" name="empState" value="재직">
		
		<table class="table">
			<tr>
				<td>사원번호</td>
				<td><input type="number" class="form-control" name="empNo" value="${empNo}"></td><!-- 직접 입력 / 사원번호 랜덤 생성 후 자동 입력 -->
				<td><button type="button" class="btn btn-primary" id="empNoMaker">사원번호 생성</button></td>
			</tr>
			<tr>
				<td>사원명</td>
				<td colspan="2"><input type="text" class="form-control" name="empName"></td>
			</tr>
			<tr>
				<td>부서명</td>
				<td colspan="2">
					<select class="form-control" name="deptName">
						<option value="" <c:if test="${emp.deptName.equals('')}">selected</c:if>>없음</option>
						<c:forEach var="d" items="${deptList}">
							<option value="${d.deptName}" <c:if test="${emp.deptName.equals(d.deptName)}">selected</c:if>>${d.deptName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td>팀명</td>
				<td colspan="2">
					<select class="form-control" name="teamName">
						<option value="" <c:if test="${emp.teamName.equals('')}">selected</c:if>>없음</option>
						<c:forEach var="t" items="${teamList}">
							<option value="${t.teamName}" <c:if test="${emp.teamName.equals(t.teamName)}">selected</c:if>>${t.teamName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
			    <td>직급</td>
			    <td colspan="2">
			        <select class="form-control" name="empPosition">
						<option value="CEO" <c:if test="${emp.empPosition.equals('CEO')}">selected</c:if>>CEO</option>
						<option value="부서장" <c:if test="${emp.empPosition.equals('부서장')}">selected</c:if>>부서장</option>
						<option value="팀장" <c:if test="${emp.empPosition.equals('팀장')}">selected</c:if>>팀장</option>
						<option value="부팀장" <c:if test="${emp.empPosition.equals('부팀장')}">selected</c:if>>부팀장</option>
						<option value="사원" <c:if test="${emp.empPosition.equals('사원')}">selected</c:if>>사원</option>
					</select>
			    </td>
			</tr>
			<tr>
			    <td>권한</td>
			    <td colspan="2">
			        <select class="form-control" name="accessLevel">
						<option value="0" <c:if test="${emp.accessLevel.equals('0')}">selected</c:if>>0레벨</option>
						<option value="1" <c:if test="${emp.accessLevel.equals('1')}">selected</c:if>>1레벨</option>
						<option value="2" <c:if test="${emp.accessLevel.equals('2')}">selected</c:if>>2레벨</option>
						<option value="3" <c:if test="${emp.accessLevel.equals('3')}">selected</c:if>>3레벨</option>
					</select>
			    </td>
			</tr>
			<tr>
				<td>입사일</td>
				<td colspan="2">
					<input type="date" class="form-control" name="employDate">
				</td>
			</tr>
		</table>
		
		<br>
		<hr><!-- 구분선 -->
		<br>
		 <div class="d-flex justify-content-between">
             <button type="button" class="btn btn-secondary" id="cancelBtn">취소</button>
             <button type="submit" class="btn btn-success" id="saveBtn">등록</button>
         </div>
	</form>
</div>	
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