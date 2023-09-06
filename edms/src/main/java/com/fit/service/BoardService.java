package com.fit.service;
import java.io.File;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fit.mapper.BoardMapper;
import com.fit.vo.BoardFile;
import com.fit.vo.EmpInfo;
import com.fit.vo.Board;
import com.fit.CC;
import com.fit.mapper.BoardFileMapper;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardService {
	@Autowired
	private BoardMapper boardMapper;
	
	@Autowired
	private BoardFileMapper boardFileMapper;
	
	// boardContent 내 파일'만' 저장하는 메서드
	public Map<String, Object> addFile(MultipartFile file, String path) throws IllegalStateException, IOException {

		// 파일명
		String originalFileName = file.getOriginalFilename();
		log.debug(CC.YE + "BoardService.addFile originalFileName : " + originalFileName + CC.RESET);
		
		// 파일 확장자
		String ext = originalFileName.substring(originalFileName.lastIndexOf("."));	
		log.debug(CC.YE + "BoardService.addFile ext : " + ext + CC.RESET);
		
		// 새롭게 저장될 파일 명
		String savedFileName = UUID.randomUUID() + ext;
		log.debug(CC.YE + "BoardService.addFile savedFileName : " + savedFileName + CC.RESET);
		
		// 파일 타입
		String contentType = file.getContentType();
		log.debug(CC.YE + "BoardService.addFile contentType : " + contentType + CC.RESET);
		
		// 객체에 담기
		BoardFile newBoardFile = new BoardFile();
		newBoardFile.setBoardOriFileName(originalFileName);
		newBoardFile.setBoardSaveFileName(savedFileName);
		newBoardFile.setBoardPath("/file/board/");
		newBoardFile.setBoardFileType(contentType);
		
		// DB에 저장
		int addBoardFileRow = boardFileMapper.addBoardFile(newBoardFile);
		log.debug(CC.YE + "BoardService.addFile addBoardFileRow : " + addBoardFileRow + CC.RESET);
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("boardFileNo", newBoardFile.getBoardFileNo()); // 자동으로 설정된 boardFileNo를 가져옴
		resultMap.put("boardSaveFileName", newBoardFile.getBoardSaveFileName()); // 이미 설정된 boardSaveFileName을 가져옴
		
		// 파일 객체 생성
		File f = new File(path + savedFileName);
		log.debug(CC.YE + "BoardService.addFile File f : " + f + CC.RESET);
		
		if(addBoardFileRow > 0) {
			log.debug(CC.YE + "BoardService.addFile file transfer success" + CC.RESET);
			file.transferTo(f); // 빈 파일에 첨부된 파일의 스트림을 주입
		} else {
			log.debug(CC.YE + "BoardService.addFile file transfer fail" + CC.RESET);
		}
		
		// 성공 후에는 저장된 파일의 이름을 반환(view에서 비동기로 파일 정보를 받아, content에 보여줘야하기 때문)
		return resultMap;
	}
	
	// boardContent 내 파일'만' 삭제하는 메서드
	public int removeFile(int boardFileNo) {
		
		// 1. boardFileNo로 데이터베이스에서 파일 정보를 조회
        BoardFile boardFileOne = boardFileMapper.selectBoardFileOne(boardFileNo);
        
	        // boardFileNo에 해당하는 board 정보가 없을 경우
	        if (boardFileOne == null) {
	            return 0; // 파일 정보가 없으면 0 반환
	        }
        
        // 2. 메서드 매개값들 확인
	    String path = "/file/board/";
        String boardSaveFileName = boardFileOne.getBoardSaveFileName();
        String fullFilePath = path + boardSaveFileName;
        
        int boardNo = boardFileOne.getBoardNo();
        
        // 3. 실제 파일 삭제 로직
        File f = new File(fullFilePath);
        if (f.exists()) {
            if (f.delete()) {
                // 성공적으로 파일을 삭제했다면, 이제 데이터베이스에서도 삭제합니다.
                int removeRow = boardFileMapper.removeBoardFile(boardNo, boardFileNo);
                log.debug(CC.YE + "BoardService.removeFile() removeRow : " + removeRow + CC.RESET);
                return 1; // 성공
            } else {
            	log.debug(CC.YE + "BoardService.removeFile() File deletion failed"+ CC.RESET);
            	return -1; // 파일 삭제 실패
            }
        } else {
        	log.debug(CC.YE + "BoardService.removeFile() File does not exist"+ CC.RESET);
        	return -2; // 파일이 존재하지 않음
        }
    }
	
	// 전체 게시글 조회
	public List<Map<String, Object>> selectBoard(Map<String, Object> param) {
		
		// 게시글 결과 값 반환
		List<Map<String, Object>> boardList = boardMapper.selectBoardList(param);
		log.debug(CC.YE + "BoardService.selectBoard() boardList : " + boardList + CC.RESET);
    	
		return boardList;
	}
	// 전체 게시글 조회(HOME)
	public List<Map<String, Object>> selectBoardHome(){
		
		// 중요공지로 이루어진 리스트를 반환
		List<Map<String, Object>> selectBoardHome = boardMapper.selectBoardHome();
		log.debug(CC.YE + "BoardService.selectBoardHome() selectBoardHome : " + selectBoardHome + CC.RESET);
		
		return selectBoardHome;
	}
	// 전체 게시글 목록 페이징(조건에 따른 행의 수)
	public int boardCount(Map<String, Object> param) {
		int boardCount = boardMapper.selectBoardCount(param);
		log.debug(CC.YE + "BoardService.getBoardCount() boardCount : " + boardCount + CC.RESET);	 
		return boardCount;
	}
}
