package com.fit.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.service.EmpService;
import com.fit.service.ExcelService;
import com.fit.service.MemberService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ExcelController {

	@Autowired
	private EmpService empService;
	
	@Autowired
	private ExcelService excelService;
	
	@Autowired
	private MemberService memberService;
	
	// [사원 등록] 사원 엑셀 등록
	@PostMapping("/excelUpload")
    public String excelUpload( @RequestParam("file") MultipartFile file ) { // MultiparFile 형식의 file을 요청
    	String result = "";
    	try {
    		// 1. 엑셀 파일 JSON 데이터로 변환 (업로드된 엑셀 파일을 파싱(분석, 해부)하여 JSON 데이터로 변환)
            List<Map<String, Object>> jsonDataList = excelService.parseExcel(file);
            log.debug(CC.YE + "ExcelController Post excelUpload() jsonDataList: " + jsonDataList + CC.RESET);
            
            // 2. 사원번호 중복검사
            for (Map<String, Object> data : jsonDataList) {
                int empNo = (int) data.get("사원번호"); // 현재 데이터의 사원번호를 가져옵니다.
                log.debug(CC.YE + "ExcelController Post excelUpload() empNo: " + empNo + CC.RESET);
                // 사원번호의 정보 개수
                int empInfoCnt = (int) memberService.checkEmpNo(empNo).get("empInfoCnt");
                if ( empInfoCnt > 0 ) { // 중복된 사원번호가 있을 경우 empInfoCnt 1 이상 + 알림 메세지 전달
                    return "redirect:/emp/empList?result=fail&error=duplicate";
                }
            }
            
            // 3. DB에 삽입
            excelService.excelProcess(jsonDataList); // 
            
            result = "success";
            return "redirect:/emp/empList?result=" + result; // 성공 시 성공 알림
            
        } catch (IOException e) { // 예외 처리
        	log.error(CC.YE + "ExcelController Post excelUpload() error: " + e.getMessage() + CC.RESET);
            e.printStackTrace();
            
            result = "fail";
            return "redirect:/emp/empList?result=" + result; // 실패 시 실패 알림
        }
    }
	
 	// 엑셀 다운로드 (정렬/검색된 결과값을 페이징 없이 출력)
  	@GetMapping("/emp/excelDownload")
  	public void excelDownload(HttpServletResponse response // 엑셀 다운로드
	 			              , @RequestParam(required = false, name = "ascDesc", defaultValue = "") String ascDesc // 오름차순, 내림차순
	 			              , @RequestParam(required = false, name = "empState", defaultValue = "재직") String empState // 재직(기본값), 퇴직
	 			              , @RequestParam(required = false, name = "empDate", defaultValue = "") String empDate // 입사일, 퇴사일
	 			              , @RequestParam(required = false, name = "deptName", defaultValue = "") String deptName // 부서명
	 			              , @RequestParam(required = false, name = "teamName", defaultValue = "") String teamName // 팀명
	 			              , @RequestParam(required = false, name = "empPosition", defaultValue = "") String empPosition // 직급
	 			              , @RequestParam(required = false, name = "searchCol", defaultValue = "") String searchCol // 검색항목
	 			              , @RequestParam(required = false, name = "searchWord", defaultValue = "") String searchWord // 검색어
	 			              , @RequestParam(required = false, name = "startDate", defaultValue = "") String startDate // 입사년도 검색 - 시작일
	 			              , @RequestParam(required = false, name = "endDate", defaultValue = "") String endDate) throws IOException { // 입사년도 검색 - 마지막일

  	    // 1. param Map (parameter값들 Map으로 묶기 -> enrichedEmpList의 매개값으로 전달)
 	    Map<String, Object> param = new HashMap<>();
 	    param.put("ascDesc", ascDesc); // 오름차순, 내림차순
 	    log.debug(CC.YE + "ExcelController.excelDownload() ascDesc: " + ascDesc + CC.RESET);
 	    param.put("empDate", empDate); // 입사일, 퇴사일
 	    log.debug(CC.YE + "ExcelController.excelDownload() empDate: " + empDate + CC.RESET);
 	    param.put("empState", empState); // 재직, 퇴직
 	    log.debug(CC.YE + "ExcelController.excelDownload() empState: " + empState + CC.RESET);
 	    param.put("deptName", deptName); // 부서명
 	    log.debug(CC.YE + "ExcelController.excelDownload() deptName: " + deptName + CC.RESET);
 	    param.put("teamName", teamName); // 팀명
 	    log.debug(CC.YE + "ExcelController.excelDownload() teamName: " + teamName + CC.RESET);
 	    param.put("empPosition", empPosition); // 직급
 	    log.debug(CC.YE + "ExcelController.excelDownload() empPosition: " + empPosition + CC.RESET);
 	    param.put("searchCol", searchCol); // 검색항목
 	    log.debug(CC.YE + "ExcelController.excelDownload() searchCol: " + searchCol + CC.RESET);
 	    param.put("searchWord", searchWord); // 검색어
 	    log.debug(CC.YE + "ExcelController.excelDownload() searchWord: " + searchWord + CC.RESET);
 	    param.put("startDate", startDate); // 입사년도 검색 - 시작일
 	    log.debug(CC.YE + "ExcelController.excelDownload() startDate: " + startDate + CC.RESET);
 	    param.put("endDate", endDate); // 입사년도 검색 - 마지막일
 	    log.debug(CC.YE + "ExcelController.excelDownload() endDate: " + endDate + CC.RESET);
 	    param.put("beginRow", 0); // 페이지 시작 행
 	    param.put("rowPerPage", Integer.MAX_VALUE); // 모든 데이터를 받아야 하므로 Integer 형의 MAX 값으로 지정
	    
    	// 2. 사원 목록 (휴가일수, 회원가입 여부 추가)
		List<Map<String, Object>> enrichedEmpList = empService.enrichedEmpList(param);
		log.debug(CC.YE + "ExcelController.excelDownload() enrichedEmpList: " + enrichedEmpList + CC.RESET);
		
		// 3. 엑셀 파일 생성 및 데이터 삽입
	    byte[] excelData = excelService.getExcel(enrichedEmpList);
	    log.debug(CC.YE + "ExcelController.excelDownload() excelData: " + excelData + CC.RESET);
		
	    // 4. 엑셀 다운로드 처리 설정
	    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"); // HTTP 응답(response)의 설정을 구성. 브라우저가 이 데이터가 엑셀 파일임을 인식할 수 있도록
	    
		/* Content-Disposition : 헤더를 설정하여 브라우저가 엑셀 파일을 어떻게 처리해야 하는지 지정
		   attachment : 파일을 첨부 파일로 다운로드하도록 지시하는 것
		   filename=employee_list.xlsx : 다운로드될 파일의 이름을 설정
		*/  
	    response.setHeader("Content-Disposition", "attachment; filename=employee_list.xlsx"); // 브라우저가 이 헤더를 통해 다운로드될 파일의 이름을 표시하고, 사용자에게 저장 위치를 묻게됨
	    
	    // 5. 엑셀 데이터를 출력 스트림에 작성
	    try (OutputStream outputStream = response.getOutputStream()) {
	    	log.debug(CC.YE + "ExcelController.excelDownload() 출력스트림에 엑셀 데이터 작성" + CC.RESET);

	    	outputStream.write(excelData); // 생성한 엑셀 데이터를 출력 스트림에 작성
	        outputStream.flush(); // 출력 스트림을 강제로 비우고 데이터를 전송
	    } catch (IOException e) {
            e.printStackTrace();
        }
 	}
  	
}
