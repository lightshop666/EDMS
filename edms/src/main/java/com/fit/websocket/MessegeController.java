package com.fit.websocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
//WebSocket 메시지 처리를 위한 컨트롤러
@Controller
public class MessegeController {
	
	// 클라이언트가 '/message' 주제로 메시지를 보낼 때 처리하는 메서드입니다.
	// 클라이언트의 메시지를 받아 가공 후, '/topic/messages' 주제로 응답 메시지를 전송
	@MessageMapping("/message")		
	@SendTo("/topic/messages")
	public ResponseMessage getMessage(final Message message) throws InterruptedException {
		// 클라이언트가 보낸 메시지 내용을 HTML 특수 문자로 이스케이핑하여 안전하게 저장
		//String escapedContent = HtmlUtils.htmlEscape( message.getName() ) + " : " + HtmlUtils.htmlEscape( message.getMessageContent() );
//log.debug(CC.WOO + "웹소켓.메시지컨트롤러 클라이언트가 보낸 메시지 :  " + escapedContent + CC.RESET);
		
		Thread.sleep(500); // 딜레이 0.5초 (시뮬레이션)
		
		// 클라이언트에게 보낼 응답 메시지 객체를 생성하고, 이스케이핑한 메시지 내용을 저장하여 반환
		return new ResponseMessage( HtmlUtils.htmlEscape(message.getMessageContent()));
	}

	
}
