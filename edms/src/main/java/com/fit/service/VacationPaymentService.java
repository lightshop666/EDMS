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
public class VacationPaymentService {
    @Autowired
    private VacationMapper vacationMapper;
    
    // 휴가 지급/차감 처리 메서드
    public void addVacation(int empNo, String vacationName, String vacationPm, int vacationDays) {
        VacationHistory vacationHistory = new VacationHistory();
        vacationHistory.setEmpNo(empNo);
        vacationHistory.setVacationName(vacationName);
        vacationHistory.setVacationPm(vacationPm);
        vacationHistory.setVacationDays(vacationDays);

        vacationMapper.insertVacationHistory(vacationHistory);
    }
}
