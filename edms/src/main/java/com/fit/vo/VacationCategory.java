package com.fit.vo;

import lombok.Data;
@Data
public class VacationCategory {
    private Long vacationNo;
       private String vacationName;
       private int minDays;
       private int maxDays;
       private String createdate;
       private String updatedate;
}
