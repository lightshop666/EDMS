package com.fit.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ClearSession {
	
	// 컨트롤러에서 result에 다양한 상태를 보내서 view에서 알림창을 띄운 후 그 세션을 삭제하는 메서드
	@GetMapping("/clear-session")
	public void clearSession(HttpSession session) {
		session.removeAttribute("result");
	}
}
