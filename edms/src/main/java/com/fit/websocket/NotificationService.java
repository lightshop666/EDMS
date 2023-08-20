package com.fit.websocket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {
	private final SimpMessagingTemplate messagingTemplate;
	
	@Autowired
	public NotificationService(SimpMessagingTemplate messagingTemplate) {
		// 스프링의 의존성 주입을 통해 SimpMessagingTemplate을 받아와서 멤버 변수에 저장합니다.
		this.messagingTemplate = messagingTemplate;
	}
	
	// 전체 사용자에게 글로벌 알림을 보내는 메서드입니다.
	public void sendGlobalNotification() {
		// ResponseMessage 객체를 생성하고, 알림 메시지를 설정합니다.
		ResponseMessage message = new ResponseMessage("Global Notification");
		
		// SimpMessagingTemplate을 사용하여 "/topic/globalNotifications" 주제로 메시지를 보냅니다.
		// 이 주제에 구독한 클라이언트들은 이 메시지를 받게 됩니다.
		messagingTemplate.convertAndSend("/topic/globalNotifications", message);
	}
	
	// 특정 사용자에게 개인 알림을 보내는 메서드
	// userId 파라미터는 알림을 받을 사용자의 고유 식별자
	public void sendPrivateNotification(final String userId) {
		// ResponseMessage 객체를 생성하고, 알림 메시지를 설정
		ResponseMessage message = new ResponseMessage("Private Notification");
		
		// SimpMessagingTemplate을 사용하여 "/topic/privateNotifications" 주제로 메시지 전송
		// 이 주제에 구독한 특정 사용자만 이 메시지를 받게 됩니다.
		// "/user/{userId}/topic/privateNotifications"와 같은 형식으로 메시지가 전송
		messagingTemplate.convertAndSendToUser(userId, "/topic/privateNotifications", message);
	}
}
