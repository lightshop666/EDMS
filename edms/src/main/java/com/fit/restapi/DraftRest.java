package com.fit.restapi;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.service.DraftService;
import com.fit.vo.MemberFile;

@RestController
public class DraftRest {
	
	@Autowired
	private DraftService draftService;
	
	// 서명 이미지 조회
	@PostMapping("/alertAndRedirectIfNoSign")
	public boolean checkMemberSign(HttpSession session) {
		// 세션에서 사원번호 가져오기
		int empNo = (int) session.getAttribute("loginMemberId");
		// 기존 서비스 호출
		MemberFile memberSign = draftService.selectMemberSign(empNo);
		
		if (memberSign == null) {
			return false;
		}
		
		return true;
	}
}
