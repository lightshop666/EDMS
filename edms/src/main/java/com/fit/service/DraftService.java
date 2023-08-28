package com.fit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.CC;
import com.fit.mapper.DraftMapper;
import com.fit.mapper.MemberMapper;
import com.fit.vo.Approval;
import com.fit.vo.ApprovalJoinDto;
import com.fit.vo.EmpInfo;
import com.fit.vo.ExpenseDraft;
import com.fit.vo.ExpenseDraftContent;
import com.fit.vo.MemberFile;
import com.fit.vo.VacationDraft;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class DraftService {

    @Autowired
    private DraftMapper draftMapper;
    
    @Autowired
    private MemberMapper memberMapper;


    //------------------------------정환 시작---------------------------------------------
    public List<EmpInfo> getAllEmp() {
        return draftMapper.getAllEmp();
    }

    @Transactional
    public int processExpenseSubmission(Boolean isSaveDraft,Map<String, Object> submissionData,List<Integer> selectedRecipientsIds, List<ExpenseDraftContent> expenseDraftContentList) {
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
        if (expenseDraftContentList != null && !expenseDraftContentList.isEmpty()) {
           for (ExpenseDraftContent expenseDetail : expenseDraftContentList) {
               expenseDetail.setDocumentNo(draftMapper.selectLastInsertedDocumentNo());
               // 기타 필드들 설정
               draftMapper.insertExpenseDraftContent(expenseDetail);
           }
        }  
        
        if (selectedRecipientsIds == null || selectedRecipientsIds.isEmpty()) {
            return 1; // 수신참조자가 없는 경우를 나타내는 코드 또는 상수값
        }else {
           for (int empNo : selectedRecipientsIds) {
                draftMapper.insertReceiveDraft(draftMapper.selectLastInsertedApprovalNo(), empNo);
            }
           return 1;
        }
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
        expenseDraftData.put("firstApproval", String.valueOf(approval.getFirstApproval()));
        expenseDraftData.put("mediateApproval", String.valueOf(approval.getMediateApproval()));
        expenseDraftData.put("finalApproval", String.valueOf(approval.getFinalApproval()));
        expenseDraftData.put("status", String.valueOf(approval.getApprovalField()));
       
        
        //역할부여
        String role = determineRole(approval, empNo);
        
        log.debug("Role Determined: {}", role); // 디버깅용 로그 추가
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
        
        
        log.debug(CC.JUNG + "[DEBUG] Expense Draft Data: {}", expenseDraftData + CC.RESET);
        
        return expenseDraftData;
    }
    
    
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
       public void cancelDraft(int approvalNo) {
           draftMapper.updateApprovalState(approvalNo, "임시저장");
       }

       public void approveDraft(int approvalNo, String role) {
           if ("middleApprover".equals(role)) {
               draftMapper.updateApprovalStateAndField(approvalNo, "결재중", "B");
           } else if ("finalApprover".equals(role)) {
               draftMapper.updateApprovalStateAndField(approvalNo, "결재완료", "C");
           }
       }

       public void rejectDraft(int approvalNo) {
           draftMapper.updateApprovalStateAndField(approvalNo, "반려","A");
       }

       public void cancelApproval(int approvalNo, String role) {
           if ("finalApprover".equals(role)) {
               draftMapper.updateApprovalStateAndField(approvalNo, "결재중", "B");
           }else {
              draftMapper.updateApprovalStateAndField(approvalNo, "결재대기", "A");
           }   
           // 중간승인자일 경우의 처리도 추가할 수 있음
       }
       
       public int modifyExpenseDraft(Map<String, Object> submissionData, List<Integer> selectedRecipientsIds, List<ExpenseDraftContent> expenseDraftContentList) {
           // 1. 수정하려는 지출 결의서의 approvalNo 가져오기
           int approvalNo = (int) submissionData.get("approvalNo");

           // 2. ExpenseDraft 테이블의 docTitle과 마감일 업데이트
           String newDocTitle = (String) submissionData.get("documentTitle");
           String newPaymentDate = (String) submissionData.get("paymentDate");
           draftMapper.updateExpenseDraft(approvalNo, newDocTitle, newPaymentDate);

           // 3. expense_draft_content 테이블에서 해당 approvalNo에 해당하는 데이터 삭제
           draftMapper.deleteExpenseDraftContents(approvalNo);

           // 4. expense_draft_content 테이블에 수정된 데이터 insert
           if (expenseDraftContentList != null && !expenseDraftContentList.isEmpty()) {
               for (ExpenseDraftContent expenseDetail : expenseDraftContentList) {
                   // approvalNo와 documentNo 설정
                   expenseDetail.setApprovalNo(approvalNo);
                   expenseDetail.setDocumentNo(draftMapper.selectDocumentNoByApprovalNo(approvalNo));
                   draftMapper.insertExpenseDraftContent(expenseDetail);
               }
           }

           // 5. receive_draft 테이블에서 해당 approvalNo에 해당하는 데이터 삭제
           draftMapper.deleteReceiveDraft(approvalNo);

           // 6. receive_draft 테이블에 수정된 데이터 insert
           if (selectedRecipientsIds != null && !selectedRecipientsIds.isEmpty()) {
               for (int empNo : selectedRecipientsIds) {
                   draftMapper.insertReceiveDraft(approvalNo, empNo);
               }
           }

           // 7. approval 테이블 수정
           int selectedMiddleApproverId = (int) submissionData.get("selectedMiddleApproverId");
           int selectedFinalApproverId = (int) submissionData.get("selectedFinalApproverId");
           draftMapper.updateApproval(approvalNo, selectedMiddleApproverId, selectedFinalApproverId);


           return 1; // 성공적으로 수정되었음을 나타내는 코드 또는 상수값
       }
   
    //------------------------------정환 끝---------------------------------------------   
    //------------------------------희진 시작---------------------------------------------   
    // 작성 폼에서 출력될 기안자의 서명 이미지 조회
    // 기존의 memberMapper 사용 // -> private으로 바꿀지 고민.. 결재상태에 따른 서명이미지 조회 메서드를 만드니까 이건 없애는게 좋을까?
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
    private int addApprovalAndReturnKey(Approval approval, boolean isSaveDraft) {
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
    
    // 휴가신청시 시간값 셋팅
    // 작성, 수정시 모두 시간값 셋팅이 필요하므로 해당 기능을 모듈화하였습니다.
    // VacationDraft 객체와 vacationTime 문자열을 매개값으로 넣고 호출해주세요.
    private void prepareVacationTimes(VacationDraft vacationDraft, String vacationTime) {
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
      // 4. 선택한 휴가가 연차 혹은 보상이라면
      } else {
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
    }

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
    
    // 결재상태에 따른 서명이미지 조회
    private Map<String, Object> getApprovalSign(ApprovalJoinDto approvalJoinDto) {
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
    
    // 휴가신청서 상세페이지 조회
    @Transactional
    public Map<String, Object> selectVacationDraftOne(int empNo, int approvalNo) {
    	Map<String, Object> resultMap = new HashMap<>();
    	
    	// 1. 결재정보 조회
    	// 양식 종류에 상관없이 공통적으로 조회되는 approval, receive_draft, document_file 테이블을 조회하는 메서드입니다.
        // ApprovalJoinDto DTO 타입으로 반환됩니다.
    	ApprovalJoinDto approvalJoinDto = draftMapper.selectApprovalOne(empNo, approvalNo);
    	// 1-1. 기안자의 이름과 부서명 조회
    	// 예정..
    	// 1-2. 수신참조자의 이름과 부서명, 직급 조회
    	// 예정..
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
    	Map<String, Object> memberSignMap = getApprovalSign(approvalJoinDto);
    	
    	resultMap.put("approvalJoinDto", approvalJoinDto);
    	resultMap.put("vacationDraft", vacationDraft);
    	resultMap.put("vacationTime", vacationTime);
    	resultMap.put("memberSignMap", memberSignMap);
    	
    	return resultMap;
    }
}