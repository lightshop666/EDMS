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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.service.BoardService;
import com.fit.service.CommonPagingService;
import com.fit.vo.Board;
import com.fit.websocket.NotificationService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private CommonPagingService commonPagingService;

	@Autowired	//알림을 위한 서비스 주입
	private NotificationService notificationService;
/* 추가 */	
	// 게시글 추가 폼
	@GetMapping("/board/addBoard")
	public String addBoard(Model model, HttpSession session) {
		int empNo = (int)session.getAttribute("loginMemberId");
		log.debug(CC.YE + "BoardController.addBoard() empNo : " + empNo + CC.RESET);

		String deptName = (String)session.getAttribute("deptName");
		log.debug(CC.YE+"BoardController.addBoard() deptName : " + deptName + CC.RESET);
		
		String empName = (String)session.getAttribute("empName");
		log.debug(CC.YE+"BoardController.addBoard() empName : " + empName + CC.RESET);
		
		model.addAttribute("empNo", empNo);
		model.addAttribute("empName", empName);
		model.addAttribute("deptName", deptName);
		
		return "/board/addBoard";
	}
	
	// 게시글 추가 액션
	@PostMapping("/board/addBoard")
	public String addBoard(HttpServletRequest request, Board board) {
		log.debug(CC.YE + "BoardController.addBoard() start" + CC.RESET); // debug 용도. static log 필드(5개)
		
		String result = "";
		
		// 경로 설정
		String path = request.getServletContext().getRealPath("/file/board/"); //직접 실제 위치(경로)를 구해서 service에 넘겨주는 api
		log.debug(CC.YE + "BoardController.addBoard() path : " + path + CC.RESET); // debug 용도. static log 필드(5개)
		
		// 추가
		int addRow = boardService.addBoard(board, path);
		log.debug(CC.YE + "BoardController.addBoard() addRow : " + addRow + CC.RESET); // debug 용도. static log 필드(5개)
		
		// 추가 성공 여부에 따라 redirect 설정
		if(addRow == 1) { // 성공
			//글로벌알림발송. 나를 제외시키기 위해 소켓ID를 받고 있으나 알림은 모두에게 간다.
			notificationService.sendGlobalNotification(result);			
			
			result = "redirect:/board/boardList?result=success";
		} else if(addRow == -1) { // 중요공지 설정 실패
			result = "redirect:/board/addBoard?result=fail";
		}  else if(addRow == -2) { // 이미 3개가 있는 경우
			result = "redirect:/board/addBoard?result=duplicate";
		}
		return result;
	}
	
/* 수정 */
	// 게시글 수정 폼
	@GetMapping("/board/modifyBoard")
	public String modifyBoard(Model model,
							  Board board,
							  @RequestParam(name = "boardNo", required = false) int boardNo) {
		log.debug(CC.YE + "BoardController.modifyBoard() boardNo : " + boardNo + CC.RESET);
		// 게시글 상세 정보 Map 가져오기
		Map<String, Object> resultMap = boardService.getSelectBoardOne(boardNo);
		// 글 정보 모델
		model.addAttribute("boardOne", resultMap.get("boardOne"));
		// 파일 정보 모델
		model.addAttribute("saveFileName", resultMap.get("selectSaveFile"));
		return "/board/modifyBoard";
	}
	
	// 게시글 수정 액션
	@PostMapping("/board/modifyBoard")
	public String modifyBoard(HttpServletRequest request, Board board) {
		// 반환값
		String result = "";
		// 게시글 번호
		int boardNo = board.getBoardNo();
		log.debug(CC.YE + "BoardController.modifyBoard() boardNo : " + boardNo + CC.RESET); // debug 용도. static log 필드(5개)
		
		// 경로 설정
		String path = request.getServletContext().getRealPath("/file/board/"); //직접 실제 위치(경로)를 구해서 service에 넘겨주는 api
		log.debug(CC.YE + "BoardController.addBoard() path : " + path + CC.RESET); // debug 용도. static log 필드(5개)
		
		// 수정 메서드 실행
		int modifyRow = boardService.modifyBoard(board, path);
		log.debug(CC.YE + "BoardController.modifyRow : " + modifyRow + CC.RESET);
		
		// 추가 성공 여부에 따라 redirect 설정
		if(modifyRow == 1) {
			result = "redirect:/board/boardList?boardNo="+boardNo+"&result=modify";
		} else if(modifyRow == 0) {
			result = "redirect:/board/modifyBoard?boardNo="+boardNo+"&result=fail";
		} else if(modifyRow == -1) {
			result = "redirect:/board/modifyBoard?boardNo="+boardNo+"&result=topExposure";
		}
		return result;
	}
	
