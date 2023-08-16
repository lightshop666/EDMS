package com.fit.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.VacationService;
import com.fit.vo.VacationHistory;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class VacationController {

    @Autowired
    private VacationService vacationService;

    @GetMapping("/vacationHistory")
    public String getVacationHistoryList(
            @RequestParam(required = false, defaultValue = "1") int currentPage,
            @RequestParam int empNo,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String vacationName,
            Model model) {

    	int rowPerPage = 10;
        log.debug(CC.JUNG + "[DEBUG] getVacationHistoryList() Start" + CC.RESET);
        log.debug("currentPage: " + currentPage + ", rowPerPage: " + rowPerPage);
        log.debug("empNo: " + empNo + ", startDate: " + startDate + ", endDate: " + endDate + ", vacationName: " + vacationName);

        // 시작 행 계산
        int beginRow = (currentPage - 1) * rowPerPage;

        // 휴가 내역 리스트 조회
        Map<String, Object> resultMap = vacationService.getVacationHistoryList(
                currentPage, rowPerPage, empNo, startDate, endDate, vacationName);

        List<VacationHistory> vacationHistoryList = (List<VacationHistory>) resultMap.get("vacationHistoryList");
        int totalCount = (int) resultMap.get("totalCount");

        log.debug("TotalCount: " + totalCount);

        // 전체 페이지 수 계산
        int lastPage = (int) Math.ceil((double) totalCount / rowPerPage);

        // 한 페이지 당 보여질 쪽 수
        int pagePerPage = 10;

        // 현재 페이지 기준으로 보여질 최소 페이지 번호 계산
        int minPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;

        // 현재 페이지 기준으로 보여질 최대 페이지 번호 계산
        int maxPage = minPage + (pagePerPage - 1);
        if (maxPage > lastPage) {
            maxPage = lastPage;
        }

        model.addAttribute("vacationHistoryList", vacationHistoryList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("maxPage", maxPage);

        model.addAttribute("currentPage", currentPage); // 현재 페이지 번호 추가
        model.addAttribute("minPage", minPage); // 최소 페이지 번호 추가
        model.addAttribute("maxPage", maxPage); // 최대 페이지 번호 추가

        // 기존 파라미터들도 모델에 추가
        model.addAttribute("empNo", empNo);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("vacationName", vacationName);

        log.debug(CC.JUNG + "[DEBUG] getVacationHistoryList() End" + CC.RESET);

        return "/vacation/vacationHistory";
    }
}