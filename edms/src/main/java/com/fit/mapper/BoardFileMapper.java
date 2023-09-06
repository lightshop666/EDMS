package com.fit.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import com.fit.vo.BoardFile;

@Mapper
public interface BoardFileMapper {
	
	// 파일 추가
	int addBoardFile(BoardFile boardFile);
	
	// 파일 상세
	List<BoardFile> selectSaveFile(int boardNo);
	
	// 파일 삭제
	int removeBoardFile(int boardNo, int boardFileNo);
}
