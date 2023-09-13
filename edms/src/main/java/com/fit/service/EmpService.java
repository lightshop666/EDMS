package com.fit.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.CC;
import com.fit.mapper.*;
import com.fit.vo.*;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class EmpService {
	@Autowired
	private EmpMapper empMapper;
	
	@Autowired
	private MemberMapper memberMapper;
	
	// 사원 목록에서 남은 휴가 일수를 가져오기 위한 의존성 주입
	@Autowired
	private VacationRemainService vacationRemainService;
	
	
	//사번 생성
   public int generateNewEmpNo() {
	    // DB에서 가장 최근 emp_no를 가져옵니다.
		Integer lastEmpNo = empMapper.findLastEmpNo();
	    log.debug(CC.WOO +"EMP서비스.generateNewEmpNo 생성 lastEmpNo :  "+ lastEmpNo + CC.RESET);
		
		// 현재 년도를 가져옵니다.
		int currentYear = Calendar.getInstance().get(Calendar.YEAR);
	    log.debug(CC.WOO +"EMP서비스.generateNewEmpNo 생성 currentYear :  "+ currentYear + CC.RESET);
	
		if (lastEmpNo != null) {
			int lastYear = lastEmpNo / 1000;  // emp_no의 앞의 4자리는 년도입니다.
		    log.debug(CC.WOO +"EMP서비스.generateNewEmpNo 년도:  "+ currentYear + CC.RESET);
			int lastSeq = lastEmpNo % 1000;   // emp_no의 뒤의 3자리는 순차적 번호입니다.
		    log.debug(CC.WOO +"EMP서비스.generateNewEmpNo 순차번호:  "+ lastSeq + CC.RESET);
		
			if (lastYear == currentYear) {
			// 같은 년도일 경우 순차적 번호를 1 증가시킨다.
			    log.debug(CC.WOO +"EMP서비스.generateNewEmpNo lastYear == currentYear입니다"+ CC.RESET);
				return (currentYear * 1000) + (lastSeq + 1);
			}
		}
		
		// 다른 년도거나, 사원번호가 아직 없는 경우 새로운 번호를 초기화한다.
	    log.debug(CC.WOO +"EMP서비스.generateNewEmpNo 마지막 사번이 올해가 아닌 경우"+ CC.RESET);
		return (currentYear * 1000) + 1;
	}


	
	
	
	
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
		
		// 재직중일 경우 퇴사일은 기본값 "0000-00-00"
		if (empInfo.getRetirementDate() == null) {
			empInfo.setRetirementDate("0000-00-00");
		}
		
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
		
		if (memberInfo != null) {
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
		}
		
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
	
	// 사원 목록 페이징(조건에 따른 행의 수)
	 public int getEmpListCount(Map<String, Object> param) {
		 int empListCount = empMapper.selectEmpListCount(param);
		 log.debug(CC.YE + "EmpService.selectEmpList() empListCount : " + empListCount + CC.RESET);	 
        return empListCount;
    }
	
	// 사원 전체 목록 조회
	public List<Map<String, Object>> enrichedEmpList(Map<String, Object> param) {
	    List<EmpInfo> selectEmpList = empMapper.selectEmpList(param);
	    log.debug(CC.YE + "EmpService.enrichedEmpList() selectEmpList : " + selectEmpList + CC.RESET);
	    
	    // 정렬/검색 적용된 사원목록 + 휴가일수, 회원가입 여부를 추가하여 => 새로운 List 생성
	    List<Map<String, Object>> enrichedEmpList = new ArrayList<>();
	    
	    // selectEmpList 만큼 반복
	    for (EmpInfo emp : selectEmpList) {
	        Map<String, Object> enrichedEmp = new HashMap<>(); // 키, 값으로 이루어진 Map을 생성
	        enrichedEmp.put("empNo", emp.getEmpNo()); // 사원번호
	        enrichedEmp.put("empName", emp.getEmpName()); // 사원명
	        enrichedEmp.put("deptName", emp.getDeptName()); // 부서명
	        enrichedEmp.put("teamName", emp.getTeamName()); // 팀명
	        enrichedEmp.put("empPosition", emp.getEmpPosition()); // 직급
	        enrichedEmp.put("employDate", emp.getEmployDate()); // 입사일
	        enrichedEmp.put("empState", emp.getEmpState()); // 재직사항
	        
	        // 1. 남은 휴가 일수 계산
	        double remainDays = getRemainVacationDays(emp.getEmpNo(), emp.getEmployDate());
	        enrichedEmp.put("remainDays", remainDays);
	        log.debug(CC.YE + "EmpService.enrichedEmpList() remainDays : " + remainDays + CC.RESET);
		    
	        // 2. 회원가입 여부 확인
	        int memberInfoCnt = memberMapper.memberInfoCnt(emp.getEmpNo());
	        enrichedEmp.put("isMember", memberInfoCnt > 0 ? "O" : "X");
	        log.debug(CC.YE + "EmpService.enrichedEmpList() memberInfoCnt : " + memberInfoCnt + CC.RESET);
		    
	        enrichedEmp.put("accessLevel", emp.getAccessLevel()); // 권한
	        log.debug(CC.YE + "EmpService.enrichedEmpList() accessLevel : " + emp.getAccessLevel() + CC.RESET);
		    
	        // 3. 사원의 이메일
	        Map<String, Object> memberInfo = memberMapper.selectMemberInfo(emp.getEmpNo());
	        log.debug(CC.YE + "EmpService.enrichedEmpList() memberInfo : " + memberInfo + CC.RESET);
	        if(memberInfo != null){
		        String email = (String)memberInfo.get("email");
		        log.debug(CC.YE + "EmpService.enrichedEmpList() email : " + email.toString() + CC.RESET);
		        enrichedEmp.put("email", email);
	        }
	        enrichedEmpList.add(enrichedEmp);
	    }

	    log.debug(CC.YE + "EmpService.enrichedEmpList() enrichedEmpList : " + enrichedEmpList + CC.RESET);
	    
	    return enrichedEmpList;
	}
	
	// 남은 휴가 일수 (연차 + 보상) - 사원목록 (관리자)
	public double getRemainVacationDays(int empNo, String employDate) {
		// 1. 남은 연차 일수 - remainDays
		// 1-1. 근속기간을 구하는 메서드 호출
		Map<String, Object> getPeriodOfWorkResult = vacationRemainService.getPeriodOfWork(employDate);
		// 1-2. 기준 연차를 구하는 메서드 호출
		int Days = vacationRemainService.vacationByPeriod(getPeriodOfWorkResult);
		// 1-3. 남은 연차 일수를 구하는 메서드 호출
		Double remainDays = vacationRemainService.getRemainDays(employDate, empNo, Days);
		
		// 2. 남은 보상휴가 일수를 구하는 메서드 호출 - remainRewardDays
		int remainRewardDays = vacationRemainService.getRemainRewardDays(empNo);
		
		// 3. 남은 연차 일수와 보상휴가 일수 더하기
		double resultDays = remainDays + remainRewardDays;
		log.debug(CC.HE + "EmpService.getRemainVacationDays() resultDays : " + resultDays + "개" + CC.RESET);
		
		return resultDays;
	}
	
	
	
	
}
