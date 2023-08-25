package com.fit.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class mainmenuController {

	@GetMapping("/mainmenu")
	public String mainMenu (HttpSession session, Model model) {

		//세션계층에서 값 받아오기
		int loginMemberId = (int)session.getAttribute("loginMemberId");
		String accessLevelStr = (String)session.getAttribute("accessLevel");
		int accessLevel = Integer.parseInt(accessLevelStr);
		String empName = (String)session.getAttribute("empName");		
		
log.debug(CC.WOO + "메인메뉴컨트롤러.세션계층 loginMemberId :  " + loginMemberId + CC.RESET);
log.debug(CC.WOO + "메인메뉴컨트롤러.세션계층 accessLevel :  " + accessLevel + CC.RESET);
log.debug(CC.WOO + "메인메뉴컨트롤러.세션계층 empName :  " + empName + CC.RESET);

		//뷰에 출력하기 위해 저장
		model.addAttribute("loginMemberId", loginMemberId);		
		model.addAttribute("accessLevel", accessLevel);		
		model.addAttribute("empName", empName);		
	
		return "/inc/mainmenu";
	}
}
