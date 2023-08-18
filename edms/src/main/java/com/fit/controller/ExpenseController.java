package com.fit.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

public class ExpenseController {

    @GetMapping("/expenseDraft")
    public String expenseDraft(Model model) {
        // 여기서 필요한 데이터를 모델에 추가하여 JSP로 전달      
        return "/draft/expenseDraft"; // JSP 파일명
    }

}
