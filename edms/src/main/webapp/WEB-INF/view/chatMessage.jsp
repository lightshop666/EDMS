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
	
	
<script type="text/javascript">
var stompClient = null;
var notificationCount = 0;

$(document).ready(function() {
    console.log("채팅창 준비 완료");
    connect();

    $("#send").click(function() {
        sendMessage();
    });

    $("#send-private").click(function() {
        sendPrivateMessage();
    });

    $("#notifications").click(function() {
        resetNotificationCount();
    });
});

function connect() {
    var socket = new SockJS('/our-websocket');
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function (frame) {
        console.log('연결 frame: ' + frame);
        updateNotificationDisplay();
        stompClient.subscribe('/topic/messages', function (message) {
            showMessage(JSON.parse(message.body).content);
        });

        stompClient.subscribe('/user/topic/private-messages', function (message) {
            showMessage(JSON.parse(message.body).content);
        });

        stompClient.subscribe('/topic/global-notifications', function (message) {
            notificationCount = notificationCount + 1;
            updateNotificationDisplay();
        });

        stompClient.subscribe('/user/topic/private-notifications', function (message) {
            notificationCount = notificationCount + 1;
            updateNotificationDisplay();
        });
    });
}

function showMessage(message) {
    $("#messages").append("<tr><td>" + message + "</td></tr>");
}

function sendMessage() {
    console.log("메시지 보내기");
    stompClient.send("/ws/message", {}, JSON.stringify({'messageContent': $("#message").val()}));
}

function sendPrivateMessage() {
    console.log("프라이빗 메시지 보내기");
    stompClient.send("/ws/private-message", {}, JSON.stringify({'messageContent': $("#private-message").val()}));
}

function updateNotificationDisplay() {
    if (notificationCount == 0) {
        $('#notifications').hide();
    } else {
        $('#notifications').show();
        $('#notifications').text(notificationCount);
    }
}

function resetNotificationCount() {
    notificationCount = 0;
    updateNotificationDisplay();
}
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
                        <label for="private-message">Private Message</label>
                        <input type="text" id="private-message" class="form-control" placeholder="Enter your message here...">
                    </div>
                    <button id="send-private" class="btn btn-default" type="button">Send Private Message</button>
                </form>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <table id="message-history" class="table table-striped">
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
                    <tbody id="messages">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
