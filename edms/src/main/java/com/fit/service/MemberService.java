package com.fit.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.mapper.MemberMapper;
import com.fit.vo.MemberFile;
import com.fit.vo.MemberInfo;
import com.fit.vo.VacationHistory;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class MemberService {
	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
	private CommonPagingService commonPagingService;
	
	// 사원번호 검사
	public Map<String, Object> checkEmpNo(int empNo) {
		// 1) 인사정보 등록여부 검사
		int empInfoCnt = memberMapper.empInfoCnt(empNo);
		log.debug(CC.HE + "MemberService.addMember() empInfoCnt : " + empInfoCnt + CC.RESET);
		
		// 2) 사원번호 중복검사
		int memberInfoCnt = memberMapper.memberInfoCnt(empNo);
		log.debug(CC.HE + "MemberService.addMember() memberInfoCnt : " + memberInfoCnt + CC.RESET);
		
		Map<String, Object> checkEmpNoResult = new HashMap<String, Object>();
		checkEmpNoResult.put("empInfoCnt", empInfoCnt);
		checkEmpNoResult.put("memberInfoCnt", memberInfoCnt);
		
		return checkEmpNoResult;
	}
	
	// 회원가입
	public int addMember(MemberInfo memberInfo) {
		int row = memberMapper.addMember(memberInfo);
		log.debug(CC.HE + "MemberService.addMember() row : " + row + CC.RESET);
		
		return row;
	}
	
	// 내 프로필 조회
	public Map<String, Object> selectMemberOne(int empNo) {
		
		Map<String, Object> selectMemberOneResult = new HashMap<>();
		
		log.debug(CC.YE + "memberService.selectMemberOne() empNo param : " + empNo + CC.RESET);
		
		// 1. 개인정보 조회 // emp_name을 추출하기 위해 emp_info 테이블과 join하므로 반환타입은 Map
		Map<String, Object> memberInfo = memberMapper.selectMemberInfo(empNo);
		
		if (memberInfo != null) {
			// 1-1. 성별 추출
			if ( memberInfo.get("gender").equals("M") ) {
				memberInfo.put("gender", "남자");
			} else {
				memberInfo.put("gender", "여자");
			}
					
			// 1-2. 날짜 추출(class java.sql.Timestamp)
			String createdate = memberInfo.get("createdate").toString();
			String udpatedate = memberInfo.get("updatedate").toString();
			memberInfo.put("createdate", createdate.substring(0, 10));
			memberInfo.put("updatedate", udpatedate.substring(0, 10));
			
			log.debug(CC.YE + "memberService.selectMemberOne() memberInfo : " + memberInfo + CC.RESET);
		}
		
		// 2. fileCategory를 Image로 지정하여 사진 조회
		MemberFile memberImage = memberMapper.selectMemberFile(empNo, "Image");
		log.debug(CC.YE + "memberService.selectMemberOne() memberImage : " + memberImage + CC.RESET);
		
		// 3. fileCategory를 Sign으로 지정하여 서명 조회
		MemberFile memberSign = memberMapper.selectMemberFile(empNo, "Sign");
		log.debug(CC.YE + "memberService.selectMemberOne() memberSign : " + memberSign + CC.RESET);
		
		selectMemberOneResult.put("memberInfo", memberInfo);
		selectMemberOneResult.put("memberImage", memberImage);
		selectMemberOneResult.put("memberSign", memberSign);
		
		return selectMemberOneResult;	
	}
	
	// 비밀번호 확인
	public int checkPw(int empNo, String pw) {
		// 비밀번호 확인 메서드 실행
		int pwCnt = memberMapper.checkPw(empNo, pw);
		log.debug(CC.YE + "memberService.checkPw() pwCnt : " + pwCnt + CC.RESET);
		
		return pwCnt;
	}
	
	// 내 프로필 수정
	public int modifyMember(MemberInfo memberInfo) {
		int modifyMemberRow = memberMapper.modifyMember(memberInfo);
		log.debug(CC.YE + "memberService.selectMemberOne() modifyMemberRow : " + modifyMemberRow + CC.RESET);
		
		return modifyMemberRow;
		
	}
	
	// 내 프로필 사진 입력 및 수정
	public int addMemberFileImage(int empNo, MultipartFile file, String path) {
	
	// 1. 삽입된 행의 수를 나타낼 변수
		int insertedRowCount = 0;
    
    // 2. 카테고리를 Image으로 설정
		String fileCategory = "Image";
	    
	// 3. MemberFile 객체 변수 생성 및 데이터 저장
	    MemberFile newMemberFile = new MemberFile();
	    // empNo
 		newMemberFile.setEmpNo(empNo);
 		log.debug(CC.YE + "memberService.addMemberFileImage() empNo : " + empNo + CC.RESET);
		// fileCategory			
		newMemberFile.setFileCategory(fileCategory);
		log.debug(CC.YE + "memberService.addMemberFileImage() fileCategory: " + fileCategory + CC.RESET);
		// originalFilename(multipartFile 활용)
		newMemberFile.setMemberOriFileName(file.getOriginalFilename()); // 파일 원본이름
		log.debug(CC.YE + "memberService.addMemberFileImage() originalFilename : " + newMemberFile.getMemberOriFileName() + CC.RESET);
		// contentType(multipartFile 활용)
		newMemberFile.setMemberFiletype(file.getContentType()); // 파일타입
		log.debug(CC.YE + "memberService.addMemberFileImage() contentType : " + newMemberFile.getMemberFiletype() + CC.RESET);
		// path
		newMemberFile.setMemberPath("/goodeeFit/image/member/");
		log.debug(CC.YE + "memberService.addMemberFileImage() path : " + path + CC.RESET);
		
		// 확장자
		String ext = newMemberFile.getMemberOriFileName().substring(file.getOriginalFilename().lastIndexOf(".")); //마지막 점(.)의 위치부터 끝까지 자르는 코드
		
		// saveFileName(random ID (UUID클래스 활용) + 확장자)
		newMemberFile.setMemberSaveFileName(UUID.randomUUID().toString().replace("-","") + ext);
		log.debug(CC.YE + "memberService.addMemberFileImage() memberSaveFileName: " + newMemberFile.getMemberSaveFileName() + CC.RESET);
	
	// 4. 기존 사진 파일 확인	
		MemberFile memberFile = memberMapper.selectMemberFile(empNo, fileCategory);
		log.debug(CC.YE + "memberService.addMemberFileImage() selectMemberFile : " + memberFile + CC.RESET);
		
	// 5. 기존 사진 파일 삭제
		if(memberFile != null) {
			log.debug(CC.YE + "memberService.addMemberFileImage() removeMemberFile 실행" + CC.RESET);
			memberMapper.removeMemberFile(empNo, newMemberFile.getFileCategory());
			
			// 파일 경로 생성
			String filePath = path + memberFile.getMemberSaveFileName();
			// 삭제할 파일을 나타내는 File 객체 생성
			File fileToDelete = new File(filePath);
			// 파일이 실제로 존재하는지 확인
			if (fileToDelete.exists()) {
				// 파일 삭제 시도
			    if (fileToDelete.delete()) {
			        log.debug(CC.YE + "memberService.addMemberFileImage() File deletion successful" + CC.RESET);
			    } else {
			        log.debug(CC.YE + "memberService.addMemberFileImage() File deletion failed" + CC.RESET);
			    }
			} else {
			    log.debug(CC.YE + "memberService.addMemberFileImage() File deletion 파일 없음" + CC.RESET);
			}
		}
					
	// 6. 새로운 사진 파일을 DB에 저장
		insertedRowCount = memberMapper.addMemberFile(newMemberFile);
		log.debug(CC.YE + "memberService.addMemberFileImage() addMemberFile addMemberFile : " + newMemberFile + CC.RESET);
		
	// 7. 사진을 웹 어플리케이션에 저장
		// path 위치에 저장파일 이름으로 빈 파일을 생성(0byte)
		File f = new File(path+newMemberFile.getMemberSaveFileName());
		log.debug(CC.YE + "memberService.addMemberFile() new File f : " + f + CC.RESET);
		
		try {
			file.transferTo(f); // 빈 파일에 첨부된 파일의 스트림을 주입
		} catch(IllegalStateException | IOException e) {
			
			e.printStackTrace();
			// 트랜잭션 작동을 위해 예외(try..catch를 강요하지 않는 예외 ex: RuntimeException)를 발생.
			throw new RuntimeException();
		}
		
		return insertedRowCount; // 삽입된 행의 수 반환
	}
	
	// 내 프로필 서명 입력 및 수정
	public int addMemberFileSign(int empNo, String sign, String path) {
	// 서명 파일 정제	
		// 삽입된 행의 수를 나타낼 변수
	    int insertedSignRowCount = 0;
		// 카테고리를 Sign으로 설정
	    String fileCategory = "Sign";
	    // 서명 파일의 타입 정보 추출
		String type = sign.split(",")[0].split(";")[0].split(":")[1];
		log.debug(CC.YE + "SignService.addMemberFileSign() type : " + type + CC.RESET);
		// Base64로 인코딩된 이미지 데이터 추출
		String data = sign.split(",")[1];
		log.debug(CC.YE + "SignService.addMemberFileSign() data : " + data + CC.RESET);
		// Base64 디코딩하여 이미지 데이터를 바이트 배열로 변환
		byte[] image = Base64.getDecoder().decode(data); // Base64 : 바이너리 데이터를 텍스트 형식으로 인코딩하는 방법 중 하나.
		log.debug(CC.YE + "SignService.addMemberFileSign() image : " + image + CC.RESET);
		
		// 저장시 사용할 파일 이름
		String saveFilename = UUID.randomUUID().toString().replace("-", "") + ".png";
		log.debug(CC.YE + "SignService.addMemberFileSign() saveFilename : " + saveFilename + CC.RESET);
		
	// MemberFile 객체 변수 생성 및 데이터 저장
	    MemberFile newMemberFile = new MemberFile();
	    // fileCategory
		newMemberFile.setFileCategory(fileCategory);
		log.debug(CC.YE + "memberService.addMemberFileImage() fileCategory" + CC.RESET);
		// empNo
		newMemberFile.setEmpNo(empNo);
		log.debug(CC.YE + "memberService.addMemberFileImage() empNo : " + empNo + CC.RESET);
		// multipartFile를 이용해 originalFilename 받기
		newMemberFile.setMemberOriFileName(saveFilename); // 파일 원본이름
		log.debug(CC.YE + "memberService.addMemberFileImage() oriFilename : " + newMemberFile.getMemberOriFileName() + CC.RESET);
		// multipartFile를 이용해 saveFileName 받기
		newMemberFile.setMemberSaveFileName(saveFilename); // 파일 원본이름
		log.debug(CC.YE + "memberService.addMemberFileImage() saveFilename : " + newMemberFile.getMemberSaveFileName() + CC.RESET);
		// multipartFile를 이용해 contentType 받기
		newMemberFile.setMemberFiletype(type); // 파일타입
		log.debug(CC.YE + "memberService.addMemberFileImage() getContentType : " + newMemberFile.getMemberFiletype() + CC.RESET);
		// path
		newMemberFile.setMemberPath("/goodeeFit/image/member/");
		log.debug(CC.YE + "memberService.addMemberFileImage() path : " + path + CC.RESET);
		
	// 기존 서명 파일 확인	
		MemberFile memberFile = memberMapper.selectMemberFile(empNo, fileCategory);
		log.debug(CC.YE + "memberService.addMemberFileImage() memberFile : " + memberFile + CC.RESET);
		
	// 기존 파일이 있을 경우 서명 수정
		if(memberFile != null) {
			log.debug(CC.YE + "memberService.addMemberFileSign() removeMemberFile 실행" + CC.RESET);
			// 파일 삭제 메서드 실행
			memberMapper.removeMemberFile(empNo, newMemberFile.getFileCategory());
			
			// 파일 경로 생성
			String filePath = path + memberFile.getMemberSaveFileName();
			// 삭제할 파일을 나타내는 File 객체 생성
			File fileToDelete = new File(filePath);
			// 파일이 실제로 존재하는지 확인
			if (fileToDelete.exists()) {
				// 파일 삭제 시도
			    if (fileToDelete.delete()) {
			        log.debug(CC.YE + "memberService.addMemberFileSign() File deletion successful" + CC.RESET);
			    } else {
			        log.debug(CC.YE + "memberService.addMemberFileSign() File deletion failed" + CC.RESET);
			    }
			} else {
			    log.debug(CC.YE + "memberService.addMemberFileSign() File deletion 파일 없음" + CC.RESET);
			}
		}
		
	// 새로운 서명 파일을 DB에 저장
		memberMapper.addMemberFile(newMemberFile);
	
	// 서명 사진을 웹 어플리케이션에 저장
		// 빈 파일 생성
		File f = new File(path+saveFilename);
		try {
			// 빈 파일에 이미지 파일 주입
			FileOutputStream fileOutputStream = new FileOutputStream(f);
			fileOutputStream.write(image);
			fileOutputStream.close();
			log.debug("SignService.addMemberFileSign() f.length() : " + f.length());
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace(); // 트랜잭션 작동을 위해 try/catch를 강요하지 않는 예외를 발생시킴
			throw new RuntimeException(); // 한 종류로써 RuntimeException 처리
		}
		return insertedSignRowCount; // 삽입된 행의 수 반환
	}
	
	// 비밀번호 변경
	public int modifyPw(int empNo, String newPw2) {
		int modifyPwCnt = memberMapper.modifyPw(empNo, newPw2);
		return modifyPwCnt;
	}
	
	// 내 프로필 휴가정보 조회
	public Map<String, Object> getVacationHistoryList(Map<String, Object> param) {
        
		int currentPage = (int) param.get("currentPage");
		
		int rowPerPage = 10;
    	int beginRow = (currentPage - 1) * rowPerPage;
        
        param.put("beginRow", beginRow);
        param.put("rowPerPage", rowPerPage);
        
        // 휴가 내역 조회
        List<VacationHistory> vacationHistoryList = memberMapper.memberVacationHistory(param);
        
        // 반환할 Map
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("vacationHistoryList", vacationHistoryList);
        
        // 4. 페이징
    	// 4-1. 검색어가 적용된 리스트의 전체 행 개수를 구해주는 메서드 실행
        int totalCount = memberMapper.memberVacationHistoryPaging(param);
		log.debug(CC.YE + "MemberService.vacationHistoryList totalCount: " + totalCount + CC.RESET);
		// 4.2. 마지막 페이지 계산
		int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage);
		log.debug(CC.YE + "MemberService.vacationHistoryList() lastPage: " + lastPage + CC.RESET);
		// 4.3. 페이지네이션에 표기될 쪽 개수
		int pagePerPage = 5;
		// 4.4. 페이지네이션에서 사용될 가장 작은 페이지 범위
		int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
		log.debug(CC.YE + "MemberService.vacationHistoryList() minPage: " + minPage + CC.RESET);
		// 4.5. 페이지네이션에서 사용될 가장 큰 페이지 범위
		int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
		log.debug(CC.YE + "MemberService.vacationHistoryList() maxPage: " + maxPage + CC.RESET);
		
		resultMap.put("lastPage", lastPage); // 마지막 페이지
		resultMap.put("minPage", minPage); // 페이지네이션에서 사용될 가장 작은 페이지 범위
		resultMap.put("maxPage", maxPage); // 페이지네이션에서 사용될 가장 큰 페이지 범위
	    
        return resultMap;
    }

}