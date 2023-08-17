package com.fit.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
		// 데이터베이스에서 페이지별 공용품 리스트를 조회
		List<Utility> utilityList = utilityMapper.selectUtilityListByPage(paramMap);
		
		// 리스트 반환 -> 파일 정보 내용도 있음
		return utilityList;
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
		public UtilityFile getUtilityFileOne(int utilityNo) {
		
		// 파일 객체에 저장, 이후 view 레이어에서 리스트 형식으로 뿌린다.
		UtilityFile utilityFile = utilityFileMapper.selectUtilityFileOne(utilityNo);
		
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
	
	// 공용품 추가 메서드 생성 - (매개변수 공용품 객체, 공용품 경로)
	public int addUtility(Utility utility, String Path) {
		
		// 디버깅
		log.debug(CC.YOUN+"utilityService.addUtility() utility: "+utility+CC.RESET);
		
		// 삽입 여부 확인을 위한 row 반환
		int row = utilityMapper.insertUtility(utility);
		
		// utility 입력 성공 후 첨부된 파일이 있을 경우
		MultipartFile singleFile = utility.getSinglepartFile();
		
		// 디버깅
		log.debug(CC.YOUN+"utilityService.addUtility() singleFile: "+singleFile+CC.RESET);
		
		// 공용품이 추가되고 파일도 추가되었다면 파일 추가 로직을 실행한다.
		if(row == 1 && !singleFile.isEmpty()) {
			
			// 디버깅
			log.debug(CC.YOUN+"utilityService.addUtility() param: 첨부 파일이 존재합니다."+CC.RESET);
			
			// 공용품 번호를 변수에 저장
			int utilityNo = utility.getUtilityNo();
			
			// 디버깅
			log.debug(CC.YOUN+"utilityService.addUtility() utilityNo: "+utilityNo+CC.RESET);
			
			// 공용품 파일 생성
			UtilityFile uf = new UtilityFile();
			// 참조된 부모의 키값 전달
			uf.setUtilityNo(utilityNo); 
			// 원본파일이름
			uf.setUtilityOriFilename(singleFile.getOriginalFilename());
			// 파일 타입(MIME)
			uf.setUtilityFiletype(singleFile.getContentType());
			// 저장될 파일 이름 = 새로운 이름(UUID) + 확장자
			String ext = singleFile.getOriginalFilename().substring(singleFile.getOriginalFilename().lastIndexOf("."));
			uf.setUtilitySaveFilename(UUID.randomUUID().toString().replace("-", "") + ext);
			// 파일 경로 저장 -> /image/tility/ 부분만 추출해서 DB에 저장
			String extractPath = Path.substring(Path.length() - 15);
			
			// 디버깅
			log.debug(CC.YOUN+"utilityService.addUtility() extractPath: "+extractPath+CC.RESET);
			
			uf.setUtilityPath(Path);
			
			// 디버깅
			log.debug(CC.YOUN+"utilityService.addUtility() singleFile.getOriginalFilename(): "+singleFile.getOriginalFilename()+CC.RESET);
			log.debug(CC.YOUN+"utilityService.addUtility() uf: "+uf+CC.RESET);
			log.debug(CC.YOUN+"utilityService.addUtility() uf.getUtilityPath(): "+uf.getUtilityPath()+CC.RESET);
			log.debug(CC.YOUN+"utilityService.addUtility() uf.getUtilitySaveFilename(): "+uf.getUtilitySaveFilename()+CC.RESET);
			
			
			// 공용품 파일 테이블에 저장
			utilityFileMapper.insertUtilityFile(uf);
			
			// 파일을 저장한다. (저장위치가 필요 -> utilityPath 변수) DB 테이블에 해당 값 저장
			// uf.getUtilityPath() 위치에 저장파일이름으로 빈파일 생성
			File f = new File(uf.getUtilityPath()+uf.getUtilitySaveFilename());
			
			// throw 사용시 controller로 예외 넘어간다. -> 트랜잭션이 동작하지 않는다. -> try-catch 문을 사용하여 트랜잭션을 동작시킨다.
			try {
				// 업로드된 파일을 서버의 지정된 경로에 저장
				singleFile.transferTo(f);
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
				
				// 트랜잭션 작동을 위해 예외(try-catch 강요하지 않는 예외 ex: RuntimeException) 발생이 필요
				throw new RuntimeException();
			}
		}
		return row;
	}
	
}
