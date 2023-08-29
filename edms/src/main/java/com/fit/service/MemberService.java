package com.fit.service;

import java.io.File;

import java.io.IOException;
import java.util.ArrayList;
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
import com.fit.vo.EmpInfo;
import com.fit.vo.MemberFile;
import com.fit.vo.MemberInfo;
import com.fit.vo.MemberInfoDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class MemberService {
	@Autowired
	private MemberMapper memberMapper;
	
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
	public int modifyMember(int empNo) {
		int modifyMemberRow = memberMapper.modifyMember(empNo);
		log.debug(CC.YE + "memberService.selectMemberOne() modifyMemberRow : " + modifyMemberRow + CC.RESET);
		
		return modifyMemberRow;
		
	}
	
	// 내 프로필 파일 수정
	public void modifyMemberFile(MemberFile memberFile) {
		// 최종 수정 값
		MemberFile modifyFileOne;
		
		// existingFile 매개값
		Integer empNo = memberFile.getEmpNo();
	    String fileCategory = memberFile.getFileCategory();
	    
	    // member_file 테이블에서 해당 파일 정보 조회
	    MemberFile existingFile = memberMapper.selectMemberFile(empNo, fileCategory);
	    
	    // empNo의 파일이 없다면
	    if (existingFile == null) {
	    	// insert 문 실행
	    	// 파일 정보 업데이트 성공한 경우에만 파일 저장 및 관련 작업 수행
	    	MemberInfoDto fileListInstance = new MemberInfoDto();
	    	List<MultipartFile> fileList = fileListInstance.getMultipartFile();
    		
            if (fileList != null && fileList.size() >= 1) {
                for (MultipartFile mf : fileList) {
                    if (mf.getSize() > 0) {
                        String originalFileName = mf.getOriginalFilename();
                        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                        
                        // 저장될 파일 이름 생성 (UUID 활용)
                        String saveFileName = UUID.randomUUID().toString().replace("-", "") + fileExtension;
                        
                        // 파일 저장 경로
                        String filePath = "/path/to/save/files/" + saveFileName;
                        
                        // 파일을 저장하는 코드
                        try {
                            mf.transferTo(new File(filePath));
                        } catch (IOException e) {
                            e.printStackTrace();
                            // 파일 저장 실패 시 예외 처리 로직 추가
                            throw new RuntimeException("File storage failed.");
                        }
                        
                        // member_file 테이블에 파일 정보 업데이트
                        MemberFile addFile = new MemberFile();
                        addFile.setEmpNo(empNo);
                        addFile.setFileCategory(fileCategory);
                        addFile.setMemberOriFileName(originalFileName);
                        addFile.setMemberSaveFileName(saveFileName);
                        addFile.setMemberFiletype(mf.getContentType());
                        addFile.setMemberPath(filePath);
                        
                        int addFileRow = memberMapper.addMemberFile(addFile);
                		log.debug(CC.YE + "memberService.selectMemberOne() addMemberFile : " + addFileRow + CC.RESET);
                        
                        if (addFileRow != 1) {
                            // 파일 정보 업데이트 실패 시 예외 처리 로직 추가
                            throw new RuntimeException("Failed to update file information.");
                        }
                    }
                }
            // 파일이 있을 시 수정(delete -> insert)
            } else {
		    	//int modifyFileRow = memberMapper.removeMemberFile(empNo, fileCategory);
	    		//log.debug(CC.YE + "memberService.selectMemberOne() modifyFileRow : " + modifyFileRow + CC.RESET);
	    		
	    		//int addFileRow = memberMapper.addMemberFile(addFile);
        		//log.debug(CC.YE + "memberService.selectMemberOne() addMemberFile : " + addFileRow + CC.RESET);
                
	        }
	            
	    }
	    
		
	}
}
