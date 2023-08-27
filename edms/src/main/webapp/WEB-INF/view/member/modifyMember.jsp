<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyMember</title>
	<!-- jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- 모달을 띄우기 위한 부트스트랩 라이브러리 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <!-- 비밀번호 확인 모달 -->
    <div class="modal fade" id="passwordModal" tabindex="-1" aria-labelledby="passwordModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="passwordModalLabel">비밀번호 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- 비밀번호 입력 폼 -->
                    <form>
                        <div class="mb-3">
                            <label for="passwordInput" class="form-label">비밀번호를 입력하세요:</label>
                            <input type="password" class="form-control" id="passwordInput" name="passwordInput">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary">확인</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 내 프로필 수정과 비밀번호 수정 탭 -->
    <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
            <a class="nav-link active" id="profile-tab" data-bs-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="true">내 프로필 수정</a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="password-tab" data-bs-toggle="tab" href="#password" role="tab" aria-controls="password" aria-selected="false">비밀번호 수정</a>
        </li>
    </ul>
	
    <!-- 탭 내용 -->
    <div class="tab-content" id="myTabContent">
        <div class="tab-pane fade show active" id="profile" role="tabpanel" aria-labelledby="profile-tab">
            <!-- 내 프로필 수정 내용 -->
            <img src="${memberFile.member_ori_file_name}" alt="프로필 사진">
            <p>사원번호: ${member.emp_no}</p>
            <p>사원명: ${member.emp_name}</p>
            <img src="${memberFile.member_ori_signature}" alt="서명 사진">
            <form>
                <label>성별:</label>
			    <input type="radio" id="male" name="gender" value="M" <c:if test="${gender == 'male'}">checked</c:if>>
			    <label for="male">남성</label>
			    
			    <input type="radio" id="female" name="gender" value="F" <c:if test="${gender == 'female'}">checked</c:if>>
			    <label for="female">여성</label>
			    <br>
                <label for="email">이메일:</label>
                <input type="email" id="email" name="email" value="${email}"><br>
                <label for="address">주소:</label>
                <input type="text" id="address" name="address" value="${address}"><br>
                <hr>
                <button type="button" class="btn btn-secondary">취소</button>
                <button type="button" class="btn btn-primary">저장</button>
            </form>
        </div>
        <div class="tab-pane fade" id="password" role="tabpanel" aria-labelledby="password-tab">
            <!-- 비밀번호 수정 내용 -->
            <form>
                <label for="currentPassword">현재 비밀번호:</label>
                <input type="password" id="currentPassword" name="pw"><br>
                <label for="newPassword">새 비밀번호:</label>
                <input type="password" id="newPassword" name="newPw"><br>
                <label for="confirmNewPassword">새 비밀번호 확인:</label>
                <input type="password" id="confirmNewPassword" name="newPw2"><br>
                <div id="passwordMatchMessage" class="text-success"></div>
                <hr>
                <button type="button" class="btn btn-secondary">취소</button>
                <button type="button" class="btn btn-primary">저장</button>
            </form>
        </div>
    </div>
</body>
</html>