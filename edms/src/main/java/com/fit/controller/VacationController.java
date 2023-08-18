package com.fit.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.VacationPaymentService;
import com.fit.service.VacationService;
import com.fit.vo.VacationHistory;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class VacationController {
	@Autowired
	private VacationService vacationService;

	@Autowired
	private VacationPaymentService vacationPaymentService;  


    @GetMapping("/vacationHistory")
    public String getVacationHistoryList(
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam (required = false, defaultValue = "1000000") int empNo,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String col,
            @RequestParam(required = false) String ascDesc,
            @RequestParam(required = false) String vacationName,
            Model model) {

        log.debug(CC.JUNG + "[DEBUG] getVacationHistoryList() Start" + CC.RESET);
        log.debug("currentPage: " + page + ", empNo: " + empNo + ", startDate: " + startDate + ", endDate: " + endDate +
                  ", col: " + col + ", ascDesc: " + ascDesc + ", vacationName: " + vacationName);

        // 휴가 내역 리스트 조회
        Map<String, Object> resultMap = vacationService.getVacationHistoryList(
                page, empNo, startDate, endDate, col, ascDesc, vacationName);

        List<VacationHistory> vacationHistoryList = (List<VacationHistory>) resultMap.get("vacationHistoryList");

        int minPage = (int) resultMap.get("minPage");
        int maxPage = (int) resultMap.get("maxPage");

        model.addAttribute("vacationHistoryList", vacationHistoryList);


        model.addAttribute("minPage", minPage);
        model.addAttribute("maxPage", maxPage);

        // 기존 파라미터들도 모델에 추가
        model.addAttribute("empNo", empNo);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("col", col);
        model.addAttribute("ascDesc", ascDesc);
        model.addAttribute("vacationName", vacationName);

        log.debug(CC.JUNG + "[DEBUG] getVacationHistoryList() End" + CC.RESET);

        return "/vacation/vacationHistory";
    }


    @PostMapping("/vacationHistory")
    public String postVacationHistoryList(
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam (required = false, defaultValue = "1000000") int empNo,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String col,
            @RequestParam(required = false) String ascDesc,
            @RequestParam(required = false) String vacationName,
            Model model) {

        return "redirect:/vacationHistory?page=" + page + "&empNo=" + empNo + "&startDate=" + startDate
                + "&endDate=" + endDate + "&col=" + col + "&ascDesc=" + ascDesc + "&vacationName=" + vacationName;
    }
    
    
    @GetMapping("/adminAddVacation")
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
        // ...

        return "redirect:/vacationHistory";
    }
}