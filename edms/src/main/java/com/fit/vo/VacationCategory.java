package com.fit.vo;

import lombok.Data;
@Data
public class VacationCategory {
    private Long vacationNo;
       private String vacationName; // 반차, 연차, 보상
       private double minDays;
       private double maxDays;
       private String createdate;
       private String updatedate;
}
