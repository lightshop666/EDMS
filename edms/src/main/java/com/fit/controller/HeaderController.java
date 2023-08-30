package com.fit.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fit.CC;
import com.fit.websocket.AlarmService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class HeaderController {
	@Autowired
	private AlarmService alarmService;
	
	

	@GetMapping("/header")
	public String header (HttpSession session, Model model) {
		//세션계층에서 멤버아이디 받아온다
		String loginMemberId = (String)session.getAttribute("loginMemberId");
log.debug(CC.WOO + "헤더컨트롤러.세션계층 loginMemberId :  " + loginMemberId + CC.RESET);
		//뷰에 출력하기 위해 저장
		model.addAttribute("loginMemberId", loginMemberId);		
		
		return "/inc/header";		
	}
}
