package com.fit.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fit.service.VacationRemainService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DraftController {
	@Autowired
	private VacationRemainService vacationRemainService;
	
	// 휴가신청서 작성 폼
	@GetMapping("/draft/vacationDraft")
	public String vacationRequest(HttpSession session, Model model) {
		// 세션 정보 조회하여 로그인 유무 및 권한 조회 후 분기 예정
		// 로그인 유무 -> 인터셉터 처리
		// 권한 분기 -> 메인메뉴에서 처리
		
		/*
		// 1. 세션 정보 조회
		// 이름, 사원번호, 부서명, 입사일
		String empName = (String) session.getAttribute("empName");
		int empNo = (int) session.getAttribute("loginMemberId");
		// 부서명 없음
		String employDate = (String) session.getAttribute("employDate");
		*/
		
		String employDateEx = "2022-01-01";
		int empNoEx = 2022002;
		
		// 2. 남은 연차 일수 - remainDays
		// 2-1. 근속기간을 구하는 메서드 호출
		Map<String, Object> getPeriodOfWorkResult = vacationRemainService.getPeriodOfWork(employDateEx);
		// 2-2. 기준 연차를 구하는 메서드 호출
		int Days = vacationRemainService.vacationByPeriod(getPeriodOfWorkResult);
		// 2-3. 남은 연차 일수를 구하는 메서드 호출
		Double remainDays = vacationRemainService.getRemainDays(employDateEx, empNoEx, Days);
		
		// 3. 남은 보상휴가 일수를 구하는 메서드 호출
		int remainRewardDays = vacationRemainService.getRemainRewardDays(empNoEx);
		
		// 4. 서명 이미지
		
		// 5. 오늘 날짜
		
		return "/draft/vacationDraft";
	}
}
