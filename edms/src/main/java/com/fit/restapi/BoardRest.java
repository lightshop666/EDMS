package com.fit.restapi;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class BoardRest {
	
	@Autowired
    private BoardService boardService;
	
	// 파일 업로드
	@PostMapping(value="/uploadSummernoteImageFile")
	public Map<String, Object> uploadSummernoteImageFile(HttpServletRequest request
														 , HttpSession session
														 , @RequestParam("file") MultipartFile file) throws IllegalStateException, IOException {	
		// 파일의 경로
		String path = request.getServletContext().getRealPath("/file/board/"); //직접 실제 위치(경로)를 구해서 service에 넘겨주는 api
	    log.debug(CC.YE + "BoardService.uploadSummernoteImageFile() path : " + path + CC.RESET);
	      
		Map<String, Object> resultMap = boardService.addFile(file, path);	//파일 저장
		log.debug(CC.YE + "BoardService.uploadSummernoteImageFile() path : " + path + CC.RESET);
		
		Map<String, Object> addBoardResultMap = new HashMap<>();
		addBoardResultMap.put("boardFileNo", resultMap.get("boardFileNo"));
		log.debug(CC.YE + "BoardService.uploadSummernoteImageFile() addBoardResultMap boardFileNo : " + resultMap.get("boardFileNo") + CC.RESET);
		
		addBoardResultMap.put("savePath", request.getContextPath() + "/file/board/" + resultMap.get("boardSaveFileName"));
		log.debug(CC.YE + "BoardService.uploadSummernoteImageFile() addBoardResultMap savePath : " + path+resultMap.get("boardSaveFileName") + CC.RESET);
		
		return addBoardResultMap;
	}
	
	// 파일 삭제
	@PostMapping("/removeSummernoteimageFile")
	public String removeSummernoteImageFile(int boardFileNo) {
		String result = "undefined";  // 초기값 지정
		
		int removeFileRow = boardService.removeFile(boardFileNo);
		log.debug(CC.YE + "BoardRest.removeSummernoteImageFile removeFileRow : " + removeFileRow + CC.RESET);
		
		if(removeFileRow == 0) {
			result = "dismatch";
		} else if(removeFileRow == -1) {
			result = "fail";
		} else if (removeFileRow == 1) {
			result = "success";
		} else if (removeFileRow == -2) {
			result = "none";
		}
		
		return result;
	}
}
