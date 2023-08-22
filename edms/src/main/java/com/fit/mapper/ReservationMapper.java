package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Reservation;


@Mapper
public interface ReservationMapper {
	
	// param : Map<String, Object> map -> int beginRow int rowPerPage
	// 각 검색 조건에 따른 행의 내용 조회 -> reservation, emp_info, utility 3개의 테이블 조인
	List<Reservation> selectReservationListByPage(Map<String, Object> listParam);
	
	// 각 검색 조건에 따른 전체 행의 수 정수형으로 출력
	int selectReservationCount(Map<String, Object> countParam);
	
	// 예약 추가
	int insertReservation(Reservation reservation);
	
	// 예약 삭제
	int deleteReservation(Long reservationNo);
}
