package com.fit.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MemberController {
	
	// 회원가입 폼
	@GetMapping("/member/addMember")
	public String addMember(HttpServletRequest session,
							@RequestParam(required = false, name = "empNo") Integer empNo,
							Model model) {
		// 로그인 유무에 따라 분기 예정 // 로그인 상태면 home으로 분기
		// session.getAttribute("loginMember");
		
		// 매개값 empNo가 넘어오면 view에서 출력한다
		if(empNo != null) {
			log.debug("\u001B[36m" + "MemberController.addMember() empNo param : " + empNo + "\u001B[0m");
			model.addAttribute("empNo", empNo);
		}
		
		return "/member/addMember";
	}
}
