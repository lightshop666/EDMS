package com.fit.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fit.mapper.VacationMapper;
import com.fit.vo.VacationHistory;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class VacationService {
    @Autowired
    private VacationMapper vacationMapper;
    
    // 휴가이력 리스트
    public Map<String, Object> getVacationHistoryList(int currentPage, int rowPerPage, int empNo,
            String startDate, String endDate, String vacationName) {
        int beginRow = (currentPage - 1) * rowPerPage;
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("beginRow", beginRow);
        paramMap.put("rowPerPage", rowPerPage);
        paramMap.put("empNo", empNo);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate", endDate);
        paramMap.put("vacationName", vacationName);

        List<VacationHistory> vacationHistoryList = vacationMapper.getVacationHistoryListByPage(paramMap);

        int totalCount = vacationMapper.getVacationHistoryCount(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("vacationHistoryList", vacationHistoryList);
        resultMap.put("totalCount", totalCount);
        
        return resultMap;
    }
    
}




