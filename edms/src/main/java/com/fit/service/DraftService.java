package com.fit.service;


import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.fit.CC;
import com.fit.mapper.DraftMapper;
import com.fit.mapper.MemberMapper;
import com.fit.vo.Approval;
import com.fit.vo.ApprovalJoinDto;
import com.fit.vo.BasicDraft;
import com.fit.vo.DocumentFile;
import com.fit.vo.EmpInfo;
import com.fit.vo.ExpenseDraft;
import com.fit.vo.ExpenseDraftContent;
import com.fit.vo.MemberFile;
import com.fit.vo.ReceiveJoinDraft;
import com.fit.vo.SalesDraft;
import com.fit.vo.SalesDraftContent;
import com.fit.vo.VacationDraft;
import com.fit.vo.VacationHistory;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class DraftService {

    @Autowired
    private DraftMapper draftMapper;
    
    @Autowired
    private MemberMapper memberMapper;


    //------------------------------정환 시작---------------------------------------------
    public List<Approval> getFilteredDrafts(Map<String, Object> filterParams, int empNo) {
        filterParams.put("empNo", empNo);
        
        log.debug("filterParamsa: {}", filterParams);
        return draftMapper.selectFilteredDrafts(filterParams);
    }

    public int getTotalDraftCount(Map<String, Object> filterParams,int empNo) {
       filterParams.put("empNo", empNo);
       return draftMapper.selectTotalDraftCount(filterParams);
    }
    

    public int getTotalReceiveCount(Map<String, Object> filterParams,int empNo) {
       filterParams.put("empNo", empNo);
       return draftMapper.selectTotalReceiveCount(filterParams);
    }
   
    public List<Approval> getFilteredReceiveDrafts(Map<String, Object> filterParams, int empNo) {
        filterParams.put("empNo", empNo);
        
        log.debug("filterParamsa: {}", filterParams);
        return draftMapper.selectFilteredReceiveDrafts(filterParams);
    }
   
    public List<EmpInfo> getAllEmp() {
        return draftMapper.getAllEmp();
    }

    //지출결의서 service 매서드
    @Transactional
    public int processExpenseSubmission(Boolean isSaveDraft,Map<String, Object> submissionData,List<Integer> selectedRecipientsIds, List<ExpenseDraftContent> expenseDraftContentList, int empNo) {
       String draftState = null;  
       if (isSaveDraft) {
               draftState = "임시저장";
           } else {
               draftState = "결재대기";
       }
       
        String expenseCategory = "지출결의서";
        String approvalField = "A";
       //임시번호 
        int empNotest = 2008001;
        
        int result = 1;

        log.debug("processExpenseSubmission() Start");

        // 전달받은 submissionData 출력
        log.debug("Submission Data: {}", submissionData);
        
     
        log.debug("Selected Middle Approver ID: {}", submissionData.get("selectedMiddleApproverId"));
        log.debug("Selected Final Approver ID: {}", submissionData.get("selectedFinalApproverId"));
        log.debug("Approval Date: {}", submissionData.get("approvalDate"));
        // approval 테이블에 데이터 입력
        Approval approval = new Approval();
        approval.setEmpNo(empNo);
        approval.setDocTitle((String) submissionData.get("documentTitle"));
        approval.setFirstApproval(empNo);
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
        if (expenseDraftContentList != null && !expenseDraftContentList.isEmpty()) {
           for (ExpenseDraftContent expenseDetail : expenseDraftContentList) {
               expenseDetail.setDocumentNo(draftMapper.selectLastInsertedDocumentNo());
               // 기타 필드들 설정
               draftMapper.insertExpenseDraftContent(expenseDetail);
           }
        }  
        
        if (selectedRecipientsIds == null || selectedRecipientsIds.isEmpty()) {
            return result; // 수신참조자가 없는 경우를 나타내는 코드 또는 상수값
        }else {
           for (int empNos : selectedRecipientsIds) {
                draftMapper.insertReceiveDraft(draftMapper.selectLastInsertedApprovalNo(), empNos);
            }
        }
        return result;
    }
    
    //expenseDraftOne
    public Map<String, Object> getExpenseDraftDataByApprovalNo(int approvalNo,int empNo) {
        Map<String, Object> expenseDraftData = new HashMap<>();
        
        
        // approval 테이블에서 데이터 조회
        Approval approval = draftMapper.selectApprovalByApprovalNo(approvalNo);
        expenseDraftData.put("approvalNo", approvalNo);
        expenseDraftData.put("firstApprovalName", String.valueOf(approval.getFirstApprovalName()));
        expenseDraftData.put("mediateApprovalName", String.valueOf(approval.getMediateApprovalName()));
        expenseDraftData.put("finalApprovalName", String.valueOf(approval.getFinalApprovalName()));
        expenseDraftData.put("firstApproval", Integer.parseInt(String.valueOf(approval.getFirstApproval())));
        expenseDraftData.put("mediateApproval", Integer.parseInt(String.valueOf(approval.getMediateApproval())));
        expenseDraftData.put("finalApproval", Integer.parseInt(String.valueOf(approval.getFinalApproval())));
        expenseDraftData.put("status", String.valueOf(approval.getApprovalField()));
       
        
        //역할부여
        String role = determineRole(approval, empNo);
        
        log.debug("Role Determined: {}", role); // 디버깅용 로그 추가....'
        expenseDraftData.put("role", role);
        
        // expense_draft 테이블에서 데이터 조회
        ExpenseDraft expenseDraft = draftMapper.selectExpenseDraftByApprovalNo(approvalNo);
        expenseDraftData.put("paymentDate", expenseDraft.getPaymentDate());
        expenseDraftData.put("docTitle", expenseDraft.getDocTitle()); // 이 부분 추가
        
        log.debug(CC.JUNG + "[DEBUG] Expense Draft Data: {}", expenseDraftData + CC.RESET);
        
        // expense_draft_content 테이블에서 데이터 조회
        List<ExpenseDraftContent> expenseDraftContentList = draftMapper.selectExpenseDraftContentsByApprovalNo(approvalNo);
        expenseDraftData.put("expenseDraftContentList", expenseDraftContentList);
        
        log.debug(CC.JUNG + "[DEBUG] Expense Draft Data: {}", expenseDraftData + CC.RESET);
        
        // receive_draft 테이블에서 데이터 조회
        List<String> selectedRecipientsIds = draftMapper.selectRecipientIdsByApprovalNo(approvalNo);
        expenseDraftData.put("selectedRecipientsIds", selectedRecipientsIds);
        
        Map<String, Object> memberSignMap = getApproverSign(approval); 
        expenseDraftData.put("memberSignMap", memberSignMap); 
        
        
        log.debug(CC.JUNG + "[DEBUG] Expense Draft Data: {}", expenseDraftData + CC.RESET);
        
        return expenseDraftData;
    }
    
       
       public int modifyExpenseDraft(Map<String, Object> submissionData, List<Integer> selectedRecipientsIds, List<ExpenseDraftContent> expenseDraftContentList) {
           // 1. 수정하려는 지출 결의서의 approvalNo 가져오기
           int approvalNo = (int) submissionData.get("approvalNo");

           // 2. ExpenseDraft 테이블의 docTitle과 마감일 업데이트
           String docTitle = (String) submissionData.get("documentTitle");
           String paymentDate = (String) submissionData.get("paymentDate");
           draftMapper.updateExpenseDraft(approvalNo, docTitle, paymentDate);

           // 3. expense_draft_content 테이블에서 해당 approvalNo에 해당하는 데이터 삭제
           draftMapper.deleteExpenseDraftContents(approvalNo);

           // 4. expense_draft_content 테이블에 수정된 데이터 insert
           if (expenseDraftContentList != null && !expenseDraftContentList.isEmpty()) {
               for (ExpenseDraftContent expenseDetail : expenseDraftContentList) {
                   //documentNo 설정
                   expenseDetail.setDocumentNo(draftMapper.selectDocumentNoByApprovalNo(approvalNo));
                   draftMapper.insertExpenseDraftContent(expenseDetail);
               }
           }

           // 5. receive_draft 테이블에서 해당 approvalNo에 해당하는 데이터 삭제
           draftMapper.deleteReceiveDrafts(approvalNo);

           log.debug("selectedRecipientsIds: {}", selectedRecipientsIds);
           // 6. receive_draft 테이블에 수정된 데이터 insert
           
           List<Integer> selectedRecipientsId = selectedRecipientsIds;
           log.debug("selectedRecipientsId: {}", selectedRecipientsId);
           if (selectedRecipientsId != null && !selectedRecipientsId.isEmpty()) {
               for (int empNo : selectedRecipientsId) {
                   draftMapper.insertReceiveDraft(approvalNo, empNo);
               }
           }
           
           int row = 1;

           // 7. approval 테이블 수정
           
           String isSave = (String) submissionData.get("isSave");
           
           int selectedMiddleApproverId = Integer.parseInt((String) submissionData.get("selectedMiddleApproverId"));
           int selectedFinalApproverId = Integer.parseInt((String) submissionData.get("selectedFinalApproverId"));
           draftMapper.updateApproval(approvalNo, selectedMiddleApproverId, selectedFinalApproverId,docTitle);


           return row; // 성공적으로 수정되었음을 나타내는 코드 또는 상수값
       }
   
       //기본 기안서 basicDraft service 매서드
       public int processBasicSubmission(Boolean isSaveDraft,Map<String, Object> submissionData,List<Integer> selectedRecipientsIds, int empNo) {
          String 
                  draftState = "결재대기";      
          
           String basicCategory = "기안서";
           String approvalField = "A";
          //임시번호 
           int empNotest = 2008001;

           log.debug("processBasicSubmission() Start");

           // 전달받은 submissionData 출력
           log.debug("Submission Data: {}", submissionData);
           
        
           log.debug("Selected Middle Approver ID: {}", submissionData.get("selectedMiddleApproverId"));
           log.debug("Selected Final Approver ID: {}", submissionData.get("selectedFinalApproverId"));
           log.debug("Approval Date: {}", submissionData.get("approvalDate"));
           // approval 테이블에 데이터 입력
           Approval approval = new Approval();
           approval.setEmpNo(empNo);
           approval.setDocTitle((String) submissionData.get("documentTitle"));
           approval.setFirstApproval(empNo);
           approval.setMediateApproval(Integer.parseInt((String) submissionData.get("selectedMiddleApproverId")));
           approval.setFinalApproval(Integer.parseInt((String) submissionData.get("selectedFinalApproverId")));
           approval.setApprovalDate("");
           approval.setApprovalReason("");
           approval.setApprovalState(draftState);
           approval.setDocumentCategory(basicCategory);
           approval.setApprovalField(approvalField);
           int insertResult = draftMapper.insertApproval(approval);

           log.debug("insertResult:", insertResult);   
           
           // basic_draft 테이블에 데이터 입력
           BasicDraft basicDraft = new BasicDraft();
           basicDraft.setApprovalNo(draftMapper.selectLastInsertedApprovalNo());
           basicDraft.setDocContent((String) submissionData.get("docContent"));
           basicDraft.setDocTitle((String) submissionData.get("documentTitle"));
           // 기타 필드들 설정
           draftMapper.insertBasicDraft(basicDraft);

           int row = 1;
           if (selectedRecipientsIds == null || selectedRecipientsIds.isEmpty()) {
               return 1; // 수신참조자가 없는 경우를 나타내는 코드 또는 상수값
           }else {
              for (int empNos : selectedRecipientsIds) {
            	   draftMapper.insertReceiveDraft(draftMapper.selectLastInsertedApprovalNo(), empNos);
               }  
           }   
           return row;
       }
       
       // 결재상태에 따른 서명이미지 조회
       private Map<String, Object> getApproverSign(Approval approval) {
          Map<String, Object> memberSignMap = new HashMap<>();
          
          // 기안자의 서명은 무조건 조회
          int firstEmpNo = approval.getFirstApproval(); // 기안자의 사원번호 조회
         memberSignMap.put("firstSign", selectMemberSign(firstEmpNo)); // 기존 메서드 사용
         // 결재상태에 따라 해당 결재자의 서명 이미지를 조회합니다.
         String approvalField = approval.getApprovalField();
          if ( approvalField.equals("B") ) { // 결재중
             int mediateEmpNo = approval.getMediateApproval(); // 중간승인자의 사원번호 조회
             memberSignMap.put("mediateSign", selectMemberSign(mediateEmpNo)); 
          } else if ( approvalField.equals("C") ) { // 결재완료
             int mediateEmpNo = approval.getMediateApproval(); // 중간승인자의 사원번호 조회
             int finalEmpNo = approval.getFinalApproval(); // 중간승인자의 사원번호 조회
             memberSignMap.put("mediateSign", selectMemberSign(mediateEmpNo));
             memberSignMap.put("finalSign", selectMemberSign(finalEmpNo));
          }
          
          return memberSignMap;
       }
       
       
       //basicDraftOne
       public Map<String, Object> getBasicDraftDataByApprovalNo(int approvalNo,int empNo) {
           Map<String, Object> basicDraftData = new HashMap<>();
           
           
           // approval 테이블에서 데이터 조회
           Approval approval = draftMapper.selectApprovalByApprovalNo(approvalNo);
           basicDraftData.put("approvalNo", approvalNo);
           basicDraftData.put("firstApprovalName", String.valueOf(approval.getFirstApprovalName()));
           basicDraftData.put("mediateApprovalName", String.valueOf(approval.getMediateApprovalName()));
           basicDraftData.put("finalApprovalName", String.valueOf(approval.getFinalApprovalName()));
           basicDraftData.put("firstApproval", Integer.parseInt(String.valueOf(approval.getFirstApproval())));
           basicDraftData.put("mediateApproval", Integer.parseInt(String.valueOf(approval.getMediateApproval())));
           basicDraftData.put("finalApproval", Integer.parseInt(String.valueOf(approval.getFinalApproval())));
           basicDraftData.put("status", String.valueOf(approval.getApprovalField()));
          
           
           //역할부여
           String role = determineRole(approval, empNo);
           
           log.debug("Role Determined: {}", role); // 디버깅용 로그 추가
           basicDraftData.put("role", role);
           
           // basic_draft 테이블에서 데이터 조회
           BasicDraft basicDraft = draftMapper.selectBasicDraftByApprovalNo(approvalNo);
           basicDraftData.put("docContent", basicDraft.getDocContent());
           basicDraftData.put("docTitle", basicDraft.getDocTitle()); // 이 부분 추가
           
           log.debug(CC.JUNG + "[DEBUG] Basic Draft Data: {}", basicDraftData + CC.RESET);
           
           
           // receive_draft 테이블에서 데이터 조회
           List<String> selectedRecipientsIds = draftMapper.selectRecipientIdsByApprovalNo(approvalNo);
           basicDraftData.put("selectedRecipientsIds", selectedRecipientsIds);
           
           
           // 5. Signature Images
           Map<String, Object> memberSignMap = getApproverSign(approval); 
           basicDraftData.put("memberSignMap", memberSignMap); 
           
           log.debug(CC.JUNG + "[DEBUG] Basic Draft Data: {}", basicDraftData + CC.RESET);
           
           return basicDraftData;
       }
       
       
       //공통 서비스
       
       // 역할을 결정하는 로직 분리
       private String determineRole(Approval approval, int empNo) {
           if (empNo == approval.getFirstApproval()) {
               return "drafter";
           } else if (empNo == approval.getMediateApproval()) {
               return "middleApprover";
           } else if (empNo == approval.getFinalApproval()) {
               return "finalApprover";
           } else {
               return "unknown"; // 혹은 다른 기본 역할 처리
           }
       }
       
       //
       public void cancelDraft(int approvalNo) { //기안취소 버튼 클릭시
           draftMapper.updateApprovalState(approvalNo, "임시저장");
       }

       public void approveDraft(int approvalNo, String role) {//승인 버튼 클릭시
          String A = "A";
           String B = "B";
           String C = "C";
          if ("middleApprover".equals(role)) {
               draftMapper.updateApprovalStateAndField(approvalNo, "결재중", B);
           } else if ("finalApprover".equals(role)) {
               draftMapper.updateApprovalStateAndField(approvalNo, "결재완료", C);
           }
       }

       public int rejectDraft(int approvalNo,String rejectionReason) { //반려 버튼 클릭시
           String A = "A";
           String B = "B";
           String C = "C";
          draftMapper.updateApprovalStateAndField(approvalNo, "반려",A);
           draftMapper.updateApprovalReason(approvalNo,rejectionReason);
       
           return 1;
       }

       public void cancelApproval(int approvalNo, String role) {
          String A = "A";
           String B = "B";
           String C = "C";
          
          if ("finalApprover".equals(role)) {   //승인취소 버튼 클릭시
               draftMapper.updateApprovalStateAndField(approvalNo, "결재중", B);
           }else {
              draftMapper.updateApprovalStateAndField(approvalNo, "결재대기", A);
           }   
         
       }
       
       public int modifyBasicDraft(Map<String, Object> submissionData, List<Integer> selectedRecipientsIds) {
           // 1. 수정하려는 지출 결의서의 approvalNo 가져오기
           int approvalNo = (int) submissionData.get("approvalNo");

           // 2. BasicDraft 테이블의 docTitle과 마감일 업데이트
           String docTitle = (String) submissionData.get("documentTitle");
           String docContent = (String) submissionData.get("docContent");
           draftMapper.updateBasicDraft(approvalNo, docTitle, docContent);

           // 3. receive_draft 테이블에서 해당 approvalNo에 해당하는 데이터 삭제
           draftMapper.deleteReceiveDrafts(approvalNo);

           log.debug("selectedRecipientsIds: {}", selectedRecipientsIds);
           // 4. receive_draft 테이블에 수정된 데이터 insert
           
           List<Integer> selectedRecipientsId = selectedRecipientsIds;
           log.debug("selectedRecipientsId: {}", selectedRecipientsId);
           if (selectedRecipientsId != null && !selectedRecipientsId.isEmpty()) {
               for (int empNo : selectedRecipientsId) {
                   draftMapper.insertReceiveDraft(approvalNo, empNo);
               }
           }

           // 5. approval 테이블 수정
           int selectedMiddleApproverId = Integer.parseInt((String) submissionData.get("selectedMiddleApproverId"));
           int selectedFinalApproverId = Integer.parseInt((String) submissionData.get("selectedFinalApproverId"));
           String isSave = (String) submissionData.get("isSave");
           
           draftMapper.updateApproval(approvalNo, selectedMiddleApproverId, selectedFinalApproverId,docTitle);


           return draftMapper.updateApproval(approvalNo, selectedMiddleApproverId, selectedFinalApproverId,docTitle); // 성공적으로 수정되었음을 나타내는 코드 또는 상수값
       }
    //------------------------------정환 끝---------------------------------------------   
    //------------------------------희진 시작--------------------------------------------
    // 작성 폼에서 출력될 기안자의 서명 이미지 조회
    // 기존의 memberMapper 사용
    @Transactional
    public MemberFile selectMemberSign(int empNo) {
       // fileCategory를 Sign으로 지정하여 서명 조회
      MemberFile memberSign = memberMapper.selectMemberFile(empNo, "Sign");
      log.debug(CC.HE + "DraftService.selectMemberSign() memberSign : " + memberSign + CC.RESET);
      
      return memberSign;
    }
    
    // approval 테이블에 insert 후 key 값을 반환하는 메서드
    // approval 테이블은 모든 양식이 공통으로 사용하는 테이블이므로 하나의 메서드를 만들었습니다.
    // 단, document_category 값을 반드시 양식에 맞게 셋팅 후 호출해주세요.
    @Transactional
    public int addApprovalAndReturnKey(Approval approval, boolean isSaveDraft) {
       // 기본값 셋팅
       approval.setApprovalDate("0000-00-00"); // 결재일
       approval.setApprovalReason(""); // 반려사유
       approval.setApprovalField("A"); // 승인상태
       // 임시저장 유무에 따라 분기
       if (isSaveDraft) {
          approval.setApprovalState("임시저장"); // 결재상태
          log.debug(CC.HE + "DraftService.addApprovalAndReturnKey() 결재상태 : 임시저장" + CC.RESET);
       } else {
          approval.setApprovalState("결재대기"); // 결재상태
          log.debug(CC.HE + "DraftService.addApprovalAndReturnKey() 결재상태 : 결재대기 " + CC.RESET);
       }
       
       // mapper 호출
       int row = draftMapper.insertApproval(approval);
       log.debug(CC.HE + "DraftService.addApprovalAndReturnKey() row : " + row + CC.RESET);
       
       if (row == 1) { // insert 성공 시
          int approvalKey = approval.getApprovalNo(); // 키 값 가져오기
          log.debug(CC.HE + "DraftService.addApprovalAndReturnKey() approvalKey : " + approvalKey + CC.RESET);
          
          return approvalKey; // 키 값 반환
       }
       
       return 0;
    }
    
    // 결재정보 조회
    // 양식 종류에 상관없이 공통적으로 조회되는 approval, receive_draft, document_file 테이블을 조회하는 메서드입니다.
    public Map<String, Object> selectApprovalOne(int empNo, int approvalNo) {
       Map<String, Object> result = new HashMap<>();
       
       // 1. approval 테이블 조회
       ApprovalJoinDto approval = draftMapper.selectApprovalOne(empNo, approvalNo);
       result.put("approval", approval);
       // 2. receive_draft, document_file 테이블 조회 (List)
       if (approval != null) {
          List<ReceiveJoinDraft> receiveList = draftMapper.selectReceiveList(approvalNo);
          List<DocumentFile> documentFileList = draftMapper.selectDocumentFileList(approvalNo);
          result.put("receiveList", receiveList);
          result.put("documentFileList", documentFileList);
       }
              
       return result;
    }
    
    // 결재상태에 따른 서명이미지 조회
    public Map<String, Object> getApprovalSign(ApprovalJoinDto approvalJoinDto) {
       Map<String, Object> memberSignMap = new HashMap<>();
       
       // 기안자의 서명은 무조건 조회
       int firstEmpNo = approvalJoinDto.getFirstApproval(); // 기안자의 사원번호 조회
      memberSignMap.put("firstSign", selectMemberSign(firstEmpNo)); // 기존 메서드 사용
      // 결재상태에 따라 해당 결재자의 서명 이미지를 조회합니다.
      String approvalField = approvalJoinDto.getApprovalField();
       if ( approvalField.equals("B") ) { // 결재중
          int mediateEmpNo = approvalJoinDto.getMediateApproval(); // 중간승인자의 사원번호 조회
          memberSignMap.put("mediateSign", selectMemberSign(mediateEmpNo)); 
       } else if ( approvalField.equals("C") ) { // 결재완료
          int mediateEmpNo = approvalJoinDto.getMediateApproval(); // 중간승인자의 사원번호 조회
          int finalEmpNo = approvalJoinDto.getFinalApproval(); // 중간승인자의 사원번호 조회
          memberSignMap.put("mediateSign", selectMemberSign(mediateEmpNo));
          memberSignMap.put("finalSign", selectMemberSign(finalEmpNo));
       }
       
       return memberSignMap;
    }
    
    // 결재상태 업데이트 메서드
    // actionType : 기안취소 -> cancel, 승인 -> approve, 반려 -> reject, 승인취소 -> CancelApprove
    @Transactional
    public int updateApprovalState(int approvalNo, String role, String approvalField, String actionType, String approvalReason) {
       int row = 0;
       
       // actionType에 따라 업데이트할 결재 상태를 지정합니다.
       // approvalReason은 입력하지 않았을 시 기본값 공백으로 들어옵니다.
       String approvalState = "";
       String newApprovalField = "A";
        if (actionType.equals("cancel")) { // 기안취소 -> 임시저장
          approvalState = "임시저장";
       } else if (actionType.equals("approve")) { // 승인
          if (role.equals("중간승인자")) { // 결재중으로 변경
             approvalState = "결재중";
             newApprovalField = "B";
          } else if (role.equals("최종승인자")) { // 결재완료로 변경
             approvalState = "결재완료";
             newApprovalField = "C";
          } else if (role.equals("중간 및 최종승인자") && approvalField.equals("A")) {
             approvalState = "결재중";
             newApprovalField = "B";
          } else if (role.equals("중간 및 최종승인자") && approvalField.equals("B")) {
             approvalState = "결재완료";
             newApprovalField = "C";
          }
       } else if (actionType.equals("CancelApprove")) { // 승인취소
          if (role.equals("중간승인자")) {
             approvalState = "결재대기";
             newApprovalField = "A";
          } else if (role.equals("최종승인자")) {
             approvalState = "결재중";
             newApprovalField = "B";
          } else if (role.equals("중간 및 최종승인자") && approvalField.equals("B")) {
             approvalState = "결재대기";
             newApprovalField = "A";
          } else if (role.equals("중간 및 최종승인자") && approvalField.equals("C")) {
             approvalState = "결재중";
             newApprovalField = "B";
          }
       } else if (actionType.equals("reject")) { // 반려
          approvalState = "반려";
          newApprovalField = "A";
       }
        
        row = draftMapper.updateApprovalDetails(approvalNo, approvalState, newApprovalField, approvalReason);

        // vacationHistory 매서드 호출
      int vacationHistoryRow = addVacationHistory(approvalNo, actionType, approvalField);
      log.debug(CC.HE + "DraftController.updateApprovalState() vacationHistoryRow : " + vacationHistoryRow + CC.RESET);
        
       return row;
    }
    
    // 결재문서를 수정하는 메서드
    // 양식들의 공통 테이블인 approval, receive_draft, document_file에 대한 수정 작업을 수행합니다.
    @Transactional
    public void updateDraftOne(Map<String, Object> paramMap) {
       // 복수의 행을 가지는 receive_draft 테이블은 delete 후 insert 작업을 수행합니다.
       // document_file 테이블은 수정 form에서 기존 파일 삭제 기능을 제공하므로 insert 작업을 수행합니다.
       // 단일행을 가지는 approval 테이블은 update 작업을 수행합니다.
       // 1. approval 테이블
       Approval approval = (Approval) paramMap.get("approval"); // map에서 객체 가져오기
       int approvalNo = approval.getApprovalNo();
       int mediateApproval = approval.getMediateApproval();
       int finalApproval = approval.getFinalApproval();
       String docTitle = approval.getDocTitle();
       // update mapper 호출
       draftMapper.updateApproval(approvalNo, mediateApproval, finalApproval, docTitle);
       log.debug(CC.HE + "DraftService.updateDraftOne() approval update 실행 "+ CC.RESET);
       // 1-1. 결재대기로 변경
       String approvalState = "결재대기"; // 임시저장과 같은 form을 공유하므로 결재상태도 수정
       int updateApprovalStateRow = draftMapper.updateApprovalState(approvalNo, approvalState);
       log.debug(CC.HE + "DraftService.updateDraftOne() approvalState 결재대기로 변경 : " + updateApprovalStateRow + CC.RESET);
       
       // 2. receive_draft
       int[] recipients = (int[]) paramMap.get("recipients"); // map에서 객체 가져오기
       // delete mapper 호출
       draftMapper.deleteReceiveDrafts(approvalNo);
       log.debug(CC.HE + "DraftService.updateDraftOne() receive_draft delete 실행 "+ CC.RESET);
       if (recipients != null) { // 빈 배열이 아니면 insert
           // insert mapper 호출
           int receiveRow = draftMapper.insertReceiveDrafts(approvalNo, recipients);
           log.debug(CC.HE + "DraftService.updateDraftOne() receive_draft insert 실행 row : " + receiveRow + CC.RESET);
       }
  
       // 3. document_file
       List<MultipartFile> multipartFile = (List<MultipartFile>) paramMap.get("multipartFile"); // map에서 객체 가져오기
       String path = (String) paramMap.get("path");
       if (multipartFile != null) { // 빈 리스트가 아니면 insert
          // insert 메서드 호출
          int documentFileRow = addDocumentFile(multipartFile, path, approvalNo);
          log.debug(CC.HE + "DraftService.updateDraftOne() document_file insert 실행 row : " + documentFileRow + CC.RESET);
       }
    }
    
    // document_file insert 메서드
    // 파일을 실제 저장소에 업로드한 후, DB에도 insert 하는 메서드입니다.
    @Transactional
    public int addDocumentFile(List<MultipartFile> multipartFile, String path, int approvalNo) {
       int row = 0;
       for (MultipartFile mf : multipartFile) {
          if (!mf.isEmpty() && mf.getSize() > 0) { // 파일을 첨부했는지 검사합니다.
             // DocumentFile vo에 값 셋팅
              DocumentFile df = new DocumentFile();
              df.setApprovalNo(approvalNo); // 가져온 부모키값
              df.setDocOriFilename(mf.getOriginalFilename()); // 파일 원본 이름
              df.setDocFiletype(mf.getContentType()); // 파일 타입
              df.setDocPath("/file/document/"); // 저장 폴더 위치
              // 저장할 파일의 이름 구하기 (+ 확장자명을 포함)
              // 1) 파일의 확장자
              // lastIndexOf() 메서드를 이용하여 "."을 기준으로 확장자명을 잘라낸다
             String ext = mf.getOriginalFilename().substring(mf.getOriginalFilename().lastIndexOf("."));
             // 2) 파일의 이름
             // 중복되지 않는 유일한 식별자를 랜덤으로 생성하기 위해 UUID 클래스의 randomUUID() 메서드 사용
             // UUID로 식별자 생성시 중간에 "-"가 들어가기 때문에 replace() 메서드를 이용하여 없애준다
             String newFilename = UUID.randomUUID().toString().replace("-", "") + ext;
             df.setDocSaveFilename(newFilename);
             
             // 최종적으로 저장
             // 1. 데이터 테이블에 저장 (mapper 호출)
             row = row + draftMapper.insertDocumentFile(df);
             // 2. 실제 저장소에 저장
             File f = new File(path + df.getDocSaveFilename()); // path에 저장된 파일 이름으로 빈 파일을 생성
             // transferTo() 메서드를 이용하여 생성한 빈 파일에 첨부된 파일의 스트림을 주입한다
             try {
                mf.transferTo(f);
             } catch (IllegalStateException | IOException e) {
                e.printStackTrace();
                
                // 트랜잭션이 정상적으로 작동할 수 있도록 try..catch를 강요하지 않는 예외 발생이 필요하다
                throw new RuntimeException();
             }
          }
       }
       
       return row;
    }
    
    // document_file delete 메서드
    // 문서 파일을 실제 저장소와 db에서 삭제합니다.
    @Transactional
    public int removeDocumentFile(String path, int docFileNo, String docSaveFilename) {
       // 1. 실제 저장소에서 삭제
       File f = new File(path + docSaveFilename);
      if (f.exists()) { // 파일이 존재하는지 확인합니다.
            if (f.delete()) {
               log.debug(CC.HE + "DraftService.removeDocumentFile() 파일이 성공적으로 삭제되었습니다. "+ CC.RESET);
            } else {
               log.debug(CC.HE + "DraftService.removeDocumentFile() 파일 삭제 실패 "+ CC.RESET);
            }
        } else {
           log.debug(CC.HE + "DraftService.removeDocumentFile() 파일이 존재하지 않습니다. "+ CC.RESET);
        }
      
      // 2. db에서 파일 삭제
      int row = draftMapper.deleteDocumentFile(docFileNo);
      log.debug(CC.HE + "DraftService.removeDocumentFile() row : " + row + CC.RESET);
      
       return row;
    }
    
    // ----------- 매출보고서 --------------
    // 매출보고서 기안하기 (+ 임시저장)
    // 매출보고서 기안 insert 순서 // approval -> sales_draft -> sales_draft_content -> receive_draft(선택) -> document_file(선택)
    @Transactional
    public int addSalesDraft(Map<String, Object> paramMap) {
       // 1. approval 테이블
       Approval approval = (Approval) paramMap.get("approval"); // map에서 approval 객체 가져오기
        boolean isSaveDraft = (boolean) paramMap.get("isSaveDraft"); // map에서 임시저장 유무 가져오기
        approval.setDocumentCategory("매출보고서"); // 메서드 호출 전 양식 셋팅
        int approvalKey = addApprovalAndReturnKey(approval, isSaveDraft); // 메서드 호출하여 키값 가져오기
        
        // 2. sales_draft, sales_draft_content 테이블
        SalesDraft salesDraft = (SalesDraft) paramMap.get("salesDraft");
        List<SalesDraftContent> salesDraftContent = (List<SalesDraftContent>) paramMap.get("salesDraftContent");
        int row = 0;
       if (approvalKey != 0) {
          // 2-1. sales_draft
          salesDraft.setApprovalNo(approvalKey); // 1번에서 반환된 부모키값으로 셋팅
          row = draftMapper.insertSalesDraft(salesDraft); // mapper 호출
            log.debug(CC.HE + "DraftService.insertSalesDraft() row : " + row + CC.RESET);
            int documentNo = salesDraft.getDocumentNo(); // 키값 가져오기
            log.debug(CC.HE + "DraftService.insertSalesDraft() documentNo : " + documentNo + CC.RESET);
            // 2-2. sales_draft_content
            if (salesDraftContent.size() != 0) {
               row = draftMapper.insertSalesDraftContent(documentNo, salesDraftContent);
                log.debug(CC.HE + "DraftService.insertSalesDraftContent() row : " + row + CC.RESET);
            }
       }
       
       // 3. receive_draft 테이블
        int[] recipients = (int[]) paramMap.get("recipients");
        log.debug(CC.HE + "DraftService.insertSalesDraftContent() recipients.length : " + recipients.length + CC.RESET);
        if (recipients.length != 0) { // 수신참조자를 선택했을 경우
           if (row != 0) { // 이전 과정이 정상적으로 수행되었을 경우
              row = draftMapper.insertReceiveDrafts(approvalKey, recipients); // mapper 호출
              log.debug(CC.HE + "DraftService.insertReceiveDrafts() row : " + row + CC.RESET);
           }
        }
        
        // 4. document_file 테이블
        List<MultipartFile> multipartFile = (List<MultipartFile>) paramMap.get("multipartFile");
        String path = (String) paramMap.get("path");
        // MultipartFile은 파일이 첨부되지 않은 경우에도 빈 MultipartFile 객체가 포함된 크기가 1인 리스트를 반환하기 떄문에
        // multipartFile에 대한 파일 첨부 유무 검사는 addDocumentFile() 메소드 내 반복문에서 실행합니다.
       if (row != 0) { // 이전 과정이 정상적으로 수행되었을 경우
          row = addDocumentFile(multipartFile, path, approvalKey);
        }
        
       return approvalKey;
    }
    
    // 매출보고서 상세 조회
    @Transactional
    public Map<String, Object> selectSalesDraftOne(int empNo, int approvalNo) {
       Map<String, Object> resultMap = new HashMap<>();
       
       // 1. 결재정보 조회 // approval, receive_draft, document_file 테이블
       Map<String, Object> result = selectApprovalOne(empNo, approvalNo); // 메서드 호출
       log.debug(CC.HE + "DraftService.selectSalesDraftOne() result : " + result + CC.RESET);
       // 반환값 추출
       ApprovalJoinDto approval = (ApprovalJoinDto) result.get("approval");
       List<ReceiveJoinDraft> receiveList = (List<ReceiveJoinDraft>) result.get("receiveList");
       List<DocumentFile> documentFileList = (List<DocumentFile>) result.get("documentFileList");
       
       if (approval != null) {
          // 2. sales_draft 테이블 조회
          SalesDraft salesDraft = draftMapper.selectSalesDraftOne(approvalNo);
           // 2-1. sales_date 값 지정
          String year = salesDraft.getSalesDate().substring(0, 4);
          String month = salesDraft.getSalesDate().substring(5, 7);
          String salesDate = year + "년 " + month + "월";
          salesDraft.setSalesDate(salesDate);
          
          // 3. sales_draft_content 테이블 조회
           int documentNo = salesDraft.getDocumentNo();
           List<SalesDraftContent> salesDraftContentList = draftMapper.selectSalesDraftContentList(documentNo);
          
          // 4. 결재 상태에 따라 서명 이미지를 조회하는 메서드 호출
           Map<String, Object> memberSignMap = getApprovalSign(approval);
           
           resultMap.put("approval", approval);
           resultMap.put("receiveList", receiveList);
           resultMap.put("documentFileList", documentFileList);
           resultMap.put("salesDraft", salesDraft);
           resultMap.put("salesDraftContentList", salesDraftContentList);
           resultMap.put("memberSignMap", memberSignMap);
       }

       return resultMap;
    }
    
    // 매출보고서 수정
    @Transactional
    public int modifySalesDraft(Map<String, Object> paramMap) {
       int row = 0;
       
       // 1. approval, receive_draft, document_file 를 수정하는 공통 메서드 호출
       updateDraftOne(paramMap);
       
       // 2. sales_draft 테이블 수정
       SalesDraft salesDraft = (SalesDraft) paramMap.get("salesDraft");  // map에서 salesDraft 객체 가져오기
       row = draftMapper.updateSalesDraft(salesDraft);
       log.debug(CC.HE + "DraftService.updateSalesDraft() row : " + row + CC.RESET);
       
       // 3. sales_draft_content 테이블 수정
       int documentNo = salesDraft.getDocumentNo();
       List<SalesDraftContent> salesDraftContent = (List<SalesDraftContent>) paramMap.get("salesDraftContent"); // map에서 salesDraftContent 객체 가져오기
        // 3-1. delete mapper 호출
       row = draftMapper.deleteSalesDraftContent(documentNo);
       log.debug(CC.HE + "DraftService.deleteSalesDraftContent() row : " + row + CC.RESET);
       // 3-2. 빈 리스트가 아니면 insert
       if (salesDraftContent.size() != 0) {
          row = draftMapper.insertSalesDraftContent(documentNo, salesDraftContent);
          log.debug(CC.HE + "DraftService.insertSalesDraftContent() row : " + row + CC.RESET);
       }
       
       return row;
    }
    
    // ----------- 휴가신청서 --------------
    // 휴가신청서 기안하기 (+ 임시저장)
    // 휴가신청서 기안 insert 순서 // approval -> vacation_draft -> receive_draft(선택)
    @Transactional
    public int addVacationDraft(Map<String, Object> paramMap) {
       // 1. approval 테이블
       Approval approval = (Approval) paramMap.get("approval"); // map에서 approval 객체 가져오기
       boolean isSaveDraft = (boolean) paramMap.get("isSaveDraft"); // map에서 임시저장 유무 가져오기
       approval.setDocumentCategory("휴가신청서"); // 메서드 호출 전 양식 셋팅
       int approvalKey = addApprovalAndReturnKey(approval, isSaveDraft); // 메서드 호출하여 키값 가져오기
       
       // 2. vacation_draft 테이블
       // map에서 vacationDraft 객체 가져오기
       VacationDraft vacationDraft = (VacationDraft) paramMap.get("vacationDraft");
       // map에서 vacationTime 문자열 가져오기
       String vacationTime = (String) paramMap.get("vacationTime");
       
       int row = 0;
       if (approvalKey != 0) { // approvalKey 값이 정상적으로 반환되었을 경우
          // 2-1. 값 셋팅
          vacationDraft.setApprovalNo(approvalKey); // 1번에서 반환된 부모키값으로 셋팅
          prepareVacationTimes(vacationDraft, vacationTime); // 시간값을 셋팅하는 메서드 호출
          
          // 2-3. mapper 호출
          row = draftMapper.insertVactionDraft(vacationDraft);
          log.debug(CC.HE + "DraftService.insertVactionDraft() row : " + row + CC.RESET);
       }
       
       // 3. receive_draft 테이블
       int[] recipients = (int[]) paramMap.get("recipients");
       if (recipients.length != 0) { // 수신참조자를 선택했을 경우
          if (row == 1) { // 이전 과정이 정상적으로 수행되었을 경우
             row = draftMapper.insertReceiveDrafts(approvalKey, recipients); // mapper 호출
             log.debug(CC.HE + "DraftService.insertReceiveDrafts() row : " + row + CC.RESET);
          }
       }
       
       return approvalKey;
    }
    
    // 휴가신청시 시간값 셋팅
    // 작성, 수정시 모두 시간값 셋팅이 필요하므로 해당 기능을 모듈화하였습니다.
    // VacationDraft 객체와 vacationTime 문자열을 매개값으로 넣고 호출해주세요.
    @Transactional
    public void prepareVacationTimes(VacationDraft vacationDraft, String vacationTime) {
       // 반차 또는 연차/보상에 따라 휴가날짜와 시간을 셋팅합니다.
       // 1. 휴가종류를 선택하지 않았다면 모든 값들 기본값으로 셋팅
       if (vacationDraft.getVacationName() == null) {
          vacationDraft.setVacationName("");
          vacationDraft.setVacationStart("0000-00-00");
          vacationDraft.setVacationEnd("0000-00-00");
          
          return;
       }
       // 2. 휴가시작일 값 가져오기
       String vacationStart = vacationDraft.getVacationStart();
       // 3. 선택한 휴가 종류가 반차라면
       // 반차일 경우 시작날짜와 종료날짜는 같습니다.
       // 단, 반차가 오전인지 오후인지에 따라 시간을 다르게 셋팅합니다.
       if (vacationDraft.getVacationName().equals("반차")) {
          // 3-1. 시작날짜를 지정하지 않았을 경우 날짜 기본값으로 변경
          if (vacationStart.equals("")) {
             vacationStart = "0000-00-00";
          }
          // 3-2. 시간 선택에 따라 시간값 셋팅
          if (vacationTime == null) { // 시간을 선택하지 않았다면 날짜값만 셋팅
             vacationDraft.setVacationStart(vacationStart);
             vacationDraft.setVacationEnd(vacationStart);
          } else if (vacationTime.equals("오전반차")) {
             vacationDraft.setVacationStart(vacationStart + " 09:00:00");
             vacationDraft.setVacationEnd(vacationStart + " 13:00:00");
          } else { // 오후반차
             vacationDraft.setVacationStart(vacationStart + " 14:00:00");
             vacationDraft.setVacationEnd(vacationStart + " 18:00:00");
          }
       } else { // 4. 선택한 휴가가 연차 혹은 보상이라면
          // 4-1. 휴가종료일 값 가져오기
          String vacationEnd = vacationDraft.getVacationEnd();
          // 4-2. 시작날짜를 지정하지 않았을 경우 날짜 기본값으로 변경
          if (vacationStart.equals("")) {
             vacationStart = "0000-00-00";
             vacationEnd = "0000-00-00";
          }
          // 4-3. 연차 또는 보상일 경우 날짜값은 그대로 유지하고, 시간만 셋팅합니다.
          vacationDraft.setVacationStart(vacationStart + " 09:00:00");
          vacationDraft.setVacationEnd(vacationEnd + " 18:00:00");
       }
       
       log.debug(CC.HE + "DraftService.prepareVacationTimes() vacationStart : " + vacationDraft.getVacationStart() + CC.RESET);
       log.debug(CC.HE + "DraftService.prepareVacationTimes() vacationEnd : " + vacationDraft.getVacationEnd() + CC.RESET);
    }
       
    // 휴가신청서 상세 조회
    @Transactional
    public Map<String, Object> selectVacationDraftOne(int empNo, int approvalNo) {
       Map<String, Object> resultMap = new HashMap<>();
       
       // 1. 결재정보 조회 // approval, receive_draft, document_file 테이블
       Map<String, Object> result = selectApprovalOne(empNo, approvalNo); // 메서드 호출
       log.debug(CC.HE + "DraftService.selectApprovalOne() result : " + result + CC.RESET);
       // 반환값 추출 // 휴가신청서는 document_file 테이블 값이 없습니다.
       ApprovalJoinDto approval = (ApprovalJoinDto) result.get("approval");
       List<ReceiveJoinDraft> receiveList = (List<ReceiveJoinDraft>) result.get("receiveList");
       
       if (approval != null) {
          // 2. vacation_draft 테이블 조회
           VacationDraft vacationDraft = draftMapper.selectVactionDraftOne(approvalNo);
           // 2-1. 반차일 경우 vacationTime 값 지정
           String vacationTime = ""; // 오전반차, 오후반차
           String vacationName = vacationDraft.getVacationName();
           if (vacationName.equals("반차")) {
              String vacationStartTime = vacationDraft.getVacationStart().substring(11, 13);
              if (vacationStartTime.equals("09")) { // 09이면 오전반차
                 vacationTime = "오전반차";
              } else { // 13이면 오후반차
                 vacationTime = "오후반차";
              }
           }
           // 3. 결재 상태에 따라 서명 이미지를 조회하는 메서드 호출
           Map<String, Object> memberSignMap = getApprovalSign(approval);
           
           resultMap.put("approval", approval);
           resultMap.put("receiveList", receiveList);
           resultMap.put("vacationDraft", vacationDraft);
           resultMap.put("vacationTime", vacationTime);
           resultMap.put("memberSignMap", memberSignMap);
       }

       return resultMap;
    }
    
    // vacationHistory 업데이트 메서드
    // vacation_draft의 approval 정보가 업데이트 될때마다 vacation_history 테이블에 insert합니다.
    @Transactional
    public int addVacationHistory(int approvalNo, String actionType, String approvalField) {
       int row = 0;
       
       // 1. vacation_draft의 정보를 조회해옵니다. // 기존 메서드 사용
      VacationDraft vacationDraft = draftMapper.selectVactionDraftOne(approvalNo);
      log.debug(CC.HE + "DraftService.addVacationHistory() vacationDraft : " + vacationDraft + CC.RESET);
      // 2. VacationHistory 객체에 값 주입
      VacationHistory vacationHistory = new VacationHistory();
      if (vacationDraft != null) {
         vacationHistory.setEmpNo(vacationDraft.getEmpNo());
         vacationHistory.setVacationName(vacationDraft.getVacationName());
         vacationHistory.setVacationDays(vacationDraft.getVacationDays());
         // 3. 분기
          // 결재상태가 "결재중(B)"에서 "승인(approve)"된 경우 마이너스.
         if (approvalField.equals("B") && actionType.equals("approve")) { 
            vacationHistory.setVacationPm("M"); // vacation_pm -> M
             row = draftMapper.insertVacationHistroy(vacationHistory);
             log.debug(CC.HE + "DraftService.addVacationHistory() row : " + row + CC.RESET);
          // 결재상태가 "결재완료(C)"에서는 플러스 밖에 없다.
         } else if (approvalField.equals("C")) { 
            vacationHistory.setVacationPm("P"); // vacation_pm -> P
             row = draftMapper.insertVacationHistroy(vacationHistory);
             log.debug(CC.HE + "DraftService.addVacationHistory() row : " + row + CC.RESET);
         }
      }

       return row;
    }
    
    // 휴가신청서 수정
    @Transactional
    public int modifyVacationDraft(Map<String, Object> paramMap) {
       int row = 0;
       
       // 1. approval, receive_draft, document_file 를 수정하는 공통 메서드 호출
       updateDraftOne(paramMap);
       
       // 2. vacation_draft 테이블 수정
        VacationDraft vacationDraft = (VacationDraft) paramMap.get("vacationDraft");  // map에서 vacationDraft 객체 가져오기
        String vacationTime = (String) paramMap.get("vacationTime"); // map에서 vacationTime 문자열 가져오기
        // 2-1. 값 셋팅
        prepareVacationTimes(vacationDraft, vacationTime); // 시간값을 셋팅하는 메서드 호출
        // 2-3. mapper 호출
        row = draftMapper.updateVacationDraft(vacationDraft);
        log.debug(CC.HE + "DraftService.modifyVacationDraft() row : " + row + CC.RESET);
        
       return row;
    }
    
    // ----------- 내 결재함 리스트 --------------
    @Transactional
    public Map<String, Object> getApprovalDraftList(Map<String, Object> paramMap) {
       Map<String, Object> result = new HashMap<>();
       
       // 검색조건으로 리스트 조회
       List<Approval> approvalDraftList = draftMapper.selectApprovalDraftList(paramMap);
       // 검색조건으로 전체 수 조회
       int approvalDraftCnt = draftMapper.selectApprovalDraftCnt(paramMap);
       // 결재상태별 갯수 조회
       int empNo = (int) paramMap.get("empNo");
       List<Map<String, Object>> countState = draftMapper.selectApprovalCountsByState(empNo);

       int approvalDraftCount = 0;
       int approvalInProgressCount = 0;
       int approvalCompletCount = 0;
       int approvalRejectCount = 0;
       int approvalsaveCount = 0;

       for (Map<String, Object> statusMap : countState) {
           String approvalState = (String)statusMap.get("approvalState");
           int count = ((Long) statusMap.get("count")).intValue(); // count가 Long 타입으로 들어올 수 있으므로 형변환 필요
           
           switch (approvalState) {
               case "결재대기":
                   approvalDraftCount = count;
                   break;
               case "결재중":
                   approvalInProgressCount = count;
                   break;
               case "결재완료":
                   approvalCompletCount = count;
                   break;
               case "반려":
                   approvalRejectCount = count;
                   break;
               case "임시저장":
                   approvalsaveCount = count;
                   break;
           }
       }
       
       result.put("approvalDraftList", approvalDraftList);
       result.put("approvalDraftCnt", approvalDraftCnt);
       result.put("approvalDraftCount", approvalDraftCount);
       result.put("approvalInProgressCount", approvalInProgressCount);
       result.put("approvalCompletCount", approvalCompletCount);
       result.put("approvalRejectCount", approvalRejectCount);
       result.put("approvalsaveCount", approvalsaveCount);
       
       return result;
    }
    
    // ----------- 임시저장함 리스트 --------------
    @Transactional
    public Map<String, Object> getTempDraftList(Map<String, Object> paramMap) {
       Map<String, Object> result = new HashMap<>();
       
       // 검색조건으로 리스트 조회
       List<Approval> tempDraftList = draftMapper.selectTempDraftList(paramMap);
       // 검색조건으로 전체 수 조회
       int tempDraftCnt = draftMapper.selectTempDraftCnt(paramMap);
       
       result.put("tempDraftList", tempDraftList);
       result.put("tempDraftCnt", tempDraftCnt);
       
       return result;
    }
    
    // 임시저장 문서 일괄 삭제
    @Transactional
    public int removeTempDraft(Map<String, Object> paramMap) {
       int[] approvalNo = (int[]) paramMap.get("approvalNo");
       String path = (String) paramMap.get("path");
       
       // 1. 해당 문서번호 배열의 파일 정보 조회
       List<DocumentFile> documentFileList = draftMapper.selectDocumentFileByApprovalNo(approvalNo);
       log.debug(CC.HE + "DraftService.removeTempDraft() documentFileList : " + documentFileList + CC.RESET);
       // 2. approval 테이블 mapper 호출 (ON DELETE CASCADE)
       int row = draftMapper.deleteApprovalTempDrafts(approvalNo);
       log.debug(CC.HE + "DraftService.removeTempDraft() row : " + row + CC.RESET);
       // 3. 해당 리스트로 파일 삭제 메서드를 반복문으로 호출
       for (DocumentFile df : documentFileList) {
          log.debug(CC.HE + "DraftService.removeTempDraft() df.getDocFileNo() : " + df.getDocFileNo() + CC.RESET);
          removeDocumentFile(path, df.getDocFileNo(), df.getDocSaveFilename());
       }
       
       return row;
    }
}