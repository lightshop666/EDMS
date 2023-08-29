package com.fit.controller;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.LoginService;

import lombok.AccessLevel;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LoginController {
	@Autowired private LoginService loginService;
	
//로그인 폼
	@GetMapping("/login")
	public String loginForm(HttpServletRequest request, HttpSession session) {
		
		if ( session.getAttribute("loginMemberId") != null ) {
			log.debug(CC.WOO + "로긴폼.세션ID :  " + session.getAttribute("loginMemberId") + CC.RESET);
	        return "/home"; // 세션계층에서 로그인 중이라면 home으로 이동
		}
		
		// 쿠키에 저장된 로그인 성공 아이디가 있다면 request 속성에 저장
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie c : cookies) {
				if (c.getName().equals("loginId")) {
                    // 로그인 성공한 아이디를 뷰 페이지에 전달
					request.setAttribute("loginId", c.getValue());
log.debug(CC.WOO + "로긴컨트롤러.쿠키에 저장된 loginId :  " + request.getAttribute("loginId") + CC.RESET);
					break; // 찾았으면 더 이상 반복할 필요가 없음
				}
			}
		}
		return "/login/login";
	}
	
//로그인 액션	
	@PostMapping("/login")
	public String loginAction(HttpSession session, Model model,
						@RequestParam(name = "memberId") String memberId,
						@RequestParam(name = "memberPw") String memberPw,
						HttpServletResponse response) {			
		
		// 쿠키 생성 및 설정
		Cookie memberIdCookie = new Cookie("loginId", memberId);
		memberIdCookie.setMaxAge(60*60); // 1시간 (1시간 = 60 * 60 초)
		memberIdCookie.setPath("/"); // 쿠키 경로 설정 (프로젝트 전체 영역)
		
		// 쿠키를 응답 헤더에 추가하여 클라이언트에게 보냅니다.
		response.addCookie(memberIdCookie);
		
	    // 사용자 정보 유효성 검증
		 Map<String, Object> loginSessionMap  = loginService.validateUser(memberId, memberPw);

	    if (loginSessionMap == null) {
	        model.addAttribute("loginError", "사원번호와 비밀번호를 확인해주세요"); // 에러 메시지 설정
	        return "/login/login"; // 로그인 실패 시 로그인 페이지 다시 보여줌
	    }

		// 로그인 성공시 세션에 정보를 저장합니다.
		session.setAttribute("loginMemberId", loginSessionMap.get("empNo"));		// 로그인 정보 저장
		session.setAttribute("accessLevel", loginSessionMap.get("accessLevel")); 	// 세션에 엑세스 레벨 저장
		session.setAttribute("empName", loginSessionMap.get("empName")); 			// 사원이름 저장 
		session.setAttribute("employDate", loginSessionMap.get("employDate")); 		// 입사일 저장
		session.setAttribute("deptName", loginSessionMap.get("deptName"));			// 부서명 저장
		session.setAttribute("empPosition", loginSessionMap.get("empPosition"));	// 직급 저장
log.debug(CC.WOO + "로긴컨트롤러.세션계층 loginMemberId :  " + session.getAttribute("loginMemberId") + CC.RESET);
log.debug(CC.WOO + "로긴컨트롤러.세션계층 accessLevel :  " + session.getAttribute("accessLevel") + CC.RESET);
log.debug(CC.WOO + "로긴컨트롤러.세션계층 empName :  " + session.getAttribute("empName") + CC.RESET);
log.debug(CC.WOO + "로긴컨트롤러.세션계층 employDate :  " + session.getAttribute("employDate") + CC.RESET);
log.debug(CC.WOO + "로긴컨트롤러.세션계층 deptName :  " + session.getAttribute("deptName") + CC.RESET);
log.debug(CC.WOO + "로긴컨트롤러.세션계층 empPosition :  " + session.getAttribute("empPosition") + CC.RESET);

        return "redirect:/home"; // 로그인 성공 시 이동할 페이지
	}

//로그아웃
	@GetMapping("/logout")
	public String logout(HttpSession session) {		
		session.invalidate();			// 세션을 무효화하여 로그아웃 처리합니다.			
		return "redirect:/login/login";	// 로그아웃 후 로그인 페이지로 이동
	}

}
