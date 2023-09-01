package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.MemberFile;
import com.fit.vo.MemberInfo;
import com.fit.vo.VacationHistory;

@Mapper
public interface MemberMapper {
	// 인사정보 등록여부 검사
	int empInfoCnt(int empNo);
		
	// 사원번호 중복검사
	int memberInfoCnt(int empNo);
	
	// 회원가입
	int addMember(MemberInfo memberInfo);
	
	// 개인정보 조회 // emp_name 추출을 위해 emp_info와 join해야하므로 반환타입은 Map
	Map<String, Object> selectMemberInfo(int empNo);
	
	// 개인정보 파일 조회
	MemberFile selectMemberFile(int empNo, String fileCategory);
	
	// 개인정보 파일 입력
	int addMemberFile(MemberFile memberFile);
	
	// 개인정보 수정
	int modifyMember(MemberInfo memberInfo);

	// 개인정보 파일 삭제
	int removeMemberFile(int empNo, String fileCategory);
	
	// 비밀번호 확인
	int checkPw(int empNo, String pw);
	
	// 비밀번호 수정
	int modifyPw(int empNo, String newPw2);
	
	// 내 프로필 휴가정보 조회
	List<VacationHistory> memberVacationHistory(Map<String, Object> param);
	
	// 내 프로필 휴가정보 조회 페이징
	int memberVacationHistoryPaging(Map<String, Object> param);
}
