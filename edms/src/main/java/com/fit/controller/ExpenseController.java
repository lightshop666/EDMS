package com.fit.controller;

import java.util.List;

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
    
    @PostMapping("/submitExpense")
    public String submitExpense(
            @RequestParam("applicantName") String applicantName,
            @RequestParam("middleApprover") String middleApprover,
            @RequestParam("finalApprover") String finalApprover,
            @RequestParam("dueDate") String dueDate,
            @RequestParam("documentTitle") String documentTitle,
            // 다른 파라미터들도 추가해주세요
            @RequestParam("attachedFile") MultipartFile attachedFile,
            // 필요한 파라미터들을 받아옵니다.
            Model model
    ) {
        // 여기서 제출된 데이터를 처리하는 로직을 작성합니다.
        // 예시로 모델에 메시지를 추가하여 결과를 JSP로 전달하는 코드를 작성합니다.
        String message = "지출결의서가 성공적으로 제출되었습니다.";
        model.addAttribute("message", message);
        
        return "draft/expenseResult"; // 결과 표시를 위한 JSP 파일명
    }
}