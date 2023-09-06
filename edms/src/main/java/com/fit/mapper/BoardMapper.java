package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Board;

@Mapper
public interface BoardMapper {
	// 게시글 추가
	int addBoard(Board board);
	
	// 게시글 수정
	int modifyBoard(Board board);
	
	// 게시글 삭제
	int removeBoard(Board board);
	
	// 게시글 리스트
	List<Map<String, Object>> selectBoardList(Map<String, Object> map);
	
	// 게시글 리스트(HOME)
	List<Map<String, Object>> selectBoardHome();
	
	// 총 게시글 행 수
	int selectBoardCount(Map<String, Object> map);
	
	// 중요 공지 개수
	int topExposureCnt();
	
	// 하나의 게시글 조회
	Map<String, Object> selectBoardOne(int BoardNo);
}
