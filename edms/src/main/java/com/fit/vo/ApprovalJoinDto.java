package com.fit.vo;

import lombok.Data;

// 각 양식의 상세페이지를 위한 결재정보 관련 DTO를 만듭니다.
@Data
public class ApprovalJoinDto {
	// approval 테이블
	private int approvalNo;
    private int empNo;
    private String docTitle;
    private int firstApproval;
    private int mediateApproval;
    private int finalApproval;
    private String approvalDate;
    private String approvalReason;
    private String approvalState;
    private String documentCategory;
    private String approvalField;
    private String createdate;
    // CASE~WHEN문 조회
    private String role; // 기안자, 중간승인자, 최종승인자, 중간 및 최종승인자
    // emp_info join
    private String firstEmpName; // 기안자의 이름
    private String firstDeptName; // 기안자의 부서명
    private String firstEmpPosition; // 기안자의 직급
    private String mediateEmpName; // 중간승인자의 이름
    private String mediateDeptName; // 중간승인자의 부서명
    private String mediateEmpPosition; // 중간승인자의 부서명
    private String finalEmpName; // 최종승인자의 이름
    private String finalDeptName; // 최종승인자의 부서명
    private String finalEmpPosition; // 최종승인자의 부서명
}
