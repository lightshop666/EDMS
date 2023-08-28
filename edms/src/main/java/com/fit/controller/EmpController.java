package com.fit.controller;

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
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.CommonPagingService;
import com.fit.service.EmpService;
import com.fit.vo.EmpInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmpController {
	@Autowired
	private EmpService empService;

	@Autowired
	private CommonPagingService commonPagingService;
	
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
		if (empNo == null) {
			return "redirect:/emp/empList";
		}
		
		// 1) 인사정보 조회 호출
		EmpInfo empInfo = empService.selectEmp(empNo);
		
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
		// empNo 유효성 검사 후 분기 예정
		if (empInfo.getEmpNo() == 0) {
			log.debug(CC.HE + "EmpController.modifyEmp() : empNo param == 0, 잘못된 접근" + CC.RESET);
			return "redirect:/emp/empList";
		}
		
		int row = empService.modifyEmp(empInfo);
		
		if (row == 1) {
			log.debug(CC.HE + "EmpController.modifyEmp() row : " + row + CC.RESET);
			return "redirect:/emp/modifyEmp?empNo=" + empInfo.getEmpNo() + "&result=success";
		} else {
			log.debug(CC.HE + "EmpController.modifyEmp() row : " + row + CC.RESET);
			return "redirect:/emp/modifyEmp?empNo=" + empInfo.getEmpNo() + "&result=fail";
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
		int empNoEx = 2016001;
		
		// empNo로 개인정보 조회 (관리자) 서비스 호출
		Map<String, Object> result = empService.selectMember(empNoEx);

		// 각 타입의 객체를 model에 담기
		model.addAttribute("member", result.get("memberInfo"));
		model.addAttribute("image", result.get("memberImage"));
		model.addAttribute("sign", result.get("memberSign"));
		
		return "/emp/adminMemberOne";
	}
	
	// 사원 등록 폼
	@GetMapping("/emp/registEmp")
	public String registEmp(Model model) {
		
		// 부서와 팀 정보를 조회하여 모델에 추가
	    Map<String, Object> departmentAndTeamInfo = empService.getDeptAndTeamList();
	    log.debug(CC.YE + "EmpController Get registEmp() departmentAndTeamInfo: " + departmentAndTeamInfo + CC.RESET);
	    model.addAttribute("deptList", departmentAndTeamInfo.get("deptList")); // 부서 정보 리스트
	    log.debug(CC.YE + "EmpController Get registEmp() deptList: " + departmentAndTeamInfo.get("deptList") + CC.RESET);
	    model.addAttribute("teamList", departmentAndTeamInfo.get("teamList")); // 팀 정보 리스트
	    log.debug(CC.YE + "EmpController Get registEmp() teamList: " + departmentAndTeamInfo.get("teamList") + CC.RESET);
	    
	    return "/emp/registEmp"; // 사원 등록 폼 페이지로 이동
	}
	
	// 사원 등록 액션
	@PostMapping("/emp/registEmp")
	public String registEmp(@ModelAttribute("empInfo") EmpInfo empInfo ) {
		
		// empInfo VO 값을 전달하여 addEmp 메서드 실행 및 사원 정보 추가
	    int rowCount = empService.addEmp(empInfo);
	    log.debug(CC.YE + "EmpController Post registEmp() rowCount: " + rowCount + CC.RESET);
	    
	    return "redirect:/emp/empList"; // 사원 목록 페이지로 리다이렉트
	}
	
    // 사원 목록 조회 폼
 	@GetMapping("/emp/empList")
 	public String empList(Model model
			 			  , HttpSession session
			 			  , HttpServletResponse response
			              , @RequestParam(required = false, name = "ascDesc", defaultValue = "") String ascDesc // 오름차순, 내림차순
			              , @RequestParam(required = false, name = "empState", defaultValue = "재직") String empState // 재직(기본값), 퇴직
			              , @RequestParam(required = false, name = "empDate", defaultValue = "") String empDate // 입사일, 퇴사일
			              , @RequestParam(required = false, name = "deptName", defaultValue = "") String deptName // 부서명
			              , @RequestParam(required = false, name = "teamName", defaultValue = "") String teamName // 팀명
			              , @RequestParam(required = false, name = "empPosition", defaultValue = "") String empPosition // 직급
			              , @RequestParam(required = false, name = "searchCol", defaultValue = "") String searchCol // 검색항목
			              , @RequestParam(required = false, name = "searchWord", defaultValue = "") String searchWord // 검색어
			              , @RequestParam(required = false, name = "startDate", defaultValue = "") String startDate // 입사년도 검색 - 시작일
			              , @RequestParam(required = false, name = "endDate", defaultValue = "") String endDate // 입사년도 검색 - 마지막일
			              , @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage // 현재 페이지
			              , @RequestParam(name = "rowPerPage", required = false, defaultValue = "10") int rowPerPage) { // 한 페이지에 출력될 행의 수
 		
 		// 1. accessLevel (세션 accessLevel값으로 권한에 따라 비밀번호 초기화 버튼 공개)
 	    String accessLevel = (String)session.getAttribute("accessLevel");
 	    
 	    // 페이지 시작 행
 	    int beginRow = (currentPage-1) * rowPerPage;
 	    
 	    // 2. param Map (parameter값을 Map으로 묶음 -> enrichedEmpList의 매개값으로 전달)
	    Map<String, Object> param = new HashMap<>();
	    param.put("ascDesc", ascDesc); // 오름차순, 내림차순
	    log.debug(CC.YE + "EmpController.empList() ascDesc: " + ascDesc + CC.RESET);
	    param.put("empDate", empDate); // 입사일, 퇴사일
	    log.debug(CC.YE + "EmpController.empList() empDate: " + empDate + CC.RESET);
	    param.put("empState", empState); // 재직, 퇴직
	    log.debug(CC.YE + "EmpController.empList() empState: " + empState + CC.RESET);
	    param.put("deptName", deptName); // 부서명
	    log.debug(CC.YE + "EmpController.empList() deptName: " + deptName + CC.RESET);
	    param.put("teamName", teamName); // 팀명
	    log.debug(CC.YE + "EmpController.empList() teamName: " + teamName + CC.RESET);
	    param.put("empPosition", empPosition); // 직급
	    log.debug(CC.YE + "EmpController.empList() empPosition: " + empPosition + CC.RESET);
	    param.put("searchCol", searchCol); // 검색항목
	    log.debug(CC.YE + "EmpController.empList() searchCol: " + searchCol + CC.RESET);
	    param.put("searchWord", searchWord); // 검색어
	    log.debug(CC.YE + "EmpController.empList() searchWord: " + searchWord + CC.RESET);
	    param.put("startDate", startDate); // 입사년도 검색 - 시작일
	    log.debug(CC.YE + "EmpController.empList() startDate: " + startDate + CC.RESET);
	    param.put("endDate", endDate); // 입사년도 검색 - 마지막일
	    log.debug(CC.YE + "EmpController.empList() endDate: " + endDate + CC.RESET);
	    param.put("beginRow", beginRow); // 시작 행
	    log.debug(CC.YE + "EmpController.empList() beginRow: " + beginRow + CC.RESET);
	    param.put("rowPerPage", rowPerPage); // 한 페이지에 출력될 행의 수
	    log.debug(CC.YE + "EmpController.empList() rowPerPage: " + rowPerPage + CC.RESET);
	    
    	// 3. 사원 목록 (휴가일수, 회원가입 여부 추가)
		List<Map<String, Object>> enrichedEmpList = empService.enrichedEmpList(param);
		log.debug(CC.YE + "EmpController.empList() enrichedEmpList: " + enrichedEmpList + CC.RESET);
		  
	    // 4. 페이징
    	// 4-1. 검색어가 적용된 리스트의 전체 행 개수를 구해주는 메서드 실행
		int totalCount = empService.getEmpListCount(param);
		log.debug(CC.YE + "EmpController.empList() totalCount: " + totalCount + CC.RESET);
		// 4.2. 마지막 페이지 계산
		int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage);
		log.debug(CC.YE + "EmpController.empList() lastPage: " + lastPage + CC.RESET);
		// 4.3. 페이지네이션에 표기될 쪽 개수
		int pagePerPage = 5;
		// 4.4. 페이지네이션에서 사용될 가장 작은 페이지 범위
		int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
		log.debug(CC.YE + "EmpController.empList() minPage: " + minPage + CC.RESET);
		// 4.5. 페이지네이션에서 사용될 가장 큰 페이지 범위
		int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
		log.debug(CC.YE + "EmpController.empList() maxPage: " + maxPage + CC.RESET);
		
	    // 5. 모델값 view에 전달
	    model.addAttribute("enrichedEmpList", enrichedEmpList); // 사원 목록 리스트
	    model.addAttribute("accessLevel", accessLevel); // 권한
	    model.addAttribute("totalCount", totalCount); // 전체 행 개수
	    model.addAttribute("lastPage", lastPage); // 마지막 페이지
	    model.addAttribute("minPage", minPage); // 페이지네이션에서 사용될 가장 작은 페이지 범위
	    model.addAttribute("maxPage", maxPage); // 페이지네이션에서 사용될 가장 큰 페이지 범위
	    model.addAttribute("param", param); // 파라미터 값
	    
	    return "/emp/empList"; // 사원 목록 페이지로 이동
    }
 	
}
