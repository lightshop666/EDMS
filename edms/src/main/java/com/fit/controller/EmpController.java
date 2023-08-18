package com.fit.controller;

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
import com.fit.service.EmpService;
import com.fit.vo.EmpInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmpController {
	@Autowired
	private EmpService empService;
	
	// 인사정보 수정 폼
	@GetMapping("/emp/modifyEmp")
	public String modifyEmp(HttpSession session,
							// required = true이면 null일 경우 404 오류가 반환된다
							// null값 검사 후 다른 페이지로 리다이렉션 하려면 우선 required = false로 둔 뒤에
							// 조건문으로 null값 검사를 해야한다
							@RequestParam(required = false, name = "empNo") Integer empNo,
							Model model) {
		// 세션 정보 조회하여 로그인 유무 및 권한 조회 후 분기 예정
		// 로그인 유무 -> 인터셉터 처리
		// 권한 분기 -> 메인메뉴에서 처리
		
		// empNo 유효성 검사 후 null일 경우 사원목록 페이지로 리다이렉션
		/*
		if (empNo == null) {
			return "redirect:/home";
		}
		*/
		int empNoEx = 2016001;
		
		// 1) 인사정보 조회 호출
		EmpInfo empInfo = empService.selectEmp(empNoEx);
		
		// 2) 부서, 팀 테이블 조회 호출
		Map<String, Object> result = empService.getDeptAndTeamList();
		
		model.addAttribute("emp", empInfo);
		model.addAttribute("deptList", result.get("deptList"));
		model.addAttribute("teamList", result.get("teamList"));
		
		return "/emp/modifyEmp";
	}
	
	// 인사정보 수정 액션
	@PostMapping("/emp/modifyEmp")
	public String modifyEmp(EmpInfo empInfo) {
		// empNo 유효성 검사 후 분기 예정 // empInfo.getEmpNo()
		int empNoEx = 2016001;
		empInfo.setEmpNo(empNoEx);
		
		int row = empService.modifyEmp(empInfo);
		
		if (row == 1) {
			log.debug(CC.HE + "EmpController.modifyEmp() row : " + row + CC.RESET);
			return "redirect:/emp/modifyEmp?result=success";
		} else {
			log.debug(CC.HE + "EmpController.modifyEmp() row : " + row + CC.RESET);
			return "redirect:/emp/modifyEmp?result=fail";
		}
	}
	
	// 개인정보 조회 (관리자)
	@GetMapping("/emp/adminMemberOne")
	public String adminMemberOne(HttpSession session,
								@RequestParam(required = false, name = "empNo") Integer empNo,
								Model model) {
		// 세션 정보 조회하여 로그인 유무 및 권한 조회 후 분기 예정
		// 로그인 유무 -> 인터셉터 처리
		// 권한 분기 -> 메인메뉴에서 처리
		
		// empNo 유효성 검사 후 null일 경우 사원목록 페이지로 리다이렉션
		/*
		if (empNo == null) {
			return "redirect:/home";
		}
		*/
		int empNoEx = 1000000;
		
		// empNo로 개인정보 조회 (관리자) 서비스 호출
		Map<String, Object> result = empService.selectMember(empNoEx);

		// 각 타입의 객체를 model에 담기
		model.addAttribute("member", result.get("memberInfo"));
		model.addAttribute("image", result.get("memberImage"));
		model.addAttribute("sign", result.get("memberSign"));
		
		return "/emp/adminMemberOne";
	}
	
	// 인사 등록 폼
	@GetMapping("/emp/registEmp")
	public String showEmployeeRegistrationForm(Model model) {
	    // 부서, 팀 정보 조회
	    Map<String, Object> departmentAndTeamInfo = empService.getDeptAndTeamList();
	    
	    model.addAttribute("deptList", departmentAndTeamInfo.get("deptList"));
	    model.addAttribute("teamList", departmentAndTeamInfo.get("teamList"));
	    
	    return "/emp/registEmp"; // 인사등록 폼으로 이동
	}
	
	// 인사 등록 액션
	@PostMapping("/emp/registEmp")
	public String processEmployeeRegistration(@ModelAttribute("empInfo") EmpInfo empInfo) {
		
	    int rowCount = empService.addEmp(empInfo);
	    log.debug(CC.YE + "EmpController.registEmp() rowCount: " + rowCount + CC.RESET);
	    
	    return "redirect:/emp/empList"; // 인사목록 페이지로 리다이렉트
	}
}
