package com.fit.vo;

import lombok.Data;

@Data
public class MemberInfo {
	private int empNo;
	private String memberName;
	private String pw;
	private char gender; // M or F
	private String email;
	private String address;
	private String createdate; // DATETIME
	private String updatedate; // DATETIME
}
