package com.fit.websocket;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class WebSocketEventListener {

    @Autowired
    private WebSocketSessionManager sessionManager;

    // STOMP 연결이 성립했을 때 호출되는 메서드
    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {
        // StompHeaderAccessor를 사용하여 STOMP 프로토콜의 헤더를 추출
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
	    log.debug(CC.WOO +"웹소켓이벤트리스너.handleWebSocketConnectListener.스톰프헤더엑세서 : " + accessor +CC.RESET);

        // 사용자 ID를 추출 String com.fit.websocket.WebSocketEventListener.getUserIdFromSession(StompHeaderAccessor accessor)
        String userId = getUserIdFromSession(accessor);

        if (userId != null) {
            // userId를 이용하여 WebSocketSessionManager의 세션 정보를 업데이트
            // 웹소켓 세션 객체 대신 userId를 사용
            sessionManager.addSession(userId);
            // 연결된 모든 사용자에게 현재 접속자 정보를 브로드캐스트
            sessionManager.broadcastConnectedUsers();
        }
    }



    private String getUserIdFromSession(StompHeaderAccessor accessor) {
        // HttpServletRequest를 사용하여 세션에서 loginMemberId 가져오기
        HttpSession session = (HttpSession) accessor.getHeader("simpSessionHttpSession");
        if (session != null) {
            Integer loginMemberIdInteger = (Integer) session.getAttribute("loginMemberId");
            // Integer 값을 String으로 변환합니다.
            return String.valueOf(loginMemberIdInteger);
        }
	    log.debug(CC.WOO +"웹소켓이벤트리스너.getUserIdFromSession이 null입니다!!!!!!!!!!!!!!!!!!!!! " + CC.RESET);
        return null;
    }



    @EventListener		//클라이언트가 웹 소켓에서 연결을 해제할 때 호출. 연결 해제된 클라이언트의 세션을 세션 관리자에서 제거. 위와 마찬가지로 이벤트 메시지에서 헤더 정보를 추출하고 세션을 관리자에서 제거
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
	
    	//StompHeaderAccessor를 사용하여 이벤트 메시지에서 헤더 정보를 추출합니다. 특히, simpSessionAttributes 헤더를 추출하여 세션 관련 정보를 얻습니다.
    	StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
		// accessor.getHeader("simpSessionAttributes")를 Map<String, Object>으로 캐스팅
		Map<String, Object> sessionAttributes = (Map<String, Object>) accessor.getHeader("simpSessionAttributes");
		
		WebSocketSession session  = null;
		if (sessionAttributes != null) {
		    // "webSocketSession" 키를 사용하여 원하는 값을 가져옴
		    session = (WebSocketSession) sessionAttributes.get("webSocketSession");
		    log.debug(CC.WOO +"웹소켓이벤트리스너.handleWebSocketConnectListener session :  " + session+ CC.RESET);
		} else {
		    log.debug(CC.WOO +"웹소켓이벤트리스너.handleWebSocketConnectListener에서 sessionAttributes가 null입니다  " + CC.RESET);
		}
		
		sessionManager.removeSession(session);
    }
}
