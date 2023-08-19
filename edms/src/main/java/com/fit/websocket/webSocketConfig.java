package com.fit.websocket;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class webSocketConfig implements WebSocketMessageBrokerConfigurer {

	// 메시지 브로커 설정
	@Override
	public void configureMessageBroker(final MessageBrokerRegistry config) {
		// 클라이언트가 구독할 주제(prefix) 설정  -->  서버에서 해당 주제로 메시지를 발행하면, 해당 주제를 구독한 클라이언트들에게 메시지가 전달
		config.enableSimpleBroker("/topic");
		
		// 클라이언트가 메시지를 보낼 때 사용할 주제(prefix) 설정
		config.setApplicationDestinationPrefixes("/ws");
	}

	// Stomp 엔드포인트 등록
	@Override
	public void registerStompEndpoints(final StompEndpointRegistry registry) {
		// Stomp 연결을 위한 엔드포인트 설정 및 SockJS 사용
		registry.addEndpoint("/ourWebsocket")
				.setHandshakeHandler(new UserHandshakeHandler())
				.withSockJS();
	}

}
