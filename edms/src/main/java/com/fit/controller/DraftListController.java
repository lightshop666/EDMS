package com.fit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.fit.mapper.DraftMapper;
import com.fit.vo.Approval;

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
}