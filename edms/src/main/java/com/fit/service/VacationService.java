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
    public Map<String, Object> getVacationHistoryList(int page,  int empNo,
            String startDate, String endDate, String col, String ascDesc, String vacationName) {
        int rowPerPage = 10;
    	int beginRow = (page - 1) * rowPerPage;
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("beginRow", beginRow);
        paramMap.put("rowPerPage", rowPerPage);
        paramMap.put("empNo", empNo);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate", endDate);
        paramMap.put("col", col);
        paramMap.put("ascDesc", ascDesc);
        paramMap.put("vacationName", vacationName);

        List<VacationHistory> vacationHistoryList = vacationMapper.getVacationHistoryListByPage(paramMap);

        int totalCount = vacationMapper.getVacationHistoryCount(paramMap);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("vacationHistoryList", vacationHistoryList);
     
        
        // 전체 페이지 수 계산
        int lastPage = (int) Math.ceil((double) totalCount / rowPerPage);
        
        // 한 페이지 당 보여질 쪽 수
        int pagePerPage = 10;

        // 현재 페이지 기준으로 보여질 최소 페이지 번호 계산
        int minPage = (((page - 1) / pagePerPage) * pagePerPage) + 1;

        // 현재 페이지 기준으로 보여질 최대 페이지 번호 계산
        int maxPage = minPage + (pagePerPage - 1);
        if (maxPage > lastPage) {
            maxPage = lastPage;
        }

        resultMap.put("minPage", minPage);
        resultMap.put("maxPage", maxPage);

        return resultMap;
    }
}




