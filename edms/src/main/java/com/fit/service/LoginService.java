package com.fit.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fit.CC;
import com.fit.mapper.LoginMapper;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class LoginService {
	@Autowired
	private LoginMapper loginMapper;

    public Map<String, Object> validateUser(String memberId, String memberPw) {
    	
		Map<String, Object> loginSessionMap = loginMapper.selectEmpForSession(memberId, memberPw);
		log.debug(CC.WOO + "로긴서비스.loginSessionMap :  " + loginSessionMap + CC.RESET);
		
		// DB에서 날짜값을 받아오면 String 타입으로 형변환이 필요합니다.
		log.debug(CC.WOO + "로긴서비스.loginSessionMap employDate의 형변환 전 타입 :  " + loginSessionMap.get("employDate").getClass() + CC.RESET);
		java.sql.Date employDate = (java.sql.Date) loginSessionMap.get("employDate");
		String employDateString = employDate.toString();
		loginSessionMap.put("employDate", employDateString);
		log.debug(CC.WOO + "로긴서비스.loginSessionMap employDate의 형변환 후 타입 :  " + loginSessionMap.get("employDate").getClass() + CC.RESET);
		
		return loginSessionMap;
    }
}
