package com.fit.vo;

import lombok.Data;

@Data
public class empInfo {
	private int empNo;				// 7자리
	private String empName;
	private String deptName;		// 부서명 반정규화, 소속부서 없을시 ""
	private String teamName;		// 팀명, 반정규화, 소속팀 없을시 ""
	private String empPosition;		// 직급
	private String accessLevel;		// Enum '3', '2','1','0' 부서장, 경영팀2~1, 기획팀-영업팀1~0
	private String empState;		// Enum '재직', '퇴직'
	private String employDate;		// Date YYYY-MM-DD 입사일
	private Double remainDays;
	private String createdate;		// DateTime YYYY-MM-DD 00:00:00
	private String updatedate;		// DateTime YYYY-MM-DD 00:00:00
}
