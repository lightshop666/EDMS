package com.fit.vo;

import lombok.Data;

@Data
public class VacationDraft {
	private int documentNo; // 기본키
	private int approvalNo; // 문서번호
	private int empNo; // 사원번호
	private String docTitle; // 제목
	private String docContent; // 내용
	private String vacationName; // 휴가종류 // 반차, 연차, 보상
	private double vacationDays; // 사용 휴가일수
	private String vacationStart; // 휴가 시작일
	private String vacationEnd; // 휴가 종료일
	private String phoneNumber; // 비상연락망
	private String createdate;
	private String updatedate;
}
