package com.fit.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.fit.CC;
import com.fit.vo.Board;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {

	// 게시글 추가 폼
	@GetMapping("/board/addBoard")
	public String addBoard(Model model, HttpSession session) {
		int empNo = (int)session.getAttribute("loginMemberId");
		String deptName = (String)session.getAttribute("deptName");
		
		model.addAttribute("empNo");
		model.addAttribute("deptName");
		return "/board/addBoard";
	}
	
	// 게시글 추가 액션
	@PostMapping("/board/addBoard")
	public String addBoard(HttpServletRequest request, Board board) {
		String path = request.getServletContext().getRealPath("/file/board"); //직접 실제 위치(경로)를 구해서 service에 넘겨주는 api
		// int row = boardService.addBoard(board, path);
		// log.debug(CC.YE + "addBoard row : " + row + CC.RESET);
		return "redirect:/board/boardList";	// 대소문자까지 일치하도록 작성
	}
		
}
