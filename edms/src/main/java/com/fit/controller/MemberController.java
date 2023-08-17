package com.fit.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.MemberService;
import com.fit.vo.MemberInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MemberController {
	@Autowired
	private MemberService memberService;
	
	// 회원가입 폼
	@GetMapping("/member/addMember")
	public String addMember(HttpSession session,
							@RequestParam(required = false, name = "empNo") Integer empNo,
							Model model) {
		// 로그인 상태면 home으로 리다이렉션
		if(session.getAttribute("loginMemberId") != null) {
			log.debug(CC.HE + "MemberController.addMember() loginMemberId : " + session.getAttribute("loginMemberId") + CC.RESET);
			return "redirect:/home";
		}
		
		// 매개값 empNo가 넘어오면 view에서 출력
		if(empNo != null) {
			log.debug(CC.HE + "MemberController.addMember() empNo param : " + empNo + CC.RESET);
			model.addAttribute("empNo", empNo);
		}
		
		return "/member/addMember";
	}
	
	// 회원가입 액션
	@PostMapping("/member/addMember")
	public String addMember(MemberInfo memberInfo) {
		int row = memberService.addMember(memberInfo); // 회원가입 결과값
		
		if (row == 1) {
			log.debug(CC.HE + "MemberController.addMember() row : " + row + CC.RESET);
	        return "redirect:/login"; // 회원가입 성공 시 로그인 페이지로
	    } else { // 회원가입 실패 시
	    	log.debug(CC.HE + "MemberController.addMember() row : " + row + CC.RESET);
	        return "redirect:/member/addMember?result=fail";
	    }
	}
}
