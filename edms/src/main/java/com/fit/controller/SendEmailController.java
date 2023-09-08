package com.fit.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class SendEmailController {
	
	// application.properties에서 myapi.publickey 값을 가져오는 어노테이션
	@Value("${myapi.publickey}")
    private String publicKey;

    @Value("${myapi.serviceid}")
    private String serviceId;

    @Value("${myapi.emailtemplatesid}")
    private String emailTemplateId;
	
	@GetMapping("/sendEmail")
	public String sendEmailForm(Model model
			// 요청 파라미터 empNo를 int형 변수 empNo에 바인딩합니다. 값이 없으면 기본값으로 0을 사용
		,	@RequestParam(name = "empNo", required = false, defaultValue = "0") int empNo) {
		
		
		model.addAttribute("empNo", empNo);
		model.addAttribute("publicKey", publicKey);
        model.addAttribute("serviceId", serviceId);
        model.addAttribute("emailTemplateId", emailTemplateId);
		
        // 넘어온값 디버깅
 		log.debug(CC.YOUN+"SendEmailController.sendEmailForm() publicKey: "+publicKey+CC.RESET);
 		log.debug(CC.YOUN+"SendEmailController.sendEmailForm() serviceId: "+serviceId+CC.RESET);
 		log.debug(CC.YOUN+"SendEmailController.sendEmailForm() emailTemplateId: "+emailTemplateId+CC.RESET);
        
 		// "/sendEmail"이라는 이름의 뷰(JSP 페이지)를 반환 실제로는 /WEB-INF/view/sendEmail.jsp 파일이 렌더링
		return "/sendEmail";
	}
}
