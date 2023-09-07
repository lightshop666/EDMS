package com.fit.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class WsRestController {
	@Autowired
	private WSService service;	
		 
	// '/sendMassage' 엔드포인트에 POST 요청이 오면 호출됩니다.
	// 요청 본문에 포함된 메시지를 추출하여 웹 소켓 서비스를 통해 모든 연결된 클라이언트에게 메시지를 전달
	@PostMapping("/sendMassage")
	public void sendMessage(String id, @RequestBody final Message message) {
	    service.notifyFrontend(id, message.getMessageContent());
	}
	
	
	/*
	 * // '/sendPrivateMessage/{id}' 엔드포인트에 POST 요청이 오면 호출 // 요청 본문에 포함된 메시지와 경로 변수로
	 * 받은 'id' 값을 사용하여 특정 사용자에게 개인 메시지를 전송
	 * 
	 * @PostMapping("/sendPrivateMessage/{id}") public void
	 * sendPrivateMessage(@PathVariable final String id,
	 * 
	 * @RequestBody final Message message) { service.notifyUser(id,
	 * message.getMessageContent()); }
	 * 
	 */
	
	//특정 사용자에게 알림 전송
	@PostMapping("/draft/{id}")
	public void sendDraftAlarm(@PathVariable final String id,
	                               @RequestBody final Message message) {
	    service.notifyFrontend(id, message.getMessageContent());
    }
	
	
}