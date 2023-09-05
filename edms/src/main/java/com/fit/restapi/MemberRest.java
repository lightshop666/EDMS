package com.fit.restapi;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
	
	
	// 사원 서명 입력 // 비동기
	@PostMapping("/member/uploadSign")
	public String uploadSign(HttpSession session
										     , @RequestParam("sign") String signImageData
                                             , HttpServletRequest request) {
		log.debug(CC.HE + "MemberRest.uploadSign() 메서드 실행" + CC.RESET);
		
		// empNo
		int empNo = (int) session.getAttribute("loginMemberId");
		log.debug(CC.HE + "MemberRest.uploadSign() empNo" + empNo + CC.RESET);
		
		// 파일 저장 경로 설정
		String path = request.getServletContext().getRealPath("/image/member/"); // 실제 파일 시스템 경로
		log.debug(CC.HE + "MemberRest.uploadSign() path" + path + CC.RESET);
		
        // 이미지 저장 후 DB 업데이트 처리
        int row = memberService.addMemberFileSign(empNo, signImageData, path);
        
        // 리다이렉션 처리
        if ( row > 0 ) {
        	return "/member/modifyMember?result=success";
        } else {
        	return "/member/modifyMember?result=success";
        }
	}
	
	// 비밀번호 확인 액션
	@PostMapping("/member/existingPwCheck")
	@ResponseBody
	public String existingPwCheck(HttpSession session
						  , @RequestParam(required = true, name = "pw") String pw) {
		String pwResult = "";
		// 세션 사원번호를 받아 검사 메서드에 사용
		int empNo = (int)session.getAttribute("loginMemberId");
		log.debug(CC.YE + "MemberRest.existingPwCheck() 세션 empNo 값 : " + empNo + CC.RESET);
	    
		// 검사 메서드 실행(비밀번호 일치하는 사원 row를 반환)
		int checkPw = memberService.checkPw(empNo, pw);
	    log.debug(CC.YE + "MemberRest.existingPwCheck() checkPw: " + empNo + CC.RESET);
	    
	    // 비밀번호 일치/불일치에 따른 redirect 설정
	    if (checkPw > 0) { // 비밀번호가 일치할 경우
	    	log.debug(CC.YE + "MemberRest.existingPwCheck() checkPw > 0 : " + checkPw + CC.RESET);
	    	pwResult = "success";
	        return pwResult; // 수정폼으로 리디렉션
	    } else { // 비밀번호가 불일치할 경우
	    	log.debug(CC.YE + "MemberController.existingPwCheck() checkPw < 0 : " + checkPw + CC.RESET);
	    	pwResult = "fail";
	        return pwResult;
	    }
	}
	
	// 비밀번호 수정 액션
	@PostMapping("/member/modifyPw")
	@ResponseBody
	public String modifyPw(HttpSession session
						   , @RequestParam(required = false, name = "newPw2") String newPw2 ) {
		// 반환값 변수 지정
		String modifyPwResult;
		
		// empNo 세션값 활용
		int empNo = (int)session.getAttribute("loginMemberId");
		// 비밀번호 수정 메서드 실행
		int modifyPwRow = memberService.modifyPw(empNo, newPw2);
		log.debug(CC.YE + "MemberController.modifyPw() row : " + modifyPwRow + CC.RESET);
		
		if(modifyPwRow > 0) {
			modifyPwResult = "success";
		} else {
			modifyPwResult = "fail";
		}
		
		return modifyPwResult;
	}
}
