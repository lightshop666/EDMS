package com.fit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.CommonPagingService;
import com.fit.service.VacationPaymentService;
import com.fit.service.VacationService;
import com.fit.vo.Approval;
import com.fit.vo.VacationHistory;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class VacationController {
	@Autowired
	private VacationService vacationService;
	@Autowired CommonPagingService commonPagingService;	

	@Autowired
	private VacationPaymentService vacationPaymentService;  


    @GetMapping("/vacation/vacationHistory")
    public String getVacationHistoryList(
    		Model model, HttpSession session
    		, @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
    		, @RequestParam(name = "rowPerPage", required = false, defaultValue = "10") int rowPerPage
    		, @RequestParam(name = "startDate", required = false, defaultValue = "") String startDate
    		, @RequestParam(name= "endDate", required = false, defaultValue = "") String endDate
    		, @RequestParam(name= "searchCol", required = false, defaultValue = "") String searchCol
    		, @RequestParam(name= "searchWord", required = false, defaultValue = "") String searchWord
    		, @RequestParam(name= "col", required = false, defaultValue = "") String col
    		, @RequestParam(name= "ascDesc", required = false, defaultValue = "") String ascDesc
    		, @RequestParam(required = false) String vacationName
    		) {

    	int empNo = (int) session.getAttribute("loginMemberId");
        log.debug(CC.JUNG + "[DEBUG] getVacationHistoryList() Start" + CC.RESET);
        log.debug("currentPage: " + currentPage + ", empNo: " + empNo + ", startDate: " + startDate + ", endDate: " + endDate +
                  ", col: " + col + ", ascDesc: " + ascDesc + ", vacationName: " + vacationName);
	    
	 // 검색 조건을 포함한 목록을 가져오도록 수정
	    Map<String, Object> filterParams = new HashMap<>();
	    filterParams.put("startDate", startDate);
	    filterParams.put("endDate", endDate);
	    filterParams.put("col", col);
	    filterParams.put("vacationName", vacationName);
	    filterParams.put("ascDesc", ascDesc);
	    filterParams.put("searchCol", searchCol);
	    filterParams.put("searchWord", searchWord);
	    filterParams.put("beginRow", (currentPage - 1) * rowPerPage); // 시작 행
	    filterParams.put("rowPerPage", rowPerPage); //
	    
	    // 페이징 처리를 위한 필요한 변수들 계산
	    int totalCount = vacationService.getTotalHistoryCount(filterParams,empNo); // 전체 게시물 수
	    int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage); // 마지막 페이지
	    int pagePerPage = 5;
	    int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
	    int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
	    
	    List<VacationHistory> vacationHistoryList = vacationService.getFilteredHistory(filterParams, empNo);
	    model.addAttribute("vacationHistoryList", vacationHistoryList);
	    model.addAttribute("currentPage", currentPage);
	    model.addAttribute("minPage", minPage);
	    model.addAttribute("maxPage", maxPage);
	    model.addAttribute("lastPage", lastPage);
	    model.addAttribute("empNo", empNo);

        log.debug(CC.JUNG + "[DEBUG] getVacationHistoryList() End" + CC.RESET);

        return "/vacation/vacationHistory";
    }
    
    
    @GetMapping("/vacation/adminAddVacation")
    public String getVacationForm(
            @RequestParam int empNo,
            Model model) {
        model.addAttribute("empNo", empNo);
        return "/vacation/adminAddVacation";
    }

    @PostMapping("/adminAddVacation")
    public String processVacation(
            @RequestParam int empNo,
            @RequestParam String vacationName,
            @RequestParam String vacationPm,
            @RequestParam int vacationDays) {

    	 vacationPaymentService.addVacation(empNo, vacationName, vacationPm, vacationDays);
        
        // 휴가 추가 후에 필요한 작업 수행 (예: 휴가 내역 다시 조회 등)

        return "redirect:/vacation/vacationHistory";
    }
}