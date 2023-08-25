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
    
    public Map<String, Object> getExpenseDraftDataByApprovalNo(int approvalNo) {
        Map<String, Object> expenseDraftData = new HashMap<>();
        
        
        // approval 테이블에서 데이터 조회
        Approval approval = draftMapper.selectApprovalByApprovalNo(approvalNo);
        expenseDraftData.put("approvalNo", approval.getApprovalNo());
        expenseDraftData.put("selectedFirstApproverId", String.valueOf(approval.getFirstApproval()));
        expenseDraftData.put("selectedMiddleApproverId", String.valueOf(approval.getMediateApproval()));
        expenseDraftData.put("selectedFinalApproverId", String.valueOf(approval.getFinalApproval()));
        // 이하 필요한 데이터 추가
        
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
        List<Integer> selectedRecipientsIds = draftMapper.selectRecipientIdsByApprovalNo(approvalNo);
        expenseDraftData.put("selectedRecipientsIds", selectedRecipientsIds);
        
        
        log.debug(CC.JUNG + "[DEBUG] Expense Draft Data: {}", expenseDraftData + CC.RESET);
        
        return expenseDraftData;
    }
    
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
}