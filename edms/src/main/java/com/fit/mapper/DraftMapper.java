package com.fit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Approval;
import com.fit.vo.ApprovalJoinDto;
import com.fit.vo.EmpInfo;
import com.fit.vo.ExpenseDraft;
import com.fit.vo.ExpenseDraftContent;
import com.fit.vo.VacationDraft;

@Mapper
public interface DraftMapper {

    List<EmpInfo> getAllEmp();
    
    int insertApproval(Approval approval);
    
    int insertExpenseDraft(ExpenseDraft expenseDraft);
    
    int insertExpenseDraftContent(ExpenseDraftContent expenseDetail);

    int insertReceiveDraft(int approvalNo, int empNo);
    
    int selectLastInsertedApprovalNo();
    
    int selectLastInsertedDocumentNo();
    
    ExpenseDraft selectExpenseDraftByApprovalNo(int approvalNo);
    
    List<ExpenseDraftContent> selectExpenseDraftContentsByApprovalNo(int approvalNo);
    
    List<String> selectRecipientIdsByApprovalNo(int approvalNo);
    
    Approval selectApprovalByApprovalNo(int approvalNo); // 추가됨
    
    int updateApprovalState(int approvalNo, String approvalState);

    int updateApprovalStateAndField(int approvalNo,String approvalState, String approvalField);
    
    int insertVactionDraft(VacationDraft vacationDraft); // 휴가신청서 테이블 insert
    
    int insertReceiveDrafts(int approvalNo, int[] recipients); // 수신참조자 테이블 insert
    
    ApprovalJoinDto selectApprovalOne(int empNo, int approvalNo); // 양식 상세 조회, DTO 사용
    
    VacationDraft selectVactionDraftOne(int approvalNo); // 휴가신청서 상세 조회
}