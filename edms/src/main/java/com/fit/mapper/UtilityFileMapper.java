package com.fit.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.UtilityFile;

@Mapper
public interface UtilityFileMapper {
	int insertUtilityFile(UtilityFile utilityFile);
	
//	1:1 방식으로 연결되므로 객체 타입으로 반환
	UtilityFile selectUtilityFileOne(int utilityNo);
	
	// 공용품 파일 삭제 메서드 -> Long 타입은 null 값을 포함하므로 확장
	int deleteUtilityFile(Long utilityNo);
}
