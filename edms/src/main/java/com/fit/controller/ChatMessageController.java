package com.fit.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping
public class ChatMessageController {

	@GetMapping("/chatMessage")
	public String chatMessage(Model model, HttpSession session) {
        // 다른 모델 속성들을 추가할 수 있습니다.

		return "/chatMessage";
	}
}
