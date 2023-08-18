package com.fit.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

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
	
	// 사원 목록 폼
	@GetMapping("/emp/empList")
	public String empList(Model model,
	                      @RequestParam(value = "downloadExcel", required = false) String downloadExcel,
	                      @RequestParam(value = "empNos", required = false) List<Integer> empNos,
	                      HttpServletResponse response) {
		// downloadExcel과 empNos 파라미터를 이용하여 엑셀 다운로드 여부 및 사원 번호 목록 확인
	    if (downloadExcel != null && empNos != null) {
	        try {
	        	 // 선택된 사원 정보 조회
	            List<EmpInfo> selectedEmpList = empService.getSelectedEmpList(empNos);
	            log.debug(CC.YE + "EmpController Get empList() selectedEmpList: " + selectedEmpList + CC.RESET);
	            
	            // HTTP 응답 헤더 설정
	            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"); // HTTP 응답 헤더를 설정. 엑셀 파일의 형식 중 Office Open XML 형식을 나타내는 MIME 유형
	            response.setHeader("Content-Disposition", "attachment; filename=selected_employees.xlsx"); // 응답 헤더의 "Content-Disposition" 필드를 설정. 다운로드할 파일의 이름과 함께 첨부 파일로 다운로드하도록 지시.
	            
	            // 엑셀 워크북 및 시트 생성
	            Workbook workbook = new XSSFWorkbook();
	            Sheet sheet = workbook.createSheet("Selected Employees");
	            
	            // 엑셀 헤더 생성
	            Row headerRow = sheet.createRow(0);
	            String[] headers = {"사원번호", "사원명", "부서명", "팀명", "직급", "권한", "재직사항", "입사일"};
	            log.debug(CC.YE + "EmpController Get empList() headers: " + selectedEmpList + CC.RESET);
	            
	            // 헤더의 길이만큼 셀을 생성하고 각각의 셀에 String 값을 세팅
	            for (int i = 0; i < headers.length; i++) {
	                Cell cell = headerRow.createCell(i);
	                cell.setCellValue(headers[i]);
	            }
	            
	            // 선택된 사원 정보로 엑셀 데이터 생성
	            for (int rowNum = 0; rowNum < selectedEmpList.size(); rowNum++) {
	                EmpInfo empInfo = selectedEmpList.get(rowNum);
	                Row dataRow = sheet.createRow(rowNum + 1);

	                dataRow.createCell(0).setCellValue(empInfo.getEmpNo());
	                dataRow.createCell(1).setCellValue(empInfo.getEmpName());
	                dataRow.createCell(2).setCellValue(empInfo.getDeptName());
	                dataRow.createCell(3).setCellValue(empInfo.getTeamName());
	                dataRow.createCell(4).setCellValue(empInfo.getEmpPosition());
	                dataRow.createCell(5).setCellValue(empInfo.getAccessLevel());
	                dataRow.createCell(6).setCellValue(empInfo.getEmpState());
	                dataRow.createCell(7).setCellValue(empInfo.getEmployDate());
	            }
	            
	            // 엑셀 데이터를 HTTP 응답 스트림에 작성하여 다운로드
	            workbook.write(response.getOutputStream());
	            workbook.close();
	            
	            // 리턴값이 null인 경우 현재 페이지에서 계속 머무르도록 함
	            return null;
	        } catch (Exception e) {
	        	// 예외 발생 시 처리	
	            e.printStackTrace();
	        }
	    } else {
	    	// downloadExcel과 empNos가 null인 경우, 사원 목록 페이지 렌더링에 필요한 데이터 추가
	        // 사원 목록 리스트를 전달하여 모델에 추가
	        List<EmpInfo> selectEmpList = empService.selectEmpList();
	        log.debug(CC.YE + "EmpController Get empList() selectEmpList: " + selectEmpList + CC.RESET);
	        
	        model.addAttribute("selectEmpList", selectEmpList);
	        
	        return "/emp/empList"; // 사원 목록 페이지로 이동
	    }
	    
	    return null; // 기본적으로 null을 리턴하도록 수정
	}

	
	// 사원 목록 액션
	@PostMapping("/emp/empList")
	public String empList() {
		log.debug(CC.YE + "EmpController Post empList() : " + CC.RESET);
	    return "/emp/resetPw";
	}
}
