package com.fit.service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.CC;
import com.fit.mapper.ScheduleMapper;
import com.fit.vo.Schedule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class ScheduleService {
	
	@Autowired
	private ScheduleMapper scheduleMapper;

	// 컨트롤러로부터 paramMap 타입으로 필요한 검색조건 매개변수들을 받아 예약 리스트 출력
	public List<Schedule> getScheduleListByPage(Map<String, Object> listParam) {
		
		// 널포인트익셉션 에러를 해결하기 위한 객체 생성 -> 달력출력시 null값이 입력되므로 처리
		if (listParam == null) {
			listParam = new HashMap<>();
			listParam.put("startRow", 0); // 시작 페이지를 0으로 설정
		    listParam.put("rowPerPage", 10); // 한 페이지당 행 수를 10으로 설정
		}
		
		// 디버깅
		log.debug(CC.YOUN+"ScheduleService.getScheduleListByPage() listParam: "+listParam+CC.RESET);
		
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
		log.debug(CC.YOUN+"ScheduleService.getScheduleListByPage() beginRow: "+beginRow+CC.RESET);
		
		listParam.put("beginRow", beginRow);
		
		// 디버깅
		log.debug(CC.YOUN+"ScheduleService.getScheduleListByPage() listParam: "+listParam+CC.RESET);
		
		// DB에서 페이지별 일정 리스트 조회
		List<Schedule> scheduleList = scheduleMapper.selectScheduleListByPage(listParam);
		
		// 리스트 반환 
		return scheduleList;
	}
		
	// 검색 조건별 행의 개수 가져오는 메서드 -> 검색조건중 시작날짜, 종료일자, 검색할 컬럼명, 검색할 단어를 매개변수로 넣어준다.(Map 타입)
	public int getScheduleCount(Map<String, Object> countParam) {
		
		// 전체행을 계산하여 반환한다.
		int totalCount = scheduleMapper.selectScheduleCount(countParam);
		
		// 디버깅
		log.debug(CC.YOUN+"ScheduleService.getScheduleCount() countParam: "+countParam+CC.RESET);
		
        return totalCount;
    }

	// 날짜별 조회된 일정 목록을 반환
    public List<Schedule> getSchedulesByDate(LocalDate date) {
    	
    	List<Schedule> scheduleByDay = scheduleMapper.findByScheduleDate(date);
    	
        return scheduleByDay;
    }
	
	// 일정추가 메서드
 	public int addSchedule(Schedule schedule) {
 		
 		// 디버깅
 		log.debug(CC.YOUN+"scheduleService.addSchedule() schedule: "+schedule+CC.RESET);
 		
 		// 삽입 여부 확인을 위한 row 반환
 		int row = scheduleMapper.insertSchedule(schedule);
 		
 		// 디버깅
 		log.debug(CC.YOUN+"scheduleService.addSchedule() row: "+row+CC.RESET);
 		
 		return row;
 	}
 	
 	// 일정삭제 - 체크박스를 통한 복수 삭제 메서드
 	public int removeSchedule(Long scheduleNo) {
 		
         // 디버깅
         log.debug(CC.YOUN+"ScheduleService.removeSchedule() scheduleNo: "+scheduleNo+CC.RESET);
         
         // 반환할 row값 생성
         int row = 0;
         
         // 체크박스가 1개라도 선택되서 번호가 입력되는 경우
         if (scheduleNo != null) {
             
         	// 디버깅
            log.debug(CC.YOUN+"ScheduleService.removeSchedule() 삭제할 일정번호:"+scheduleNo+CC.RESET);
         	
     		// 공용품 글을 삭제
     		row = scheduleMapper.deleteSchedule(scheduleNo);
     		
     		// 디버깅
            log.debug(CC.YOUN+"ScheduleService.removeSchedule() 일정 삭제 row:"+row+CC.RESET);
         }
         // row 값 반환
         return row;
     }
}
