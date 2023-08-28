package com.fit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MemberInfoDto {
	private int empNo;
	private String pw;
	private String gender; // M or F
	private String phoneNumber; // 010-1234-5678
	private String email;
	private String address;
	private String createdate; // DATETIME
	private String updatedate; // DATETIME
	
	private List<MultipartFile> multipartFile; // 업로드된 파일 리스트
}
