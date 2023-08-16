package com.fit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Department;
import com.fit.vo.EmpInfo;
import com.fit.vo.Team;

@Mapper
public interface EmpMapper {
	// 인사정보 조회
	EmpInfo selectEmp(int empNo);
	
	// 부서 테이블 조회
	List<Department> selectDepartment();
	
	// 팀 테이블 조회
	List<Team> selectTeam();
	
	// 인사정보 수정
	int modifyEmp(EmpInfo empInfo);
}
