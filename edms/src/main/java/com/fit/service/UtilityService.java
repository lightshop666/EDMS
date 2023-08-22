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
import com.fit.vo.UtilityDto;
import com.fit.vo.UtilityFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional // 서비스 레이어에서 트랜잭션 처리 진행
public class UtilityService {
	
	@Autowired
	private UtilityMapper UtilityMapper;
	
	@Autowired
	private UtilityFileMapper UtilityFileMapper;
	
	// 컨트롤러로부터 받은 매개변수를 넣어 getUtilityListByPage 메서드 실행
	public List<UtilityDto> getUtilityListByPage(int currentPage, int rowPerPage, String UtilityCategory) {
		// 컨트롤러로부터 받은 값을 계산하여 다시 컨트롤러로 반환
		int beginRow = (currentPage - 1) * rowPerPage;
		
		// 디버깅
		log.debug(CC.YOUN+"UtilityService.getUtilityListByPage() beginRow: "+beginRow+CC.RESET);
		
		// Map 타입으로 저장
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("UtilityCategory", UtilityCategory);
		paramMap.put("beginRow", beginRow);
		paramMap.put("rowPerPage", rowPerPage);
		
		// 컨트롤러로부터 받은 페이지 번호, 행 수, 카테고리를 기반으로
		// 데이터베이스에서 페이지별 공용품 리스트를 조회
		List<UtilityDto> UtilityList = UtilityMapper.selectUtilityListByPage(paramMap);
		
		// 리스트 반환 -> 파일 정보 내용도 있음
		return UtilityList;
	}
	
	// 카테고리별 행의 개수 가져오는 메서드 
	public int getUtilityCount(String UtilityCategory) {
		
		int totalCount = UtilityMapper.selectUtilityCount(UtilityCategory);
		
        return totalCount;
    }
	
	// 공용품 이미지 상세를 조회하는 메서드
	public UtilityFile getUtilityFileOne(int utilityNo) {
		
		// 파일 객체에 저장, 이후 view 레이어에서 리스트 형식으로 뿌린다.
		UtilityFile utilityFile = UtilityFileMapper.selectUtilityFileOne(utilityNo);
		
		// 디버깅
		log.debug(CC.YOUN+"UtilityService.getUtilityFileOne() utilityFile: "+utilityFile+CC.RESET);
		
		return utilityFile;
	}
	
	// 개별적인 공용품 이미지를 불러오기 위한 공용품 상세 메서드
	public UtilityDto getUtilityOne(int utilityNo) {
		
		// 디버깅
		log.debug(CC.YOUN+"UtilityService.getUtilityOne() utilityNo: "+utilityNo+CC.RESET);
		
		return UtilityMapper.selectUtilityOne(utilityNo);
	}
	
