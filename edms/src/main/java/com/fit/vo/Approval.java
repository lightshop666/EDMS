package com.fit.vo;

import lombok.Data;

@Data
public class Approval {
    private int approvalNo;
    private String firstApprovalName;
    private String mediateApprovalName;
    private String finalApprovalName;
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
}