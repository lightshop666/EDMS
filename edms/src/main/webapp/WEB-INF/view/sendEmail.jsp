<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>sendEmail</title>
<title>Contact Form</title>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
    <script type="text/javascript">
        (function() {
            // https://dashboard.emailjs.com/admin/account
            emailjs.init('Wf0oiGKE5P8dzKYRf'); // 인증받은 공용키 설정
        })();
    </script>
    <script>
        window.onload = function() {
            document.getElementById('contact-form').addEventListener('submit', function(event) {
                event.preventDefault();
                // generate a five digit number for the contact_number variable
                this.contact_number.value = Math.random() * 100000 | 0;
                // these IDs from the previous steps
                emailjs.sendForm('service_9mlnvcs', 'template_a7ooggg', this) // 서비스 id, 이메일 템플릿 id -> https://dashboard.emailjs.com/admin 에서 확인
                    .then(function() {
                        console.log('SUCCESS!');
                    }, function(error) {
                        console.log('FAILED...', error);
                    });
            });
        }
        
        // document.getElementById("sendMessage").innerHTML = '회원가입:<a href="/goodeeFit/member/addMember"></a> 사원번호: ${empNo}';

    </script>
</head>
<body>
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