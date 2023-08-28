package com.fit.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.mapper.EmpMapper;
import com.fit.vo.EmpInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ExcelService {
	@Autowired
	private EmpMapper empMapper;
	
	// 사원 등록 엑셀 업로드
    public void excelProcess(List<Map<String, Object>> jsonDataList) {
        log.debug(CC.YE + "EmpService.excelProcess() 실행" + CC.RESET);
        log.debug(CC.YE + "EmpService.excelProcess() jsonData.size(): " + jsonDataList.size() + CC.RESET);
        // 엑셀 파일 파싱
        for (Map<String, Object> jsonData : jsonDataList) { // jsonData를 가지고 필요한 처리를 수행하고 데이터베이스에 저장
            EmpInfo empInfo = new EmpInfo();
            empInfo.setEmployDate((String) jsonData.get("입사일"));
            empInfo.setEmpPosition((String) jsonData.get("직급"));
            empInfo.setEmpNo((int) jsonData.get("사원번호"));
            empInfo.setAccessLevel((String) jsonData.get("권한"));
            empInfo.setDeptName((String) jsonData.get("부서명"));
            empInfo.setEmpState((String) jsonData.get("재직사항"));
            empInfo.setEmpName((String) jsonData.get("사원명"));
            empInfo.setTeamName((String) jsonData.get("팀명"));
            log.debug(CC.YE + "EmpService.excelProcess() empInfo: "+ empInfo + CC.RESET);
            
            // 2. 사원번호 등록
		    int addEmpNoRow = empMapper.addEmpNo(empInfo.getEmpNo());
		    log.debug(CC.YE + "EmpService.addEmpNoRow() row : " + addEmpNoRow + CC.RESET);
		    
		    // 3. 사원번호 등록 후 인사 정보 등록
		    int addEmpRow = empMapper.addEmp(empInfo);
		    log.debug(CC.YE + "EmpService.addEmp() row : " + addEmpRow + CC.RESET);
        }
    }
    
	// [사원 등록] 엑셀 파일을 파싱하여 JSON 데이터로 변환하는 메서드
    public List<Map<String, Object>> parseExcel( MultipartFile file ) throws IOException { // excelUPload에서 호출하여 사용
        List<Map<String, Object>> jsonDataList = new ArrayList<>();
        
        try ( InputStream inputStream = file.getInputStream() ) { // import InputStream
        	/* InputStream = Java의 기본 클래스이자, 데이터를 '읽어오는 데 사용'되는 입력 스트림을 표현하는 인터페이스.
        	   파일, 네트워크 연결, 메모리 등 다양한 소스로부터 데이터를 읽을 때 사용. */
            Workbook workbook = WorkbookFactory.create(inputStream); // import poi Workbook/WorkbookFactory
            /* Workbook : 엑셀 파일의 논리적 구조를 나타내는 클래스
               WorkbookFactory : 엑셀 파일을 읽어 Workbook 객체 생성(.xlsx와 .xls 파일을 형식에 관계없이 다룸)
            */
            Sheet sheet = workbook.getSheetAt(0); // import Sheet, 첫 번째 시트 가져오기(인덱스는 0부터 시작하므로)

            // 헤더 행 추출
            Row headerRow = sheet.getRow(0); // 첫 번째 행을 헤더 행으로 추출
            List<String> headers = new ArrayList<>();
            for ( Cell cell : headerRow ) {
                headers.add(cell.getStringCellValue()); // 헤더 행의 각 셀의 값을 가져와서 헤더 ArrayList에 추가
            }
            log.debug(CC.YE + "ExcelUpload.parseExcel() Headers: " + headers + CC.RESET);
            
            // 데이터 행 추출 및 변환
            for ( int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++ ) { // 시트의 마지막 행까지 반복
                Row dataRow = sheet.getRow(rowIndex); // 데이터 행을 추출
                
                if ( dataRow != null ) { // 행이 있으면
                	
                	// 한 행의 키와 값을 함께 저장할 Map 객체 생성
                    Map<String, Object> rowData = new HashMap<>();
                    
                    // 헤더 셀의 수만큼 반복
                    for ( int cellIndex = 0; cellIndex < headers.size(); cellIndex++ ) {
                        Cell cell = dataRow.getCell(cellIndex); // 인덱스에 해당하는 셀 값을 추출
                        
                        if ( cell != null ) {
                            String header = headers.get(cellIndex); // 현재 셀의 헤더 이름 가져오기
                            log.debug(CC.YE + "ExcelUpload.parseExcel() header: " + header + CC.RESET);
                            
                            rowData.put( header, getCellValue( cell, header ) ); // 헤더 데이터 형식에 맞추어 값을 정제 -> rowData에 넣음
                            log.debug(CC.YE + "ExcelUpload.parseExcel() rowData: " + rowData + CC.RESET);
                        }
                    }
                    jsonDataList.add( rowData ); // 변환된 데이터를 리스트에 추가
                }
            }
        } catch ( Exception e ) {
        	log.debug(CC.YE + "ExcelUpload.parseExcel() error" + CC.RESET);
            e.printStackTrace();
        }

        return jsonDataList; // 변환된 JSON 데이터 리스트 반환
    }
    
    // [사원 등록] 셀 데이터 형식을 변환하여 반환하는 메서드
    public Object getCellValue( Cell cell, String header ) { // parseExcel에서 호출하여 사용
    	// 셀의 타입에 따라
        switch ( cell.getCellType() ) {
        	
            case STRING: // 문자열 셀 데이터일 경우
                return cell.getStringCellValue(); // 문자열 값 반환
                
            case NUMERIC: // 숫자 셀 데이터일 경우
                if ( "입사일".equals(header) ) { // 숫자 셀의 헤더 값이 "입사일"일때
                	
                    Date dateCellValue = cell.getDateCellValue(); // 해당하는 셀의 값을 날짜로 가져와서 Java의 Date 객체로 변환
                    log.debug(CC.YE + "ExcelUpload.getCellValue() dateCellValue: " + dateCellValue + CC.RESET);
                    
                    /* 그런데 Date로 가져오면 ex) Thu Aug 17 00:00:00 KST 2023 이러한 형태로 들어오게 됨.
                       => SimpleDateFormat 객체를 만들어 날짜 형식 "yyyy-MM-dd"로 바꾸어줌. */
                    
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // '월' MM은 '분' mm과 겹칠 수 있어 대문자로 표기. 
                    
                    /* simpleDateFormat 처리를 거친 후 날짜 포맷 */
                    
                    String formattedDate = dateFormat.format(dateCellValue);
                    log.debug(CC.YE + "ExcelUpload.getCellValue() formattedDate: " + formattedDate + CC.RESET);
                    
                    return formattedDate; // 포맷된 날짜를 반환
                    
                } else if ( "사원번호".equals(header) ) { // 숫자 셀의 헤더 값이 "사원번호"일때
                    log.debug(CC.YE + "ExcelUpload.getCellValue() 사원번호 정제" + CC.RESET);
                    
                    return (int) cell.getNumericCellValue(); // 실수를 정수로 변환하여 반환
                    
                } else if ( "권한".equals(header) ) { // 숫자 셀의 헤더 값이 "권한"일때(원래는 ENUM 값)
                	double permissionValue = cell.getNumericCellValue(); // 권한 값을 double로 받아오기(엑셀에서 텍스트 형식으로 지정해도 더블로 받아옴)
                	log.debug(CC.YE + "ExcelUpload.getCellValue() 권한 값을 double 값 확인: " + permissionValue + CC.RESET);

                    String permissionStr = String.valueOf(permissionValue); // 권한 값을 문자열로 변환
                    log.debug(CC.YE + "ExcelUpload.getCellValue() 권한 값을 문자열로 변환: " + permissionStr + CC.RESET);
                    
                    if ( permissionStr.endsWith(".0") ) { // 문자열 상태의 권한 값이 .0으로 끝난다면
                        permissionStr = permissionStr.substring( 0, permissionStr.length() - 2 ); // ".0" 소숫점 제거
                        log.debug(CC.YE + "ExcelUpload.getCellValue() 문자열 권한 값의 소숫점 제거: " + permissionStr + CC.RESET);
                    }
                    
                    return permissionStr;
                } else { // 숫자 셀의 헤더 값이 예외적일때
                    log.debug(CC.YE + "ExcelUpload.getCellValue() : 이외 나머지 값 정수로 변환" + CC.RESET);
                    
                    return cell.getNumericCellValue(); // 모두 숫자 값을 반환
                }
                
            case BOOLEAN: // 불리언 셀 데이터일 경우
                log.debug(CC.YE + "ExcelUpload.getCellValue() boolean값 정제" + CC.RESET);
                
                return cell.getBooleanCellValue(); // 불리언 값 반환
                
            default: // 셀 데이터 타입을 모를 경우
                log.error(CC.YE + "ExcelUpload.getCellValue() 다른 타입의 값을 null 처리 " + CC.RESET);
                
                return null; // null로 반환
        }
    }

    // [목록 다운로드] 엑셀 파일 생성을 위한 메서드
    public byte[] getExcel(List<Map<String, Object>> dataList) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            // 1. 시트 생성 및 이름 설정
            Sheet sheet = workbook.createSheet("사원 목록");

            // 2. 헤더 행 생성
            Row headerRow = sheet.createRow(0);
            int colIdx = 0; // 열 인덱스를 초기화
            
            // 3. 열 이름과 키 값을 매칭하는 맵 생성
            Map<String, String> columnMapping = new HashMap<>();
            columnMapping.put("사원번호", "empNo");
            columnMapping.put("사원명", "empName");
            columnMapping.put("부서명", "deptName");
            columnMapping.put("팀명", "teamName");
            columnMapping.put("직급", "empPosition");
            columnMapping.put("입사일", "employDate");
            columnMapping.put("잔여휴가일", "remainDays");
            columnMapping.put("회원가입유무", "isMember");
            columnMapping.put("권한", "accessLevel");

            // 4. 헤더 셀 생성
            for (String columnName : columnMapping.keySet()) {
                Cell cell = headerRow.createCell(colIdx++);
                cell.setCellValue(columnName); // 헤더 셀에 열 이름을 채우기
            }

            // 5. 데이터 행 채우기
            int rowIdx = 1; // 데이터 행의 시작 인덱스 설정
            
            for (Map<String, Object> data : dataList) {
                Row dataRow = sheet.createRow(rowIdx++);
                colIdx = 0; // 열 인덱스를 초기화
                for (String columnName : columnMapping.values()) {
                	// 데이터 셀 생성
                    Cell cell = dataRow.createCell(colIdx++);
                    Object value = data.get(columnName); // 맵 데이터에서 해당 열 이름에 해당하는 값을 가져오는 코드
                    
                    // 값이 문자열일 경우, 셀에 문자열 값을 채웁
                    if (value instanceof String) {
                        cell.setCellValue((String) value);
                    // 값이 숫자일 경우, 셀에 숫자 값을 채움
                    } else if (value instanceof Number) {
                        cell.setCellValue(((Number) value).doubleValue());
                    }
                    
                }
            }
            
            // ByteArrayOutputStream에 워크북을 작성하여 엑셀 파일 생성
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray(); // 생성된 엑셀 파일의 바이트 배열을 반환
        }
    }
    
}
