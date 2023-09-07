//알림 횟수를 저장하는 변수
var notificationCount = 0;
// 웹소켓이 연결되어 있는지 나타내는 플래그
var isConnected = false;
//유저 리스트 선언
var userList;
//웹소켓 클라이언트 객체 변수 선언
let stompClient = null;


//웹소켓 연결 함수
function connect() {
    if (isConnected) {
        console.log("웹소켓이 이미 연결되어 있습니다.");
        return;
    }
	
	// SockJS를 통해 웹 소켓 연결 생성
	let socket = new SockJS('/ourWebsocket');
	// SockJS 연결을 Stomp 클라이언트로 래핑
	stompClient = Stomp.over(socket);

    isConnected = true;  // 웹소켓 연결이 성공하면 플래그를 true로 설정
    
	 // 서버와 연결 후 실행되는 콜백 함수
	stompClient.connect({}, function (frame) {
		console.log('연결 frame: ' + frame);
		// 알림 표시 업데이트 함수 호출
		updateNotificationDisplay();
		
		
		//users를 구독하여 전체 리스트 받아오기
		stompClient.subscribe('/topic/users', function(message) {
	        userList = JSON.parse(message.body);
			console.log('받아온 userList: ' + JSON.stringify(userList, null, 2));
/*
			JSON.stringify 함수는 최대 3개의 인자를 받을 수 있습니다.
			첫 번째 인자는 JSON 문자열로 변환할 대상 객체입니다.
			두 번째 인자는 replacer라고 불리며, 함수 혹은 배열이 될 수 있습니다. 이 인자는 JSON 문자열 생성 시 어떤 속성을 포함하거나 변경할지를 제어합니다. null을 지정하면 모든 속성을 기본 동작대로 처리합니다.
			세 번째 인자는 space라고 하며, 출력될 JSON 문자열의 들여쓰기를 제어합니다. 숫자를 넣으면 그 숫자만큼의 공백 문자로 들여쓰기가 이루어집니다. 예를 들어, 2를 지정하면 들여쓰기가 2칸으로 이루어집니다.
			
			콘솔에 찍히는 JSON
			받아온 userList: {
			  "z0csorxh": {
			    "name": "2022002"
			  },
			  "ybccu4w3": {
			    "name": "1000000"
			  }
			}
*/
			// div를 비움
			$('.message-center').empty();
			
			// userList를 반복하여 div에 이름을 추가
			for (let sessionId in userList) {
				console.log('sessionId in userList 반복문 안에 들어왔다! ');
				if (userList.hasOwnProperty(sessionId)) {
					userName = userList[sessionId].name;
					console.log('메시지 반복문 안의 userName : ' + userName);
					let userTemplate = `
						<a href="javascript:void(0)" class="message-item d-flex align-items-center border-bottom px-3 py-2">
							<div class="user-img">
								<img src="/assets/images/users/1.jpg" alt="user" class="img-fluid rounded-circle" width="40px"> 
								<span class="profile-status online float-end"></span>
							</div>
							<div class="w-75 d-inline-block v-middle ps-2">
								<h6 class="message-title mb-0 mt-1"> ${userName} </h6>
							</div>
						</a>
					`;					
					$('.message-center').append(userTemplate);
				}
			}
	    });
		
        // '/activeUsers' 주제로 사용자 목록을 요청하고 받음
        stompClient.subscribe('/user/topic/activeUsers', function (message) {
            // message.body에 서버에서 전송한 데이터가 들어 있음
            // 이 데이터를 뷰에 업데이트하는 함수 호출
            updateActiveUsers(JSON.parse(message.body));
        });
		
		// '/topic/messages' 주제를 구독하여 일반 메시지 수신 처리
		stompClient.subscribe('/topic/messages', function (message) {
		    let receivedMessage = JSON.parse(message.body);
		    let messageContent = receivedMessage.content; 
		    console.log('메시지 구독 messageContent : ' + messageContent);
		    let receivedWebSocketId = receivedMessage.webSocketId;
		    console.log('메시지 구독 receivedWebSocketId : ' + receivedWebSocketId);
		    
		    let isMine = (loginMemberId === receivedWebSocketId);
		    showMessage(messageContent,receivedWebSocketId, isMine);
		});


/*
		// '/user/topic/privateMessages' 주제를 구독하여 개인 메시지 수신 처리
		stompClient.subscribe('/user/topic/privateMessages', function (message) {
			showMessage(JSON.parse(message.body).content);
		});
		
*/	
		//채팅 알림 구독
		stompClient.subscribe('/topic/globalNotifications', function(message) {
			console.log('알림 구독 globalNotifications 안에 들어왔다!');
			notificationCount += 1;
			updateNotificationDisplay();
		});
		
		// '/topic/draftAlarm' 주제를 구독하여 전체 알림 수신 처리
		stompClient.subscribe('/user/topic/draftAlarm', function (message) {
			notificationCount = notificationCount + 1;
			updateNotificationDisplay();
		});

	});
}

