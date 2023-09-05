package com.fit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.service.DraftService;
import com.fit.service.CommonPagingService;
import com.fit.CC;
import com.fit.mapper.DraftMapper;
import com.fit.vo.Approval;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DraftListController {

	@Autowired DraftService draftService;
	@Autowired CommonPagingService commonPagingService;	
	@Autowired
    private DraftMapper draftMapper;
	
	@GetMapping("/draft/submitDraft")
	public String getSubmitDraft(
		Model model, HttpSession session
		, @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
		, @RequestParam(name = "rowPerPage", required = false, defaultValue = "10") int rowPerPage
		, @RequestParam(name = "startDate", required = false, defaultValue = "") String startDate
		, @RequestParam(name= "endDate", required = false, defaultValue = "") String endDate
		, @RequestParam(name= "searchCol", required = false, defaultValue = "") String searchCol
		, @RequestParam(name= "searchWord", required = false, defaultValue = "") String searchWord
		, @RequestParam(name= "col", required = false, defaultValue = "") String col
		, @RequestParam(name= "ascDesc", required = false, defaultValue = "") String ascDesc
		) {
		int empNo = (int) session.getAttribute("loginMemberId");
		    

		    // 검색 조건을 포함한 목록을 가져오도록 수정
		    Map<String, Object> filterParams = new HashMap<>();
		    filterParams.put("startDate", startDate);
		    filterParams.put("endDate", endDate);
		    filterParams.put("col", col);
		    filterParams.put("ascDesc", ascDesc);
		    filterParams.put("searchCol", searchCol);
		    filterParams.put("searchWord", searchWord);
		    filterParams.put("beginRow", (currentPage - 1) * rowPerPage); // 시작 행
		    filterParams.put("rowPerPage", rowPerPage); // 페이지당 행 수
	
		    int totalCount = draftService.getTotalDraftCount(filterParams,empNo); // 전체 게시물 수
		    
		    // 페이징 처리를 위한 필요한 변수들 계산
		    int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage); // 마지막 페이지
		    int pagePerPage = 5;
		    int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
		    int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
	
		    
		    List<Approval> draftList = draftService.getFilteredDrafts(filterParams, empNo);
		    model.addAttribute("draftList", draftList);
		    model.addAttribute("currentPage", currentPage);
		    model.addAttribute("minPage", minPage);
		    model.addAttribute("maxPage", maxPage);
		    model.addAttribute("lastPage", lastPage);
	
		    List<Map<String, Object>> countState = draftMapper.getApprovalStatusByEmpNo(empNo);

		    int approvalDraftCount = 0;
		    int approvalInProgressCount = 0;
		    int approvalCompletCount = 0;
		    int approvalRejectCount = 0;
		    int approvalsaveCount = 0;

		    for (Map<String, Object> statusMap : countState) {
		        String approvalState = (String)statusMap.get("approvalState");
		        int count = ((Long) statusMap.get("count")).intValue(); // count가 Long 타입으로 들어올 수 있으므로 형변환 필요
		        
		        switch (approvalState) {
		            case "결재대기":
		                approvalDraftCount = count;
		                break;
		            case "결재중":
		                approvalInProgressCount = count;
		                break;
		            case "결재완료":
		                approvalCompletCount = count;
		                break;
		            case "반려":
		                approvalRejectCount = count;
		                break;
		            case "임시저장":
		                approvalsaveCount = count;
		                break;
		        }
		    }
		    
		    model.addAttribute("approvalDraftCount", approvalDraftCount);
		    model.addAttribute("approvalInProgressCount", approvalInProgressCount);
		    model.addAttribute("approvalCompletCount", approvalCompletCount);
		    model.addAttribute("approvalRejectCount", approvalRejectCount);
		    model.addAttribute("approvalsaveCount", approvalsaveCount);
		    
		    return "draft/submitDraft"; // submitDraft.jsp 페이지로 포워딩
	}
	
	@GetMapping("/draft/receiveDraft")
	public String getReceiveDraft(
		Model model, HttpSession session
		, @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
		, @RequestParam(name = "rowPerPage", required = false, defaultValue = "10") int rowPerPage
		, @RequestParam(name = "startDate", required = false, defaultValue = "") String startDate
		, @RequestParam(name= "endDate", required = false, defaultValue = "") String endDate
		, @RequestParam(name= "searchCol", required = false, defaultValue = "") String searchCol
		, @RequestParam(name= "searchWord", required = false, defaultValue = "") String searchWord
		, @RequestParam(name= "col", required = false, defaultValue = "") String col
		, @RequestParam(name= "ascDesc", required = false, defaultValue = "") String ascDesc
		) {
		int empNo = (int) session.getAttribute("loginMemberId");
		   
	
		    // 검색 조건을 포함한 목록을 가져오도록 수정
		    Map<String, Object> filterParams = new HashMap<>();
		    filterParams.put("startDate", startDate);
		    filterParams.put("endDate", endDate);
		    filterParams.put("col", col);
		    filterParams.put("ascDesc", ascDesc);
		    filterParams.put("searchCol", searchCol);
		    filterParams.put("searchWord", searchWord);
		    filterParams.put("beginRow", (currentPage - 1) * rowPerPage); // 시작 행
		    filterParams.put("rowPerPage", rowPerPage); // 페이지당 행 수
	
		    int totalCount = draftService.getTotalReceiveCount(filterParams,empNo); // 전체 게시물 수
		    
		    // 페이징 처리를 위한 필요한 변수들 계산
		    int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage); // 마지막 페이지
		    int pagePerPage = 5;
		    int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
		    int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
		    
		    List<Approval> draftList = draftService.getFilteredReceiveDrafts(filterParams, empNo);
		    model.addAttribute("draftList", draftList);
		    model.addAttribute("currentPage", currentPage);
		    model.addAttribute("minPage", minPage);
		    model.addAttribute("maxPage", maxPage);
		    model.addAttribute("lastPage", lastPage);
	
		    List<Map<String, Object>> countState = draftMapper.getApprovalStatusByEmpNo(empNo);

		    int approvalDraftCount = 0;
		    int approvalInProgressCount = 0;
		    int approvalCompletCount = 0;
		    int approvalRejectCount = 0;
		    int approvalsaveCount = 0;

		    for (Map<String, Object> statusMap : countState) {
		        String approvalState = (String)statusMap.get("approvalState");
		        int count = ((Long) statusMap.get("count")).intValue(); // count가 Long 타입으로 들어올 수 있으므로 형변환 필요
		        
		        switch (approvalState) {
		            case "결재대기":
		                approvalDraftCount = count;
		                break;
		            case "결재중":
		                approvalInProgressCount = count;
		                break;
		            case "결재완료":
		                approvalCompletCount = count;
		                break;
		            case "반려":
		                approvalRejectCount = count;
		                break;
		            case "임시저장":
		                approvalsaveCount = count;
		                break;
		        }
		    }
		    
		    model.addAttribute("approvalDraftCount", approvalDraftCount);
		    model.addAttribute("approvalInProgressCount", approvalInProgressCount);
		    model.addAttribute("approvalCompletCount", approvalCompletCount);
		    model.addAttribute("approvalRejectCount", approvalRejectCount);
		    model.addAttribute("approvalsaveCount", approvalsaveCount);
		    return "draft/receiveDraft"; // submitDraft.jsp 페이지로 포워딩
	}
	
	// 결재함 리스트
	@GetMapping("/draft/approvalDraft")
	public String approvalDraftList(HttpSession session
			, @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
			, @RequestParam(name = "rowPerPage", required = false, defaultValue = "10") int rowPerPage
			, @RequestParam(name = "startDate", required = false, defaultValue = "") String startDate
			, @RequestParam(name= "endDate", required = false, defaultValue = "") String endDate
			, @RequestParam(name= "searchCol", required = false, defaultValue = "") String searchCol
			, @RequestParam(name= "searchWord", required = false, defaultValue = "") String searchWord
			, @RequestParam(name= "col", required = false, defaultValue = "") String col
			, @RequestParam(name= "ascDesc", required = false, defaultValue = "") String ascDesc
			, Model model) {
		/*
			1. 세션 사원번호
			2. 해당 사원번호가 중간승인자 or 최종승인자인 approval 문서 전부 조회, 단 결재상태가 임시저장인 것은 조회하면 안됨
			3. 리스트 조회 내용 -> 양식종류, 기안자, 제목, 결재상태, 기안일
			4. + 검색조건 -> 기간별, 정렬, 항목별 검색단어
			5. 결재상태별 cnt
		*/
		// 세션 정보 조회하여 로그인 유무 및 권한 조회 후 분기 예정
		// 로그인 유무 -> 인터셉터 처리
		// 권한 분기 -> 메인메뉴에서 처리
		
		log.debug(CC.HE + "DraftListController.approvalDraftList() currentPage : " + currentPage + CC.RESET);
		log.debug(CC.HE + "DraftListController.approvalDraftList() rowPerPage : " + rowPerPage + CC.RESET);
		log.debug(CC.HE + "DraftListController.approvalDraftList() startDate : " + startDate + CC.RESET);
		log.debug(CC.HE + "DraftListController.approvalDraftList() endDate : " + endDate + CC.RESET);
		log.debug(CC.HE + "DraftListController.approvalDraftList() searchCol : " + searchCol + CC.RESET);
		log.debug(CC.HE + "DraftListController.approvalDraftList() searchWord : " + searchWord + CC.RESET);
		log.debug(CC.HE + "DraftListController.approvalDraftList() col : " + col + CC.RESET);
		log.debug(CC.HE + "DraftListController.approvalDraftList() ascDesc : " + ascDesc + CC.RESET);
		
		// 1. 세션 정보 조회
		int empNo = (int) session.getAttribute("loginMemberId");
		// 2. 검색조건 및 페이징 조건을 map에 담기
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("empNo", empNo);
	    paramMap.put("startDate", startDate);
	    paramMap.put("endDate", endDate);
	    paramMap.put("col", col);
	    paramMap.put("ascDesc", ascDesc);
	    paramMap.put("searchCol", searchCol);
	    paramMap.put("searchWord", searchWord);
	    paramMap.put("beginRow", (currentPage - 1) * rowPerPage); // 시작 행
	    paramMap.put("rowPerPage", rowPerPage); // 페이지당 행 수
	    
	    // 3. 서비스 호출
	    Map<String, Object> result = draftService.getApprovalDraftList(paramMap);
	    List<Approval> approvalDraftList = (List<Approval>) result.get("approvalDraftList");
	    int approvalDraftCnt = (int) result.get("approvalDraftCnt");
	    int approvalDraftCount = (int) result.get("approvalDraftCount");
	    int approvalInProgressCount = (int) result.get("approvalInProgressCount");
	    int approvalCompletCount = (int) result.get("approvalCompletCount");
	    int approvalRejectCount = (int) result.get("approvalRejectCount");
	    int approvalsaveCount = (int) result.get("approvalsaveCount");
	    
	    // 페이징 처리를 위한 필요한 변수들 계산 // commonPagingService 사용
	    int lastPage = commonPagingService.getLastPage(approvalDraftCnt, rowPerPage); // 마지막 페이지
	    int pagePerPage = 5;
	    int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
	    int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
	    
	    model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("col", col);
	    model.addAttribute("ascDesc", ascDesc);
	    model.addAttribute("searchCol", searchCol);
	    model.addAttribute("searchWord", searchWord);
	    model.addAttribute("approvalDraftList", approvalDraftList);
	    model.addAttribute("currentPage", currentPage);
	    model.addAttribute("minPage", minPage);
	    model.addAttribute("maxPage", maxPage);
	    model.addAttribute("lastPage", lastPage);
	    model.addAttribute("approvalDraftCount", approvalDraftCount);
	    model.addAttribute("approvalInProgressCount", approvalInProgressCount);
	    model.addAttribute("approvalCompletCount", approvalCompletCount);
	    model.addAttribute("approvalRejectCount", approvalRejectCount);
	    model.addAttribute("approvalsaveCount", approvalsaveCount);
		
		return "/draft/approvalDraft";
	}
	
	// 임시저장함 리스트
	@GetMapping("/draft/tempDraft")
	public String tempDraftList(HttpSession session
			, @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
			, @RequestParam(name = "rowPerPage", required = false, defaultValue = "10") int rowPerPage
			, @RequestParam(name = "startDate", required = false, defaultValue = "") String startDate
			, @RequestParam(name= "endDate", required = false, defaultValue = "") String endDate
			, @RequestParam(name= "searchCol", required = false, defaultValue = "") String searchCol
			, @RequestParam(name= "searchWord", required = false, defaultValue = "") String searchWord
			, @RequestParam(name= "col", required = false, defaultValue = "") String col
			, @RequestParam(name= "ascDesc", required = false, defaultValue = "") String ascDesc
			, Model model) {
		// 세션 정보 조회하여 로그인 유무 및 권한 조회 후 분기 예정
		// 로그인 유무 -> 인터셉터 처리
		// 권한 분기 -> 메인메뉴에서 처리
		// 1. 세션 정보 조회
		int empNo = (int) session.getAttribute("loginMemberId");
		// 2. 검색조건 및 페이징 조건을 map에 담기
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("empNo", empNo);
	    paramMap.put("startDate", startDate);
	    paramMap.put("endDate", endDate);
	    paramMap.put("col", col);
	    paramMap.put("ascDesc", ascDesc);
	    paramMap.put("searchCol", searchCol);
	    paramMap.put("searchWord", searchWord);
	    paramMap.put("beginRow", (currentPage - 1) * rowPerPage); // 시작 행
	    paramMap.put("rowPerPage", rowPerPage); // 페이지당 행 수
	    
	    // 3. 서비스호출
	    Map<String, Object> result = draftService.getTempDraftList(paramMap);
	    List<Approval> tempDraftList = (List<Approval>) result.get("tempDraftList");
	    int tempDraftCnt = (int) result.get("tempDraftCnt");
	    
	    // 페이징 처리를 위한 필요한 변수들 계산 // commonPagingService 사용
	    int lastPage = commonPagingService.getLastPage(tempDraftCnt, rowPerPage); // 마지막 페이지
	    int pagePerPage = 5;
	    int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
	    int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
	    
	    model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("col", col);
	    model.addAttribute("ascDesc", ascDesc);
	    model.addAttribute("searchCol", searchCol);
	    model.addAttribute("searchWord", searchWord);
	    model.addAttribute("tempDraftList", tempDraftList);
	    model.addAttribute("currentPage", currentPage);
	    model.addAttribute("minPage", minPage);
	    model.addAttribute("maxPage", maxPage);
	    model.addAttribute("lastPage", lastPage);
	    
		return "/draft/tempDraft";
	}
	
	// 임시저장 문서 일괄 삭제
	@PostMapping("/draft/tempDraft")
	public String removeTempDraft(@RequestParam(name = "approvalNo") int[] approvalNo,
            					HttpServletRequest request) {
		// 세션 정보 조회하여 로그인 유무 및 권한 조회 후 분기 예정
		// 로그인 유무 -> 인터셉터 처리
		// 권한 분기 -> 메인메뉴에서 처리
		log.debug(CC.HE + "DraftListController.removeTempDraft() approvalNo.length : " + approvalNo.length + "개" + CC.RESET);
		for(int i = 0; i < approvalNo.length; i++) {
			log.debug(CC.HE + "DraftListController.removeTempDraft() approvalNo[" + i + "] param : " + approvalNo[i] + CC.RESET);
		}
		// 파일 삭제를 위한 경로 구하기
		String path = request.getServletContext().getRealPath("/file/document/");
		// 모든 매개값 map에 담기
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("approvalNo", approvalNo);
		paramMap.put("path", path);
		// 서비스 호출
		int row = draftService.removeTempDraft(paramMap);
		// 서비스 결과에 따라 분기
		if (row != 0) {
			log.debug(CC.HE + "DraftListController.removeTempDraft() 삭제 성공 row : " + row + CC.RESET);
			return "redirect:/draft/tempDraft?result=success";
		} else {
			log.debug(CC.HE + "DraftListController.removeTempDraft() 삭제 실패" + CC.RESET);
			return "redirect:/draft/tempDraft?result=fail";
		}
	}
}