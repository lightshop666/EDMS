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
}
