package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Utility;

@Mapper
public interface UtilityMapper {
	
	Utility selectUtilityOne(int utilityNo); // 공용품 상세 -> 공용품 추가 및 수정에 사용예정
	
	// param : Map<String, Object> map -> int beginRow int rowPerPage
	List<Utility> selectUtilityListByPage(Map<String, Object> map);
	
	// 차량, 회의실, 전체 행의 수
	int selectUtilityCount(String utilityCategory);
	
	
}
