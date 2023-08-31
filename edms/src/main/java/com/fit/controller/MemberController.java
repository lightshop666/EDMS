package com.fit.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fit.CC;
import com.fit.service.EmpService;
import com.fit.service.MemberService;
import com.fit.vo.MemberFile;
import com.fit.vo.MemberInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MemberController {
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private EmpService empService;
	
	// 회원가입 폼
	@GetMapping("/member/addMember")
	public String addMember(HttpSession session,
							@RequestParam(required = false, name = "empNo") Integer empNo,
							Model model) {
		/*
			템플릿 적용 이슈로 주석 처리...
			// 로그인 상태면 home으로 리다이렉션
			if(session.getAttribute("loginMemberId") != null) {
				log.debug(CC.HE + "MemberController.addMember() loginMemberId : " + session.getAttribute("loginMemberId") + CC.RESET);
				return "redirect:/home";
			}
		*/
		
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
	
	// 비밀번호 확인 폼
	@GetMapping("/member/memberPwCheck")
	public String checkPw() {
		log.debug(CC.HE + "MemberController.memberPwCheck() 실행" + CC.RESET);
		return "/member/memberPwCheck";
	}
	
	// 비밀번호 확인 액션
	@PostMapping("/member/memberPwCheck")
	public String checkPw(HttpSession session
						  , @RequestParam(required = false, name = "pw") String pw
						  , RedirectAttributes attributes) {
		String result = "";
		// 세션 사원번호를 받아 검사 메서드에 사용
		int empNo = (int)session.getAttribute("loginMemberId");
		log.debug(CC.HE + "MemberController.memberPwCheck() 세션 empNo 값 : " + empNo + CC.RESET);
	    
		// 검사 메서드 실행(비밀번호 일치하는 사원 row를 반환)
		int checkPw = memberService.checkPw(empNo, pw);
	    log.debug(CC.HE + "MemberController.memberPwCheck() checkPw: " + empNo + CC.RESET);
	    
	    // 비밀번호 일치/불일치에 따른 redirect 설정
	    if (checkPw > 0) { // 비밀번호가 일치할 경우
	    	log.debug(CC.HE + "MemberController.memberPwCheck() checkPw : " + checkPw + CC.RESET);
	    	result = "success";
	        return "redirect:/member/modifyMember?result="+result; // 수정폼으로 리디렉션
	    } else { // 비밀번호가 불일치할 경우
	    	log.debug(CC.HE + "MemberController.memberPwCheck() checkPw : " + checkPw + CC.RESET);
	    	result = "fail";
	        return "redirect:/member/memberPwCheck?result="+result; // redirect 대신, 현재 페이지를 유지하면서 메시지만 전달하도록 설정
	    }
	}
	
	// 내 프로필 수정 폼
	@GetMapping("/member/modifyMember")
	public String memberOne(HttpSession session
							, @RequestParam(required = false, name = "result") String result
							, Model model) {
		// 세션에서 사원번호와 사원명을 받아오고 개인정보 조회 메서드에 사용
		int empNo = (int)session.getAttribute("loginMemberId");
		String empName = (String)session.getAttribute("empName");
		log.debug(CC.YE + "MemberController.memberOne() 수정 폼 empNo : " + empNo + CC.RESET);
		log.debug(CC.YE + "MemberController.memberOne() 수정 폼 empName : " + empName + CC.RESET);
    	
		// 비밀번호 검사를 하고 페이지에 접근한 경우(조회 가능)
	    if ("success".equals(result)) { // URL 파라미터로 전달된 결과 값을 확인하여 접근 제어
	    	log.debug(CC.YE + "MemberController.memberOne() 수정 폼 checkPw success : " + empName + CC.RESET);
	    		
			// empNo로 개인정보 조회
			Map<String, Object> profileResult = empService.selectMember(empNo);
			log.debug(CC.YE + "MemberController.memberOne() 수정 폼 profileResult : " + profileResult + CC.RESET);
	    	
			// view에 모델값을 전달
			model.addAttribute("member", profileResult.get("memberInfo"));
			model.addAttribute("image", profileResult.get("memberImage"));
			model.addAttribute("sign", profileResult.get("memberSign"));
			model.addAttribute("empNo", empNo);
			model.addAttribute("empName", empName);
			
			return "/member/modifyMember";
	    } else {
	    	log.debug(CC.YE + "MemberController.memberOne() 수정 폼 checkPw 불일치 " + CC.RESET);
	        // 비밀번호 검사를 하지 않고 페이지에 접근한 경우
	        return "redirect:/member/memberPwCheck"; // 실패한 경우 다른 경로로 리다이렉트
	    }
	}
	
	// 내 프로필 정보 수정 액션
	@PostMapping("/member/modifyMember")
	public String memberOne(MemberInfo memberInfo) {
		// empNo로 개인정보 수정
		int modifyMemberRow = memberService.modifyMember(memberInfo);
		log.debug(CC.YE + "MemberController.memberOne() modifyMemberRow : " + modifyMemberRow + CC.RESET);
        
		if(modifyMemberRow > 0) {
			log.debug(CC.YE + "MemberController.memberOne() modifyMemberRow : " + modifyMemberRow + CC.RESET);
			return "redirect:/member/modifyMember?result=success&modify=success";
		}
		log.debug(CC.YE + "MemberController.memberOne() modifyMemberRow : " + modifyMemberRow + CC.RESET);
		return "redirect:/member/modifyMember?result=success&modify=fail";
	}
	
	// 내 프로필 사진 입력 액션
	@PostMapping("/member/uploadImage")
	public String uploadImage(@RequestParam("empNo") int empNo
							  , @RequestParam("multipartFile") MultipartFile file
							  , HttpServletRequest request) {
		
		
		// request api를 직접 호출하기 위해 매개값으로 request 객체를 받음
		String path = request.getServletContext().getRealPath("/image/member/"); //직접 실제 위치(경로)를 구해서 service에 넘겨주는 api
		log.debug(CC.YE + "MemberController.uploadImage() path : " + path + CC.RESET);
		
		// 디버깅
		log.debug(CC.YE + "MemberController.uploadImage() empNo(): " + empNo + CC.RESET);

		// 입력 메서드 실행
		int row = memberService.addMemberFileImage(empNo, file, path);
		log.debug(CC.YE + "MemberController.uploadImage() row : " + row + CC.RESET);
		
		if(row > 0) {
			log.debug(CC.YE + "MemberController.uploadImage() row : " + row + CC.RESET);
			return "/member/modifyMember?result=success&file=Success_Insert_Image";
		}
		log.debug(CC.YE + "MemberController.uploadImage() row : " + row + CC.RESET);
		return "/member/modifyMember?result=success&file=Fail_Insert_Image";
	}
	
	// 내 프로필 사진 수정 액션
	@PostMapping("/member/modifyImage")
	public String modifyImage(@RequestParam("empNo") int empNo
			  				  , @RequestParam("multipartFile") MultipartFile file
			  				  , HttpServletRequest request) {
		return "";
	}
	
	
}
