<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>sendEmail</title>
<title>Contact Form</title>
	<!-- emailjs 라이브러리 로드 -->
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
    <script type="text/javascript">
        (function() {
            // https://dashboard.emailjs.com/admin/account
            // emailjs 초기화. 서버에서 전달받은 publicKey 사용
            emailjs.init('${publicKey}'); 
        })();
    </script>
    <script>
 		// 페이지 로드 완료 후 실행할 함수 정의
        window.onload = function() { 
        	// 'contact-form' 아이디를 가진 요소의 submit 이벤트 리스너 등록
            document.getElementById('contact-form').addEventListener('submit', function(event) {
            	// 기본 submit 동작 막기
                event.preventDefault();
             	// contact_number 필드에 랜덤 값 할당
                this.contact_number.value = Math.random() * 100000 | 0;
             	// 디버깅을 위한 로그 출력. 서버에서 전달받은 serviceId와 emailTemplateId 출력
                console.log('${serviceId}', '${emailTemplateId}');
                // sendForm에 서비스 id, 이메일 템플릿 id, 랜덤으로 생성된 contact_number 필드값 전달 후 성공유무 출력
                // -> https://dashboard.emailjs.com/admin 에서 확인
                emailjs.sendForm('${serviceId}', '${emailTemplateId}', this) 
                    .then(function() {
                        console.log('SUCCESS!');
                        /* 메일 보내기가 성공한 경우 사원 리스트로 이동 */
                        window.location.href = '${pageContext.request.contextPath}/emp/empList';
                    }, function(error) {
                        console.log('FAILED...', error);
                    });
            });
        }
        
        // document.getElementById("sendMessage").innerHTML = '회원가입:<a href="/goodeeFit/member/addMember"></a> 사원번호: ${empNo}';

    </script>
</head>
<body>
	<!-- 이메일 전달 폼 -->
	<form id="contact-form">
        <input type="hidden" name="contact_number">
        <label>받는사람</label>
        <input type="text" name="to_name"> 
        <label>보내는사람</label>
        <input type="text" name="from_name"> 
        <label>받는사람 Email</label>
        <input type="email" name="to_email">
       <!--  <label>보내는사람 Email</label>
        <input type="email" name="from_email"> -->
        <label>Message</label>
        <textarea id="sendMessage" name="message">사원번호: ${empNo}</textarea>
        <input type="submit" value="Send">
    </form>	
</body>
</html>