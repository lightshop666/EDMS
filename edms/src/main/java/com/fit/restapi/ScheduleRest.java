/*
package com.fit.restapi;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.fit.CC;
import com.fit.service.ReservationService;
import com.fit.service.ScheduleService;
import com.fit.vo.ReservationDto;
import com.fit.vo.Schedule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class ScheduleRest {
	
	@Autowired
	private ScheduleService scheduleService;
	
	@Autowired
	private ReservationService reservationService;
	
	// 달력 페이지를 요청받았을때 실행된다.
	@GetMapping("/schedule/schedule")
	public ModelAndView scheduleCalendar() {
		
		// view에 보낼 리스트를 담을 객체 생성
		ModelAndView mav = new ModelAndView("/schedule/schedule");
		
		
		// 예약리스트와 일정리스트를 조회
		List<Schedule> scheduleList = scheduleService.getScheduleListByPage(null);
		List<ReservationDto> reservationList = reservationService.getReservationListByPage(null);
		
		// 디버깅
		log.debug(CC.YOUN+"ScheduleRest.scheduleCalendar() scheduleList: "+scheduleList+CC.RESET);
		log.debug(CC.YOUN+"ScheduleRest.scheduleCalendar() reservationList: "+reservationList+CC.RESET);
		
		
		// 객체에 리스트값을 넣음
		mav.addObject("scheduleList", scheduleList);
		mav.addObject("reservationList", reservationList);
		
		// 객체를 전달
		return mav;
	}
}
*/