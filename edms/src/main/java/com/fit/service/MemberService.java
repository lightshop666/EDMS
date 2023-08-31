package com.fit.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
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
	public int modifyMember(MemberInfo memberInfo) {
		int modifyMemberRow = memberMapper.modifyMember(memberInfo);
		log.debug(CC.YE + "memberService.selectMemberOne() modifyMemberRow : " + modifyMemberRow + CC.RESET);
		
		return modifyMemberRow;
		
	}
	// 내 프로필 사진 입력
	public int addMemberFileImage(int empNo, MultipartFile file, String path) {

		// 삽입된 행의 수를 나타낼 변수
	    int insertedRowCount = 0;
	    
	    // 메소드에 사용할 매개변수 객체 만들기
	    MemberFile newMemberFile = new MemberFile();
		// 파일 카테고리를 이미지로 설정			
		newMemberFile.setFileCategory("Image");
		log.debug(CC.YE + "memberService.addMemberFileImage() fileCategory"+ CC.RESET);
		// empNo
		newMemberFile.setEmpNo(empNo);
		log.debug(CC.YE + "memberService.addMemberFileImage() empNo : " + empNo + CC.RESET);
		// multipartFile를 이용해 originalFilename 받기
		newMemberFile.setMemberOriFileName(file.getOriginalFilename()); // 파일 원본이름
		log.debug(CC.YE + "memberService.addMemberFileImage() mf.getOriginalFilename : " + newMemberFile.getMemberOriFileName() + CC.RESET);
		// multipartFile를 이용해 contentType 받기
		newMemberFile.setMemberFiletype(file.getContentType()); // 파일타입
		log.debug(CC.YE + "memberService.addMemberFileImage() mf.getContentType : " + newMemberFile.getMemberFiletype() + CC.RESET);
		// path
		newMemberFile.setMemberPath("/image/member/");
		log.debug(CC.YE + "memberService.addMemberFileImage() path : " + path + CC.RESET);
		
	// 저장될 파일 이름
		// 확장자 (고유성을 지킬 수 있으며, 일반적인 파일 이름 형식을 준수할 수 있음)
		String ext = newMemberFile.getMemberOriFileName().substring(file.getOriginalFilename().lastIndexOf(".")); //마지막 점(.)의 위치부터 끝까지 자르는 코드
		
		// UUID클래스에서 random한 이름 구하기		
		newMemberFile.setMemberSaveFileName(UUID.randomUUID().toString().replace("-","") + ext);
		log.debug(CC.YE + "memberService.addMemberFileImage() memberSaveFileName: " + newMemberFile.getMemberSaveFileName() + CC.RESET);
		
		// addMemberFile 메서드 실행
		insertedRowCount = memberMapper.addMemberFile(newMemberFile);
		log.debug(CC.YE + "memberService.addMemberFileImage() newMemberFile : " + newMemberFile + CC.RESET);
		
	// 파일 저장(저장 위치 필요 -> path 변수)
		// path 위치에 저장파일 이름으로 빈 파일을 생성(0byte)
		File f = new File(path+newMemberFile.getMemberSaveFileName());
		log.debug(CC.YE + "memberService.addMemberFileImage() newMemberFile : " + newMemberFile + CC.RESET);
		
		try {
			file.transferTo(f); // 빈 파일에 첨부된 파일의 스트림을 주입
		} catch(IllegalStateException | IOException e) {
			
			e.printStackTrace();
			// 트랜잭션 작동을 위해 예외(try..catch를 강용하지 않는 예외 ex: RuntimeException)를 발생하는 게 필요하다.
			throw new RuntimeException();
		}
		
		return insertedRowCount; // 삽입된 행의 수 반환
	}
	
	// 내 프로필 서명 입력
	public int addMemberFileSign(int empNo, String sign, String path) {
		
		// 삽입된 행의 수를 나타낼 변수
	    int insertedSignRowCount = 0;
		
		String type = sign.split(",")[0].split(";")[0].split(":")[1];
		log.debug(CC.YE + "SignService.addMemberFileSign() type : " + type + CC.RESET);
		
		String data = sign.split(",")[1];
		log.debug(CC.YE + "SignService.addMemberFileSign() data : " + data + CC.RESET);
		
		byte[] image = Base64.getDecoder().decode(data);
		log.debug(CC.YE + "SignService.addMemberFileSign() image : " + image + CC.RESET);
		
		// 저장시 사용할 파일 이름
		String saveFilename = UUID.randomUUID().toString().replace("-", "") + ".png";
		log.debug(CC.YE + "SignService.addMemberFileSign() saveFilename : " + saveFilename + CC.RESET);
		
		// sign 객체에 데이터 저장
		// 메소드에 사용할 매개변수 객체 만들기
	    MemberFile newMemberFile = new MemberFile();
		// 파일 카테고리를 이미지로 설정			
		newMemberFile.setFileCategory("Sign");
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
		newMemberFile.setMemberPath("/image/member/");
		log.debug(CC.YE + "memberService.addMemberFileImage() path : " + path + CC.RESET);
		
		// DB에 정보 저장
		memberMapper.addMemberFile(newMemberFile);
		
		// 빈 파일 생성
		File f = new File(path+saveFilename);

		try {
			// 빈 파일에 이미지 파일 주입
			FileOutputStream fileOutputStream = new FileOutputStream(f);
			fileOutputStream.write(image);
			fileOutputStream.close();
			log.debug("SignService.addMemberFileSign() f.length() : " + f.length());
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
			// 트랜잭션 작동을 위해 예외(try/catch를 강요하지 않는 예외: RuntimeException) 발생이 필요
			throw new RuntimeException();
		}
		return insertedSignRowCount; // 삽입된 행의 수 반환
	}
	
}
