package com.fit.controller;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.compress.utils.IOUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.apache.poi.ss.usermodel.*;

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
	            empService.excelProcess(jsonDataList); // 
	            
	            result = "success";
	            return "redirect:/emp/empList?result=" + result; // 성공 시 성공 알림
	            
	        } catch (IOException e) { // 예외 처리
	        	log.error(CC.YE + "ExcelController Post excelUpload() error: " + e.getMessage() + CC.RESET);
	            e.printStackTrace();
	            
	            result = "fail";
	            return "redirect:/emp/empList?result=" + result; // 실패 시 실패 알림
	        }
	    }
		
			// [목록 다운로드] 사원 목록 엑셀 다운로드
			@GetMapping("/emp/excelDownload")
			public void excelDownload(HttpServletResponse response, Model model) {
			    try {
			        // 모델에서 풍부한 사원 목록을 가져옵니다.
			        List<Map<String, Object>> enrichedEmpList = (List<Map<String, Object>>) model.getAttribute("enrichedEmpList");
	
			        // 엑셀 데이터를 생성하여 포함한 ByteArrayInputStream을 생성합니다.
			        ByteArrayInputStream excelStream = createExcelStream(enrichedEmpList);
	
			        // HTTP 응답 헤더를 설정합니다 (파일 이름 및 타입).
			        HttpHeaders headers = new HttpHeaders();
			        headers.add("Content-Disposition", "attachment; filename=employee_list.xlsx");
			        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
	
			        // 엑셀 파일을 HTTP 응답에 기록합니다.
			        ServletOutputStream outputStream = response.getOutputStream();
			        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			        response.setHeader("Content-Disposition", "attachment; filename=employee_list.xlsx");
			        IOUtils.copy(excelStream, outputStream);
			        
			        excelStream.close();
			        outputStream.flush();
			    } catch (IOException e) {
			        // 예외 처리
			        e.printStackTrace();
			    }
			}
		    // [목록 다운로드]
	    	private ByteArrayInputStream createExcelStream(List<Map<String, Object>> enrichedEmpList) throws IOException {
	    		log.debug(CC.YE + "ExcelController Post createExcelStream() enrichedEmpList: " + enrichedEmpList + CC.RESET);
	    		
	    		// 엑셀 워크북 생성
	    		Workbook workbook = new XSSFWorkbook();
	    		log.debug(CC.YE + "ExcelController Post createExcelStream() workbook: " + workbook + CC.RESET);
	            
	    		// 엑셀 시트 생성
	    		Sheet sheet = workbook.createSheet("Employee Data");
	    		log.debug(CC.YE + "ExcelController Post createExcelStream() sheet: " + sheet + CC.RESET);
	            
	    	    // 헤더 행 생성
	    	    Row headerRow = sheet.createRow(0);
	    	    String[] columns = {"사원번호", "사원명", "부서명", "팀명", "직급", "입사일", "잔여휴가일", "회원가입 유무", "권한"};
	    	    log.debug(CC.YE + "ExcelController Post createExcelStream() columns: " + columns + CC.RESET);
	            
	    	    for (int col = 0; col < columns.length; col++) {
	    	        Cell cell = headerRow.createCell(col);
	    	        log.debug(CC.YE + "ExcelController Post createExcelStream() cell: " + cell + CC.RESET);
	    	        cell.setCellValue(columns[col]);
	    	        log.debug(CC.YE + "ExcelController Post createExcelStream() cell: " + cell + CC.RESET);
	                
	    	    }
	    	    
	    	    // 데이터 행 생성
	    	    int rowNum = 1;
	    	    for (Map<String, Object> data : enrichedEmpList) {
	    	        Row dataRow = sheet.createRow(rowNum++);
	    	        log.debug(CC.YE + "ExcelController Post createExcelStream() dataRow: " + dataRow + CC.RESET);
	                
	    	        int colNum = 0;
	    	        for (String column : columns) {
	    	            Cell cell = dataRow.createCell(colNum++);
	    	            log.debug(CC.YE + "ExcelController.createExcelStream() cell: " + cell + CC.RESET);
	                    
	    	            Object value = data.get(column.toLowerCase()); // 열 이름이 소문자로 매핑되도록 설정
	    	            log.debug(CC.YE + "ExcelController.createExcelStream() value: " + value + CC.RESET);
	                    
	    	            if (value != null) {
	    	                cell.setCellValue(value.toString());
	    	                log.debug(CC.YE + "ExcelController.createExcelStream() cell value: " + cell + CC.RESET);
	                        
	    	            } else {
	    	                cell.setCellValue("");
	    	                log.debug(CC.YE + "ExcelController.createExcelStream() cell vlaue값 없음: " + cell + CC.RESET);
	                        
	    	            }
	    	        }
	    	    }
	
	    	    // 엑셀 파일을 바이트 배열로 변환
	    	    ByteArrayOutputStream excelBytes = new ByteArrayOutputStream();
	    	    log.debug(CC.YE + "ExcelController.createExcelStream() excelBytes: " + excelBytes + CC.RESET);
	            
	    	    workbook.write(excelBytes);
	    	    workbook.close();
	
	    	    return new ByteArrayInputStream(excelBytes.toByteArray());
	    	}
}
