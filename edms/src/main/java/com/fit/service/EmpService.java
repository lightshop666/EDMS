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
		
		// 날짜만 추출
		String createdate = empInfo.getCreatedate().substring(0, 10);
		String udpatedate = empInfo.getUpdatedate().substring(0, 10);
		empInfo.setCreatedate(createdate);
		empInfo.setUpdatedate(udpatedate);
		
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
		
		// 1. 개인정보 조회 // emp_name을 추출하기 위해 emp_info 테이블과 join하므로 반환타입은 Map
		Map<String, Object> memberInfo = memberMapper.selectMemberInfo(empNo);
		
		// 1-1. 성별 추출
		if ( memberInfo.get("gender").equals("M") ) {
			memberInfo.put("gender", "남자");
		} else {
			memberInfo.put("gender", "여자");
		}
				
		// 1-2. 날짜 추출
		// log.debug(CC.HE + memberInfo.get("createdate").getClass() + CC.RESET);
		// -> class java.sql.Timestamp
		String createdate = memberInfo.get("createdate").toString(); // Timestamp 객체를 String타입으로 형변환
		String udpatedate = memberInfo.get("updatedate").toString();
		memberInfo.put("createdate", createdate.substring(0, 10));
		memberInfo.put("updatedate", udpatedate.substring(0, 10));
		
		log.debug(CC.HE + "EmpService.selectMember() memberInfo : " + memberInfo + CC.RESET);
		
		// 2. fileCategory를 Image로 지정하여 사진 조회
		MemberFile memberImage = memberMapper.selectMemberFile(empNo, "Image");
		log.debug(CC.HE + "EmpService.selectMember() memberImage : " + memberImage + CC.RESET);
		
		// 3. fileCategory를 Sign으로 지정하여 서명 조회
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
		// 사원번호 등록
	    int addEmpNoRow = empMapper.addEmpNo(empInfo.getEmpNo());
	    log.debug(CC.YE + "EmpService.addEmpNoRow() row : " + addEmpNoRow + CC.RESET);
	    
	    // 사원번호 등록 후 인사 정보 등록
	    int addEmpRow = empMapper.addEmp(empInfo);
	    log.debug(CC.YE + "EmpService.addEmp() row : " + addEmpRow + CC.RESET);
	    
	    return addEmpRow; // 사원 정보 등록 결과를 반환
	}
	
	// 사원 전체 목록 조회
	public List<EmpInfo> selectEmpList() {
		// 사원 목록을 List 형식으로 담기
		List<EmpInfo> selectEmpList = empMapper.selectEmpList();
		log.debug(CC.YE + "EmpService.selectListEmp() selectListEmp : " + selectEmpList + CC.RESET);
		
		return selectEmpList;
	}
	
    // 사원 등록 엑셀 업로드
	@Transactional
    public void excelProcess(List<Map<String, Object>> jsonDataList) {
        log.debug(CC.YE + "EmpService.excelProcess() 실행" + CC.RESET);
        log.debug(CC.YE + "EmpService.excelProcess() jsonData.size(): " + jsonDataList.size() + CC.RESET);
        // 엑셀 파일 파싱
        for (Map<String, Object> jsonData : jsonDataList) { // jsonData를 가지고 필요한 처리를 수행하고 데이터베이스에 저장
            EmpInfo empInfo = new EmpInfo();
            empInfo.setEmployDate((String) jsonData.get("입사일"));
            empInfo.setEmpPosition((String) jsonData.get("직급"));
            empInfo.setEmpNo((int) jsonData.get("사원번호"));
            empInfo.setAccessLevel((String) jsonData.get("권한"));
            empInfo.setDeptName((String) jsonData.get("부서명"));
            empInfo.setEmpState((String) jsonData.get("재직사항"));
            empInfo.setEmpName((String) jsonData.get("사원명"));
            empInfo.setTeamName((String) jsonData.get("팀명"));
            log.debug(CC.YE + "EmpService.excelProcess() empInfo: "+ empInfo + CC.RESET);
            
            // 2. 사원번호 등록
		    int addEmpNoRow = empMapper.addEmpNo(empInfo.getEmpNo());
		    log.debug(CC.YE + "EmpService.addEmpNoRow() row : " + addEmpNoRow + CC.RESET);
		    
		    // 3. 사원번호 등록 후 인사 정보 등록
		    int addEmpRow = empMapper.addEmp(empInfo);
		    log.debug(CC.YE + "EmpService.addEmp() row : " + addEmpRow + CC.RESET);
        }
    }
	
	// 선택된 사원 정보 리스트
	public List<EmpInfo> getSelectedEmpList(List<Integer> empNos) {
		// empMapper의 getSelectedEmpList 선택된 사원 정보 리스트 조회
		List<EmpInfo> selectedEmpList = empMapper.getSelectedEmpList(empNos);
		log.debug(CC.YE + "EmpService.addEmpNoRow() selectedEmpList : " + selectedEmpList + CC.RESET);
		
		// 선택된 사원 정보 리스트를 반환
        return selectedEmpList;
    }
	
}
