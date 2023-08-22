package com.fit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.CC;
import com.fit.mapper.ReservationMapper;
import com.fit.vo.Reservation;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class ReservationService {
	
	@Autowired
	private ReservationMapper reservationMapper;
	
	// 컨트롤러로부터 paramMap 타입으로 필요한 검색조건 매개변수들을 받아 예약 리스트 출력
	public List<Reservation> getReservationListByPage(Map<String, Object> listParam) {
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getReservationListByPage() listParam: "+listParam+CC.RESET);
		
		// map으로부터 값 꺼내서 넣기
		int currentPage = 1;
		
		// Map에 들어있는 currentPage, rowPerPage 값이 없을경우 NullPointException 에러가 발생하므로 키값이 존재할 경우에만 값을 넣어주겠다.
		if(listParam.containsKey("currentPage")) {
			currentPage = (int)listParam.get("currentPage");
		}
		
		int rowPerPage = 10;
		if(listParam.containsKey("rowPerPage")) {
			rowPerPage = (int)listParam.get("rowPerPage");
		}
		
		// 컨트롤러로부터 받은 값을 계산하여 다시 컨트롤러로 반환
		int beginRow = (currentPage - 1) * rowPerPage;
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getReservationListByPage() beginRow: "+beginRow+CC.RESET);
		
		listParam.put("beginRow", beginRow);
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getReservationListByPage() listParam: "+listParam+CC.RESET);
		
		/*
		// Map 타입으로 저장
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("startDate", startDate);
		paramMap.put("endDate", endDate);
		paramMap.put("searchCol", searchCol);
		paramMap.put("searchWord", searchWord);
		paramMap.put("col", col);
		paramMap.put("ascDesc", ascDesc);
		paramMap.put("beginRow", beginRow);
		paramMap.put("rowPerPage", rowPerPage);
		*/
		
		// DB에서 페이지별 예약 리스트 조회
		List<Reservation> reservationList = reservationMapper.selectReservationListByPage(listParam);
		
		// 리스트 반환 
		return reservationList;
	}
	
	// 검색 조건별 행의 개수 가져오는 메서드 
	public int getReservationCount(Map<String, Object> countParam) {
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getReservationListByPage() countParam: "+countParam+CC.RESET);
		
        return reservationMapper.selectReservationCount(countParam);
    }
	
	// lastPage를 구하는 메서드
	public int getLastPage(int totalCount, int rowPerPage) {
		int lastPage = totalCount / rowPerPage;
		if(totalCount % rowPerPage != 0) {
			lastPage = lastPage + 1;
		}
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getLastPage() lastPage: "+lastPage+CC.RESET);
		
        return lastPage;
    }
	
	// minPage를 구하는 메서드
	public int getMinPage(int currentPage, int pagePerPage) {
		int minPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getMinPage() minPage: "+minPage+CC.RESET);
		
		return minPage;
	}
	
	// maxPage를 구하는 메서드
	public int getMaxPage(int minPage, int pagePerPage, int lastPage) {
		int maxPage = minPage + (pagePerPage - 1);
		
		// 최대 페이지가 마지막페이지를 넘어가지 못하도록 제한
		if (maxPage > lastPage) {
			maxPage = lastPage;
		}
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getMaxPage() maxPage: "+maxPage+CC.RESET);
		
		return maxPage;
	}
	
	// 예약 추가 메서드
	public int addReservation(Reservation reservation) {
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.addReservation() reservation: "+reservation+CC.RESET);
		
		// 예약 성공 여부 확인을 위한 row 반환
		int row = reservationMapper.insertReservation(reservation);
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.addReservation() row: "+row+CC.RESET);
		
		// row값 반환하여 컨트롤러단에서 예약신청 성공 및 실패 여부 확인
		return row;
	}
	
	// 예약 삭제 메서드
	public int removeReservation(Long reservationNo) {
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.removeReservation() reservationNo: "+reservationNo+CC.RESET);
		
		// 예약을 삭제
		int row = reservationMapper.deleteReservation(reservationNo);
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.removeReservation() reservationNo: "+reservationNo+CC.RESET);
		
		// row값 반환하여 컨트롤러단에서 예약취소 성공 및 실패 여부 확인
		return row;
	}
}