/* 삭제 */
	// 게시글 삭제 액션
	@PostMapping("/board/removeBoard")
	public String removeBoard(@RequestParam(name = "boardNo") int boardNo // 현재 페이지
							  , @RequestParam(name = "empNo") int empNo 
							  , @RequestParam(name = "boardSaveFileName", required = false) List<String> boardSaveFileName
							  , HttpServletRequest request){ // 한 페이지 당 행의 수
		
		int removeRow = 0;
		// 경로 설정
		String path = request.getServletContext().getRealPath("/file/board/"); //직접 실제 위치(경로)를 구해서 service에 넘겨주는 api
		log.debug(CC.YE + "BoardController.removeBoard() path : " + path + CC.RESET); // debug 용도. static log 필드(5개)
	
		// board 글 및 파일 삭제
	    if (boardSaveFileName != null) {
	        removeRow = boardService.removeBoard(boardNo, empNo, boardSaveFileName, path);
	        log.debug(CC.YE + "BoardController.removeBoard() removeRow : " + removeRow + CC.RESET);
	    } else {
	    	removeRow = boardService.removeBoard(boardNo, empNo, boardSaveFileName, path);
	    	log.debug(CC.YE + "BoardController.removeBoard() boardSaveFileName is null" + CC.RESET);
	    }
	    
		return "redirect:/board/boardList?result=removed";
	}
	
/* 조회 */	
	// 전체 게시글 조회
	@GetMapping("/board/boardList")
	public String boardList(Model model, HttpSession session
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
		
		// 5. 권한 설정
		String accessLevel = boardService.selectAccess((int)session.getAttribute("loginMemberId"));
		
	    // 6. 모델값 view에 전달
		model.addAttribute("board", boardList); // 공지 목록
	    model.addAttribute("totalCount", totalCount); // 전체 행 개수
	    model.addAttribute("lastPage", lastPage); // 마지막 페이지
	    model.addAttribute("minPage", minPage); // 페이지네이션에서 사용될 가장 작은 페이지 범위
	    model.addAttribute("maxPage", maxPage); // 페이지네이션에서 사용될 가장 큰 페이지 범위
	    model.addAttribute("param", param); // 파라미터 값
	    model.addAttribute("accessLevel", accessLevel); // 권한
	    model.addAttribute("currentPage", currentPage); // 현재페이지
	    
		return "/board/boardList";
	}
	
	// 하나의 게시글 조회
	@GetMapping("/board/boardOne")
	public String boardList(Model model,
							@RequestParam(name = "boardNo") int boardNo) {
		Map<String, Object> boardAndFileOne = boardService.getSelectBoardOne(boardNo);
		
		// boardOne 글 정보 반환
		model.addAttribute("boardOne", boardAndFileOne.get("boardOne"));
		System.out.println(CC.YE + boardAndFileOne.get("boardOne") != null ? 1 : 0 + CC.RESET);
		// boardFile 파일 정보 반환
		model.addAttribute("saveFileName", boardAndFileOne.get("selectSaveFile"));
		System.out.println(CC.YE + boardAndFileOne.get("selectSaveFile")!=null? 1 : 0 + CC.RESET);
		
		return "/board/boardOne";
	}
}
