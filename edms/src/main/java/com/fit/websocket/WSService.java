package com.fit.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
public class WSService {
	
	private final SimpMessagingTemplate messagingTemplate;
	private final NotificationService notificationService;
	
	// 이 서비스 클래스는 웹 소켓 관련 비즈니스 로직을 처리
	// 여기에서는 SimpMessagingTemplate를 사용하여 웹 소켓 메시지를 보내고 NotificationService를 사용하여 알림 메시지를 처리
	
	@Autowired
	public WSService(SimpMessagingTemplate messagingTemplate, NotificationService notificationService) {
		this.messagingTemplate = messagingTemplate;
		this.notificationService = notificationService;
	}
	
	// 클라이언트에게 일반 메시지를 전송
	public void notifyFrontend(final String message) {
	    // ResponseMessage 객체를 생성하고, 메시지 내용을 설정
	    ResponseMessage response = new ResponseMessage(message);
	    
	    // 알림 서비스를 호출하여 글로벌 알림 전송
	    notificationService.sendGlobalNotification();
	
	    // '/topic/messages' 주제로 메시지를 전송하여 모든 연결된 클라이언트에게 브로드캐스트합니다.
	    messagingTemplate.convertAndSend("/topic/messages", response);
	}
	
	// 특정 사용자에게 개인 메시지 전송
	public void notifyUser(final String id, final String message) {
	    // ResponseMessage 객체를 생성하고, 메시지 내용을 설정
	    ResponseMessage response = new ResponseMessage(message);
	
	    // 알림 서비스를 호출하여 해당 사용자에게 개인 알림 전송
	    notificationService.sendPrivateNotification(id);
	
	    // '/topic/privateMessages' 주제로 메시지를 전송하여 해당 사용자에게 개인 메시지 전송
	    messagingTemplate.convertAndSendToUser(id, "/topic/privateMessages", response);
	}
}