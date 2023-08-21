package com.fit.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.mapper.DraftMapper;
import com.fit.vo.Approval;
import com.fit.vo.EmpInfo;
import com.fit.vo.ExpenseDraft;
import com.fit.vo.ExpenseDraftContent;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class DraftService {

    @Autowired
    private DraftMapper draftMapper;

    
    public List<EmpInfo> getAllEmp() {
        return draftMapper.getAllEmp();
    }

    @Transactional
    public int processExpenseSubmission(Map<String, Object> submissionData,int[] selectedRecipientsIds) {
        String draftState = "결재대기";
        String expenseCategory = "지출결의서";
        String approvalField = "A";

        log.debug("processExpenseSubmission() Start");

        // 전달받은 submissionData 출력
        log.debug("Submission Data: {}", submissionData);
        
     
        // approval 테이블에 데이터 입력
        Approval approval = new Approval();
        approval.setEmpNo((Integer) submissionData.get("empNo"));
        approval.setDocTitle((String) submissionData.get("documentTitle"));
        approval.setFirstApproval((Integer) submissionData.get("applicantName"));
        approval.setMediateApproval((Integer) submissionData.get("selectedMiddleApproverId"));
        approval.setFinalApproval((Integer) submissionData.get("selectedFinalApproverId"));
        approval.setApprovalDate((String) submissionData.get("approvalDate"));
        approval.setApprovalReason("");
        approval.setApprovalState(draftState);
        approval.setDocumentCategory(expenseCategory);
        approval.setApprovalField(approvalField);
        draftMapper.insertApproval(approval);

        // 생성된 approval_no를 가져옴
        int approvalNo = draftMapper.selectLastInsertedApprovalNo();

        // expense_draft 테이블에 데이터 입력
        ExpenseDraft expenseDraft = new ExpenseDraft();
        expenseDraft.setApprovalNo(approvalNo);
        // 이 값은 어떻게 가져오는지에 따라 다를 수 있음
        expenseDraft.setDocumentNo(draftMapper.selectLastInsertedDocumentNo());
        expenseDraft.setPaymentDate((String) submissionData.get("paymentDate"));
        expenseDraft.setDocTitle((String) submissionData.get("documentTitle"));
        // 기타 필드들 설정
        draftMapper.insertExpenseDraft(expenseDraft);

        // expense_draft_content 테이블에 데이터 입력
        List<Map<String, Object>> expenseDetails = (List<Map<String, Object>>) submissionData.get("expenseDetails");
        for (Map<String, Object> expenseDetailData : expenseDetails) {
            ExpenseDraftContent expenseDetail = new ExpenseDraftContent();
            expenseDetail.setDocumentNo(draftMapper.selectLastInsertedDocumentNo());
            expenseDetail.setExpenseCategory((String) expenseDetailData.get("expenseCategory"));
            expenseDetail.setExpenseCost((Double) expenseDetailData.get("expenseCost"));
            expenseDetail.setExpenseInfo((String) expenseDetailData.get("expenseInfo"));
            // 기타 필드들 설정
            draftMapper.insertExpenseDraftContent(expenseDetail);
        }

        // receive_draft 테이블에 데이터 입력 (수신참조자)
        for (int empNo : selectedRecipientsIds) {
            draftMapper.insertReceiveDraft(approvalNo, empNo);
        }
        return 1;

    }
}