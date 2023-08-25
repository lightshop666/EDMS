package com.fit.mapper;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Schedule;

@Mapper
public interface ScheduleMapper {
	
	// 페이징 및 검색조건에 따른 일정리스트를 출력할 메서드
	List<Schedule> selectScheduleListByPage(Map<String, Object> listParam);
	
	// 검색조건에 따른 행의 개수를 출력할 메서드
	int selectScheduleCount(Map<String, Object> countParam);
	
	// 예약 테이블에서 날짜를 찾는 메서드
	List<Schedule> findByScheduleDate(LocalDate date);
	 
	// 예약 추가 메서드
}
