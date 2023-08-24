package com.fit.controller;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.service.CommonPagingService;
import com.fit.service.EmpService;
import com.fit.service.MemberService;
import com.fit.vo.EmpInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmpController {
	@Autowired
	private EmpService empService;
	
	@Autowired
	private MemberService memberService;
	
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
	
	// 사원 엑셀 등록 액션
	@PostMapping("/excelUpload")
    public String excelUpload( @RequestParam("file") MultipartFile file ) { // MultiparFile 형식의 file을 요청
    	String result = "";
    	try {
            List<Map<String, Object>> jsonDataList = parseExcel(file); // 업로드된 엑셀 파일을 파싱(분석, 해부)하여 JSON 데이터로 변환
            log.debug(CC.YE + "ExcelUpload Post excelUpload() jsonDataList: " + jsonDataList + CC.RESET);
            
            // 중복검사 메서드
            for (Map<String, Object> data : jsonDataList) {
                int empNo = (int) data.get("사원번호"); // 실제 컬럼 이름에 맞게 수정
                log.debug(CC.YE + "ExcelUpload Post excelUpload() empNo: " + empNo + CC.RESET);
                
                int empInfoCnt = (int) memberService.checkEmpNo(empNo).get("empInfoCnt");
                // 중복 되면 back 
                if ( empInfoCnt > 0 ) { // 중복된 사원번호가 있을 경우
                    return "redirect:/emp/empList?result=fail&error=duplicate";
                }
            }
            
            // 실행
            empService.excelProcess(jsonDataList); // 변환된 데이터를 서비스를 통해 DB에 삽입
            
            // 새로 등록된 사원번호 목록 추적
            List<String> newEmpNos = new ArrayList<>();
            for (Map<String, Object> data : jsonDataList) {
                String empNo = String.valueOf(data.get("사원번호")); // 실제 컬럼 이름에 맞게 수정
                newEmpNos.add(empNo);
            }
            
            result = "success";
            String joinNewEmpNos = String.join(",", newEmpNos);
            return "redirect:/emp/empList?newEmpNos=" + joinNewEmpNos + "&result=" + result;
            
        } catch (IOException e) {
        	log.error(CC.YE + "ExcelUpload Post excelUpload() error: " + e.getMessage() + CC.RESET);
            e.printStackTrace();
            
            result = "fail";
            return "redirect:/emp/empList?result=" + result; // 실패 시 사원 등록 페이지로 리다이렉트 + 오류 메시지 전달
        }
    }
    
    // 엑셀 파일을 파싱하여 JSON 데이터로 변환하는 메서드
    private List<Map<String, Object>> parseExcel( MultipartFile file ) throws IOException { // excelUPload에서 호출하여 사용
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
    
    // 셀 데이터 형식을 변환하여 반환하는 메서드
    private Object getCellValue( Cell cell, String header ) { // parseExcel에서 호출하여 사용
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
	
    // 사원 목록 폼
 	@GetMapping("/emp/empList")
 	public String empList(Model model
			 			  , HttpSession session
			              , @RequestParam(required = false, name = "ascDesc", defaultValue = "") String ascDesc // 오름차순, 내림차순
			              , @RequestParam(required = false, name = "empState", defaultValue = "") String empState // 재직, 퇴직
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
 		
 		// 1. 세션에서 accessLevel 가져오기
 	    String accessLevel = (String)session.getAttribute("accessLevel");
 	    
 	    int beginRow = (currentPage-1) * rowPerPage;
 	    
 	    // 2. parameter들을 Map으로 만들어 enrichedEmpList의 매개값으로 전달
	    Map<String, Object> param = new HashMap<>();
	    param.put("ascDesc", ascDesc); // 오름차순, 내림차순
		// 재직 상태가 선택되지 않았을 때
	    /* if (empState == null) {
	        param.put("empState", "재직"); // '재직' 상태만 출력하도록 설정
	    }
	    */
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
	    
 	    // 사원 목록 리스트를 전달하여 모델에 추가
		List<Map<String, Object>> enrichedEmpList = empService.enrichedEmpList(param);
	    log.debug(CC.YE + "EmpController.empList() enrichedEmpList: " + enrichedEmpList + CC.RESET);
	    
    	// 3. 검색어가 적용된 리스트의 전체 행 개수를 구해주는 메서드 실행
		int totalCount = empService.getEmpListCount(param);
		log.debug(CC.YE + "EmpController.empList() totalCount: " + totalCount + CC.RESET);
		// 마지막 페이지 계산
		int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage);
		log.debug(CC.YE + "EmpController.empList() lastPage: " + lastPage + CC.RESET);
		// 페이지네이션에 표기될 쪽 개수
		int pagePerPage = 5;
		// 페이지네이션에서 사용될 가장 작은 페이지 범위
		int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
		log.debug(CC.YE + "EmpController.empList() minPage: " + minPage + CC.RESET);
		// 페이지네이션에서 사용될 가장 큰 페이지 범위
		int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
		log.debug(CC.YE + "EmpController.empList() maxPage: " + maxPage + CC.RESET);
		
	    // 모델에 담아 view에 전달
	    model.addAttribute("enrichedEmpList", enrichedEmpList);
	    model.addAttribute("accessLevel", accessLevel);
	    model.addAttribute("totalCount", totalCount); // 전체 행 개수
	    model.addAttribute("lastPage", lastPage); // 마지막 페이지
	    model.addAttribute("minPage", minPage); // 페이지네이션에서 사용될 가장 작은 페이지 범위
	    model.addAttribute("maxPage", maxPage); // 페이지네이션에서 사용될 가장 큰 페이지 범위
	    
	    return "/emp/empList"; // 사원 목록 페이지로 이동
 	}
 	
 	// 사원 목록 액션
 	@PostMapping("/emp/empList")
 	public String empList() {
 		
 		log.debug(CC.YE + "EmpController Post empList() : " + CC.RESET);
 	    return "/emp/empList";
 	}
}
