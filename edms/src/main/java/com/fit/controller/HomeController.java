package com.fit.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fit.CC;
import com.fit.service.BoardService;
import com.fit.service.MemberService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class HomeController {
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private MemberService memberService;

	
	@Value("${myapi.kakaoKey}")
    private String appkey;
	
	@GetMapping("/home")
	public String home(HttpSession session, Model model) {
		
		//세션계층에서 값 받아오기
		int loginMemberId = (int)session.getAttribute("loginMemberId");
		String accessLevelStr = (String)session.getAttribute("accessLevel");
		int accessLevel = Integer.parseInt(accessLevelStr);
		String empName = (String)session.getAttribute("empName");		
		
		//사용자 정보 board에서 불러온다
		List<Map<String, Object>> selectBoardHome = boardService.selectBoardHome();
		log.debug(CC.YE + "home컨트롤러 boardList :  " + selectBoardHome + CC.RESET);

log.debug(CC.WOO + "home컨트롤러.세션계층 loginMemberId :  " + loginMemberId + CC.RESET);
log.debug(CC.WOO + "home컨트롤러.세션계층 accessLevel :  " + accessLevel + CC.RESET);
log.debug(CC.WOO + "home컨트롤러.세션계층 empName :  " + empName + CC.RESET);

		//사용자 정보 이미지 member_file에서 불러온다
		Map<String, Object> selectMemberOneResult =  memberService.selectMemberOne(loginMemberId);
		log.debug(CC.WOO + "헤더컨트롤러.세션계층 image :  " + selectMemberOneResult.get("memberImage") + CC.RESET);
		//다른 페이지에서도 출력하기 위해 세션에 넣어준다.
	    session.setAttribute("image", selectMemberOneResult.get("memberImage"));



		//뷰에 출력하기 위해 저장
		model.addAttribute("loginMemberId", loginMemberId);		
		model.addAttribute("accessLevel", accessLevel);		
		model.addAttribute("empName", empName);		
		model.addAttribute("board", selectBoardHome);
		model.addAttribute("appkey", appkey);
		model.addAttribute("image", selectMemberOneResult.get("memberImage"));
		
		return "/home";
	}
}
