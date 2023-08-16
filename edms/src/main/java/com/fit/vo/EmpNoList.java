package com.fit.vo;

import lombok.Data;

@Data
public class EmpNoList {
	private int empNo;			// 7자리
	private String active;		// ENUM 'Y', 'N'
	private String createdate;	// DateTime YYYY-MM-DD 00:00:00
}
