package com.fit.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.CC;
import com.fit.mapper.DraftMapper;
import com.fit.mapper.MemberMapper;
import com.fit.vo.Approval;
import com.fit.vo.EmpInfo;
import com.fit.vo.ExpenseDraft;
import com.fit.vo.ExpenseDraftContent;
import com.fit.vo.MemberFile;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class DraftService {

    @Autowired
    private DraftMapper draftMapper;
    
    @Autowired
    private MemberMapper memberMapper;

    
    public List<EmpInfo> getAllEmp() {
        return draftMapper.getAllEmp();
    }

    
    public int processExpenseSubmission(Map<String, Object> submissionData,int[] selectedRecipientsIds, List<ExpenseDraftContent> expenseDraftContentList) {
        String draftState = "결재대기";
        String expenseCategory = "지출결의서";
        String approvalField = "A";
       //임시번호 
        int empNotest = 2008001;

        log.debug("processExpenseSubmission() Start");

        // 전달받은 submissionData 출력
        log.debug("Submission Data: {}", submissionData);
        
     
        log.debug("Selected Middle Approver ID: {}", submissionData.get("selectedMiddleApproverId"));
        log.debug("Selected Final Approver ID: {}", submissionData.get("selectedFinalApproverId"));
        log.debug("Approval Date: {}", submissionData.get("approvalDate"));
        // approval 테이블에 데이터 입력
        Approval approval = new Approval();
        approval.setEmpNo(empNotest);
        approval.setDocTitle((String) submissionData.get("documentTitle"));
        approval.setFirstApproval(empNotest);
        approval.setMediateApproval(Integer.parseInt((String) submissionData.get("selectedMiddleApproverId")));
        approval.setFinalApproval(Integer.parseInt((String) submissionData.get("selectedFinalApproverId")));
        approval.setApprovalDate("");
        approval.setApprovalReason("");
        approval.setApprovalState(draftState);
        approval.setDocumentCategory(expenseCategory);
        approval.setApprovalField(approvalField);
        int insertResult = draftMapper.insertApproval(approval);

        log.debug("insertResult:", insertResult);	
        
        // expense_draft 테이블에 데이터 입력
        ExpenseDraft expenseDraft = new ExpenseDraft();
        expenseDraft.setApprovalNo(draftMapper.selectLastInsertedApprovalNo());
        expenseDraft.setPaymentDate((String) submissionData.get("paymentDate"));
        expenseDraft.setDocTitle((String) submissionData.get("documentTitle"));
        // 기타 필드들 설정
        draftMapper.insertExpenseDraft(expenseDraft);

        // expense_draft_content 테이블에 데이터 입력
        for (ExpenseDraftContent expenseDetail : expenseDraftContentList) {
            expenseDetail.setDocumentNo(draftMapper.selectLastInsertedDocumentNo());
            // 기타 필드들 설정
            draftMapper.insertExpenseDraftContent(expenseDetail);
        }

        // receive_draft 테이블에 데이터 입력 (수신참조자)
        for (int empNo : selectedRecipientsIds) {
            draftMapper.insertReceiveDraft(draftMapper.selectLastInsertedApprovalNo(), empNo);
        }
        return 1;

    }
    
    // 작성 폼에서 출력될 기안자의 서명 이미지 조회
    // 기존의 memberMapper 사용
    @Transactional
    public MemberFile selectMemberSign(int empNo) {
    	// fileCategory를 Sign으로 지정하여 서명 조회
		MemberFile memberSign = memberMapper.selectMemberFile(empNo, "Sign");
		log.debug(CC.HE + "EmpService.selectMemberSign() memberSign : " + memberSign + CC.RESET);
		
		return memberSign;
    }
}