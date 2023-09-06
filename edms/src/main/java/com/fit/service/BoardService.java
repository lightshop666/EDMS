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
	
	// 게시글 추가
	public int addBoard(Board board, String path) {
		
		// 중요 공지 개수 체크
	    int topExposureCount = boardMapper.topExposureCnt();
	    if (topExposureCount >= 3 && "Y".equals(board.getTopExposure())) {
	    	log.debug(CC.YE + "BoardService.addBoard() topExposureCount > 3" + CC.RESET);
	        return 0;
	    }
		
		int row = boardMapper.addBoard(board); // 성공 시 board의 boardNo가 키 값으로 채워짐
		
		// VO 파일리스트 호출
		List<MultipartFile> fileList = board.getMultipartFile();
		
		// board 입력에 성공 + 첨부된 파일이 1개 이상이고 + 그 크기가 1보다 클때
		if(row == 1 && fileList != null && fileList.size() >= 1) {
			
			int boardNo = board.getBoardNo();
			
			for(MultipartFile mf : fileList) { // 첨부된 파일의 개수만큼 반복
				if(mf.getSize() > 0) {
					BoardFile bf = new BoardFile();
					bf.setBoardNo(boardNo); // 부모 키값
					bf.setBoardOriFileName(mf.getOriginalFilename()); // 파일 원본이름
					bf.setBoardFileType(mf.getContentType()); // 파일타입
					bf.setBoardPath(path);
				// 저장될 파일 이름
					// 확장자 (고유성을 지킬 수 있으며, 일반적인 파일 이름 형식을 준수할 수 있음)
					String ext = mf.getOriginalFilename().substring(mf.getOriginalFilename().lastIndexOf(".")); //마지막 점(.)의 위치부터 끝까지 자르는 코드
					
					// randomUUID()를 이용한 새 이름 구하기
					bf.setBoardSaveFileName(UUID.randomUUID().toString().replace("-","") + ext);
					
				// boardFile 테이블에 저장
					boardFileMapper.addBoardFile(bf);
					
				// 파일 저장(저장 위치 필요 -> path 변수)
					// path 위치에 저장파일 이름으로 빈 파일을 생성(0byte)
					File f = new File(path+bf.getBoardSaveFileName());
					
					try {
						mf.transferTo(f); // 빈 파일에 첨부된 파일의 스트림을 주입
					} catch(IllegalStateException | IOException e) {
						
						e.printStackTrace();
						// 트랜잭션 작동을 위해 예외(try..catch를 강용하지 않는 예외 ex: RuntimeException)를 발생하는 게 필요하다.
						throw new RuntimeException();
					}
				}
			}
		}
		return row; // 0 또는 1을 반환
	}
	
	// 게시글 수정
	public int modifyBoard(Board board) {
		
		// 중요 공지 개수 체크
	    int topExposureCount = boardMapper.topExposureCnt();
	    if (topExposureCount >= 3 && "Y".equals(board.getTopExposure())) {
	    	log.debug(CC.YE + "BoardService.modifyBoard() topExposureCount > 3" + CC.RESET);
	        return 0;
	    }
		
		int modifyBoardRow = boardMapper.modifyBoard(board);
		
		
		log.debug(CC.YE + "BoardService.modifyBoard() modifyBoardRow : " + modifyBoardRow + CC.RESET);
		
		return modifyBoardRow;
	}
	
	// 게시글 삭제
	public int removeBoard(Board board) {
		int removeBoardRow = boardMapper.removeBoard(board);
		log.debug(CC.YE + "BoardService.removeBoard() removeBoardRow : " + removeBoardRow + CC.RESET);
		
		return removeBoardRow;
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
		// 페이징 행 수
		int boardCount = boardMapper.selectBoardCount(param);
		log.debug(CC.YE + "BoardService.getBoardCount() boardCount : " + boardCount + CC.RESET);	 
		
		return boardCount;
	}
	
	// 하나의 게시글 조회
	public Map<String, Object> getSelectBoardOne(int boardNo) {
		// board 글 상세 정보
		Map<String, Object> boardOne = boardMapper.selectBoardOne(boardNo);
	    
		// boardFile 글에 저장된 파일 리스트
	    List<BoardFile> selectSaveFile = boardFileMapper.selectSaveFile(boardNo);
	    
	    // resultMap에 담아 사용
	    Map<String, Object> boardAndFileOne = new HashMap<String, Object>();
	    boardAndFileOne.put("boardOne", boardOne);
	    boardAndFileOne.put("selectSaveFile", selectSaveFile);
	    
	    return boardAndFileOne;
	}
}
