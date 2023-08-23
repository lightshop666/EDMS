package com.fit.controller;

import java.time.LocalDate;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.DraftService;
import com.fit.vo.EmpInfo;
import com.fit.vo.MemberFile;
import com.google.gson.Gson;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DraftController {
	
	@Autowired
	private DraftService draftService;
	
	// 휴가신청서 작성 폼
	@GetMapping("/draft/vacationDraft")
	public String vacationRequest(HttpSession session, Model model) {
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
		
		// 3. 휴가 카테고리 조회 (최소날짜, 최대날짜)
		// 예정..
		
		// 4. 사원 리스트 메서드 호출 - employeeList
		List<EmpInfo> employeeList = draftService.getAllEmp();
		// JSON 형식의 데이터를 String으로 변환하여 추가
		String employeeListJson = new Gson().toJson(employeeList);
		
		// 5. 오늘 날짜 - year, month, day
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
	public String vacationRequest(@RequestParam int mediateApproval,
								@RequestParam int finalApproval,
								@RequestParam int[] recipients) {
		// 값이 정상적으로 넘어오는지 확인중..
		// 추후 수정 예정
		log.debug(CC.HE + "mediateApproval : " + mediateApproval + CC.RESET);
		log.debug(CC.HE + "finalApproval : " + finalApproval + CC.RESET);
		log.debug(CC.HE + "recipients : " + recipients + CC.RESET);
		for (int i = 0; i < recipients.length; i++) {
		    log.debug(CC.HE + "recipients[" + i + "] : " + recipients[i] + CC.RESET);
		}
		return "";
	}
	
	// 임시저장함 목록
	@GetMapping("/draft/tempDraft")
	public String tempDraftList() {
		return "/draft/tempDraft";
	}
}
