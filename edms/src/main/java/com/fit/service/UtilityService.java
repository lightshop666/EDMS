package com.fit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
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
		log.debug(CC.YOUN+"utilityService.getUtilityListByPage() beginRow: "+beginRow+CC.RESET);
		
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
		log.debug(CC.YOUN+"utilityService.getLastPage() lastPage: "+lastPage+CC.RESET);
		
        return lastPage;
    }
	
	// 공용품 이미지 상세를 조회하는 메서드
	public UtilityFile getUtilityFileOne(Utility utility) {
		
		// 파일 객체에 저장, 이후 view 레이어에서 리스트 형식으로 뿌린다.
		UtilityFile utilityFile = utilityFileMapper.selectUtilityFileOne(utility);
		
		/*
		// 각 컬럼을 개별적으로 사용하기 위해 Map에 저장
		Map<String, Object> utilityFileMap = new HashMap<>();
		utilityFileMap.put("utilityNo", utilityFile.getUtilityNo());
		utilityFileMap.put("utilityOriFilename", utilityFile.getUtilityOriFilename());
		utilityFileMap.put("utilitySaveFilename", utilityFile.getUtilitySaveFilename());
		utilityFileMap.put("utilityFiletype", utilityFile.getUtilityFiletype());
		utilityFileMap.put("utilityPath", utilityFile.getUtilityPath());
		utilityFileMap.put("createdate", utilityFile.getCreatedate());
		utilityFileMap.put("updatedate", utilityFile.getUpdatedate());
		*/
		
		// 디버깅
		log.debug(CC.YOUN+"utilityService.getUtilityFileOne() utilityFile: "+utilityFile+CC.RESET);
		
		return utilityFile;
	}
	
	// 개별적인 공용품 이미지를 불러오기 위한 공용품 상세 메서드
	public Utility getUtilityOne(int utilityNo) {
		
		// 디버깅
		log.debug(CC.YOUN+"utilityService.getUtilityOne() utilityNo: "+utilityNo+CC.RESET);
		
		return utilityMapper.selectUtilityOne(utilityNo);
	}
	
	// 공용품 추가 메서드 생성
	public int addUtility(Utility utility, String utilityPath) {
		
		// 디버깅
		log.debug(CC.YOUN+"utilityService.addUtility() utility: "+utility+CC.RESET);
		log.debug(CC.YOUN+"utilityService.addUtility() utilityPath: "+utilityPath+CC.RESET);
		
		// 삽입 여부 확인을 위한 row 반환
		int row = utilityMapper.insertUtility(utility);
		
		// utility 입력 성공 후 첨부된 파일이 있을 경우
		MultipartFile singleFile = utility.getSinglepartFile();
		
		if(row == 1 && singleFile != null) {
			
			// 디버깅
			log.debug(CC.YOUN+"utilityService.addUtility() param: 첨부 파일이 존재합니다."+CC.RESET);
			
			// 공용품 번호를 변수에 저장
			int utilityNo = utility.getUtilityNo();
			
			// 디버깅
			log.debug(CC.YOUN+"utilityService.addUtility() utilityNo: "+utilityNo+CC.RESET);
			
			UtilityFile uf = new UtilityFile();
			// 참조된 부모의 키값 전달
			uf.setUtilityNo(utilityNo); 
			// 원본파일이름
			uf.setUtilityOriFilename(singleFile.getOriginalFilename());
			// 파일 타입(MIME)
			uf.setUtilityFiletype(singleFile.getContentType());
			// 저장될 파일 이름 = 새로운 이름(UUID) + 확장자
			String ext = singleFile.getOriginalFilename().substring(singleFile.getOriginalFilename().lastIndexOf("."));
			
			
		}
		
	}
	
	
}
