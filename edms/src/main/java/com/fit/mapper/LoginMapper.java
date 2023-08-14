package com.fit.mapper;

import java.util.*;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LoginMapper {
	//로그인 세션 저장 정보
	Map<String, Object> selectEmpForSession(String memberId, String memberPw);

}
