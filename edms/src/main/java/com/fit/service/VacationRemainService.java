package com.fit.service;

import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.HashMap;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class VacationRemainService {
	/*
		1. 사원의 입사일과 오늘날짜를 기준으로 근속기간을 구합니다. // 근속기간
		2. 근속기간을 이용하여 연차 지급 기준에 따른 기준 연차 갯수를 구합니다. // 기준 연차
		-> 1년 미만과 1년 이상의 연차 지급 기준 테이블이 다르므로 메서드를 분리합니다.
		3. 최근 연차 발생일로부터 현재 날짜까지 사용한 연차와 반차를 차감하여 남은 연차일수를 계산합니다. // 남은 연차일수
		-> vacation_draft 테이블을 조회하여 해당 기간에 결재 상태가 '결재완료'인 휴가신청서의 내역으로 계산합니다.
	*/
	
	// 근속기간 구하기
	public Map<String, Object> getPeriodOfWork(String employDate) {
		Map<String, Object> result = new HashMap<>();
		
		boolean isOverOneYear = true; // 근속년수가 1년 이상이면 true 반환, 1년 미만이면 false 반환
		int periodOfWork = 0; // 근속년수 또는 근속월수 반환
		
		// 1. 입사일
    	// parse()을 사용하여 사원의 입사일(String)을 LocalDate 객체로 변환
    	// DateTimeFormatter.ofPattern()을 사용하여 yyyy-MM-dd 형식으로 지정
    	// DateTimeFormatter에서 소문자 m은 시간의 분을 의미하기 때문에 주의한다!
    	LocalDate employLocalDate = LocalDate.parse(employDate, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    	log.debug(CC.HE + "VactionRemainService vacationRemaining() 입사일 : " + employLocalDate + CC.RESET);
    	
    	// 2. 오늘 날짜
    	// LocalDate 객체로 오늘 날짜를 가져올 수 있다
    	LocalDate today = LocalDate.now();
    	log.debug(CC.HE + "VactionRemainService vacationRemaining() 오늘날짜 : " + today + CC.RESET);
    	
    	// 3. 입사일과 오늘 날짜 사이의 기간 구하기
    	// Period 객체로 두 날짜 사이의 기간을 구할 수 있다
    	Period period = Period.between(employLocalDate, today);
    	// log.debug(CC.HE + "VactionRemainService vacationRemaining() 기간 : " + period + CC.RESET);
    	// -> ex) P7Y7M17D 는 7년 7개월 17일의 기간을 의미한다 (7Y 7M 17D)
    	
    	// 4. 기간에서 년수만 가져오기
    	// getYears()을 이용하여 해당 기간 중 년 정보만 가져온다
    	int yearsOfWork = period.getYears();
    	
    	// 5. 년수에 따라 분기하여 반환값 저장
    	if (yearsOfWork == 0) {
    		// 근속년수가 1년 미만일 경우
    		isOverOneYear = false;
    		log.debug(CC.HE + "VactionRemainService vacationRemaining() 근속년수 1년 미만 -> false" + CC.RESET);
    		
    		// 반환값에 개월수 저장
    		periodOfWork = period.getMonths(); // getMonths()을 이용하여 해당 기간 중 월 정보만 가져온다
    		log.debug(CC.HE + "VactionRemainService vacationRemaining() 근속기간 : " + periodOfWork + "개월" + CC.RESET);
    	} else {
    		// 근속년수가 1년 이상일 경우
    		log.debug(CC.HE + "VactionRemainService vacationRemaining() 근속년수 1년 이상 -> true" + CC.RESET);
    		
    		// 반환값에 년수 저장
    		periodOfWork = yearsOfWork;
    		log.debug(CC.HE + "VactionRemainService vacationRemaining() 근속기간 : " + periodOfWork + "년" + CC.RESET);
    	}
    	
    	// 6. Map에 저장
    	result.put("isOverOneYear", isOverOneYear);
    	result.put("periodOfWork", periodOfWork);
    	
    	return result;
	}
	
	// 기준 연차 구하기 (1년 이상)
	public int vacationByYears(int periodOfWork) {
		int Days = 0;
		
		if (periodOfWork >= 1 && periodOfWork < 3) {
			Days = 15;
		} else if (periodOfWork >= 3 && periodOfWork < 5) {
			Days = 16;
		} else if (periodOfWork >= 5 && periodOfWork < 7) {
			Days = 17;
		} else if (periodOfWork >= 7 && periodOfWork < 9) {
			Days = 18;
		} else if (periodOfWork >= 9 && periodOfWork < 11) {
			Days = 19;
		} else if (periodOfWork >= 11 && periodOfWork < 13) {
			Days = 20;
		} else if (periodOfWork >= 13 && periodOfWork < 15) {
			Days = 21;
		} else if (periodOfWork >= 15 && periodOfWork < 17) {
			Days = 22;
		} else if (periodOfWork >= 17 && periodOfWork < 19) {
			Days = 23;
		} else if (periodOfWork >= 19 && periodOfWork < 21) {
			Days = 24;
		} else if (periodOfWork >= 21) {
			Days = 25;
		}
		
		return Days;
	}
	
	// 기준 연차 구하기 (1년 미만)
	public int vacationByMonths(int periodOfWork) {
		int Days = 0;
		
		// 수정예정...
		
		return Days;
	}
	
	// 남은 휴가 일수 구하기
	public Double getRemainDays(String employDate, int empNo, int Days) {
		
		return 0.0;
	}

}
