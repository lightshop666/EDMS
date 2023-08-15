package com.fit.restapi;

import java.util.HashMap;
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
	public Map<String, Object> checkEmpNo(Integer empNo) {
		Map<String, Object> result = new HashMap<>();
		
		log.debug("\033[46;97m" + "MemberController.checkEmpNo() empNo param : " + empNo + "\u001B[0m");
		
		// 사원번호 검사 service 호출
		Map<String, Object> checkEmpNoResult = memberService.checkEmpNo(empNo);
		int empInfoCnt = (int) checkEmpNoResult.get("empInfoCnt");
		int memberInfoCnt = (int) checkEmpNoResult.get("memberInfoCnt");
		
		// 반환할 map에 결과값(Cnt) 담기
		result.put("empInfoCnt", empInfoCnt);
		result.put("memberInfoCnt", memberInfoCnt);
		log.debug("\033[46;97m" + "MemberController.checkEmpNo() empInfoCnt : " + empInfoCnt + "\u001B[0m");
		log.debug("\033[46;97m" + "MemberController.checkEmpNo() memberInfoCnt : " + memberInfoCnt + "\u001B[0m");
		
		// 반환할 map에 resultMsg 담기
		if(empInfoCnt == 0) {
			result.put("resultMsg", "인사정보에 존재하지 않는 사원번호 입니다. 다른 사원번호를 입력하세요.");
		} else if(memberInfoCnt != 0) {
			result.put("resultMsg", "중복된 사원번호입니다. 다른 사원번호를 입력하세요.");
		} else {
			result.put("resultMsg", "가입 가능한 사원번호입니다.");
		}
		
		return result;
	}
}
