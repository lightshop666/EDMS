package com.fit.vo;

import lombok.Data;

@Data
public class ReceiveJoinDraft {
	private int receiveNo;
	private int approvalNo;
	private int empNo;
	private String createDate;
	// emp_info join
	private String receiveEmpName; // 수신참조자의 이름
	private String receiveDeptName; // 수신참조자의 부서명
	private String receiveEmpPosition; // 수신참조자의 직급
}
