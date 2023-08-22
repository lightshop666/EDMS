package com.fit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.CommonPagingService;
import com.fit.service.ReservationService;
import com.fit.vo.ReservationDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ReservationController {
	
	@Autowired
	private ReservationService reservationService;
	
	@Autowired
	private CommonPagingService commonPagingService;
	
	@GetMapping("/reservation/addReservation")
	public String addReservation(HttpSession session) {
		
		return "/reservation/addReservation";
	}
	
	@PostMapping("/reservation/addReservation")
	public String addReservation(HttpSession session, ReservationDto reservationDto, HttpServletRequest request) {
		
		// 입력유무를 확인
		int row = reservationService.addReservation(reservationDto);
		
		if(row == 1) {
			// 디버깅
			// 예약 신청 성공시 리스트로
			log.debug(CC.YOUN+"utilityController.addUtility() row: "+row+CC.RESET);
			return "redirect:/reservation/reservationList";
		} else {
			// 디버깅
			// 예약 신청 실패시 fail을 매개변수로 view에 전달
			log.debug(CC.YOUN+"utilityController.addUtility() row: "+row+CC.RESET);
			return "redirect:/reservation/reservationList?result=fail";
		}
	}
	
	// view의 예약리스트 페이지로부터 각종 검색조건에 필요한 파라미터들을 받는다
	@GetMapping("/reservation/reservationList")
	public String reservationList(Model model, HttpSession session
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
		log.debug(CC.YOUN+"reservationController.reservationList() currentPage: "+currentPage+CC.RESET);
		log.debug(CC.YOUN+"reservationController.reservationList() rowPerPage: "+rowPerPage+CC.RESET);
		log.debug(CC.YOUN+"reservationController.reservationList() startDate: "+startDate+CC.RESET);
		log.debug(CC.YOUN+"reservationController.reservationList() endDate: "+endDate+CC.RESET);
		log.debug(CC.YOUN+"reservationController.reservationList() searchCol: "+searchCol+CC.RESET);
		log.debug(CC.YOUN+"reservationController.reservationList() searchWord: "+searchWord+CC.RESET);
		log.debug(CC.YOUN+"reservationController.reservationList() col: "+col+CC.RESET);
		log.debug(CC.YOUN+"reservationController.reservationList() ascDesc: "+ascDesc+CC.RESET);
		
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
		int totalCount = reservationService.getReservationCount(countParam);
		// 마지막 페이지 계산 -> 공통 페이징 메서드를 사용한다.
		int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage);
		// 페이지네이션에 표기될 쪽 개수
		int pagePerPage = 5;
		// 페이지네이션에서 사용될 가장 작은 페이지 범위 -> 공통 페이징 메서드를 사용한다.
		int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
		// 페이지네이션에서 사용될 가장 큰 페이지 범위 -> 공통 페이징 메서드를 사용한다.
		int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
		
		// 예약 리스트 출력 -> join을 통해 사원명과 공용품 종류를 같이 조회
		List<ReservationDto> reservationList = reservationService.getReservationListByPage(listParam);
		
		// 디버깅
		log.debug(CC.YOUN+"reservationController.reservationList() reservationList: "+reservationList+CC.RESET);
		
		// 페이징에 필요한 값 모델로 view에 넘김
		model.addAttribute("reservationList", reservationList);
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
		
		// 이동할 해당 뷰 페이지를 작성한다.
		return "/reservation/reservationList";
	}
}
