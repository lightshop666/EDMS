package com.fit.mapper;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.ReservationDto;
import com.fit.vo.Schedule;


@Mapper
public interface ReservationMapper {
	
	// param : Map<String, Object> map -> int beginRow int rowPerPage
	// 각 검색 조건에 따른 행의 내용 조회 -> reservation, emp_info, utility 3개의 테이블 조인
	List<ReservationDto> selectReservationListByPage(Map<String, Object> listParam);
	
	// 각 검색 조건에 따른 전체 행의 수 정수형으로 출력
	int selectReservationCount(Map<String, Object> countParam);
	
	// 예약 추가
	int insertReservation(ReservationDto reservationDto);
	
	// 예약 삭제
	int deleteReservation(Long reservationNo);
	
	// 예약 신청시 차량 중복검사하는 메서드
	int selectCarChk(Map<String, Object> carChkParam);
	
	// 예약 신청시 회의실 중복검사하는 메서드
	int selectMeetingChk(Map<String, Object> meetingChkParam);
	
	// 예약 테이블에서 날짜를 찾는 메서드
	List<ReservationDto> findByReservationDate(LocalDate date);
}
