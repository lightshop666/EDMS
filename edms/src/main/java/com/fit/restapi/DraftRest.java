package com.fit.restapi;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.CC;
import com.fit.mapper.DraftMapper;
import com.fit.service.DraftService;
import com.fit.vo.MemberFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class DraftRest {
	
	@Autowired
	private DraftService draftService;
	
	@Autowired
	private DraftMapper draftMapper;
	
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
	
	// 이미 존재하는 기준년월 조회
	@PostMapping("/getExistingSalesDates")
	public List<String> getExistingSalesDates(String today, String previousMonth, String previousMonthBefore) {
		log.debug(CC.HE + "DraftRest.getExistingSalesDates() today param : " + today + CC.RESET);
		log.debug(CC.HE + "DraftRest.getExistingSalesDates() previousMonth param : " + previousMonth + CC.RESET);
		log.debug(CC.HE + "DraftRest.getExistingSalesDates() previousMonthBefore param : " + previousMonthBefore + CC.RESET);
		
		List<String> salesDateList = draftMapper.selectSalesDateList(today, previousMonth, previousMonthBefore);
		log.debug(CC.HE + "DraftRest.getExistingSalesDates() salesDateList : " + salesDateList + CC.RESET);
	
		return salesDateList;
	}
}
