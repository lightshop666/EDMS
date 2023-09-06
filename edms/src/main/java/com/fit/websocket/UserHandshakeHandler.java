package com.fit.websocket;

import com.fit.CC;
import com.sun.security.auth.UserPrincipal;

import lombok.extern.slf4j.Slf4j;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

import java.security.Principal;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Slf4j
@Component
public class UserHandshakeHandler extends DefaultHandshakeHandler {
	// WebSocket 핸드셰이크 과정에서 사용자 Principal을 결정하는 메서드. 이 메서드는 WebSocket 연결이 확립될 때마다 호출
    @Override
    protected Principal determineUser(ServerHttpRequest request, WebSocketHandler wsHandler, Map<String, Object> attributes) {
		// ServerHttpRequest를 ServletServerHttpRequest로 형변환하여 HTTP 요청 객체를 가져옵니다.
		ServletServerHttpRequest servletRequest = (ServletServerHttpRequest) request;
		log.debug(CC.WOO + "핸드쉐이크 servletRequest :  " + servletRequest + CC.RESET);
		
		// WebSocket은 HTTP와 별개로 작동하므로, WebSocket 핸드셰이크 시에는 HTTP 요청과는 별개의 요청이 생성됩니다.
		// 이를 통해 HTTP 세션에 저장된 데이터를 직접 사용할 수 없습니다.		
		// 그러나 이 코드는 HTTP 요청을 통해 세션에 저장된 데이터를 가져올 수 있도록 도와줍니다.
		
		// ServletServerHttpRequest에서 HttpServletRequest를 가져옵니다.
		HttpServletRequest httpRequest = servletRequest.getServletRequest();
		log.debug(CC.WOO + "핸드쉐이크 httpRequest :  " + httpRequest + CC.RESET);
		
		// HttpServletRequest를 사용하여 세션에서 loginMemberId 가져오기
		HttpSession session = httpRequest.getSession();
		log.debug(CC.WOO + "핸드쉐이크 session :  " + session + CC.RESET);
		// 세션에서 Integer 타입으로 값을 가져옵니다.
		Integer loginMemberIdInteger = (Integer) session.getAttribute("loginMemberId");
		// Integer 값을 String으로 변환합니다.
		String loginMemberId = String.valueOf(loginMemberIdInteger);

		log.debug(CC.WOO + "핸드쉐이크 loginMemberId :  " + loginMemberId + CC.RESET);
		
		// loginMemberId가 null인 경우 로그인하지 않은 사용자 처리
		if (loginMemberId == null) {			
			// 랜덤한 사용자 ID 생성
			final String randomId = UUID.randomUUID().toString();
			
			log.debug(CC.WOO + "이 페이지에서의 유저 ID :  " + randomId + CC.RESET);
			
			loginMemberId = randomId;
        }
		// 사용자 ID를 세션에서 가져오거나 생성한 후, 웹 소켓 헤더에 추가
		StompHeaderAccessor accessor = StompHeaderAccessor.create(StompCommand.CONNECT);
/*
StompHeaderAccessor: STOMP 메시지의 헤더를 다루기 위한 유틸리티 클래스입니다. 헤더에는 메시지의 목적지, 유형, 사용자 정보 등이 포함됩니다. 
이 클래스는 헤더를 생성하고 수정하는 데 사용됩니다.

create(StompCommand.CONNECT): StompHeaderAccessor 클래스의 create 메서드는 주어진 STOMP 프레임(명령)에 대한 새로운 헤더 accessor를 생성합니다. 
StompCommand.CONNECT는 STOMP CONNECT 프레임을 나타내며, 이를 기반으로 헤더 accessor를 생성합니다.

STOMP CONNECT 프레임은 클라이언트가 서버에 연결을 요청할 때 사용됩니다. 
이 프레임은 연결을 설정하는 데 필요한 정보를 포함하며, 사용자 인증과 관련된 정보를 설정할 때 주로 사용됩니다.

따라서 StompHeaderAccessor.create(StompCommand.CONNECT)은 CONNECT 프레임에 대한 헤더 accessor를 생성하게 됩니다. 
이 accessor를 사용하여 CONNECT 프레임의 헤더를 수정하고 사용자 정보를 설정할 수 있습니다.
 
 */
		// 사용자 ID를 웹 소켓 세션 헤더에 추가
		accessor.setUser(new UserPrincipal(loginMemberId));
		
        return new UserPrincipal(loginMemberId);
    }
}
