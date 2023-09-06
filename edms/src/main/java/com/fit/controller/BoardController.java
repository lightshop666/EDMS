package com.fit.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.BoardService;
import com.fit.service.CommonPagingService;
import com.fit.vo.Board;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private CommonPagingService commonPagingService;
	
	// 게시글 추가 폼
	@GetMapping("/board/addBoard")
	public String addBoard(Model model, HttpSession session) {
		int empNo = (int)session.getAttribute("loginMemberId");
		log.debug(CC.YE + "BoardController.addBoard() empNo : " + empNo + CC.RESET);
		
		String deptName = (String)session.getAttribute("deptName");
		log.debug(CC.YE+"BoardController.addBoard() deptName : " + deptName + CC.RESET);
		
		String empName = (String)session.getAttribute("empName");
		log.debug(CC.YE+"BoardController.addBoard() empName : " + empName + CC.RESET);
		
		model.addAttribute(empNo);
		model.addAttribute("empName");
		model.addAttribute("deptName");
		return "/board/addBoard";
	}
	
	// 전체 게시글 조회
	@GetMapping("/board/boardList")
	public String boardList(Model model
							, @RequestParam(name = "currentPage", defaultValue = "1") int currentPage // 현재 페이지
							, @RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage // 한 페이지 당 행의 수
							, @RequestParam(name = "searchCol", defaultValue = "", required = false) String searchCol // 검색항목
				            , @RequestParam(name = "searchWord", defaultValue = "", required = false) String searchWord // 검색어
							, @RequestParam(name = "boardCategory", defaultValue = "") String boardCategory) { // 부서별 조회
		
		// 1. 페이지 시작 행
 	    int beginRow = (currentPage-1) * rowPerPage;
 	    
 	    // 2. parameter Map
 	    Map<String, Object> param = new HashMap<>();
 	    param.put("searchCol", searchCol); // 검색항목
	    log.debug(CC.YE + "BoardController.boardList() searchCol: " + searchCol + CC.RESET);
	    param.put("searchWord", searchWord); // 검색어
	    log.debug(CC.YE + "BoardController.boardList() searchWord: " + searchWord + CC.RESET);
 	    param.put("boardCategory", boardCategory);
 	    param.put("beginRow", beginRow);
 	    param.put("rowPerPage", rowPerPage);
		
 	    // 3. 공지 목록
 		List<Map<String, Object>> boardList = boardService.selectBoard(param);
 			
 		// 4. 페이징
    	// 4-1. 검색어가 적용된 리스트의 전체 행 개수를 구해주는 메서드 실행
		int totalCount = boardService.boardCount(param);
		log.debug(CC.YE + "BoardService.boardList() totalCount: " + totalCount + CC.RESET);
		// 4.2. 마지막 페이지 계산
		int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage);
		log.debug(CC.YE + "BoardService.boardList() lastPage: " + lastPage + CC.RESET);
		// 4.3. 페이지네이션에 표기될 쪽 개수
		int pagePerPage = 5;
		// 4.4. 페이지네이션에서 사용될 가장 작은 페이지 범위
		int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
		log.debug(CC.YE + "BoardService.boardList() minPage: " + minPage + CC.RESET);
		// 4.5. 페이지네이션에서 사용될 가장 큰 페이지 범위
		int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
		log.debug(CC.YE + "BoardService.boardList() maxPage: " + maxPage + CC.RESET);
		
	    // 5. 모델값 view에 전달
		model.addAttribute("board", boardList); // 공지 목록
	    model.addAttribute("totalCount", totalCount); // 전체 행 개수
	    model.addAttribute("lastPage", lastPage); // 마지막 페이지
	    model.addAttribute("minPage", minPage); // 페이지네이션에서 사용될 가장 작은 페이지 범위
	    model.addAttribute("maxPage", maxPage); // 페이지네이션에서 사용될 가장 큰 페이지 범위
	    model.addAttribute("param", param); // 파라미터 값
	    model.addAttribute("boardCategory", boardCategory); // 정렬값 유지
	    
		return "/board/boardList";
	}
}
