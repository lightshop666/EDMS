package com.fit.restapi;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fit.CC;
import com.fit.service.MemberService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@CrossOrigin
public class MemberRest {
	
	@Autowired
	private MemberService memberService;
	
	// 사원번호 검사 // 비동기
	@PostMapping("/checkEmpNo")
	public Map<String, Object> checkEmpNo(Integer empNo) {
		Map<String, Object> result = new HashMap<>();
		
		log.debug(CC.HE + "MemberRest.checkEmpNo() empNo param : " + empNo + CC.RESET);
		
		// 사원번호 검사 service 호출
		Map<String, Object> checkEmpNoResult = memberService.checkEmpNo(empNo);
		int empInfoCnt = (int) checkEmpNoResult.get("empInfoCnt");
		int memberInfoCnt = (int) checkEmpNoResult.get("memberInfoCnt");
		
		// 반환할 map에 결과값(Cnt) 담기
		result.put("empInfoCnt", empInfoCnt);
		result.put("memberInfoCnt", memberInfoCnt);
		log.debug(CC.HE + "MemberRest.checkEmpNo() empInfoCnt : " + empInfoCnt + CC.RESET);
		log.debug(CC.HE + "MemberRest.checkEmpNo() memberInfoCnt : " + memberInfoCnt + CC.RESET);
		
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
	
	// 비밀번호 검사 // 비동기
	@PostMapping("/checkPw")
	public boolean checkPw(HttpSession session, @RequestParam(required = false, name = "pw") String pw) {
	    
		int empNo = (int)session.getAttribute("loginMemberId");
	    int checkPw = memberService.checkPw(empNo, pw);
	    
	    return checkPw > 0; // 비밀번호가 일치하면 true, 아니면 false 반환
	}
}
