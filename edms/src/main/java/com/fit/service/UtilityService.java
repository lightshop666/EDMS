package com.fit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.mapper.UtilityMapper;
import com.fit.vo.Utility;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional // 서비스 레이어에서 트랜잭션 처리 진행
public class UtilityService {
	@Autowired
	private UtilityMapper utilityMapper;
	
	// 컨트롤러로부터 받은 매개변수를 넣어 getUtilityListByPage 메서드 실행
	public List<Utility> getUtilityListByPage(int currentPage, int rowPerPage, String utilityCategory) {
		// 컨트롤러로부터 받은 값을 계산하여 다시 컨트롤러로 반환
		int beginRow = (currentPage - 1) * rowPerPage;
		
		// 디버깅
		log.debug("\u001B[101m"+"utilityService.getUtilityListByPage() beginRow: "+beginRow+"\u001B[0m");
		
		// Map 타입으로 저장
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("utilityCategory", utilityCategory);
		paramMap.put("beginRow", beginRow);
		paramMap.put("rowPerPage", rowPerPage);
		
		// 컨트롤러로부터 받은 페이지 번호, 행 수, 카테고리를 기반으로
		// 데이터베이스에서 페이지별 공용품 리스트를 조회한 후 반환
		return utilityMapper.selectUtilityListByPage(paramMap);
	}
	
	// 카테고리별 행의 개수 가져오는 메서드 
	public int getUtilityCount(String utilityCategory) {
        return utilityMapper.selectUtilityCount(utilityCategory);
    }
	
	// lastPage를 구하는 메서드
	public int getLastPage(int totalCount, int rowPerPage) {
		int lastPage = totalCount / rowPerPage;
		if(totalCount % rowPerPage != 0) {
			lastPage = lastPage + 1;
		}
        return lastPage;
    }
}
