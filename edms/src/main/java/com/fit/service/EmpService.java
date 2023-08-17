package com.fit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.CC;
import com.fit.mapper.EmpMapper;
import com.fit.mapper.MemberMapper;
import com.fit.vo.Department;
import com.fit.vo.EmpInfo;
import com.fit.vo.MemberFile;
import com.fit.vo.Team;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class EmpService {
	@Autowired
	private EmpMapper empMapper;
	
	@Autowired
	private MemberMapper memberMapper;
	
	// 인사정보 조회 (emp_info)
	public EmpInfo selectEmp(int empNo) {
		log.debug(CC.HE + "EmpService.selectEmp() empNo param : " + empNo + CC.RESET);
		
		EmpInfo empInfo = empMapper.selectEmp(empNo);
		log.debug(CC.HE + "EmpService.selectEmp() empInfo : " + empInfo + CC.RESET);
		
		return empInfo;
	}
	
	// 부서, 팀 테이블 조회 (department, team)
	public Map<String, Object> getDeptAndTeamList() {
		Map<String, Object> result = new HashMap<>();
		
		List<Department> deptList = empMapper.selectDepartment();
		List<Team> teamList = empMapper.selectTeam();
		
		result.put("deptList", deptList);
		result.put("teamList", teamList);
		
		return result;
	}
	
	// 인사정보 수정
	public int modifyEmp(EmpInfo empInfo) {
		log.debug(CC.HE + "EmpService.modifyEmp() empNo param : " + empInfo.getEmpNo() + CC.RESET);
		
		int row = empMapper.modifyEmp(empInfo);
		log.debug(CC.HE + "EmpService.modifyEmp() row : " + row + CC.RESET);
		
		return row;
	}
	
	// 개인정보 조회 (관리자)
	public Map<String, Object> selectMember(int empNo) {
		Map<String, Object> result = new HashMap<>();
		
		log.debug(CC.HE + "EmpService.selectMember() empNo param : " + empNo + CC.RESET);
		
		// 개인정보 조회 // emp_name을 추출하기 위해 emp_info 테이블과 join하므로 반환타입은 Map
		Map<String, Object> memberInfo = memberMapper.selectMemberInfo(empNo);
		log.debug(CC.HE + "EmpService.selectMember() memberInfo : " + memberInfo + CC.RESET);
		// fileCategory를 Image로 지정하여 사진 조회
		MemberFile memberImage = memberMapper.selectMemberFile(empNo, "Image");
		log.debug(CC.HE + "EmpService.selectMember() memberImage : " + memberImage + CC.RESET);
		// fileCategory를 Sign으로 지정하여 서명 조회
		MemberFile memberSign = memberMapper.selectMemberFile(empNo, "Sign");
		log.debug(CC.HE + "EmpService.selectMember() memberSign : " + memberSign + CC.RESET);
		
		// map에 담기
		result.put("memberInfo", memberInfo);
		result.put("memberImage", memberImage);
		result.put("memberSign", memberSign);
		
		return result;	
	}
	
	// 비밀번호 수정 (관리자)
	public int modifyPw(int empNo, String tempPw) {
		int row = empMapper.modifyPw(empNo, tempPw);
		
		return row;
	}
	
	// 인사 정보 등록
	public int addEmp(EmpInfo empInfo) {
	    
	    // 인사 정보 등록
	    int addEmpRow = empMapper.addEmp(empInfo);
	    log.debug(CC.YE + "EmpService.addEmp() row : " + addEmpRow + CC.RESET);
	    
	    // 사원번호 사용여부 등록
	    if( addEmpRow > 0) {
		    int addEmpNoRow = empMapper.addEmpNo(empInfo.getEmpNo());
		    log.debug(CC.YE + "EmpService.addEmpNoRow() row : " + addEmpNoRow + CC.RESET);
	    }
	    
	    return addEmpRow; // 사원 정보 등록 결과를 반환
	}
}
