package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Board;

@Mapper
public interface BoardMapper {

	// 게시글 리스트
	List<Map<String, Object>> selectBoardList(Map<String, Object> map);
	
	// 게시글 리스트(HOME)
	List<Map<String, Object>> selectBoardHome();
	
	// 총 게시글 행 수
	int selectBoardCount(Map<String, Object> map);
	
}
