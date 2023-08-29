package com.fit.websocket;

import com.fit.CC;
import com.sun.security.auth.UserPrincipal;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

import java.security.Principal;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Slf4j
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
        return new UserPrincipal(loginMemberId);
    }
}
