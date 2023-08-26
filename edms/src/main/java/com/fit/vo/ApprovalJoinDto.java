package com.fit.vo;

import java.util.List;

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
    private String role; // 기안자, 중간승인자, 최종승인자
    private String firstEmpName; // 기안자의 이름
    private String firstDeptName; // 기안자의 부서명
    // receive_draft 테이블
    List<ReceiveDraft> receiveDraftList;
    // document_file 테이블
    List<DocumentFile> documentFileList;
}
