package com.fit.restapi;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.CC;
import com.fit.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class BoardRest {
	
	@Autowired
	private BoardService boardService;
	
	// 파일 삭제
	@PostMapping("/removeBoardFile")
	public String removeBoardFile(HttpServletRequest request, int boardFileNo) {
		String result = "undefined";  // 초기값 지정

		String path = request.getServletContext().getRealPath("/file/board/");
        
		int removeFileRow = boardService.removeFile(boardFileNo, path);
		log.debug(CC.YE + "BoardRest.removeSummernoteImageFile removeFileRow : " + removeFileRow + CC.RESET);
		
		if(removeFileRow == -1) {
			// 삭제 실패
			result = "fail";
		} else if (removeFileRow == 1) {
			// 삭제 성공
			result = "success";
		}

		return result;
	}
}
