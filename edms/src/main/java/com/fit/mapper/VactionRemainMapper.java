package com.fit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VactionRemainMapper {
	// 연차 또는 반차 사용내역 조회
	List<Double> getUsedVacationDays(int empNo, String recentVacationDate); // 사원번호, 최근 연차 발생일
	
	// 남은 보상 휴가 일수 계산
	Integer getRemainRewardVacationDays(int empNo);
}
