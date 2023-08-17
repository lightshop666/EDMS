package com.fit.vo;

import lombok.Data;

@Data
public class MemberInfo {
	private int empNo;
	private String pw;
	private String gender; // M or F
	private String email;
	private String address;
	private String createdate; // DATETIME
	private String updatedate; // DATETIME
}
