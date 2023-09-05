package com.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class SendEmailController {
	
	@GetMapping("/sendEmail")
	public String sendEmailForm(Model model
			// 사원번호 입력받음
		,	@RequestParam(name = "empNo", required = false, defaultValue = "0") int empNo) {
		
		
		model.addAttribute("empNo", empNo);
		
		return "/sendEmail";
	}
}
