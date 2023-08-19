//웹소켓 클라이언트 객체 변수 선언
let stompClient = null;
//알림 횟수를 저장하는 변수
let notificationCount = 0;


$(document).ready(function() {
	console.log("채팅창 준비 완료");
	//웹 소켓 연결 함수 호출
	connect();
	
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

//웹소켓 연결 함수
function connect() {
	// SockJS를 통해 웹 소켓 연결 생성
	let socket = new SockJS('/ourWebsocket');
	// SockJS 연결을 Stomp 클라이언트로 래핑
	stompClient = Stomp.over(socket);
	
	 // 서버와 연결 후 실행되는 콜백 함수
	stompClient.connect({}, function (frame) {
		console.log('연결 frame: ' + frame);
		// 알림 표시 업데이트 함수 호출
		updateNotificationDisplay();
		
		// '/topic/messages' 주제를 구독하여 일반 메시지 수신 처리
		stompClient.subscribe('/topic/messages', function (message) {
			showMessage(JSON.parse(message.body).content);
		});

		// '/user/topic/privateMessages' 주제를 구독하여 개인 메시지 수신 처리
		stompClient.subscribe('/user/topic/privateMessages', function (message) {
			showMessage(JSON.parse(message.body).content);
		});
		
		// '/topic/globalNotifications' 주제를 구독하여 전체 알림 수신 처리
		stompClient.subscribe('/topic/globalNotifications', function (message) {
			notificationCount = notificationCount + 1;
			updateNotificationDisplay();
		});

		// '/user/topic/privateNotifications' 주제를 구독하여 개인 알림 수신 처리
		stompClient.subscribe('/user/topic/privateNotifications', function (message) {
			notificationCount = notificationCount + 1;
			updateNotificationDisplay();
		});
	});
}

//메시지를 화면에 표시하는 함수
function showMessage(message) {
    $("#messages").append("<tr><td>" + message + "</td></tr>");
}

//일반 메시지를 전송하는 함수
function sendMessage() {
    console.log("메시지 보내기");
    stompClient.send("/ws/message", {}, JSON.stringify({'messageContent': $("#message").val()}));
}

//개인 메시지를 전송하는 함수
function sendPrivateMessage() {
    console.log("프라이빗 메시지 보내기");
    stompClient.send("/ws/privateMessages", {}, JSON.stringify({'messageContent': $("#privateMessages").val()}));
}

//알림 표시를 업데이트 하는 함수
function updateNotificationDisplay() {
	//알림 횟수가 0일 때, 알림 영역을 숨깁니다.
    if (notificationCount == 0) {
        $('#notifications').hide();
    } else {
        $('#notifications').show();
        $('#notifications').text(notificationCount);
    }
}

//알림 횟수를 초기화하는 함수
function resetNotificationCount() {
    notificationCount = 0;
    //알림 표시를 업데이트 합니다.
    updateNotificationDisplay();
}