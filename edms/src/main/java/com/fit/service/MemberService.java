package com.fit.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.mapper.MemberMapper;
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
		log.debug("\033[46;97m" + "MemberService.addMember() empInfoCnt : " + empInfoCnt + "\u001B[0m");
		
		// 2) 사원번호 중복검사
		int memberInfoCnt = memberMapper.memberInfoCnt(empNo);
		log.debug("\033[46;97m" + "MemberService.addMember() memberInfoCnt : " + memberInfoCnt + "\u001B[0m");
		
		Map<String, Object> checkEmpNoResult = new HashMap<String, Object>();
		checkEmpNoResult.put("empInfoCnt", empInfoCnt);
		checkEmpNoResult.put("memberInfoCnt", memberInfoCnt);
		
		return checkEmpNoResult;
	}
	
	// 회원가입
	public int addMember(MemberInfo memberInfo) {
		int row = memberMapper.addMember(memberInfo);
		log.debug("\033[46;97m" + "MemberService.addMember() row : " + row + "\u001B[0m");
		
		return row;
	}
}
