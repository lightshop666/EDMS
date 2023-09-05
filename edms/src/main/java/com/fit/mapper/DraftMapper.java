package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Approval;
import com.fit.vo.ApprovalJoinDto;
import com.fit.vo.DocumentFile;
import com.fit.vo.EmpInfo;
import com.fit.vo.ExpenseDraft;
import com.fit.vo.ExpenseDraftContent;
import com.fit.vo.ReceiveJoinDraft;
import com.fit.vo.SalesDraft;
import com.fit.vo.SalesDraftContent;
import com.fit.vo.VacationDraft;
import com.fit.vo.BasicDraft;
import com.fit.vo.VacationHistory;

@Mapper
public interface DraftMapper {

    
    //공통매서드
	
	List<EmpInfo> getAllEmp();
	
    int insertApproval(Approval approval);
    
    int insertReceiveDraft(int approvalNo, int empNo);
    
    int selectLastInsertedApprovalNo();
    
    int selectLastInsertedDocumentNo();
    
    Approval selectApprovalByApprovalNo(int approvalNo); // 추가됨
    
    int selectDocumentNoByApprovalNo(int approvalNo);
    
    int deleteReceiveDrafts(int approvalNo);

    int updateApproval(int approvalNo, int selectedMiddleApproverId, int selectedFinalApproverId, String docTitle);//docTitle 추가필요
    
    List<String> selectRecipientIdsByApprovalNo(int approvalNo);
    
    int updateApprovalState(int approvalNo, String approvalState);

    int updateApprovalStateAndField(int approvalNo,String approvalState, String approvalField);
    
    int updateApprovalReason(int approvalNo, String rejectionReason);
    
    //기안함 List
    
    List<Approval> selectFilteredDrafts(Map<String, Object> filter);

    int selectTotalDraftCount(Map<String, Object> filter);
    
    //결재상태별 갯수 조회
    List<Map<String, Object>> getApprovalStatusByEmpNo(int empNo);
    
    // 수신함 List
    List<Approval> selectFilteredReceiveDrafts(Map<String, Object> filter);
    
    int selectTotalReceiveCount(Map<String, Object> filter);
    
    //Expense Mapper
    
    int insertExpenseDraft(ExpenseDraft expenseDraft);
    
    int insertExpenseDraftContent(ExpenseDraftContent expenseDetail);
    
    ExpenseDraft selectExpenseDraftByApprovalNo(int approvalNo);
    
    List<ExpenseDraftContent> selectExpenseDraftContentsByApprovalNo(int approvalNo);
    
    int updateExpenseDraft(int approvalNo, String docTitle, String paymentDate);

    int deleteExpenseDraftContents(int approvalNo);


    //Basic Mapper
    
    int insertBasicDraft(BasicDraft basicDraft);
    
    BasicDraft selectBasicDraftByApprovalNo(int approvalNo);
    
    int updateBasicDraft(int approvalNo, String docTitle, String docContent);
    
    
    //-------------------------정환 끝------------------------------------------------------
    
    // 희진
    int insertSalesDraft(SalesDraft salesDraft); // 매출보고서 테이블 insert
    
    SalesDraft selectSalesDraftOne(int approvalNo); // 매출보고서 상세 조회
    
    List<SalesDraftContent> selectSalesDraftContentList(int documentNo); // 매출보고서 내역 테이블 조회
    
    int insertSalesDraftContent(int documentNo, List<SalesDraftContent> salesDraftContent); // 매출보고서 내역 테이블 insert
    
    int updateSalesDraft(SalesDraft salesDraft); // 매출보고서 수정
    
    int deleteSalesDraftContent(int documentNo); // 매출보고서 내역 삭제
    
    int insertVactionDraft(VacationDraft vacationDraft); // 휴가신청서 테이블 insert
    
    int insertReceiveDrafts(int approvalNo, int[] recipients); // 수신참조자 테이블 insert
    
    ApprovalJoinDto selectApprovalOne(int empNo, int approvalNo); // 양식 상세 조회, DTO 사용
    
    List<ReceiveJoinDraft> selectReceiveList(int approvalNo); // 해당 문서의 수신참조자 목록 조회, DTO 사용
    
    List<DocumentFile> selectDocumentFileList(int approvalNo); // 해당 문서의 파일 목록 조회
    
    VacationDraft selectVactionDraftOne(int approvalNo); // 휴가신청서 상세 조회
    
    int updateApprovalDetails(int approvalNo, String approvalState, String approvalField, String approvalReason); // 결재상태 업데이트

    int insertVacationHistroy(VacationHistory vacationHistory); // 휴가 히스토리 추가
    
    int deleteDocumentFile(int docFileNo); // 문서 파일 삭제
    
    int insertDocumentFile(DocumentFile documentFile); // 문서 파일 추가
    
    int updateVacationDraft(VacationDraft vacationDraft); // 휴가신청서 수정
    
    List<String> selectSalesDateList(String today, String previousMonth, String previousMonthBefore); // 해당 날짜의 기준년월 데이터가 존재하는지 조회
    
    List<Approval> selectApprovalDraftList(Map<String, Object> paramMap); // 내 결재함 리스트 조회
    
    int selectApprovalDraftCnt(Map<String, Object> paramMap); // 내 결제함 전체 수
    
    List<Map<String, Object>> getApprovalCountsByState(int empNo); // 내 결재함의 결재상태별 갯수 조회
}