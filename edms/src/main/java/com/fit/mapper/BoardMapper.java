package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Board;

@Mapper
public interface BoardMapper {
	// 게시글 추가
	int addBoard(Board board);
		
	// 게시글 삭제
	int removeBoard(Board board);
	
	List<Board> selectBoardList(Map<String, Object> map);
	
	// 총 게시글 행 수
	int selectBoardCount(String boardCategory);
	
	// 하나의 게시글 조회
	Board selectBoardOne(int BoardNo);
}
