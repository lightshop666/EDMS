package com.fit.service;

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
	
	// 일정추가 메서드
	
}
