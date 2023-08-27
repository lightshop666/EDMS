<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Hello WS</title>
	<link href="/webjars/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="/webjars/jquery/jquery.min.js"></script>
	<script src="/webjars/sockjs-client/sockjs.min.js"></script>
	<script src="/webjars/stomp-websocket/stomp.min.js"></script>
	<script src="/WebsocketScripts.js"></script>
	
<script>
$(document).ready(function() {
	//웹 소켓 연결 함수 호출
	connect();
	console.log("웹소켓 연결 완료");
	
	//전송 버튼 클릭 시 메시지 전송 함수 호출
	$("#send").click(function() {
		sendMessage();
	});
	
	//'프라이빗 전송' 클릭 시 개인 메시지 전송 함수
	$("#sendPrivate").click(function() {
		sendPrivateMessage();
	});
	
	//'알림' 영역 클릭시 알림 횟수 초기화 함수 호출
	$("#notifications").click(function() {
		resetNotificationCount();
	});
});
</script>
</head>
<body>
<div class="container" style="margin-top: 50px">
	<div class="row">
	    <div class="col-md-12">
	        <form class="form-inline">
	            <div class="form-group">
	                <label for="message">Message</label>
	                <input type="text" id="message" class="form-control" placeholder="Enter your message here...">
	            </div>
	            <button id="send" class="btn btn-default" type="button">Send</button>
	        </form>
	    </div>
	</div>
	<div class="row" style="margin-top: 10px">
	    <div class="col-md-12">
	        <form class="form-inline">
	            <div class="form-group">
	                <label for="privateMessage">Private Message</label>
	                <input type="text" id="privateMessage" class="form-control" placeholder="Enter your message here...">
	            </div>
	            <button id="sendPrivate" class="btn btn-default" type="button">Send Private Message</button>
	        </form>
	    </div>
	</div>
	<div class="row">
	    <div class="col-md-12">
	        <table id="messageHistory" class="table table-striped">
	            <thead>
	            <tr>
	                <th>Messages
						<span
							id="notifications"
							style="
							color: white;
							background-color: red;
							padding-left: 15px;
							padding-right: 15px;">
						</span>
	              </th>
	          </tr>
	          </thead>
	<!--메시지 출력부분 -->
	            <tbody id="messages">
	            </tbody>
	        </table>
	    </div>
	</div>
</div>
</body>
</html>
