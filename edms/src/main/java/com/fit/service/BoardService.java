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
import com.fit.mapper.EmpMapper;
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
	
	@Autowired
	private EmpMapper empMapper;
	
	// 게시글 추가(글 + 파일 추가)
	public int addBoard(Board board, String path) {
		
		// 중요 공지 개수 체크
	    int topExposureCount = boardMapper.topExposureCnt();
	    if (topExposureCount >= 3 && "Y".equals(board.getTopExposure())) {
	    	log.debug(CC.YE + "BoardService.addBoard() topExposureCount > 3" + CC.RESET);
	        return -1;
	    }
	    
        int row = boardMapper.addBoard(board);
    		
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
					bf.setBoardPath("/file/board/");
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
	
	// 게시글 수정(글 수정+파일 추가)
	public int modifyBoard(Board board, String path) {
		// 반환 값
		int modifyBoard = 0;
		
	    // 글 수정
	    modifyBoard = boardMapper.modifyBoard(board);
		log.debug(CC.YE + "BoardService.modifyBoard() modifyBoard : " + modifyBoard + CC.RESET);
		
		int topExposureCount = boardMapper.topExposureCnt();
		
		// 제일 오래된 중요공지
		int board_no = boardMapper.topExposureAsc();
		
		// 중요 공지 개수 체크
	    if (topExposureCount > 3) {
	    	int topExposureChangeRow = boardMapper.topExposureChange(board_no);
	    	log.debug(CC.YE + "BoardService.modifyBoard() topExposureChangeRow : " + topExposureChangeRow + CC.RESET);
	    }
		
		// VO 파일리스트 호출
		List<MultipartFile> fileList = board.getMultipartFile();
		
		// board 입력에 성공 + 첨부된 파일이 1개 이상이고 + 그 크기가 1보다 클때
		if(modifyBoard == 1 && fileList != null && fileList.size() >= 1) {
			
			int boardNo = board.getBoardNo();
			
			for(MultipartFile mf : fileList) { // 첨부된 파일의 개수만큼 반복
				if(mf.getSize() > 0) {
					BoardFile bf = new BoardFile();
					bf.setBoardNo(boardNo); // 부모 키값
					bf.setBoardOriFileName(mf.getOriginalFilename()); // 파일 원본이름
					bf.setBoardFileType(mf.getContentType()); // 파일타입
					bf.setBoardPath("/file/board/");
				// 저장될 파일 이름
					// 확장자 (고유성을 지킬 수 있으며, 일반적인 파일 이름 형식을 준수할 수 있음)
					String ext = mf.getOriginalFilename().substring(mf.getOriginalFilename().lastIndexOf(".")); //마지막 점(.)의 위치부터 끝까지 자르는 코드
					
					// randomUUID()를 이용한 새 이름 구하기
					bf.setBoardSaveFileName(UUID.randomUUID().toString().replace("-","") + ext);
					
				// boardFile 테이블에 저장
					boardFileMapper.addBoardFile(bf);
					
				// 파일 저장(저장 위치 필요 -> path 변수)
					// path 위치에 저장파일 이름으로 빈 파일을 생성(0byte)
					File f = new File(path + bf.getBoardSaveFileName());
					
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
		return modifyBoard; // 0 또는 1을 반환
	}
	
	// 게시글 삭제
	public int removeBoard(int boardNo, int empNo, List<String> boardSaveFileName, String path) {
		int removeBoardRow = boardMapper.removeBoard(boardNo, empNo);
		log.debug(CC.YE + "BoardService.removeBoard() removeBoardRow : " + removeBoardRow + CC.RESET);
		
		if(boardSaveFileName != null) {
			// 배열에 있는 각 파일 이름을 반복하여 삭제
		    for (String fileName : boardSaveFileName) {
		        File f = new File(path + fileName);
		        if (f.exists()) {
		            if (!f.delete()) { // 파일 삭제가 실패하면 로그를 출력하고 실패 코드 반환
		                log.debug(CC.YE + "BoardService.removeFile() 파일 삭제 실패 : " + fileName + CC.RESET);
		                return -1; // 파일 삭제 실패
		            }
		        } else {
		            log.debug(CC.YE + "BoardService.removeFile() 파일이 존재하지 않음 : " + fileName + CC.RESET);
		            return -2; // 파일이 존재하지 않음
		        }
		    }
		} else {
			log.debug(CC.YE + "BoardService.removeFile() boardSaveFileName 존재하지 않음 : " + CC.RESET);
			return 1;
		}
	    return 1; // 성공
		
	}
	// 파일만 입력(미사용)
	public Map<String, Object> addFile(int boardNo, MultipartFile file, String path) throws IllegalStateException, IOException {
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
		newBoardFile.setBoardNo(boardNo);
		newBoardFile.setBoardOriFileName(originalFileName);
		newBoardFile.setBoardSaveFileName(savedFileName);
		newBoardFile.setBoardPath("/file/board/");
		newBoardFile.setBoardFileType(contentType);
		
		// DB에 저장
		int addBoardFileRow = boardFileMapper.addBoardFile(newBoardFile);
		log.debug(CC.YE + "BoardService.addFile addBoardFileRow : " + addBoardFileRow + CC.RESET);
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("boardOriFileName", newBoardFile.getBoardOriFileName()); // 자동으로 설정된 boardFileNo를 가져옴
		resultMap.put("boardFileNo", newBoardFile.getBoardFileNo()); // 이미 설정된 boardSaveFileName을 가져옴
		
		// 파일 객체 생성
		File f = new File(path + savedFileName);
		log.debug(CC.YE + "BoardService.addFile File f : " + f + CC.RESET);
		
		if(addBoardFileRow > 0) {
			log.debug(CC.YE + "BoardService.addFile file transfer success" + CC.RESET);
			file.transferTo(f); // 빈 파일에 첨부된 파일의 스트림을 주입
		} else {
			log.debug(CC.YE + "BoardService.addFile file transfer fail" + CC.RESET);
		}
		
		// 성공 후에는 저장된 파일의 이름을 반환(view에서 비동기로 파일 정보를 받아 보여줘야하기 때문)
		return resultMap;
	}
	
	// 파일만 삭제(사용)
	public int removeFile(int boardFileNo, String path) {
		
		// 1. boardFileNo로 데이터베이스에서 파일 정보를 조회
        BoardFile boardFileOne = boardFileMapper.selectBoardFileOne(boardFileNo);
        log.debug(CC.YE + "BoardService.removeFile() boardFileOne : " + boardFileOne + CC.RESET);
        
        // 2. 메서드 매개값
        String boardSaveFileName = boardFileOne.getBoardSaveFileName();
        log.debug(CC.YE + "BoardService.removeFile() boardFileOne boardSaveFileName : " + boardSaveFileName + CC.RESET);

        int boardNo = boardFileOne.getBoardNo();
        log.debug(CC.YE + "BoardService.removeFile() boardNo : " + boardNo + CC.RESET);
        
        
        // 3. 실제 파일 삭제 로직
        File f = new File(path + boardSaveFileName);
        log.debug(CC.YE + "BoardService.removeFile() f : " + f + CC.RESET);
        f.delete();
        if (!f.exists()) {
            // 성공적으로 파일을 삭제했다면, 데이터베이스에서도 삭제
            int removeRow = boardFileMapper.removeBoardFile(boardNo, boardFileNo);
            log.debug(CC.YE + "BoardService.removeFile() removeRow : " + removeRow + CC.RESET);
            return 1; // 성공
        } else {
        	log.debug(CC.YE + "BoardService.removeFile() File deletion failed"+ CC.RESET);
        	return -1; // 파일 삭제 실패
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
	public String selectAccess(int empNo) {
		String accessLevel = "";
		
		EmpInfo empInfo = empMapper.selectEmp(empNo);
		accessLevel = empInfo.getAccessLevel();
		
		return accessLevel;
	}
}
