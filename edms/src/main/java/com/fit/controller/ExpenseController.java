package com.fit.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.mapper.DraftMapper;
import com.fit.service.DraftService;
import com.fit.vo.EmpInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ExpenseController {
 @Autowired DraftService draftService;
    @GetMapping("/expenseDraft")
    public String expenseDraft(Model model) {
        log.debug("[DEBUG] expenseDraft() Start");

        List<EmpInfo> employeeList = draftService.getAllEmp();

        // 사원 리스트 정보를 로그로 출력
        for (EmpInfo emp : employeeList) {
            log.debug(CC.JUNG+"[DEBUG] Employee: {}"+ CC.RESET, emp);
        }

        model.addAttribute("employeeList", employeeList);
        return "draft/expenseDraft";
    }
    
    @PostMapping("/expenseDraft")
    public String submitExpense(@RequestParam Map<String, Object> submissionData, 
                                @RequestParam(value = "recipients[]", required = false) int[] selectedRecipientsIds,
                                Model model) {
        log.debug("제출 데이터: {}", submissionData);

        int result = draftService.processExpenseSubmission(submissionData, selectedRecipientsIds);

        if (result == 1) {
            // 성공적인 경우 처리 (예: 리다이렉트)
            return "redirect:/home";
        } else {
            // 실패한 경우 처리 (예: 에러 메시지 전달)
            String errorMessage = "지출 제출 실패";
            model.addAttribute("errorMessage", errorMessage);
            return "/draft/expenseDraft";
        }
    }
}