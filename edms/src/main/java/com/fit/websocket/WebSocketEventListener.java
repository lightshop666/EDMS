package com.fit.websocket;

import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class WebSocketEventListener {
	
	ConcurrentHashMap<String, Object> connectedUsers = new ConcurrentHashMap<>();
	/*
	 * ConcurrentHashMap은 Map 인터페이스를 구현하는 클래스 중 하나입니다. 이 클래스는 멀티스레딩 환경에서 효율적으로 작동하도록
	 * 설계되어 있습니다. 즉, 여러 스레드가 동시에 맵에 접근하더라도 문제가 없습니다. 내부적으로 세그먼트를 사용해 락을 최소화하고, 효율적인
	 * 동시성 제어를 가능하게 합니다.
	 */
	
	@Autowired
	private SimpMessagingTemplate messagingTemplate;

    // STOMP 연결이 성립했을 때 호출되는 메서드
    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {
        // StompHeaderAccessor를 사용하여 STOMP 프로토콜의 헤더를 추출
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
	    log.debug(CC.WOO +"웹소켓이벤트리스너.handleWebSocketConnectListener.스톰프헤더엑세서 : " + accessor +CC.RESET);
    	String sessionId = accessor.getSessionId();
	    log.debug(CC.WOO +"웹소켓이벤트리스너.접속시 sessionId :  " + sessionId + CC.RESET);
	    Object simpUser = accessor.getHeader("simpUser");
	    log.debug(CC.WOO +"웹소켓이벤트리스너.접속시 simpUser :  " + simpUser + CC.RESET);	     


        if (simpUser != null) {
            connectedUsers.put(sessionId , simpUser);
    	    log.debug(CC.WOO +"웹소켓이벤트리스너.접속시 connectedUsers :  " + connectedUsers + CC.RESET);

            // 전체 클라이언트에게 사용자 리스트를 푸시
            messagingTemplate.convertAndSend("/topic/users", connectedUsers);
        }
    }



    @EventListener		//클라이언트가 웹 소켓에서 연결을 해제할 때 호출. 연결 해제된 클라이언트의 세션을 세션 관리자에서 제거. 위와 마찬가지로 이벤트 메시지에서 헤더 정보를 추출하고 세션을 관리자에서 제거
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
	
    	//StompHeaderAccessor를 사용하여 이벤트 메시지에서 헤더 정보를 추출합니다. 특히, simpSessionAttributes 헤더를 추출하여 세션 관련 정보를 얻습니다.
    	StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
    	String sessionId = accessor.getSessionId();
	    log.debug(CC.WOO +"웹소켓이벤트리스너.해제시 sessionId :  " + sessionId + CC.RESET);
	    Object simpUser = accessor.getHeader("simpUser");
	    log.debug(CC.WOO +"웹소켓이벤트리스너.해제시 simpUser :  " + simpUser + CC.RESET);	     
	    
	    if (sessionId != null) {
	        connectedUsers.remove(sessionId);
	        log.debug(CC.WOO + "웹소켓이벤트리스너.접속종료. connectedUsers : " + connectedUsers + CC.RESET);

	        // 전체 클라이언트에게 사용자 리스트를 푸시
	        messagingTemplate.convertAndSend("/topic/users", connectedUsers.keySet());

	    }
    }
}
