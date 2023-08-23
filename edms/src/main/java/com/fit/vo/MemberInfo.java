package com.fit.vo;

import lombok.Data;

@Data
public class MemberInfo {
	private int empNo;
	private String pw;
	private String gender; // M or F
	private String phoneNumber; // 010-1234-5678
	private String email;
	private String address;
	private String createdate; // DATETIME
	private String updatedate; // DATETIME
}
