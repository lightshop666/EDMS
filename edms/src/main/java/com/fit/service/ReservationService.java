package com.fit.service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.CC;
import com.fit.mapper.ReservationMapper;
import com.fit.mapper.UtilityMapper;
import com.fit.vo.ReservationDto;
import com.fit.vo.UtilityDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class ReservationService {
	
	@Autowired
	private ReservationMapper reservationMapper;
	
	@Autowired
	private UtilityMapper utilityMapper;
	
	// 컨트롤러로부터 paramMap 타입으로 필요한 검색조건 매개변수들을 받아 예약 리스트 출력
	public List<ReservationDto> getReservationListByPage(Map<String, Object> listParam) {
		
		// 널포인트익셉션 에러를 해결하기 위한 객체 생성 -> 달력출력시 null값이 입력되므로 처리
		if (listParam == null) {
			listParam = new HashMap<>();
			listParam.put("startRow", 0); // 시작 페이지를 0으로 설정
		    listParam.put("rowPerPage", 10); // 한 페이지당 행 수를 10으로 설정
		}
		
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
		
		// DB에서 페이지별 예약 리스트 조회
		List<ReservationDto> reservationList = reservationMapper.selectReservationListByPage(listParam);
		
		// 리스트 반환 
		return reservationList;
	}
	
	// 검색 조건별 행의 개수 가져오는 메서드 -> 검색조건중 시작날짜, 종료일자, 검색할 컬럼명, 검색할 단어를 매개변수로 넣어준다.(Map 타입)
	public int getReservationCount(Map<String, Object> countParam) {
		
		int totalCount = reservationMapper.selectReservationCount(countParam);
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getReservationCount() countParam: "+countParam+CC.RESET);
		
        return totalCount;
    }
	
	// 예약 추가 메서드
	public int addReservation(ReservationDto reservationDto) {
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.addReservation() reservationDto: "+reservationDto+CC.RESET);
		
		// 예약 성공 여부 확인을 위한 row 반환
		int row = reservationMapper.insertReservation(reservationDto);
		
		// row값 반환하여 컨트롤러단에서 예약신청 성공 및 실패 여부 확인
		return row;
	}
	
	// 예약 삭제 메서드
	public int removeReservation(Long reservationNo) {
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.removeReservation() reservationNo: "+reservationNo+CC.RESET);
		
		// 예약을 삭제
		int row = reservationMapper.deleteReservation(reservationNo);
		
		// row값 반환하여 컨트롤러단에서 예약취소 성공 및 실패 여부 확인
		return row;
	}
	
	// 공용품 카테고리를 입력받아서 해당하는 공용품 번호를 리스트 형식으로 출력한다.
	public List<UtilityDto> getUtilityByCategory(String utilityCategory) {
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getUtilityNoByCategory() utilityCategory: "+utilityCategory+CC.RESET);
		
		// 해당 카테고리에 포함된 공용품 번호를 출력
		List<UtilityDto> utilities = utilityMapper.selectUtilityByCategory(utilityCategory);
		
		return utilities;
	}
	
	// 예약일, 공용품 번호, 사원 번호를 입력받아서 차량 중복검사를 진행
	public int getCarChk(Map<String, Object> carChkParam) {
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getCarChk() carChkParam: "+carChkParam+CC.RESET);
		
		// Mapper를 통해 중복체크 여부를 반환받음 1 - 중복, 0 - 비중복
		int row = reservationMapper.selectCarChk(carChkParam);
		
		return row;
	}
	
	// 예약일, 예약시간, 공용품 번호, 사원 번호를 입력받아서 회의실 중복검사를 진행
	public int getMeetingChk(Map<String, Object> meetingChkParam) {
		
		// 디버깅
		log.debug(CC.YOUN+"reservationService.getMeetingChk() meetingChkParam: "+meetingChkParam+CC.RESET);
		
		// Mapper를 통해 중복체크 여부를 반환받음 1 - 중복, 0 - 비중복
		int row = reservationMapper.selectMeetingChk(meetingChkParam);
		
		return row;
	}
	
	// 날짜별 조회된 일정 목록을 반환
    public List<ReservationDto> getReservationByDate(LocalDate date) {
    	
    	List<ReservationDto> reservationByDay = reservationMapper.findByReservationDate(date);
    	
        return reservationByDay;
    }
	
	
}
