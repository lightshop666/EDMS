package com.fit.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmpController {
	
	// 인사정보 수정 폼
	@GetMapping("/emp/modifyEmp")
	public String modifyEmp(HttpSession session,
							@RequestParam(required = false, name = "empNo") Integer empNo,
							Model model) {
		// 세션 정보 조회 (로그인 유무 및 권환)
		if (session.getAttribute("loginMemberId") == null) {
			return "/login";
		}
		int accessLevel = (int) session.getAttribute("accessLevel"); // 권한 레벨 가져오기
		if (accessLevel < 2) {
			return "/home";
		}
		return "";
	}
}
