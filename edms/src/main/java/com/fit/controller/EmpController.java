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
										// 아무 값을 넣지 않아도 호출이 되게 하려면, required=false로 바꿔주면 된다.
							@RequestParam(required = true, name = "empNo") Integer empNo,
							Model model) {
		// 세션 정보 조회하여 로그인 유무 및 권한 조회 후 분기 예정
		
		// empNo 유효성 검사 후 분기 예정
		int empNoEx = 2016001;
		
		// 1) 인사정보 조회 호출
		EmpInfo empInfo = empService.selectEmp(empNoEx);
		// 날짜만 추출
		String createdate = empInfo.getCreatedate().substring(0, 10);
		String udpatedate = empInfo.getUpdatedate().substring(0, 10);
		empInfo.setCreatedate(createdate);
		empInfo.setUpdatedate(udpatedate);
		
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
		
		// empNo 유효성 검사 후 분기 예정
		int empNoEx = 2016001;
		
		Map<String, Object> result = empService.selectMember(empNoEx);
		
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
