package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.UtilityDto;

@Mapper
public interface UtilityMapper {
	
	UtilityDto selectUtilityOne(int utilityNo); // 공용품 상세 -> 공용품 추가 및 수정에 사용예정
	
	// param : Map<String, Object> map -> int beginRow int rowPerPage
	List<UtilityDto> selectUtilityListByPage(Map<String, Object> paramMap);
	
	// 차량, 회의실, 전체 행의 수
	int selectUtilityCount(String utilityCategory);
	
	// 공용품 추가
	int insertUtility(UtilityDto utility);
	
	// 공용품 수정
	int updateUtility(UtilityDto utility);
	
	// 공용품 삭제 
	int deleteUtility(Long utilityNo);
	
	// 카테고리 종류에 따라 해당하는 공용품 번호를 출력 -> 예약 신청 페이지에서 활용
	List<UtilityDto> selectUtilityByCategory(String utilityCategory);
}
