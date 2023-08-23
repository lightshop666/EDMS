package com.fit.restapi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.service.EmpService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class EmpRest {
	@Autowired
	private EmpService empService;
	
	// 비밀번호 초기화
	@PostMapping("/adminUpdatePw")
	public int adminUpdatePw(int empNo, String tempPw) {
		log.debug("\033[46;97m" + "EmpRest.adminUpdatePw() empNo : " + empNo + "\u001B[0m");
		log.debug("\033[46;97m" + "EmpRest.adminUpdatePw() tempPw : " + tempPw + "\u001B[0m");
		
		int row = empService.modifyPw(empNo, tempPw);

		return row;
	}
}
