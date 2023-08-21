package com.fit.service;

import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.CC;
import com.fit.mapper.VactionRemainMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class VacationRemainService {
	
	@Autowired
	private VactionRemainMapper vacationRemainMapper;
	
	/*
		남은 연차 일수
		1. 근속기간, 1년 이상 유무
			-> 사원의 입사일과 오늘날짜를 기준으로 근속기간과 근속기간이 1년 미만인지 1년 이상인지를 구합니다.
		2. 기준 연차
			-> 근속기간을 이용하여 연차 지급 기준에 따른 기준 연차 갯수를 구합니다.
			-> 1년 미만과 1년 이상의 기준 연차 기준이 다르므로 분기합니다.
		3. 남은 연차일수
			-> 연차는 입사일 기준으로 1년 만근시 새로 발생하며, 유효기간은 발생일로부터 1년입니다.
			-> 최근 연차 발생일로부터 현재 날짜까지 사용한 연차와 반차를 차감하여 계산합니다. (기준 연차 - 사용내역)
			-> 사용내역은 vacation_draft, approval 테이블을 조인하여 결재상태가 '결재완료'인 내역을 조회합니다.
	*/
	
	// 근속기간 구하기 (+ 1년 이상 유무)
	public Map<String, Object> getPeriodOfWork(String employDate) {
		Map<String, Object> result = new HashMap<>();
		
		boolean isOverOneYear = true; // 근속년수가 1년 이상이면 true 반환, 1년 미만이면 false 반환
		int periodOfWork = 0; // 근속년수 또는 근속월수 반환
		
		// 1. 입사일
		// parse()을 사용하여 사원의 입사일(String)을 LocalDate 객체로 변환
    	// DateTimeFormatter.ofPattern()을 사용하여 yyyy-MM-dd 형식으로 지정
    	// DateTimeFormatter에서 소문자 m은 시간의 분을 의미하기 때문에 주의한다!
    	LocalDate employLocalDate = LocalDate.parse(employDate, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    	log.debug(CC.HE + "VactionRemainService getPeriodOfWork() 입사일 : " + employLocalDate + CC.RESET);
    	
    	// 2. 오늘 날짜
    	// LocalDate 객체로 오늘 날짜를 가져올 수 있다
    	LocalDate today = LocalDate.now();
    	log.debug(CC.HE + "VactionRemainService getPeriodOfWork() 오늘날짜 : " + today + CC.RESET);
    	
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
    		log.debug(CC.HE + "VactionRemainService getPeriodOfWork() 근속년수 1년 미만 -> false" + CC.RESET);
    		
    		// 반환값에 개월수 저장
    		periodOfWork = period.getMonths(); // getMonths()을 이용하여 해당 기간 중 월 정보만 가져온다
    		log.debug(CC.HE + "VactionRemainService getPeriodOfWork() 근속기간 : " + periodOfWork + "개월" + CC.RESET);
    	} else {
    		// 근속년수가 1년 이상일 경우
    		log.debug(CC.HE + "VactionRemainService getPeriodOfWork() 근속년수 1년 이상 -> true" + CC.RESET);
    		
    		// 반환값에 년수 저장
    		periodOfWork = yearsOfWork;
    		log.debug(CC.HE + "VactionRemainService getPeriodOfWork() 근속기간 : " + periodOfWork + "년" + CC.RESET);
    	}
    	
    	// 6. Map에 저장
    	result.put("isOverOneYear", isOverOneYear);
    	result.put("periodOfWork", periodOfWork);
    	
    	return result;
	}
	
	// 기준 연차 구하기
	public int vacationByPeriod(Map<String, Object> getPeriodOfWorkResult) {
		int Days = 0;
		
		// getPeriodOfWork()의 반환값 Map에서 가져오기
		// 근속년수가 1년 이상이면 true 반환, 1년 미만이면 false 반환
		boolean isOverOneYear = (boolean) getPeriodOfWorkResult.get("isOverOneYear");
		// 근속기간
		int periodOfWork = (int) getPeriodOfWorkResult.get("periodOfWork"); 
		
		// 근속기간 1년 이상 유무따라 분기
		// 1. 근속기간이 1년 미만일 경우
		if (isOverOneYear == false) {
			Days = periodOfWork; // 한달 만근시 연차가 1개씩 발생
			log.debug(CC.HE + "VactionRemainService vacationByPeriod() 기준연차 : " + Days + "개" + CC.RESET);
			return Days;
		}
		
		// 2. 근속기간이 1년 이상일 경우
		// 최초 1년 만근시 15개 발생, 이후 2년마다 발생할 기준 연차가 1개씩 증가
		// 이후 최대 25개까지 발생 가능
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
		log.debug(CC.HE + "VactionRemainService vacationByYears() 기준연차 : " + Days + "개" + CC.RESET);
		
		return Days;
	}
	
	// 남은 연차 일수 구하기
	public Double getRemainDays(String employDate, int empNo, int Days) {
		Double remainDays = (double) Days; // 기준 연차 값으로 초기화
		
		// 1. 최근 연차 발생일 구하기 - recentVacationDate
		// 1-1. 오늘 날짜에서 년도 추출
    	LocalDate today = LocalDate.now(); // LocalDate 객체로 오늘 날짜를 가져올 수 있다
    	int todayYear = today.getYear(); // 올해 년도만 가져오기
    	
    	// 1-2. 입사일의 년도를 올해 년도로 바꾸기
    	// String 타입의 employDate를 LocalDate 객체로 바꾸기
    	LocalDate employLocalDate = LocalDate.parse(employDate, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    	// withYear() 메서드를 이용하여 년도를 바꾼다
    	employLocalDate = employLocalDate.withYear(todayYear);
    	
    	// 1-3. 바꾼 날짜가 오늘 날짜를 넘어갈 경우 년도를 작년으로 변경
    	// isAfter() 메서드를 이용하여 날짜를 비교할 수 있다
    	if ( employLocalDate.isAfter(today) ) {
    		employLocalDate = employLocalDate.minusYears(1); // minusYears() 메서드를 이용하여 작년으로 변경
    	}
    	
    	// 1-4. String 타입으로 다시 형변환
    	String recentVacationDate = employLocalDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    	log.debug(CC.HE + "VactionRemainService getRemainDays() 최근 연차 발생일 : " + recentVacationDate + CC.RESET);
    	
    	// 2. 사용내역 조회 메서드 호출
    	List<Double> usedVacationDaysList = vacationRemainMapper.getUsedVacationDays(empNo, recentVacationDate);
    	log.debug(CC.HE + "VactionRemainService getRemainDays() usedVacationDaysList : " + usedVacationDaysList + CC.RESET);
    	
    	// 3. 기준연차에서 사용내역만큼 차감 - remainDays
    	for (Double usedDays : usedVacationDaysList) {
    		remainDays -= usedDays;
    	}
    	log.debug(CC.HE + "VactionRemainService getRemainDays() 남은 연차 일수 : " + remainDays + "개" + CC.RESET);
		
		return remainDays;
	}

	/*
		남은 보상휴가 일수
		보상휴가의 유효기간은 1년이므로 오늘 날짜부터 1년동안의 보상휴가 내역을 조회합니다.
		-> vacation_history 테이블을 조회하여 지급 내역과 차감 내역을 계산합니다.
		-> createdate을 기준으로 P는 더하고 M은 차감하여 집계함수 SUM을 이용해 계산합니다.
	*/
	
	// 남은 보상휴가 일수 구하기
	public int getRemainRewardDays(int empNo) {
		int remainRewardDays = vacationRemainMapper.getRemainRewardVacationDays(empNo);
		log.debug(CC.HE + "VactionRemainService getRemainRewardDays() 남은 보상휴가 일수 : " + remainRewardDays + "개" + CC.RESET);
	
		return remainRewardDays;
	}

}
