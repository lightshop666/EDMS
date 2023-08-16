package com.fit.vo;

import lombok.Data;

@Data
public class VacationHistory {
	   private int vacationHistoryNo;
       private int empNo;
       private String vacationName;
       private String vacationPm;
       private int vacationDays;
       private String vacationStart;
       private String createDate;
}
