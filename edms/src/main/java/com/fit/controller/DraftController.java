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
import com.fit.vo.ApprovalJoinDto;
import com.fit.vo.EmpInfo;
import com.fit.vo.MemberFile;
import com.fit.vo.VacationDraft;
import com.fit.websocket.AlarmService;
import com.google.gson.Gson;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DraftController {
	
	@Autowired
	private DraftService draftService;
	@Autowired
	private AlarmService alarmService;
	
	
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
		
		// 2~4 를 하나의 서비스에 묶는게 낫지 않을까?
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
								@RequestParam(required = false) int[] recipients,
								@RequestParam boolean isSaveDraft) {
		
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
		log.debug(CC.HE + "DraftController.addVacationDraft() isSaveDraft : " + isSaveDraft + CC.RESET); // 임시저장 유무
		
		// 매개값을 하나의 Map에 담습니다.
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("approval", approvalFormData);
		paramMap.put("vacationDraft", vacationDraftFormData);
		paramMap.put("vacationTime", vacationTime);
		paramMap.put("recipients", recipients);
		paramMap.put("isSaveDraft", isSaveDraft);
		
		// 서비스 호출
		int approvalKey = draftService.addVacationDraft(paramMap);
		
//웹소켓 알림 보내기
		//사용자ID, 알림 내용 enum '기안알림','일정알림','공지알림', 구독 주제 (/topic/draftAlarm)
		//sendAlarmToUser(int empNo,String alarmContent, String prefixContent)
		alarmService.sendAlarmToUser(1000000, "기안알림", "/topic/draftAlarm");//테스트용 
		/*
		//for문으로 중간승인자,최종승인자,참조인에게 알림 보낸다. 나중에는 성공 유무에 따라 성공한 경우만 하게 if문 안으로 넣기
		for (int recipient : recipients) {
		    // 사용자가 로그인하지 않은 경우에도 알림 쌓기
		}		
		 */
		
		// 성공 유무에 따라 approvalKey로 상세 페이지로 분기 예정...
		if (approvalKey != 0) {
			log.debug(CC.HE + "DraftController.addVacationDraft() 기안 성공 approvalKey : " + approvalKey + CC.RESET);
			return "redirect:/draft/vacationDraft?result=success";
		} else {
			log.debug(CC.HE + "DraftController.addVacationDraft() 기안 실패 approvalKey : " + approvalKey + CC.RESET);
			return "redirect:/draft/vacationDraft?result=fail";
		}
	}
	
	// 휴가신청서 상세
	@GetMapping("/draft/vacationDraftOne")
	public String vacationDraftOne(HttpSession session,
									@RequestParam(required = false) Integer approvalNo, // null값 검사를 위해 Integer로 받습니다.
									Model model) {
		/*
			필요한 정보
			1. 세션에서 사원번호 가져오기
			2. 해당 approvalNo의 휴가신청서 내용 조회
			3. 버튼 출력
			- 세션에서 조회한 사원번호가 해당 approvalNo의 어떤 결재 라인인지
			- 현재 결재상태 (A,B,C)
			
			3-1. 결재대기 (A)
			기안자 : 목록 / 기안취소 / 수정
			-> 기안취소시 임시저장함으로 이동
			-> 수정시 수정폼으로 이동
			중간승인자 : 목록 / 반려 / 승인
			-> 반려시 결재상태 반려로 변경
			-> 승인시 결재상태 결재중으로 변경
			최증승인자 : 목록
			
			3-2. 결재중 (B)
			기안자 : 목록
			중간승인자 : 목록 / 승인취소 / 반려
			-> 승인취소시 결재상태 결재대기로 변경
			-> 반려시 결재상태 반려로 변경
			최종승인자 : 목록 / 반려 / 승인
			-> 반려시 결재상태 반려로 변경
			-> 승인시 결재상태 결재완료로 변경
			
			3-3. 결재완료 (C)
			기안자 : 목록
			중간승인자 : 목록
			최종승인자 : 목록 / 승인취소 / 반려
			-> 승인취소시 결재상태 결재중으로 변경
			-> 반려시 결재상태 반려로 변경
			
			3-4. 반려
			기안자 : 목록 / 재기안(?)
			-> 재기안시 해당 데이터를 가지고 어디로?? 수정폼으로 가면 udpate가 되는데...
			재기안시에는 반려된 데이터는 남겨두어야 하니 새로 insert를 해야해요
			-> 재기안 보류
			중간승인자 : 목록
			최종승인자 : 목록
			
			3-5. 임시저장 -> 기안자만 접근 가능
			-> 클릭 시 해당 데이터를 가지고 수정폼으로 바로 이동하여 저장시 결재상태 결재대기로 변경
		*/
		
		// 세션 정보 조회하여 로그인 유무 및 권한 조회 후 분기 예정
		// 로그인 유무 -> 인터셉터 처리
		// 권한 분기 -> 메인메뉴에서 처리
		
		// approvalNo 값이 없으면 분기
		/*
		if (approvalNo == null) {

			return "redirect:/home";
		}
		*/
		int approvalNoEx = 6; // test
		// 세션에서 사원번호 가져오기
		int empNo = (int) session.getAttribute("loginMemberId");
		
		// 서비스 호출
		Map<String, Object> resultMap = draftService.selectVacationDraftOne(empNo, approvalNoEx);
		ApprovalJoinDto approvalJoinDto = (ApprovalJoinDto) resultMap.get("approvalJoinDto");
		VacationDraft vacationDraft = (VacationDraft) resultMap.get("vacationDraft");
		String vacationTime = (String) resultMap.get("vacationTime"); 
		Map<String, Object> memberSignMap = (Map) resultMap.get("memberSignMap");
		
		model.addAttribute("approvalJoinDto", approvalJoinDto);
		model.addAttribute("vacationDraft", vacationDraft);
		model.addAttribute("vacationTime", vacationTime);
		model.addAttribute("memberSignMap", memberSignMap); // key -> firstSign, mediateSign, finalSign
		
		return "/draft/vacationDraftOne";
	}
	
	// 임시저장함 목록
	@GetMapping("/draft/tempDraft")
	public String tempDraftList() {
		return "/draft/tempDraft";
	}
}
