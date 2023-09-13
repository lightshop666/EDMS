package com.fit.controller;


import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class HeaderController {
	@GetMapping("/header")
	public String header (HttpSession session, Model model) {
		//세션계층에서 멤버아이디 받아온다
		String loginMemberId = (String)session.getAttribute("loginMemberId");
		int IntloginMemberId = Integer.parseInt(loginMemberId);
log.debug(CC.WOO + "헤더컨트롤러.세션계층 IntloginMemberId :  " + IntloginMemberId + CC.RESET);
	
		// 뷰에 출력하기 위해 저장
		model.addAttribute("loginMemberId", loginMemberId);
		
		return "/inc/header";		
	}
}
