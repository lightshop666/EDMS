package com.fit.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WSController {
	@Autowired
	private WSService service;
	
	@PostMapping("/sendMassage")
	public void sendMessage(@RequestBody Message message) {
		service.notifyFrontend(message.getMessageContent());
	}

}
