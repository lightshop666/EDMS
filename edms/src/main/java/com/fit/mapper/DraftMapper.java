package com.fit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Approval;
import com.fit.vo.EmpInfo;
import com.fit.vo.ExpenseDraft;
import com.fit.vo.ExpenseDraftContent;

@Mapper
public interface DraftMapper {

    List<EmpInfo> getAllEmp();
    
    int insertApproval(Approval approval);
    
    int insertExpenseDraft(ExpenseDraft expenseDraft);
    
    int insertExpenseDraftContent(ExpenseDraftContent expenseDetail);

    int insertReceiveDraft(int approvalNo, int empNo);
    
    int selectLastInsertedApprovalNo();
    
    int selectLastInsertedDocumentNo();
}
