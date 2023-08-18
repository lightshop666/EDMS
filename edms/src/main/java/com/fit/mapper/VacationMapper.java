package com.fit.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map; // Map을 import

import com.fit.vo.VacationHistory;

@Mapper
public interface VacationMapper {
    // 휴가히스토리 리스트 조회
    List<VacationHistory> getVacationHistoryListByPage(Map<String, Object> paramMap);
    
    // 정렬조건에 따른 히스토리 총 행수 카운트
    int getVacationHistoryCount(Map<String, Object> paramMap);
    
    int insertVacationHistory(VacationHistory vacationHistory);
}