	// 공용품 추가 메서드 생성 - (매개변수 공용품 객체, 공용품 경로)
	public int addUtility(UtilityDto utilityDto, String Path) {
		
		// 디버깅
		log.debug(CC.YOUN+"UtilityService.addUtility() UtilityDto: "+utilityDto+CC.RESET);
		
		// 삽입 여부 확인을 위한 row 반환
		int row = UtilityMapper.insertUtility(utilityDto);
		
		// UtilityDto 입력 성공 후 첨부된 파일이 있을 경우
		MultipartFile singleFile = utilityDto.getSinglepartFile();
		
		// 디버깅
		log.debug(CC.YOUN+"UtilityService.addUtility() singleFile: "+singleFile+CC.RESET);
		
		// 공용품이 추가되고 파일도 추가되었다면 파일 추가 로직을 실행한다.
		if(row == 1 && !singleFile.isEmpty()) {
			
			// 디버깅
			log.debug(CC.YOUN+"UtilityService.addUtility() param: 첨부 파일이 존재합니다."+CC.RESET);
			
			// 공용품 번호를 변수에 저장
			int utilityNo = utilityDto.getUtilityNo();
			
			// 디버깅
			log.debug(CC.YOUN+"UtilityService.addUtility() utilityNo: "+utilityNo+CC.RESET);
			
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
			log.debug(CC.YOUN+"UtilityService.addUtility() extractPath: "+extractPath+CC.RESET);
			
			uf.setUtilityPath(Path);
			
			// 디버깅
			log.debug(CC.YOUN+"UtilityService.addUtility() singleFile.getOriginalFilename(): "+singleFile.getOriginalFilename()+CC.RESET);
			log.debug(CC.YOUN+"UtilityService.addUtility() uf: "+uf+CC.RESET);
			log.debug(CC.YOUN+"UtilityService.addUtility() uf.getUtilityPath(): "+uf.getUtilityPath()+CC.RESET);
			log.debug(CC.YOUN+"UtilityService.addUtility() uf.getUtilitySaveFilename(): "+uf.getUtilitySaveFilename()+CC.RESET);
			
			// 공용품 파일 테이블에 저장
			UtilityFileMapper.insertUtilityFile(uf);
			
			// 파일을 저장한다. (저장위치가 필요 -> UtilityPath 변수) DB 테이블에 해당 값 저장
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
	
	// 파일과 공용품을 동시에 삭제하는 메서드 -> null값을 포함할 수 있는 Long 타입 사용
	public int removeUtilityAndFile(Long utilityNo) {
        // 공용품 및 관련 파일 삭제 로직 작성 -> Long 타입을 int형으로 형변환
        UtilityDto utilityDto = UtilityMapper.selectUtilityOne(utilityNo.intValue());
        
        // 디버깅
        log.debug(CC.YOUN+"UtilityService.deleteUtilityAndFile() utilityDto: "+utilityDto+CC.RESET);
        
        // 반환할 row값 생성
        int row = 0;
        
        // 체크박스가 1개라도 선택되서 객체가 생성된 경우
        if (utilityDto != null) {
            
        	// 디버깅
            log.debug(CC.YOUN+"UtilityService.deleteUtilityAndFile() 삭제할 공용품번호:"+utilityNo+CC.RESET);
        	
        	// 공용품 파일을 삭제 (DB)
        	int flieRow = UtilityFileMapper.deleteUtilityFile(utilityNo);
        	
        	// 디버깅
            log.debug(CC.YOUN+"UtilityService.deleteUtilityAndFile() 공용품 파일 삭제 flieRow:"+flieRow+CC.RESET);
        	
        	// 실제 파일이 저장된 경로
        	String filePath = utilityDto.getUtilityPath();
        	// 삭제할 파일의 이름
        	String fileName = utilityDto.getUtilitySaveFilename();
        	// 파일 객체를 생성 -> 파일 삭제 메서드 사용하기 위함
        	File file = new File(filePath + fileName);
        	
        	// 디버깅
            log.debug(CC.YOUN+"UtilityService.deleteUtilityAndFile() file:"+file+CC.RESET);
        	
        	// 파일을 삭제
        	file.delete();
        	
    		// 공용품 글을 삭제
    		row = UtilityMapper.deleteUtility(utilityNo);
    		
    		// 디버깅
            log.debug(CC.YOUN+"UtilityService.deleteUtilityAndFile() 공용품 삭제 row:"+row+CC.RESET);
        }
        // row 값 반환
        return row;
    }
	
	// 공용품을 수정하는 메서드 -> 공용품 정보의 경우 UPDATE 하고 기존 파일이 존재할 경우 기존 파일을 삭제하고 수정폼에서 입력받은 파일을 저장한다.
	// 기존에 파일이 있는지 확인하는 객체 existingUtility를 입력받는다, 수정폼으로부터 수정된 값을 저장하는 modifiedUtility 객체를 입력받는다.
	public int modifyUtility(UtilityDto modifiedUtility, String path, UtilityDto existingUtility) {
		// 공용품 정보 업데이트 -> 수정된 공용품 정보를 통해 Utility table 수정
	    int row = UtilityMapper.updateUtility(modifiedUtility); 
	    
	    // 디버깅
        log.debug(CC.YOUN+"UtilityService.modifyUtility() 공용품 수정 row:"+row+CC.RESET);
	    
	    // 수정폼으로부터 입력받은 수정된 공용품 정보를 담고 있는 modifiedUtility 객체로부터 새로 업로드된 파일을 가져온다.
	    MultipartFile newSingleFile = modifiedUtility.getSinglepartFile();
	    
	    // 기존 파일이 있었을 경우 삭제 -> 실제로 파일이 저장되어 있는 경로에서 파일을 삭제
	    if (existingUtility.getUtilitySaveFilename() != null && !existingUtility.getUtilitySaveFilename().isEmpty()) {
	        String existingFilePath = path + existingUtility.getUtilitySaveFilename();
	        File existingFile = new File(existingFilePath);
	        if (existingFile.exists()) {
	            existingFile.delete();
	        }
	        
	        // 파일 삭제 메서드의 매개변수 타입이 Long 타입이므로 int 타입을 Long 타입으로 형변환
	        Long utilityNo = Long.valueOf(existingUtility.getUtilityNo());
	        // DB에 저장된 파일 데이터 삭제
	        UtilityFileMapper.deleteUtilityFile(utilityNo);
	    }

	    // 수정폼으로부터 새 파일이 업로드된 경우
	    if (row == 1 && newSingleFile != null && !newSingleFile.isEmpty()) {
	        UtilityFile newUtilityFile = new UtilityFile();
	        newUtilityFile.setUtilityNo(modifiedUtility.getUtilityNo());
	        newUtilityFile.setUtilityOriFilename(newSingleFile.getOriginalFilename());
	        newUtilityFile.setUtilityFiletype(newSingleFile.getContentType());
	        String ext = newSingleFile.getOriginalFilename().substring(newSingleFile.getOriginalFilename().lastIndexOf("."));
	        newUtilityFile.setUtilitySaveFilename(UUID.randomUUID().toString().replace("-", "") + ext);
	        newUtilityFile.setUtilityPath(path);
	        
	        // DB에 파일업로드
	        UtilityFileMapper.insertUtilityFile(newUtilityFile);

	        // 파일을 저장
	        File newFile = new File(path + newUtilityFile.getUtilitySaveFilename());
	        try {
	        	// 업로드된 파일을 서버의 지정된 경로에 저장
	            newSingleFile.transferTo(newFile);
	        } catch (IllegalStateException | IOException e) {
	            e.printStackTrace();
	            throw new RuntimeException();
	        }
	    }
	    // 수정유무 확인을 위한 row값 반환
	    return row;
	}

}
