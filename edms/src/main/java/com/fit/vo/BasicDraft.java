package com.fit.vo;

import lombok.Data;

@Data
public class BasicDraft {
    private int documentNo;
    private int approvalNo;
    private int deptNo;
    private String docTitle;
    private String createdate;
    private String updatedate;
    private String docContent;
}
