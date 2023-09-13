package com.fit.restapi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fit.CC;
import com.fit.mapper.DraftMapper;
import com.fit.service.CommonPagingService;
import com.fit.service.DraftService;
import com.fit.vo.EmpInfo;
import com.fit.vo.MemberFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class DraftRest {
	
	@Autowired
	private DraftService draftService;
	
	@Autowired
	private DraftMapper draftMapper;
	
	@Autowired
	private CommonPagingService commonPagingService;
	
	// 서명 이미지 조회
	@PostMapping("/alertAndRedirectIfNoSign")
	public boolean checkMemberSign(HttpSession session) {
		// 세션에서 사원번호 가져오기
		int empNo = (int) session.getAttribute("loginMemberId");
		// 기존 서비스 호출
		MemberFile memberSign = draftService.selectMemberSign(empNo);
		
		if (memberSign == null) {
			return false;
		}
		
		return true;
	}
	
	// 이미 존재하는 기준년월 조회
	@PostMapping("/getExistingSalesDates")
	public List<String> getExistingSalesDates(String today, String previousMonth, String previousMonthBefore) {
		log.debug(CC.HE + "DraftRest.getExistingSalesDates() today param : " + today + CC.RESET);
		log.debug(CC.HE + "DraftRest.getExistingSalesDates() previousMonth param : " + previousMonth + CC.RESET);
		log.debug(CC.HE + "DraftRest.getExistingSalesDates() previousMonthBefore param : " + previousMonthBefore + CC.RESET);
		
		List<String> salesDateList = draftMapper.selectSalesDateList(today, previousMonth, previousMonthBefore);
		log.debug(CC.HE + "DraftRest.getExistingSalesDates() salesDateList : " + salesDateList + CC.RESET);
	
		return salesDateList;
	}
	
	// 기존 파일 삭제 (document_file)
	@PostMapping("/deleteDocumentFile")
	public int deleteDocumentFile(HttpServletRequest request, int docFileNo, String docSaveFilename) {
		String path = request.getServletContext().getRealPath("/file/document/");
		log.debug(CC.HE + "DraftRest.deleteDocumentFile() path : " + path + CC.RESET);
		log.debug(CC.HE + "DraftRest.deleteDocumentFile() docFileNo param : " + docFileNo + CC.RESET);
		log.debug(CC.HE + "DraftRest.deleteDocumentFile() docSaveFilename param : " + docSaveFilename + CC.RESET);
		
		// 파일 삭제 서비스 호출
		int row = draftService.removeDocumentFile(path, docFileNo, docSaveFilename);
		
		return row;
	}
	
	// 검색조건에 따라 동적으로 변경되는 사원목록 조회
	@PostMapping("/getEmpInfoListByPage")
	public Map<String, Object> getEmpInfoListByPage(@RequestParam(required = false, name = "ascDesc", defaultValue = "") String ascDesc // 오름차순, 내림차순
            , @RequestParam(required = false, name = "deptName", defaultValue = "") String deptName // 부서명
            , @RequestParam(required = false, name = "teamName", defaultValue = "") String teamName // 팀명
            , @RequestParam(required = false, name = "empPosition", defaultValue = "") String empPosition // 직급
            , @RequestParam(required = false, name = "searchCol", defaultValue = "") String searchCol // 검색항목
            , @RequestParam(required = false, name = "searchWord", defaultValue = "") String searchWord // 검색어
            , @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage // 현재 페이지
            ) {
		
		// 페이지 시작 행
		int rowPerPage = 10;
 	    int beginRow = (currentPage-1) * rowPerPage;
 	    
 	    // 매퍼 호출을 위해 매개값 Map에 담기
 	    Map<String, Object> paramMap = new HashMap<>();
 	    paramMap.put("ascDesc", ascDesc);
 	    paramMap.put("deptName", deptName);
 	    paramMap.put("teamName", teamName);
 	    paramMap.put("empPosition", empPosition);
 	    paramMap.put("searchCol", searchCol);
 	    paramMap.put("searchWord", searchWord);
 	    paramMap.put("beginRow", beginRow);
 	    paramMap.put("rowPerPage", rowPerPage);
 	    
 	    // 매퍼 호출
 	    List<EmpInfo> resultList = draftMapper.getEmpInfoListByPage(paramMap);
 	    
 	    // 페이징을 위한 작업
 	    int totalCount = draftMapper.getEmpInfoListByPageCnt(paramMap);
 	    int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage);
 	    int pagePerPage = 5;
 	    int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
 	    int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
 	    
 	    Map<String, Object> resultMap = new HashMap<>();
 	    resultMap.put("resultList", resultList);
 	    resultMap.put("totalCount", totalCount);
 	    resultMap.put("lastPage", lastPage);
 	    resultMap.put("minPage", minPage);
 	    resultMap.put("maxPage", maxPage);
 	    resultMap.put("param", paramMap);
 	   
 	    return resultMap;
	}
}
