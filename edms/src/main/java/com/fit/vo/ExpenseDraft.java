package com.fit.vo;

import lombok.Data;
import java.util.List;

@Data
public class ExpenseDraft {
    private int documentNo;
    private int approvalNo;
    private int deptNo;
    private String docTitle;
    private String createdate;
    private String updatedate;
    private String paymentDate;
    private List<ExpenseDraftContent> expenseDraftContents; // 지출결의서 내용들을 담을 리스트
}


