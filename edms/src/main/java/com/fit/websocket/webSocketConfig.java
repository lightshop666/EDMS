package com.fit.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class webSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Autowired
    private  UserHandshakeHandler userHandshakeHandler;
    

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
                .setHandshakeHandler(userHandshakeHandler)	//사용자 Principal을 결정하는 역할
                .withSockJS();
        /*
UserHandshakeHandler 클래스는 WebSocket 핸드셰이크 시에 사용자 Principal을 결정하는 역할을 합니다. 
이 핸들러는 WebSocket 연결이 확립될 때마다 호출되어, 사용자를 인식하고 식별하기 위한 작업을 수행합니다.
여기서 UserHandshakeHandler를 빈으로 등록하는 이유는 핸드셰이크 과정 중에 필요한 의존성을 주입하기 위함입니다.  (의존성 주입? 장난감 배터리 넣어주듯이)

AlarmService는 알림과 관련된 비즈니스 로직을 처리하는 서비스 클래스로, 웹소켓 핸드셰이크 과정에서 사용자를 식별하고 알림을 전송할 때 필요합니다.
그래서 UserHandshakeHandler 클래스의 생성자에서 AlarmService를 주입받게 되는데, 이렇게 의존성 주입을 통해 AlarmService의 기능을 활용할 수 있습니다.

기본적으로 WebSocket은 HTTP와 별개로 작동하며, WebSocket 핸드셰이크 시에는 HTTP 요청과는 별개의 요청이 생성됩니다. 그러므로 HTTP 요청에서 세션에 저장된 데이터를 직접 사용할 수 없습니다.
하지만 UserHandshakeHandler 클래스에서는 HttpServletRequest를 이용하여 HTTP 요청과 연결되어 있는 세션에서 데이터를 가져오는 방식을 사용합니다. 
이를 통해 세션에 저장된 로그인 정보나 사용자 식별 정보를 WebSocket 핸드셰이크 시에 활용할 수 있습니다.

요약하면, UserHandshakeHandler 클래스가 빈으로 등록되고 생성자에서 AlarmService를 주입받는 것은 WebSocket 핸드셰이크 시에 필요한 데이터를 세션을 통해 활용하기 위함입니다. 
이를 통해 사용자를 식별하고 필요한 비즈니스 로직을 수행할 수 있습니다.
         */
	}

}
