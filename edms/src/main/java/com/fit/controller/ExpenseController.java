package com.fit.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.mapper.DraftMapper;
import com.fit.service.DraftService;
import com.fit.vo.EmpInfo;
import com.fit.vo.ExpenseDraftContent;

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
    public String submitExpense(@RequestBody Map<String, Object> formData, Model model) {
        log.debug("제출 데이터: {}", formData);

        Boolean isSaveDraft = (Boolean) formData.get("isSaveDraft");
        
        Map<String, Object> submissionData = (Map<String, Object>) formData;
        List<Integer> selectedRecipientsIds = (List<Integer>) formData.get("selectedRecipientsIds");
        List<ExpenseDraftContent> expenseDraftContentList = null;
        // expenseDetails가 null인 경우에만 아래 코드 블록을 실행하지 않도록 체크합니다.
        if (formData.containsKey("expenseDetails") && formData.get("expenseDetails") instanceof List) {
            List<Map<String, Object>> expenseDetails = (List<Map<String, Object>>) formData.get("expenseDetails");

            expenseDraftContentList = new ArrayList<>();
            for (Map<String, Object> expenseDetail : expenseDetails) {
                String expenseCostStr = (String) expenseDetail.get("cost");

                // 필요한 필드가 null 또는 빈 값이 아닌지 확인합니다.
                if (expenseDetail.get("category") != null && expenseCostStr != null && !expenseCostStr.trim().isEmpty() && expenseDetail.get("info") != null) {
                    Double expenseCost = Double.parseDouble(expenseCostStr);

                    ExpenseDraftContent content = new ExpenseDraftContent();
                    content.setExpenseCategory((String) expenseDetail.get("category"));
                    content.setExpenseCost(expenseCost);
                    content.setExpenseInfo((String) expenseDetail.get("info"));
                    expenseDraftContentList.add(content);

                    // 디버깅 메시지 추가: 각 content 정보를 출력
                    log.debug("Expense Draft Content: {}", content);
                } else {
                    log.debug("Ignoring expense detail due to null or empty values: {}", expenseDetail);
                }
            }
        }
            int result = draftService.processExpenseSubmission(isSaveDraft, submissionData, selectedRecipientsIds, expenseDraftContentList);

        log.debug("result: ", result);
        
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
    
    @GetMapping("/expenseDraftOne")
    public String ExpenseDraftOne(@RequestParam("approvalNo") int approvalNo, Model model) {
        int empNo = 2008001; //test

        Map<String, Object> expenseDraftData = draftService.getExpenseDraftDataByApprovalNo(approvalNo,empNo);


        log.debug(CC.JUNG + "[DEBUG] Expense Draft Data: {}", expenseDraftData + CC.RESET);
        model.addAttribute("expenseDraftData", expenseDraftData);
      

        return "/draft/expenseDraftOne";
    }
    
    @PostMapping("/expenseDraftOne")
    public String ExpenseDraftOneAction(@RequestParam("role") String role,
                                                  @RequestParam("status") String status,
                                                  @RequestParam("approvalNo") int approvalNo,
                                                  @RequestParam("action") String action,
                                                  Model model) {

       log.debug("Action Value: {}", action);

       
        if ("cancelButton".equals(action)) {
            draftService.cancelDraft(approvalNo);
        } else if ("modifyButton".equals(action)) {
            // 여기서 수정 페이지로 리다이렉트 등의 처리를 수행할 수 있음
        } else if ("approveButton".equals(action)) {
            draftService.approveDraft(approvalNo, role);
        } else if ("rejectButton".equals(action)) {
            draftService.rejectDraft(approvalNo);
        } else if ("cancelApproval".equals(action)) {
            draftService.cancelApproval(approvalNo, role);
        }
        
        return "/draft/expenseDraftOne";
        // 여기서 필요한 리다이렉트나 뷰를 반환하면 됨
    }   // 다른 컨트롤러 메소드들
    
    @GetMapping("/modifyExpense")
    public String modifyExpense(@RequestParam("approvalNo") int approvalNo, Model model) {
        int empNo = 2008001; // 테스트용

        Map<String, Object> expenseDraftData = draftService.getExpenseDraftDataByApprovalNo(approvalNo, empNo);
        List<EmpInfo> employeeList = draftService.getAllEmp();
        
        // expenseDraftOne 컨트롤러와 유사하게 기존의 데이터를 가져와서 모델에 추가합니다.
        model.addAttribute("expenseDraftData", expenseDraftData);
        model.addAttribute("employeeList", employeeList);
        return "/draft/modifyExpense"; // 또는 적절한 뷰 이름
    }
    
    @PostMapping("/modifyExpense")
    public String modifyExpenseAction(@RequestBody Map<String, Object> formData, Model model) {
        log.debug("제출 데이터: {}", formData);

        Boolean isSaveDraft = (Boolean) formData.get("isSaveDraft");
        List<Integer> selectedRecipientsIds = (List<Integer>) formData.get("selectedRecipientsIds");
        List<ExpenseDraftContent> expenseDraftContentList = null;

        // expenseDetails가 null인 경우에만 아래 코드 블록을 실행하지 않도록 체크합니다.
        if (formData.containsKey("expenseDetails") && formData.get("expenseDetails") instanceof List) {
            List<Map<String, Object>> expenseDetails = (List<Map<String, Object>>) formData.get("expenseDetails");

            expenseDraftContentList = new ArrayList<>();
            for (Map<String, Object> expenseDetail : expenseDetails) {
                Double expenseCost = Double.parseDouble((String) expenseDetail.get("cost"));

                ExpenseDraftContent content = new ExpenseDraftContent();
                content.setExpenseCategory((String) expenseDetail.get("category"));
                content.setExpenseCost(expenseCost);
                content.setExpenseInfo((String) expenseDetail.get("info"));
                expenseDraftContentList.add(content);

                // 디버깅 메시지 추가: 각 content 정보를 출력
                log.debug("Expense Draft Content: {}", content);
            }
        }

        Map<String, Object> submissionData = formData;
        int result = draftService.modifyExpenseDraft(submissionData, selectedRecipientsIds, expenseDraftContentList);

        log.debug("result: {}", result);

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