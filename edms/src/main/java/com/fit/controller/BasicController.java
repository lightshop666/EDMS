package com.fit.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.mapper.DraftMapper;
import com.fit.service.DraftService;
import com.fit.vo.EmpInfo;
import com.fit.vo.ExpenseDraftContent;
import com.fit.vo.MemberFile;
import com.fit.websocket.NotificationService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BasicController {
	@Autowired		//웹소켓 알림 서비스 주입
	private NotificationService notificationService;
	
	@Autowired DraftService draftService;
 
    @GetMapping("/draft/basicDraft")
    public String basicDraft(HttpSession session,Model model) {
        log.debug("[DEBUG] expenseDraft() Start");

        List<EmpInfo> employeeList = draftService.getAllEmp();
        String empName = (String) session.getAttribute("empName");
        int empNo = (int) session.getAttribute("loginMemberId");
        String deptName = (String) session.getAttribute("deptName");
		String empPosition = (String) session.getAttribute("empPosition");
        
        // 사원 리스트 정보를 로그로 출력
        for (EmpInfo emp : employeeList) {
            log.debug(CC.JUNG+"[DEBUG] Employee: {}"+ CC.RESET, emp);
        }
        
        // 기안자의 서명 이미지
        MemberFile memberSign = draftService.selectMemberSign(empNo);

        model.addAttribute("employeeList", employeeList);
        model.addAttribute("empName", empName);
        model.addAttribute("sign", memberSign);
		model.addAttribute("deptName", deptName);
		model.addAttribute("empPosition", empPosition);
        
        return "draft/basicDraft";
    }
    
    @ResponseBody
    @PostMapping("/draft/basicDraft")
    public Map<String, Object> submitBasic(@RequestBody Map<String, Object> formData, HttpSession session,HttpServletResponse response) throws IOException {
        int empNo = (int) session.getAttribute("loginMemberId");
        log.debug("제출 데이터: {}", formData);

        Boolean isSaveDraft = (Boolean) formData.get("isSaveDraft");
        
        Map<String, Object> submissionData = (Map<String, Object>) formData;
        List<Integer> selectedRecipientsIds = (List<Integer>) formData.get("selectedRecipientsIds");
        
        int result = draftService.processBasicSubmission(isSaveDraft, submissionData, selectedRecipientsIds, empNo);
        
        //웹소켓 알림 보내기
        String middleNoti = (String) submissionData.get("selectedMiddleApproverId");
        String finalNoti = (String) submissionData.get("selectedFinalApproverId");
		log.debug(CC.WOO + "베이직드래프트.기안신청 submissionData.selectedMiddleApproverId() :  " + middleNoti + CC.RESET);
		log.debug(CC.WOO + "베이직드래프트.기안신청 submissionData.selectedFinalApproverId() :  " + finalNoti + CC.RESET);
		
        if (result == 1) {
			//성공시 특정 유저에게 웹소켓 알림 발송
			notificationService.sendPrivateNotification(middleNoti);
			notificationService.sendPrivateNotification(finalNoti);
        	
            // 서버에서 리다이렉션 수행        	
        	log.debug("result: {}", result);
            response.sendRedirect("/draft/submitDraft");
        }
        
        Map<String, Object> responseMap = new HashMap<>();
        responseMap.put("result", result);
        return responseMap;
    }

    
    @GetMapping("/draft/basicDraftOne")
    public String BasicDraftOne(HttpSession session, @RequestParam("approvalNo") int approvalNo, Model model) {
    	int empNo = (int) session.getAttribute("loginMemberId");

        Map<String, Object> basicDraftData = draftService.getBasicDraftDataByApprovalNo(approvalNo,empNo);

        Map<String, Object> memberSignMap = (Map) basicDraftData.get("memberSignMap");	
        
        log.debug(CC.JUNG + "[DEBUG] Basic Draft Data: {}", basicDraftData + CC.RESET);
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
            
            return "redirect:/draft/tempDraft";
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