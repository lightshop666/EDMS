package com.fit.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fit.mapper.DraftMapper;
import com.fit.vo.EmpInfo;

@Service
public class DraftService {

    @Autowired
    private DraftMapper draftMapper;

    public List<EmpInfo> getAllEmp() {
        return draftMapper.getAllEmp();
    }

    //public void submitDraft(DraftForm draftForm) {
        // 기안서 정보를 저장하는 로직 (예: approval 테이블에 insert 후 생성된 approval_no를 사용하여 expense_draft 테이블에 insert)
        // expense_draft_content 테이블에도 내역 추가
      //}
}

