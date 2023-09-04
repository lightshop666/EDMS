package com.fit.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fit.mapper.VacationMapper;
import com.fit.vo.Approval;
import com.fit.vo.VacationHistory;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class VacationService {
    @Autowired
    private VacationMapper vacationMapper;
    
    public List<VacationHistory> getFilteredHistory(Map<String, Object> filterParams, int empNo) {
        filterParams.put("empNo", empNo);
        
        log.debug("filterParamsa: {}", filterParams);
        return vacationMapper.selectFilteredHistory(filterParams);
    }

    public int getTotalHistoryCount(Map<String, Object> filterParams, int empNo) {
    	filterParams.put("empNo", empNo);
        return vacationMapper.selectTotalHistoryCount(filterParams);
    }
}




