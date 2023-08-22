package com.fit.vo;

import lombok.Data;

@Data
public class Reservation {
	private int reservationNo;
	private int empNo;
	private int utilityNo;
	private String reservationDate;
	private String reservationTime;
	private String createdate;
	
	// DB 테이블과는 일치하지 않는 확장컬럼
	private String utilityCategory;
	private String empName;
}
