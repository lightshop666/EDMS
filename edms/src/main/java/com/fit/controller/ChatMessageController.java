package com.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ChatMessageController {

	@GetMapping("/chatMessage")
	public String chatMessage() {
		return "/chatMessage";
	}
}
