package com.fit.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

import java.security.Principal;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public class WebSocketSessionManager {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    // WebSocket 세션을 관리하기 위한 ConcurrentHashMap
    private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    // 접속한 사용자 ID를 저장하는 리스트
    private final List<String> connectedUserIds = new ArrayList<>();

    // 새로운 WebSocket 세션을 추가하는 메서드
    public WebSocketSession addSession(WebSocketSession session) {
        Principal principal = session.getPrincipal();
	    log.debug(CC.WOO +"웹소켓세션매니저.principal : " + principal + CC.RESET);

        if (principal != null) {
            String userId = principal.getName();
            sessions.put(userId, session);
    	    log.debug(CC.WOO +"웹소켓세션매니저.addSession principal.getName() : " + userId + CC.RESET);
    	    
            // 새로 접속한 사용자 ID를 리스트에 추가
            connectedUserIds.add(userId);
            // 모든 사용자에게 접속자 리스트를 알려주는 메서드를 호출
            broadcastConnectedUsers();
        }
        return sessions.put(session.getId(), session);
    }
    
	// 새로운 WebSocket 세션을 추가하는 메서드 (오버로드)
	public void addSession(String userId) {
		log.debug(CC.WOO + "웹소켓세션매니저.addSession userId : " + userId + CC.RESET);
		// 새로 접속한 사용자 ID를 리스트에 추가
		connectedUserIds.add(userId);
		// 모든 사용자에게 접속자 리스트를 알려주는 메서드를 호출
		broadcastConnectedUsers();
	}
    
    
    // 여기에서 모든 연결된 사용자에게 브로드캐스트 메시지를 보낼 수 있습니다.
    public void broadcastConnectedUsers() {
        messagingTemplate.convertAndSend("/topic/activeUsers", connectedUserIds);
    }

    // 연결이 종료된 WebSocket 세션을 제거하는 메서드
    public void removeSession(WebSocketSession session) {
	    log.debug(CC.WOO +"웹소켓세션매니저.removeSession : " + session + CC.RESET);
        sessions.remove(session.getId());

        Principal principal = session.getPrincipal();
        if (principal != null) {
            String userId = principal.getName();

            // 접속이 끊긴 사용자 ID를 리스트에서 제거
            connectedUserIds.remove(userId);
            // 모든 사용자에게 변경된 접속자 리스트를 알려주는 메서드를 호출
            broadcastConnectedUsers();
        }
    }

    // 모든 WebSocket 세션을 반환하는 메서드
    public Map<String, WebSocketSession> getAllSessions() {
	    log.debug(CC.WOO +"웹소켓세션매니저.모든웹소켓 : " + sessions + CC.RESET);
        return sessions;
    }
    
    // 현재 접속 중인 모든 사용자의 ID를 반환하는 메서드
    public Set<String> getConnectedUserIds() {
	    log.debug(CC.WOO +"웹소켓세션매니저.모든사용자의ID : " + sessions.keySet() + CC.RESET);
        return sessions.keySet();
    }
}