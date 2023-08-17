package com.fit.controller;


import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class UUIDTest {
	@GetMapping("/uuid")
	public String uuid() {
		// 랜덤 uuid 객체를 생성
		UUID uuid = UUID.randomUUID();
		
		// 디버깅
		log.debug(CC.YOUN+"UUIDTest.uuid() uuid: "+uuid.toString().replace("-", "")+CC.RESET);
		
		return "";
	}
}
