package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Department;
import com.fit.vo.EmpInfo;
import com.fit.vo.Team;

@Mapper
public interface EmpMapper {
    // 마지막 사원번호 조회
    Integer findLastEmpNo();
	
	// 인사정보 조회
	EmpInfo selectEmp(int empNo);
	
	// 부서 테이블 조회
	List<Department> selectDepartment();
	
	// 팀 테이블 조회
	List<Team> selectTeam();
	
	// 인사정보 수정
	int modifyEmp(EmpInfo empInfo);
	
	// 인사정보 등록
	int addEmp(EmpInfo empInfo);
	
	// 사원번호 사용여부 등록
	int addEmpNo(int empNo);
	
	// 사원 목록 페이징
	int selectEmpListCount(Map<String, Object> param);
	
	// 사원 목록 조회
	List<EmpInfo> selectEmpList(Map<String, Object> param);

	// 비밀번호 수정 (관리자)
	int modifyPw(int empNo, String tempPw);

	
}
