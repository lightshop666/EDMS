package com.fit.vo;

import lombok.Data;

@Data
public class VacationHistory {
	   private int vacationHistoryNo;
       private int empNo;
       private String vacationName; // 반차, 연차, 보상
       private String vacationPm; // P, M
       private double vacationDays;
       private String createdate; // 발생일자
}
