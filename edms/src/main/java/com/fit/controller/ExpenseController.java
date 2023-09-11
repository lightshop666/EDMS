package com.fit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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
    @GetMapping("/draft/expenseDraft")
    public String expenseDraft(HttpSession session,Model model) {
        log.debug("[DEBUG] expenseDraft() Start");
        String empName = (String) session.getAttribute("empName");
        List<EmpInfo> employeeList = draftService.getAllEmp();

        // 사원 리스트 정보를 로그로 출력
        for (EmpInfo emp : employeeList) {
            log.debug(CC.JUNG+"[DEBUG] Employee: {}"+ CC.RESET, emp);
        }

        model.addAttribute("empName", empName);
        model.addAttribute("employeeList", employeeList);
        return "draft/expenseDraft";
    }
    
    @PostMapping("/draft/expenseDraft")
    public ResponseEntity<Map<String, String>> submitExpense(@RequestBody Map<String, Object> formData, Model model, HttpSession session) {
        log.debug("제출 데이터: {}", formData);
        
        int empNo = (int) session.getAttribute("loginMemberId");

        Boolean isSaveDraft = (Boolean) formData.get("isSaveDraft");
        
        Map<String, Object> submissionData = (Map<String, Object>) formData;
        List<Integer> selectedRecipientsIds = (List<Integer>) formData.get("selectedRecipientsIds");
        
        log.debug("selectedRecipientsIds: {}", selectedRecipientsIds);
        
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
            int result = draftService.processExpenseSubmission(isSaveDraft, submissionData, selectedRecipientsIds, expenseDraftContentList, empNo);

        log.debug("result: "+ result);
        
        
        Map<String, String> responseMap = new HashMap<>();
        responseMap.put("redirectUrl", "/draft/submitDraft"); // 이 부분에 원하는 리다이렉션 URL을 설정합니다.

        return ResponseEntity.ok(responseMap);
    }
    
    @GetMapping("/draft/expenseDraftOne")
    public String ExpenseDraftOne(@RequestParam("approvalNo") int approvalNo, Model model,HttpSession session) {
    	int empNo = (int) session.getAttribute("loginMemberId");
		String empName = (String) session.getAttribute("empName");
		String deptName = (String) session.getAttribute("deptName");
		String empPosition = (String) session.getAttribute("empPosition");

        Map<String, Object> expenseDraftData = draftService.getExpenseDraftDataByApprovalNo(approvalNo,empNo);
        Map<String, Object> memberSignMap = (Map) expenseDraftData.get("memberSignMap");

        log.debug(CC.JUNG + "[DEBUG] Expense Draft Data: {}", expenseDraftData + CC.RESET);
        model.addAttribute("expenseDraftData", expenseDraftData);
        model.addAttribute("memberSignMap", memberSignMap);

        return "/draft/expenseDraftOne";
    }
    
    @PostMapping("/draft/expenseDraftOne")
    public String ExpenseDraftOneAction(@RequestParam("role") String role,
                                                  @RequestParam("status") String status,
                                                  @RequestParam("approvalNo") int approvalNo,
                                                  @RequestParam("action") String action,
                                                  @RequestParam("rejectionReason") String rejectionReason,
                                                  Model model) {

       log.debug("Action Value: {}", action);

       
       if ("cancelButton".equals(action)) {
           draftService.cancelDraft(approvalNo);
           return "redirect:/draft/tempDraft";
       } else if ("modifyButton".equals(action)) {
    	   return "redirect:/draft/modifyExpense?approvalNo=" + approvalNo;
       } else if ("approveButton".equals(action)) {
           draftService.approveDraft(approvalNo, role);
       } else if ("reject".equals(action)) {
           draftService.rejectDraft(approvalNo,rejectionReason);
       } else if ("cancelApproval".equals(action)) {
           draftService.cancelApproval(approvalNo, role);
       }
        
        return "redirect:/draft/expenseDraftOne?approvalNo=" + approvalNo;
        // 여기서 필요한 리다이렉트나 뷰를 반환하면 됨
    }   
    
    @GetMapping("/draft/modifyExpense")
    public String modifyExpense(@RequestParam("approvalNo") int approvalNo, 
                                @RequestParam(name = "isSave", required = false) String isSave,
                                HttpSession session,
                                Model model) {
    	int empNo = (int) session.getAttribute("loginMemberId");

        Map<String, Object> expenseDraftData = draftService.getExpenseDraftDataByApprovalNo(approvalNo, empNo);
        List<EmpInfo> employeeList = draftService.getAllEmp();

        log.debug("isSave : {}", isSave);
        
        if (isSave != null) {
            model.addAttribute("isSave", isSave);
        }

        // expenseDraftOne 컨트롤러와 유사하게 기존의 데이터를 가져와서 모델에 추가합니다.
        model.addAttribute("expenseDraftData", expenseDraftData);
        model.addAttribute("employeeList", employeeList);
        return "/draft/modifyExpense"; // 또는 적절한 뷰 이름
    }
    
    @PostMapping("/draft/modifyExpense")
    public String modifyExpenseAction(@RequestBody Map<String, Object> formData, 					
    									Model model) {
        log.debug("제출 데이터: {}", formData);

      
        List<Integer> selectedRecipientsIds = (List<Integer>) formData.get("selectedRecipientsIds");
       
        log.debug("selectedRecipientsIds: {}", selectedRecipientsIds);
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

        
        if (result !=0) {
            // 성공적인 경우 처리 (예: 리다이렉트)
            return "redirect:/draft/expenseDraftOne?approvalNo=" + formData.get("approvalNo");
        } else {
            // 실패한 경우 처리 (예: 에러 메시지 전달)
            String errorMessage = "지출 제출 실패";
            model.addAttribute("errorMessage", errorMessage);
            return "redirect:/draft/modifyExpense?approvalNo=" + formData.get("approvalNo");
        }
    }

}