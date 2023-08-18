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
		
		// 1. 세션 정보 조회
		// 이름, 사원번호, 부서명, 입사일
		/*
			String empName = session.getAttribute("empName");
			String empNo = session.getAttribute("loginMemberId");
			부서명 없음
			String employDate = session.getAttribute("employDate");
		*/
		int empNoEx = 20160101;
		String employDateEx = "2016-01-01";
		
		// 2. 남은 휴가 일수
		// 2-1. 근속기간을 구하는 메서드 호출
		Map<String, Object> result = vacationRemainService.getPeriodOfWork(employDateEx);
		boolean isOverOneYear = (boolean) result.get("isOverOneYear"); // 근속년수가 1년 이상이면 true 반환, 1년 미만이면 false 반환
		int periodOfWork = (int) result.get("periodOfWork"); // 근속기간
		
		// 2-2. 반환값에 따라 기준 연차 구하는 메서드 호출
		int Days = 0; // 기준 연차
		if (isOverOneYear == true) { // 근속년수 1년 이상
			Days = vacationRemainService.vacationByYears(periodOfWork);
		} else { // 근속년수 1년 미만
			Days = vacationRemainService.vacationByMonths(periodOfWork);
		}
		
		// 2-3. 남은 휴가 일수를 계산하는 메서드 호출
		Double remainDays = vacationRemainService.getRemainDays(employDateEx, empNoEx, Days);
		
		// 3. 서명 이미지
		
		// 4. 오늘 날짜
		
		return "/draft/vacationDraft";
	}
}
