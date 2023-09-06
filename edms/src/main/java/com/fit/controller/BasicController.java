package com.fit.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

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
public class BasicController {
 @Autowired DraftService draftService;
    @GetMapping("/draft/basicDraft")
    public String basicDraft(HttpSession session,Model model) {
        log.debug("[DEBUG] expenseDraft() Start");

        List<EmpInfo> employeeList = draftService.getAllEmp();
        String empName = (String) session.getAttribute("empName");
        
        // 사원 리스트 정보를 로그로 출력
        for (EmpInfo emp : employeeList) {
            log.debug(CC.JUNG+"[DEBUG] Employee: {}"+ CC.RESET, emp);
        }

        model.addAttribute("employeeList", employeeList);
        model.addAttribute("empName", empName);
        return "draft/basicDraft";
    }
    
    @PostMapping("/draft/basicDraft")
    public String submitBasic(@RequestBody Map<String, Object> formData, Model model) {
        log.debug("제출 데이터: {}", formData);

        Boolean isSaveDraft = (Boolean) formData.get("isSaveDraft");
        
        Map<String, Object> submissionData = (Map<String, Object>) formData;
        List<Integer> selectedRecipientsIds = (List<Integer>) formData.get("selectedRecipientsIds");
        int result = draftService.processBasicSubmission(isSaveDraft, submissionData, selectedRecipientsIds);

        log.debug("result: ", result);
        
        if (result == 1) {
            // 성공적인 경우 처리 (예: 리다이렉트)
            return "redirect:/home";
        } else {
            // 실패한 경우 처리 (예: 에러 메시지 전달)
            String errorMessage = "지출 제출 실패";
            model.addAttribute("errorMessage", errorMessage);
            return "/draft/basicDraft";
        }
    }

    
    @GetMapping("/draft/basicDraftOne")
    public String BasicDraftOne(HttpSession session, @RequestParam("approvalNo") int approvalNo, Model model) {
    	int empNo = (int) session.getAttribute("loginMemberId");

        Map<String, Object> basicDraftData = draftService.getBasicDraftDataByApprovalNo(approvalNo,empNo);

        Map<String, Object> memberSignMap = (Map) basicDraftData.get("memberSignMap");	
        
        log.debug(CC.JUNG + "[DEBUG] Expense Draft Data: {}", basicDraftData + CC.RESET);
        model.addAttribute("basicDraftData", basicDraftData);
        model.addAttribute("memberSignMap", memberSignMap);

        return "/draft/basicDraftOne";
    }
    
    @PostMapping("/draft/basicDraftOne")
    public String BasicDraftOneAction(@RequestParam("role") String role,
                                                  @RequestParam("status") String status,
                                                  @RequestParam("approvalNo") int approvalNo,
                                                  @RequestParam("action") String action,
                                                  @RequestParam("rejectionReason") String rejectionReason,
                                                  Model model) {

       log.debug("Action Value: {}", action);

       
        if ("cancelButton".equals(action)) {
            draftService.cancelDraft(approvalNo);
        } else if ("modifyButton".equals(action)) {
        	return "redirect:/draft/modifyBasic?approvalNo=" + approvalNo;
        } else if ("approveButton".equals(action)) {
            draftService.approveDraft(approvalNo, role);
        } else if ("reject".equals(action)) {
            draftService.rejectDraft(approvalNo,rejectionReason);
        } else if ("cancelApproval".equals(action)) {
            draftService.cancelApproval(approvalNo, role);
        }
        
        return "redirect:/draft/basicDraftOne?approvalNo=" + approvalNo;
        // 여기서 필요한 리다이렉트나 뷰를 반환하면 됨
    } 
    
    @GetMapping("/draft/modifyBasic")
    public String modifyBasic(HttpSession session,
		    						  @RequestParam("approvalNo") int approvalNo,
		    		 				  @RequestParam(name = "isSave", required = false) String isSave,
    		 				  		  Model model) {
    	int empNo = (int) session.getAttribute("loginMemberId");

        Map<String, Object> basicDraftData = draftService.getBasicDraftDataByApprovalNo(approvalNo, empNo);
        List<EmpInfo> employeeList = draftService.getAllEmp();
        
        log.debug("isSave : {}", isSave);
        
        
        if (isSave != null) {
            model.addAttribute("isSave", isSave);
        }
        
        // basicDraftOne 컨트롤러와 유사하게 기존의 데이터를 가져와서 모델에 추가합니다.
        model.addAttribute("basicDraftData", basicDraftData);
        model.addAttribute("employeeList", employeeList);
        return "/draft/modifyBasic"; 
    }
    
    @PostMapping("/draft/modifyBasic")
    public String modifyExpenseAction(@RequestBody Map<String, Object> formData, Model model) {
        log.debug("제출 데이터: {}", formData);

      
        List<Integer> selectedRecipientsIds = (List<Integer>) formData.get("selectedRecipientsIds");
       
        log.debug("selectedRecipientsIds: {}", selectedRecipientsIds);
   

        Map<String, Object> submissionData = formData;
        
        Boolean isSave = (Boolean)formData.get("isSave");
        
        if (isSave == true) {
            submissionData.put("isSave", "");
        } else {
            submissionData.put("isSave", "결재대기");
        }
        
        int result = draftService.modifyBasicDraft(submissionData, selectedRecipientsIds);

        log.debug("result: {}", result);

        if (result == 1) {
            // 성공적인 경우 처리 (예: 리다이렉트)
            return "redirect:/draft/basicDraftOne?approvalNo=" + formData.get("approvalNo");
        } else {
            // 실패한 경우 처리 (예: 에러 메시지 전달)
            String errorMessage = "지출 제출 실패";
            model.addAttribute("errorMessage", errorMessage);
            return "redirect:/draft/modifyBasic?approvalNo=" + formData.get("approvalNo");
        }
    }
}