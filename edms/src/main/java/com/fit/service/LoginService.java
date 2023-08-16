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
		
		
		return loginSessionMap;
    }
}
