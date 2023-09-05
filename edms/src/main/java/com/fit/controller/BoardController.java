package com.fit.controller;


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
public class BoardController {
	@Autowired
	private BoardService boardService;
	
	// 게시글 추가 폼
	@GetMapping("/board/addBoard")
	public String addBoard(Model model, HttpSession session) {
		int empNo = (int)session.getAttribute("loginMemberId");
		log.debug(CC.YE + "BoardController.addBoard() empNo : " + empNo + CC.RESET);
		
		String deptName = (String)session.getAttribute("deptName");
		log.debug(CC.YE+"BoardController.addBoard() deptName : " + deptName + CC.RESET);
		
		String empName = (String)session.getAttribute("empName");
		log.debug(CC.YE+"BoardController.addBoard() empName : " + empName + CC.RESET);
		
		model.addAttribute(empNo);
		model.addAttribute("empName");
		model.addAttribute("deptName");
		return "/board/addBoard";
	}

}
