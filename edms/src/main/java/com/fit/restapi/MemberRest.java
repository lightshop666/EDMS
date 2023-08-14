package com.fit.restapi;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.service.MemberService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class MemberRest {
	
	@Autowired
	private MemberService memberService;
	
	// 사원번호 검사 // 비동기
	@PostMapping("/checkEmpNo")
	public String checkEmpNo(Integer empNo) {
		if(empNo != null) {
			log.debug("\033[46;97m" + "MemberController.checkEmpNo() empNo param : " + empNo + "\u001B[0m");
			
			Map<String, Object> checkEmpNoResult = memberService.checkEmpNo(empNo);
			int empInfoCnt = (int) checkEmpNoResult.get("empInfoCnt");
			int memberInfoCnt = (int) checkEmpNoResult.get("memberInfoCnt");
			
			if(empInfoCnt == 0) {
				log.debug("\033[46;97m" + "MemberController.checkEmpNo() empInfoCnt : " + empInfoCnt + "\u001B[0m");
				return "인사정보에 존재하지 않는 사원번호 입니다. 다른 사원번호를 입력하세요.";
			} else if(memberInfoCnt != 0) {
				log.debug("\033[46;97m" + "MemberController.checkEmpNo() memberInfoCnt : " + memberInfoCnt + "\u001B[0m");
				return "중복된 사원번호입니다. 다른 사원번호를 입력하세요.";
			} else {
				return "가입 가능한 사원번호입니다.";
			}
		}
		
		return "사원번호를 입력해주세요.";
	}
}
