package com.fit.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.DraftService;
import com.fit.vo.Approval;
import com.fit.vo.EmpInfo;
import com.fit.vo.MemberFile;
import com.fit.vo.VacationDraft;
import com.google.gson.Gson;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DraftController {
	
	@Autowired
	private DraftService draftService;
	
	// 휴가신청서 작성 폼
	@GetMapping("/draft/vacationDraft")
	public String addVacationDraft(HttpSession session, Model model) {
		// 세션 정보 조회하여 로그인 유무 및 권한 조회 후 분기 예정
		// 로그인 유무 -> 인터셉터 처리
		// 권한 분기 -> 메인메뉴에서 처리
		
		// 1. 세션 정보 조회
		// 사원번호, 이름, 부서명
		int empNo = (int) session.getAttribute("loginMemberId");
		String empName = (String) session.getAttribute("empName");
		String deptName = (String) session.getAttribute("deptName");
		
		// 2. 서명 이미지 - memberSign
		MemberFile memberSign = draftService.selectMemberSign(empNo);
		
		// 3. 사원 리스트 메서드 호출 - employeeList
		List<EmpInfo> employeeList = draftService.getAllEmp();
		// JSON 형식의 데이터를 String으로 변환하여 추가
		String employeeListJson = new Gson().toJson(employeeList);
		
		// 4. 오늘 날짜 - year, month, day
		LocalDate today = LocalDate.now();
		int year = today.getYear();
		int month = today.getMonthValue();
		int day = today.getDayOfMonth();
		
		model.addAttribute("empNo", empNo);
		model.addAttribute("empName", empName);
		model.addAttribute("deptName", deptName);
		model.addAttribute("employeeList", employeeList);
		model.addAttribute("employeeListJson", employeeListJson);
		model.addAttribute("sign", memberSign);
		model.addAttribute("year", year);
		model.addAttribute("month", month);
		model.addAttribute("day", day);
		
		return "/draft/vacationDraft";
	}
	
	// 휴가신청서 작성 액션
	@PostMapping("/draft/vacationDraft")
	public String addVacationDraft(@ModelAttribute Approval approvalFormData,
								@ModelAttribute VacationDraft vacationDraftFormData,
								@RequestParam(required = false) String vacationTime,
								@RequestParam(required = false) int[] recipients) {
		
		// @ModelAttribute -> form 입력값을 가져올 때 vo 타입과 자동으로 매핑하여 vo 타입 객체로 가져올 수 있습니다.
		// 디버깅..
		log.debug(CC.HE + "DraftController.addVacationDraft() approvalFormData : " + approvalFormData + CC.RESET);
		/*
 			Approval(approvalNo=0, empNo=1000000, docTitle=휴가 신청합니다 테스트중, firstApproval=1000000,
 				mediateApproval=1111112, finalApproval=2008001, approvalDate=null, approvalReason=null,
 				approvalState=null, documentCategory=null, approvalField=null, createdate=null)
		*/
		log.debug(CC.HE + "DraftController.addVacationDraft() vacationDraftFormData : " + vacationDraftFormData + CC.RESET);
		/*
			VacationDraft(documentNo=0, approvalNo=0, empNo=1000000, docTitle=휴가 신청합니다 테스트중,
				docContent=테스트중입니다, vacationName=연차, vacationDays=6.0, vacationStart=2023-08-24,
				vacationEnd=2023-08-29, phoneNumber=010-1234-5678, createdate=null, updatedate=null)
		*/
		log.debug(CC.HE + "DraftController.addVacationDraft() vacationTime : " + vacationTime + CC.RESET); // 오전반차 or 오후반차
		log.debug(CC.HE + "DraftController.addVacationDraft() recipients : " + recipients + CC.RESET); // 수신참조자 정수 배열
		for (int i = 0; i < recipients.length; i++) {
		    log.debug(CC.HE + "recipients[" + i + "] : " + recipients[i] + CC.RESET);
		    // recipients[0] : 2016001, recipients[1] : 2016002, recipients[2] : 2016003
		}
		
		// 매개값을 하나의 Map에 담습니다.
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("approval", approvalFormData);
		paramMap.put("vacationDraft", vacationDraftFormData);
		paramMap.put("vacationTime", vacationTime);
		paramMap.put("recipients", recipients);
		
		// 서비스 호출
		int approvalKey = draftService.addVacationDraft(paramMap);
		
		// 성공 유무에 따라 approvalKey로 상세 페이지로 분기 예정...
		if (approvalKey != 0) {
			log.debug(CC.HE + "DraftController.addVacationDraft() 기안 성공 approvalKey : " + approvalKey + CC.RESET);
			return "redirect:/draft/vacationDraft?result=success";
		} else {
			log.debug(CC.HE + "DraftController.addVacationDraft() 기안 실패 approvalKey : " + approvalKey + CC.RESET);
			return "redirect:/draft/vacationDraft?result=fail";
		}
	}
	
	// 임시저장함 목록
	@GetMapping("/draft/tempDraft")
	public String tempDraftList() {
		return "/draft/tempDraft";
	}
}