//메시지를 화면에 표시하는 함수

function showMessage(messageContent, webSocketId, isMine) {
    let messageHTML = "";
    if (isMine) {	
		console.log('내 대화는 들어가고 :  ' + messageContent + webSocketId);
        messageHTML = `<li class="chat-item odd list-style-none mt-3">
                            <div class="chat-content text-end d-inline-block ps-3">
                                <div class="box msg p-2 d-inline-block mb-1">${messageContent}</div>
                                <br>
                            </div>
                        </li>`;
    } else {		
		console.log('남의 대화 들어가나? :  ' + messageContent + webSocketId);
        let userName = webSocketId || "Unknown"; // WebSocket ID에 해당하는 사용자 이름을 가져오거나, 없다면 "Unknown" 사용
        messageHTML = '<li class="chat-item list-style-none mt-3">' +
                            '<div class="chat-img d-inline-block">' +
                                '<img src="/assets/images/users/1.jpg" alt="user" class="rounded-circle" width="45">' +
                            '</div>' +
                            '<div class="chat-content d-inline-block ps-3">' +
                                '<h6 class="font-weight-medium">' + userName + '</h6>' +
                                '<div class="msg p-2 d-inline-block mb-1">' + messageContent + '</div>' +
                            '</div>' +
                      '</li>';
    }

    $(".chat-list").append(messageHTML);
}


//일반 메시지를 전송하는 함수
function sendMessage() {
	console.log("메시지 보내기");
	stompClient.send("/ws/message", {}, JSON.stringify({
		'messageContent': $("#message").val(),
		'webSocketId': loginMemberId 
	}));
  // 전송 후 입력 필드 내용 지우기
  $("#message").val('');
}

//개인 메시지를 전송하는 함수
function sendPrivateMessage() {
    console.log("프라이빗 메시지 보내기");
	stompClient.send("/ws/privateMessage", {}, JSON.stringify({'messageContent': $("#privateMessage").val()}));
}

// 사용자 목록을 업데이트하는 함수
function updateActiveUsers(users) {
    // 사용자 목록을 HTML 요소로 만들어 뷰에 추가
    let userList = $('#userList');
    userList.empty(); // 목록 초기화

    for (let userId in users) {
        let listItem = $('<li>').text(userId);
        userList.append(listItem);
    }
}



//알림 표시를 업데이트 하는 함수
function updateNotificationDisplay() {	
	//알림 횟수가 0일 때, 알림 영역을 숨깁니다.
    if (notificationCount == 0) {
        $('#notifications').hide();
    } else {
        $('#notifications').show();
        $('#notifications').text(notificationCount);// 알림 횟수를 텍스트로 설정
    }
}

//알림 횟수를 초기화하는 함수
function resetNotificationCount() {
    notificationCount = 0;
    //알림 표시를 업데이트 합니다.
    updateNotificationDisplay();
}