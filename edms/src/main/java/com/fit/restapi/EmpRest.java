package com.fit.restapi;

import java.util.HashMap;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.CC;
import com.fit.service.EmpService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class EmpRest {
	@Autowired
	private EmpService empService;
	    
	// 비밀번호 초기화
	@PostMapping("/adminUpdatePw")
	public int adminUpdatePw(int empNo, String tempPw) {
		log.debug(CC.HE + "EmpRest.adminUpdatePw() empNo : " + empNo + CC.RESET);
		log.debug(CC.HE + "EmpRest.adminUpdatePw() tempPw : " + tempPw + CC.RESET);
		
		int row = empService.modifyPw(empNo, tempPw);

		return row;
	}

	
	//empNo 생성
	@PostMapping("/generateEmpNo")
	public Map<String, Object> generateEmpNo() {
		int newEmpNo = empService.generateNewEmpNo();  // 신규 사원번호 생성 로직을 EmpService에
	    log.debug(CC.WOO +"EMPRest.사번생성 아작스 newEmpNo : "+ newEmpNo + CC.RESET);
		Map<String, Object> result = new HashMap<>();
		result.put("newEmpNo", newEmpNo);
		
		return result;
	}
}
