package com.fit.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.CommonPagingService;
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
	
	@Autowired
	private CommonPagingService commonPagingService;
	
	// 달력페이지를 요청받았을 때 실행된다.
	@GetMapping("/schedule/schedule")
	public String schedule(Model model
			, @RequestParam(name = "tabCategory", required = false, defaultValue = "") String tabCategory
			) {
		
		// 예약리스트와 일정리스트 변수 초기화
		List<Schedule> scheduleList = null;
		List<ReservationDto> reservationList = null;
		
		// view에서 탭을 통해 tabCategory라는 변수를 입력받아서 조건문에 따라 특정 리스트만 출력되도록 분기함.
		if ("일정".equals(tabCategory)) {
		       // 일정일 경우 일정 리스트만 조회
		       scheduleList = scheduleService.getScheduleListByPage(null);
		   } else if ("예약".equals(tabCategory)) {
		       // 예약일 경우 예약 리스트만 조회
		       reservationList = reservationService.getReservationListByPage(null);
		   } else {
		       // 그 외 (전체) 경우 모두 조회
		       scheduleList = scheduleService.getScheduleListByPage(null);
		       reservationList = reservationService.getReservationListByPage(null);
		   }
		
		// 일반적으로 스프링 프레임워크는 Jackson 라이브러리를 사용하여 자동으로 Java 객체를 JSON 형식으로 변환이 가능하다.
		// @ResponseBody 또는 ResponseEntity 타입을 반환하는 경우에 이 기능이 활성화된다.
		// FullCalendar과 같이 클라이언트 사이드 라이브러리가 특정 형식의 JSON 문자열을 요구하는 경우에는 직접 문자열로 변환해야 좋을 수 있으므로 JSON 라이브러리를 추가하고 직접 변환하여 view로 전달한다.
		
		// 일정 이벤트 리스트 생성
		// FullCalendar에 전달할 '일정' 이벤트 목록을 저장할 JSONArray를 생성
	    JSONArray scheduleEvents = new JSONArray();
	    // 입력받은 날짜/시간 문자열의 형식을 정의하는 SimpleDateFormat 객체를 생성
	    SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    // 출력할 날짜/시간 문자열의 형식 (ISO 8601) 을 정의하는 SimpleDateFormat 객체를 생성
	    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	    // null일 경우 에러가 뜨므로 방지
	    if (scheduleList != null) {
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
	            event.put("className", "bg-info");
	            // 생성된 이벤트 객체를 '일정' 이벤트 목록에 추가
	            scheduleEvents.put(event);
	    	}
	    }
    	
    	// 예약 이벤트 리스트 생성
    	JSONArray reservationEvents = new JSONArray();
    	// null일 경우 에러가 뜨므로 방지
    	if (reservationList != null) {
	    	for (ReservationDto reservationDto : reservationList) {
	    	    if (reservationDto.getStartDateTime() != null && reservationDto.getEndDateTime() != null) {
	    	        JSONObject event = new JSONObject();
	    	        
	    	        // 예약 타입에 따라 제목과 CSS 클래스 설정
	    	        String title;
	    	        String clazz;
	    	        if ("차량".equals(reservationDto.getUtilityCategory())) {
	    	            title = "차량 예약";
	    	            clazz = "bg-warning";
	    	        } else if ("회의실".equals(reservationDto.getUtilityCategory())) {
	    	            title = "회의실 예약";
	    	            clazz = "bg-success";
	    	        } else {
	    	            title = "예약";  // 기본값
	    	            clazz = "bg-info";  // 기본값
	    	        }
	    	        
	    	        event.put("title", title);
	    	        // ISO 8601 형식의 문자열로 변환하기 위해 toString 메서드 사용 -> FullCalendar는 ISO 8601 형식의 문자열을 받아들임
	    	        event.put("start", reservationDto.getStartDateTime().toString());
	    	        event.put("end", reservationDto.getEndDateTime().toString());
	    	        event.put("allDay", false);
	    	        event.put("className", clazz);
	    	        reservationEvents.put(event);
	    	    }
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
	
	// 월별 달력에서 해당 날짜를 클릭했을 때 동작하는 메서드
	@GetMapping("/schedule/scheduleDay")
	public String getScheduleReservationDay(@RequestParam(name = "date") @DateTimeFormat(pattern="yyyy-MM-dd") LocalDate date, Model model) {
		
		// date에 해당하는 일정 리스트를 반환
		List<Schedule> scheduleByDay = scheduleService.getSchedulesByDate(date);
       
		// date에 해당하는 예약 리스트를 반환
		List<ReservationDto> reservationByDay = reservationService.getReservationByDate(date);
		
		// 디버깅
		log.debug(CC.YOUN+"ScheduleController.getScheduleReservationDay() scheduleByDay: "+scheduleByDay+CC.RESET);
		log.debug(CC.YOUN+"ScheduleController.getScheduleReservationDay() reservationByDay: "+reservationByDay+CC.RESET);
       
		model.addAttribute("scheduleByDay", scheduleByDay);
		model.addAttribute("reservationByDay", reservationByDay);
		model.addAttribute("date", date);
		
		return "schedule/scheduleDay";
    }
	
	// 월별 달력에서 일정추가 태그를 눌렀을 경우 동작하는 메서드
	@GetMapping("/schedule/addSchedule")
	public String addSchedule(HttpSession session) {
		
		return "/schedule/addSchedule";
	}
	
	@PostMapping("/schedule/addSchedule")
	public String addUtility(HttpSession session, Schedule schedule) {
		
		// 입력유무를 확인
		int row = scheduleService.addSchedule(schedule);
		
		if(row == 1) {
			// 디버깅
			// 일정 추가시 세션에 값을 저장 후 view 페이지에서 조건 분기로 처리 후 세션값을 삭제한다.
			log.debug(CC.YOUN+"scheduleController.addSchedule() row: "+row+CC.RESET);
			session.setAttribute("result", "insert");
			return "redirect:/schedule/scheduleList";
		} else {
			// 디버깅
			// 일정 추가 실패시 세션에 값을 저장 후 view 페이지에서 조건 분기로 처리 후 세션값을 삭제한다.
			log.debug(CC.YOUN+"scheduleController.addSchedule() row: "+row+CC.RESET);
			session.setAttribute("result", "fail");
			return "redirect:/schedule/scheduleList";
		}
	}
	
	// view의 예약리스트 페이지로부터 각종 검색조건에 필요한 파라미터들을 받는다
	@GetMapping("/schedule/scheduleList")
	public String scheduleList(Model model, HttpSession session
			, @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
			, @RequestParam(name = "rowPerPage", required = false, defaultValue = "10") int rowPerPage
			, @RequestParam(name = "startDate", required = false, defaultValue = "") String startDate
			, @RequestParam(name= "endDate", required = false, defaultValue = "") String endDate
			, @RequestParam(name= "searchCol", required = false, defaultValue = "") String searchCol
			, @RequestParam(name= "searchWord", required = false, defaultValue = "") String searchWord
			, @RequestParam(name= "col", required = false, defaultValue = "") String col
			, @RequestParam(name= "ascDesc", required = false, defaultValue = "") String ascDesc
			) {
		
		// 넘어온값 디버깅
		log.debug(CC.YOUN+"scheduleController.scheduleList() currentPage: "+currentPage+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() rowPerPage: "+rowPerPage+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() startDate: "+startDate+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() endDate: "+endDate+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() searchCol: "+searchCol+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() searchWord: "+searchWord+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() col: "+col+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() ascDesc: "+ascDesc+CC.RESET);
		
		// 조건에 따른 전체 행 개수를 출력하는 메서드에 줄 매개변수값을 저장할 Map 생성
		// Mapper에 조건식에 사용될 변수들을 넣어준다.
		Map<String, Object> countParam = new HashMap<>();
		countParam.put("startDate", startDate);
		countParam.put("endDate", endDate);
		countParam.put("searchWord", searchWord);
		countParam.put("searchCol", searchCol);
		
		// 조건에 따라 해당하는 리스트를 출력하는 메서드에 줄 매개변수값을 저장할 Map 생성
		// Mapper에 조건식에 사용될 변수들을 넣어준다.
		Map<String, Object> listParam = new HashMap<>();
		listParam.put("startDate", startDate);
		listParam.put("endDate", endDate);
		listParam.put("searchWord", searchWord);
		listParam.put("searchCol", searchCol);
		listParam.put("col", col);
		listParam.put("ascDesc", ascDesc);
		listParam.put("rowPerPage", rowPerPage);
		// 컨트롤러에서는 현재 페이지값을 맵으로 넣고 서비스단에서 beginRow값을 계산한후 Map에 다시 넣어서 완성된 Map을 Mapper에 넘긴다.
		listParam.put("currentPage", currentPage);
		
		// 각 조건에 따른 전체 행 개수 
		int totalCount = scheduleService.getScheduleCount(countParam);
		// 마지막 페이지 계산 -> 공통 페이징 메서드를 사용한다.
		int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage);
		// 페이지네이션에 표기될 쪽 개수
		int pagePerPage = 5;
		// 페이지네이션에서 사용될 가장 작은 페이지 범위 -> 공통 페이징 메서드를 사용한다.
		int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
		// 페이지네이션에서 사용될 가장 큰 페이지 범위 -> 공통 페이징 메서드를 사용한다.
		int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
		
		// 일정 리스트 출력 
		List<Schedule> scheduleList = scheduleService.getScheduleListByPage(listParam);
		
		// 디버깅
		log.debug(CC.YOUN+"scheduleController.scheduleList() scheduleList: "+scheduleList+CC.RESET);
		
		// 페이징에 필요한 값 모델로 view에 넘김
		model.addAttribute("scheduleList", scheduleList);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("pagePerPage", pagePerPage);
		model.addAttribute("minPage", minPage);
		model.addAttribute("maxPage", maxPage);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("searchWord", searchWord);
		model.addAttribute("searchCol", searchCol);
		model.addAttribute("col", col);
		model.addAttribute("ascDesc", ascDesc);
		
		// 디버깅
		log.debug(CC.YOUN+"scheduleController.scheduleList() model.getAttribute(\"currentPage\"): "+model.getAttribute("currentPage")+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() model.getAttribute(\"lastPage\"): "+model.getAttribute("lastPage")+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() model.getAttribute(\"minPage\"): "+model.getAttribute("minPage")+CC.RESET);
		log.debug(CC.YOUN+"scheduleController.scheduleList() model.getAttribute(\"maxPage\"): "+model.getAttribute("maxPage")+CC.RESET);
		
		// 이동할 해당 뷰 페이지를 작성한다.
		return "/schedule/scheduleList";
	}
	
	
	// view로부터 체크된 항목에 대한 값을 매개값으로 해당 항목에 해당하는 공용품 게시글을 삭제
	@PostMapping("/schedule/delete")
    public String deleteSelectedSchedules(HttpSession session
    		,	// 선택된 체크박스의 공용품 번호를 리스트 형식으로 매개값을 받는다.
    			@RequestParam(value = "selectedItems", required = false) List<Long> selectedItems) {
		
		// 삭제 유무를 확인
		int row = 0;
		
		// 체크박스를 선택한 값이 있다면
        if (selectedItems != null && !selectedItems.isEmpty()) {
        	// 체크된 매개값을 해당하는 공용품 번호에 매칭하여 삭제하는 메서드 동작
            for (Long scheduleNo : selectedItems) {
            	// 서비스단의 공용품글과 파일을 동시에 삭제하는 메서드 실행
                row = scheduleService.removeSchedule(scheduleNo);
            }
        }
        
        if(row >= 1) {
			// 디버깅
			// 일정 삭제시 세션에 값을 저장 후 view 페이지에서 조건 분기로 처리 후 세션값을 삭제한다.
			log.debug(CC.YOUN+"scheduleController.deleteSelectedSchedules() row: "+row+CC.RESET);
			session.setAttribute("result", "delete");
			return "redirect:/schedule/scheduleList";
		} else {
			// 디버깅
			// 일정 삭제 실패시 세션에 값을 저장 후 view 페이지에서 조건 분기로 처리 후 세션값을 삭제한다.
			log.debug(CC.YOUN+"scheduleController.deleteSelectedSchedules() row: "+row+CC.RESET);
			session.setAttribute("result", "fail");
			return "redirect:/schedule/scheduleList";
		}
    }
}
