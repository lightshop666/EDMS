package com.fit.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fit.CC;
import com.fit.service.ReservationService;
import com.fit.service.ScheduleService;
import com.fit.vo.ReservationDto;
import com.fit.vo.Schedule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ScheduleController {
	
	@Autowired
	private ScheduleService scheduleService;
	
	@Autowired
	private ReservationService reservationService;
	
	// 달력페이지를 요청받았을 때 실행된다.
	@GetMapping("/schedule/schedule")
	public String schedule(Model model) {
		
		// 예약리스트와 일정리스트를 조회 -> 파라미터에 넘긴 값이 없으므로 null값 전달
		List<Schedule> scheduleList = scheduleService.getScheduleListByPage(null);
		List<ReservationDto> reservationList = reservationService.getReservationListByPage(null);
		
		// 일정 이벤트 리스트 생성
		// FullCalendar에 전달할 '일정' 이벤트 목록을 저장할 JSONArray를 생성
	    JSONArray scheduleEvents = new JSONArray();
	    // 입력받은 날짜/시간 문자열의 형식을 정의하는 SimpleDateFormat 객체를 생성
	    SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    // 출력할 날짜/시간 문자열의 형식 (ISO 8601) 을 정의하는 SimpleDateFormat 객체를 생성
	    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	    // 각 '일정'에 대해 JSONObject (event) 를 만들고 그 안에 필요한 정보 (제목, 시작/종료 시간 등) 를 넣기
    	for (Schedule schedule : scheduleList) {
            JSONObject event = new JSONObject();
            event.put("title", schedule.getScheduleContent());
            // 날짜/시간 문자열을 파싱하거나 포매팅 할 때 오류가 발생할 수 있으므로 try-catch 구문으로 에러 처리
            try {
				Date startTime = inputFormat.parse(schedule.getScheduleStartTime());
				Date endTime = inputFormat.parse(schedule.getScheduleEndTime());
				event.put("start", outputFormat.format(startTime));
				event.put("end", outputFormat.format(endTime));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            // '하루 종일' 옵션은 false로 설정
            event.put("allDay", false);
            // 이벤트에 적용할 CSS 클래스를 설정
            event.put("clazz", "bg-blue");
            // 생성된 이벤트 객체를 '일정' 이벤트 목록에 추가
            scheduleEvents.put(event);
    	}
    	
    	// 예약 이벤트 리스트 생성
    	JSONArray reservationEvents = new JSONArray();
    	for (ReservationDto reservationDto : reservationList) {
    	    if (reservationDto.getStartDateTime() != null && reservationDto.getEndDateTime() != null) {
    	        JSONObject event = new JSONObject();
    	        
    	        // 예약 타입에 따라 제목과 CSS 클래스 설정
    	        String title;
    	        String clazz;
    	        if ("차량".equals(reservationDto.getUtilityCategory())) {
    	            title = "차량 예약";
    	            clazz = "bg-blue";
    	        } else if ("회의실".equals(reservationDto.getUtilityCategory())) {
    	            title = "회의실 예약";
    	            clazz = "bg-red";
    	        } else {
    	            title = "예약";  // 기본값
    	            clazz = "bg-green";  // 기본값
    	        }
    	        
    	        event.put("title", title);
    	        // ISO 8601 형식의 문자열로 변환하기 위해 toString 메서드 사용 -> FullCalendar는 ISO 8601 형식의 문자열을 받아들임
    	        event.put("start", reservationDto.getStartDateTime().toString());
    	        event.put("end", reservationDto.getEndDateTime().toString());
    	        event.put("allDay", false);
    	        event.put("clazz", clazz);
    	        reservationEvents.put(event);
    	    }
    	}

		
		
		// 디버깅
		log.debug(CC.YOUN+"ScheduleController.schedule() scheduleEvents: "+scheduleEvents+CC.RESET);
		log.debug(CC.YOUN+"ScheduleController.schedule() reservationEvents: "+reservationEvents+CC.RESET);
		
		// 모델에 JSON 타입으로 VIEW 페이지로 전달
		model.addAttribute("scheduleEvents", scheduleEvents.toString());
		model.addAttribute("reservationEvents", reservationEvents.toString());
		
		// 뷰 페이지에 객체를 전달
		return "/schedule/schedule";
	}
}
