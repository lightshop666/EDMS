package com.fit.restapi;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.service.VacationRemainService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class VacationRest {
	
	@Autowired
	private VacationRemainService vacationRemainService;
	
	// 휴가 종류 선택에 따른 남은 휴가 일수 조회 // 비동기
	@PostMapping("/getRemainDays")
	public double getRemainDays(HttpSession session, String vacationName) {
		double remainDays = 0.0;
		
		log.debug("\033[46;97m" + "VacationRest.getRemainDays() vacationName param : " + vacationName + "\u001B[0m");
		
		// 1. 세션 정보 조회
		// 사원번호, 입사일
		int empNo = (int) session.getAttribute("loginMemberId");
		String employDate = (String) session.getAttribute("employDate");
		
		// 2. 휴가 종류에 따라 메서드 호출
		if (vacationName.equals("보상")) { // 선택한 휴가 종류가 "보상"이면
			remainDays = vacationRemainService.getRemainRewardDays(empNo);
			
			return remainDays;
		} else { // 선택한 휴가 종류가 "연차" 또는 "반차"이면
			// 1) 근속기간을 구하는 메서드 호출
			Map<String, Object> getPeriodOfWorkResult = vacationRemainService.getPeriodOfWork(employDate);
			// 2) 기준 연차를 구하는 메서드 호출
			int Days = vacationRemainService.vacationByPeriod(getPeriodOfWorkResult);
			// 3) 남은 연차 일수를 구하는 메서드 호출
			remainDays = vacationRemainService.getRemainDays(employDate, empNo, Days);
			
			return remainDays;
		}
	}
}
