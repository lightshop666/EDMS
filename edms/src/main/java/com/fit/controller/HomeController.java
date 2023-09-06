package com.fit.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fit.CC;
import com.fit.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class HomeController {
	@Autowired
	private BoardService boardService;
	
	@GetMapping("/home")
	public String home(HttpSession session, Model model) {
		
		//세션계층에서 값 받아오기
		int loginMemberId = (int)session.getAttribute("loginMemberId");
		String accessLevelStr = (String)session.getAttribute("accessLevel");
		int accessLevel = Integer.parseInt(accessLevelStr);
		String empName = (String)session.getAttribute("empName");		
		
		List<Map<String, Object>> selectBoardHome = boardService.selectBoardHome();
		log.debug(CC.YE + "home컨트롤러 boardList :  " + selectBoardHome + CC.RESET);

log.debug(CC.WOO + "home컨트롤러.세션계층 loginMemberId :  " + loginMemberId + CC.RESET);
log.debug(CC.WOO + "home컨트롤러.세션계층 accessLevel :  " + accessLevel + CC.RESET);
log.debug(CC.WOO + "home컨트롤러.세션계층 empName :  " + empName + CC.RESET);

		//뷰에 출력하기 위해 저장
		model.addAttribute("loginMemberId", loginMemberId);		
		model.addAttribute("accessLevel", accessLevel);		
		model.addAttribute("empName", empName);		
		model.addAttribute("board", selectBoardHome);
		
		return "/home";
	}
}
