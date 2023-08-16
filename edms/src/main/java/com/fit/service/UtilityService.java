package com.fit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.mapper.UtilityFileMapper;
import com.fit.mapper.UtilityMapper;
import com.fit.vo.Utility;
import com.fit.vo.UtilityFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional // 서비스 레이어에서 트랜잭션 처리 진행
public class UtilityService {
	
	@Autowired
	private UtilityMapper utilityMapper;
	
	@Autowired
	private UtilityFileMapper utilityFileMapper;
	
	// 컨트롤러로부터 받은 매개변수를 넣어 getUtilityListByPage 메서드 실행
	public List<Utility> getUtilityListByPage(int currentPage, int rowPerPage, String utilityCategory) {
		// 컨트롤러로부터 받은 값을 계산하여 다시 컨트롤러로 반환
		int beginRow = (currentPage - 1) * rowPerPage;
		
		// 디버깅
		log.debug("\u001B[48;5;208m"+"utilityService.getUtilityListByPage() beginRow: "+beginRow+"\u001B[0m");
		
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
		
		// 디버깅
		log.debug("\u001B[48;5;208m"+"utilityService.getLastPage() lastPage: "+lastPage+"\u001B[0m");
		
        return lastPage;
    }
	
	// 공용품 이미지 상세를 조회하는 메서드
	public Map<String, Object> getUtilityFileOne(Utility utility) {
		
		// 파일 객체에 저장
		UtilityFile utilityFile = utilityFileMapper.selectUtilityFileOne(utility);
		
		// 각 컬럼을 개별적으로 사용하기 위해 Map에 저장
		Map<String, Object> utilityFileMap = new HashMap<>();
		utilityFileMap.put("utilityNo", utilityFile.getUtilityNo());
		utilityFileMap.put("utilityOriFilename", utilityFile.getUtilityOriFilename());
		utilityFileMap.put("utilitySaveFilename", utilityFile.getUtilitySaveFilename());
		utilityFileMap.put("utilityFiletype", utilityFile.getUtilityFiletype());
		utilityFileMap.put("utilityPath", utilityFile.getUtilityPath());
		utilityFileMap.put("createdate", utilityFile.getCreatedate());
		utilityFileMap.put("updatedate", utilityFile.getUpdatedate());
		
		// 디버깅
		log.debug("\u001B[48;5;208m"+"utilityService.getUtilityFileOne() utilityFileMap: "+utilityFileMap+"\u001B[0m");
		
		return utilityFileMap;
	}
	
	// 개별적인 공용품 이미지를 불러오기 위한 공용품 상세 메서드
	public Utility getUtilityOne(int utilityNo) {
		
		// 디버깅
		log.debug("\u001B[48;5;208m"+"utilityService.getUtilityOne() utilityNo: "+utilityNo+"\u001B[0m");
		
		return utilityMapper.selectUtilityOne(utilityNo);
	}
}
