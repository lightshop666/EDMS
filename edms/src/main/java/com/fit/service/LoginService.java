package com.fit.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fit.mapper.LoginMapper;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class LoginService {
	@Autowired
	private LoginMapper loginMapper;

    public Map<String, Object> validateUser(String memberId, String memberPw) {
    	
		Map<String, Object> loginSessionMap = loginMapper.selectEmpForSession(memberId, memberPw);
log.debug("\u001B[46m" + "로긴서비스.loginSessionMap :  " + loginSessionMap + "\u001B[0m");
		
		
		return loginSessionMap;
    }
}
